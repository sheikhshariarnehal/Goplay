import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme.dart';
import '../../core/typography.dart';
import '../../models/channel.dart';
import '../../services/local_proxy.dart';
import '../../services/playback/playback_state.dart';
import '../../services/playback/playback_state_machine.dart';
import '../../services/playback/connectivity_service.dart';
import '../../services/playback/playback_telemetry.dart';
import '../tv_focus_wrapper.dart';
import 'channel_video_player.dart';

Widget getChannelVideoPlayer({
  required Channel channel,
  VoidCallback? onFullscreenToggle,
  bool isFullscreen = false,
  bool showControls = true,
  VoidCallback? onTap,
  VoidCallback? onPreviousChannel,
  VoidCallback? onNextChannel,
  VoidCallback? onInteract,
  VoidCallback? onFocusChannelPanel,
  bool isTvDevice = false,
  FocusNode? playPauseFocusNode,
  List<Channel>? servers,
  int activeServerIndex = 0,
  ValueChanged<int>? onServerSelected,
}) {
  return ChannelVideoPlayerNative(
    channel: channel,
    onFullscreenToggle: onFullscreenToggle,
    isFullscreen: isFullscreen,
    showControls: showControls,
    onTap: onTap,
    onPreviousChannel: onPreviousChannel,
    onNextChannel: onNextChannel,
    onInteract: onInteract,
    onFocusChannelPanel: onFocusChannelPanel,
    isTvDevice: isTvDevice,
    playPauseFocusNode: playPauseFocusNode,
    servers: servers,
    activeServerIndex: activeServerIndex,
    onServerSelected: onServerSelected,
  );
}

class ChannelVideoPlayerNative extends StatefulWidget implements ChannelVideoPlayer {
  @override
  final Channel channel;
  @override
  final VoidCallback? onFullscreenToggle;
  @override
  final bool isFullscreen;
  @override
  final bool showControls;
  @override
  final VoidCallback? onTap;
  @override
  final VoidCallback? onPreviousChannel;
  @override
  final VoidCallback? onNextChannel;
  @override
  final VoidCallback? onInteract;
  @override
  final VoidCallback? onFocusChannelPanel;
  @override
  final bool isTvDevice;
  @override
  final FocusNode? playPauseFocusNode;
  @override
  final List<Channel>? servers;
  @override
  final int activeServerIndex;
  @override
  final ValueChanged<int>? onServerSelected;

  const ChannelVideoPlayerNative({
    super.key,
    required this.channel,
    this.onFullscreenToggle,
    this.isFullscreen = false,
    this.showControls = true,
    this.onTap,
    this.onPreviousChannel,
    this.onNextChannel,
    this.onInteract,
    this.onFocusChannelPanel,
    this.isTvDevice = false,
    this.playPauseFocusNode,
    this.servers,
    this.activeServerIndex = 0,
    this.onServerSelected,
  });

  @override
  State<ChannelVideoPlayerNative> createState() => _ChannelVideoPlayerNativeState();
}

String _formatDuration(Duration d) {
  final hrs = d.inHours;
  final mins = d.inMinutes.remainder(60);
  final secs = d.inSeconds.remainder(60);
  if (hrs > 0) {
    return '$hrs:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
  return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
}

enum _DragType { none, seek, brightness, volume }

class _ChannelVideoPlayerNativeState extends State<ChannelVideoPlayerNative> {
  MethodChannel? _methodChannel;
  bool _isPlaying = false;
  bool _isBuffering = true;
  bool _hasError = false;
  String? _errorMessage;

  // Cache creation params to avoid re-building on every frame
  Map<String, dynamic>? _cachedParams;
  String? _cachedChannelId;

  // Player state variables for controls
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  Duration _bufferedPosition = Duration.zero;
  Timer? _progressTimer;

  double _volume = 1.0;
  double _prevVolume = 1.0;
  bool _isMuted = false;

  double _brightness = 0.5;
  Timer? _osdHideTimer;

  final ValueNotifier<double?> _brightnessOsdNotifier = ValueNotifier<double?>(null);
  final ValueNotifier<double?> _volumeOsdNotifier = ValueNotifier<double?>(null);

  // Unified Drag/Pan & Scrubbing state
  _DragType _dragType = _DragType.none;
  Offset _dragStartPosition = Offset.zero;
  Duration _dragStartSeekPosition = Duration.zero;

  bool _isScrubbing = false;
  final ValueNotifier<Duration?> _scrubPositionNotifier = ValueNotifier<Duration?>(null);
  final ValueNotifier<Duration?> _seekDeltaNotifier = ValueNotifier<Duration?>(null);

  // 3-Zone Double Tap state
  int _doubleTapSeekSeconds = 0;
  bool _showDoubleTapLeft = false;
  bool _showDoubleTapRight = false;
  Timer? _doubleTapResetTimer;

  bool _isLive = false;

  void _onDoubleTapSeek(int seconds) {
    if (_duration <= Duration.zero) return;
    _doubleTapResetTimer?.cancel();
    final isLeft = seconds < 0;
    final currentAccum = (isLeft ? _showDoubleTapLeft : _showDoubleTapRight) ? _doubleTapSeekSeconds : 0;
    final newSeconds = currentAccum + seconds;

    _seekRelative(seconds, wakeControls: false);

    setState(() {
      _showDoubleTapLeft = isLeft;
      _showDoubleTapRight = !isLeft;
      _doubleTapSeekSeconds = newSeconds;
    });

    _doubleTapResetTimer = Timer(const Duration(milliseconds: 750), () {
      if (mounted) {
        setState(() {
          _showDoubleTapLeft = false;
          _showDoubleTapRight = false;
          _doubleTapSeekSeconds = 0;
        });
      }
    });
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    if (_isLocked) return;
    final width = MediaQuery.of(context).size.width;
    final x = details.localPosition.dx;
    if (x < width * 0.35) {
      _onDoubleTapSeek(-10);
    } else if (x > width * 0.65) {
      _onDoubleTapSeek(10);
    } else {
      widget.onFullscreenToggle?.call();
    }
  }

  void _handlePanStart(DragStartDetails details) {
    if (_isLocked) return;
    _dragStartPosition = details.localPosition;
    _dragStartSeekPosition = _position;
    _dragType = _DragType.none;
    _osdHideTimer?.cancel();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_isLocked) return;
    final screen = MediaQuery.of(context).size;
    if (screen.width <= 0 || screen.height <= 0) return;

    final dx = details.localPosition.dx - _dragStartPosition.dx;
    final dy = details.localPosition.dy - _dragStartPosition.dy;

    // Disambiguate drag type if not decided yet
    if (_dragType == _DragType.none) {
      if (dx.abs() < 10 && dy.abs() < 10) return;

      if (dx.abs() > dy.abs() * 1.2 && _duration > Duration.zero) {
        // Horizontal swipe -> Seek scrub!
        _dragType = _DragType.seek;
        _isScrubbing = true;
        _scrubPositionNotifier.value = _position;
        _seekDeltaNotifier.value = Duration.zero;
      } else if (dy.abs() > dx.abs()) {
        // Vertical swipe -> Brightness (left half) or Volume (right half)
        if (widget.isFullscreen) {
          if (_dragStartPosition.dx < screen.width / 2) {
            _dragType = _DragType.brightness;
            _brightnessOsdNotifier.value = _brightness;
          } else {
            _dragType = _DragType.volume;
            _volumeOsdNotifier.value = _volume;
          }
        }
      }
    }

    // Process active drag
    if (_dragType == _DragType.seek && _duration > Duration.zero) {
      final scrubRangeMs = (_duration.inMilliseconds > 600000)
          ? (_duration.inMilliseconds * 0.25).clamp(90000.0, 600000.0)
          : (_duration.inMilliseconds > 0 ? _duration.inMilliseconds.toDouble() : 90000.0);
      final seekDeltaMs = ((dx / screen.width) * scrubRangeMs).round();
      final targetMs = (_dragStartSeekPosition.inMilliseconds + seekDeltaMs)
          .clamp(0, _duration.inMilliseconds);
      final targetPos = Duration(milliseconds: targetMs);
      _scrubPositionNotifier.value = targetPos;
      _seekDeltaNotifier.value = Duration(milliseconds: targetMs - _dragStartSeekPosition.inMilliseconds);
    } else if (_dragType == _DragType.brightness) {
      final delta = -details.delta.dy / (screen.height * 0.7);
      _brightness = (_brightness + delta).clamp(0.01, 1.0);
      _methodChannel?.invokeMethod('setBrightness', _brightness);
      _brightnessOsdNotifier.value = _brightness;
    } else if (_dragType == _DragType.volume) {
      final delta = -details.delta.dy / (screen.height * 0.7);
      _volume = (_volume + delta).clamp(0.0, 1.0);
      _isMuted = _volume == 0;
      _methodChannel?.invokeMethod('setVolume', _volume);
      _volumeOsdNotifier.value = _volume;
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_dragType == _DragType.seek) {
      final finalTarget = _scrubPositionNotifier.value;
      if (finalTarget != null) {
        _seekTo(finalTarget);
      }
      _scrubPositionNotifier.value = null;
      _seekDeltaNotifier.value = null;
      _isScrubbing = false;
    } else if (_dragType == _DragType.brightness || _dragType == _DragType.volume) {
      _startOsdHideTimer();
    }
    _dragType = _DragType.none;
  }

  void _handlePanCancel() {
    _handlePanEnd(DragEndDetails());
  }

  void _startOsdHideTimer() {
    _osdHideTimer?.cancel();
    _osdHideTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) {
        _brightnessOsdNotifier.value = null;
        _volumeOsdNotifier.value = null;
      }
    });
  }


  // ignore: unused_field
  String _currentQuality = 'Auto';
  int _aspectRatioIndex = 0;
  bool _isLocked = false;
  bool _subtitlesEnabled = true;
  double _playbackSpeed = 1.0;

  final List<int> _resizeModes = [0, 3, 4]; // RESIZE_MODE_FIT, RESIZE_MODE_FILL, RESIZE_MODE_ZOOM
  final List<String> _aspectLabels = ['FIT', 'STRETCH', 'ZOOM'];

  static const _pipChannel = MethodChannel('com.goplay/pip');

  // ─── Playback State Machine ────────────────────────────────────

  late final PlaybackStateMachine _stateMachine;
  late final ConnectivityService _connectivityService;

  // ─── Pre-cached gradient decorations — allocated once, not per build() ──

  static final _kGradientOverlayFS = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        Colors.black.withAlpha(200),
        Colors.transparent,
        Colors.transparent,
      ],
    ),
  );
  static final _kGradientOverlayPortrait = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        Colors.black.withAlpha(200),
        Colors.transparent,
        Colors.black.withAlpha(160),
      ],
    ),
  );

  String? _cachedStreamUrl;

  // ─── Creation params ─────────────────────────────────────────────

  Map<String, dynamic> _getCreationParams() {
    if (_cachedParams != null &&
        _cachedChannelId == widget.channel.id &&
        _cachedStreamUrl == widget.channel.streamUrl) {
      return _cachedParams!;
    }
    _cachedChannelId = widget.channel.id;
    _cachedStreamUrl = widget.channel.streamUrl;
    _cachedParams = _buildCreationParams();
    return _cachedParams!;
  }

  Map<String, dynamic> _buildCreationParams() {
    final headers = widget.channel.headers.map(
      (key, value) => MapEntry(key, value.toString()),
    );

    // Bypass local proxy — ExoPlayer's DefaultHttpDataSource.Factory
    // already propagates custom headers to all sub-requests (manifests,
    // segments, keys) natively.  Routing segments through the Dart heap
    // caused severe GC stalls (CollectNewGeneration up to 9.5 s).
    final rawUrl = widget.channel.streamUrl.trim();
    final isPendingDynamic = rawUrl.isEmpty || rawUrl.startsWith('pro/') || rawUrl.contains('.txt');
    final playUrl = isPendingDynamic ? '' : rawUrl;

    final params = <String, dynamic>{
      'url': playUrl,
      'headers': headers,
    };

    if (widget.channel.hasDrm) {
      final drm = widget.channel.drm!;
      params['drm_type'] = drm.type.name;

      if (drm.isClearKey) {
        if (drm.kid != null) params['drm_kid'] = drm.kid;
        if (drm.key != null) params['drm_key'] = drm.key;
        if (drm.clearKeys != null) params['drm_clearkeys'] = drm.clearKeys;
      } else if (drm.isWidevine) {
        if (drm.licenseUrl != null) params['drm_license_url'] = drm.licenseUrl;
        if (drm.licenseHeaders != null) params['drm_license_headers'] = drm.licenseHeaders;
      }
    }

    return params;
  }

  // ─── Platform view lifecycle ─────────────────────────────────────

  void _onPlatformViewCreated(int id) {
    _methodChannel = MethodChannel('com.goplay/native_player_$id');
    _methodChannel!.setMethodCallHandler(_handleMethodCall);

    if (widget.channel.streamUrl.contains('otte.cache.aiv-cdn.net')) {
      LocalProxy.startKkx4Auth();
    }
  }

  // ─── Method call handler ─────────────────────────────────────────

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    if (!mounted) return;

    switch (call.method) {
      case 'onStateChanged':
        final args = Map<String, dynamic>.from(call.arguments as Map);
        final state = args['state'] as String;
        final isPlaying = args['isPlaying'] as bool? ?? false;
        final nowBuffering = state == 'buffering';
        final isReady = state == 'ready' || state == 'playing';

        // Delegate to state machine for recovery logic
        _stateMachine.handleNativeStateEvent(args);

        // Update local UI state for controls rendering
        if (_isPlaying != isPlaying || _isBuffering != nowBuffering ||
            (isReady && (_hasError || _errorMessage != null))) {
          setState(() {
            _isPlaying = isPlaying;
            _isBuffering = nowBuffering;
            if (isReady) {
              _hasError = false;
              _errorMessage = null;
            }
          });
        }

        if (isPlaying) {
          _startProgressTimer();
        } else {
          _stopProgressTimer();
        }
        _updateProgress();
        break;

      case 'onError':
        final args = Map<String, dynamic>.from(call.arguments as Map);
        final message = args['message'] as String? ?? 'Unknown playback error';
        debugPrint('NativePlayer error: $message');
        _stopProgressTimer();

        // Delegate to state machine — it will classify, retry, or skip
        _stateMachine.handleError(args);
        break;
    }
  }

  // ─── State Machine Listener ──────────────────────────────────────

  void _onStateMachineChanged() {
    if (!mounted) return;
    final smState = _stateMachine.state;

    // Sync error state from state machine into widget state
    switch (smState.phase) {
      case PlaybackPhase.failed:
        setState(() {
          _hasError = true;
          _errorMessage = smState.error?.userMessage ?? 'Unable to play this stream';
          _isBuffering = false;
        });
        // Auto-failover to next available server if multi-stream channel
        if (widget.servers != null && widget.servers!.length > 1 && widget.onServerSelected != null) {
          final nextServerIndex = (widget.activeServerIndex + 1) % widget.servers!.length;
          if (nextServerIndex != widget.activeServerIndex) {
            debugPrint('[Failover] Stream failed on index ${widget.activeServerIndex}, switching to server index $nextServerIndex (${widget.servers![nextServerIndex].name})');
            widget.onServerSelected!(nextServerIndex);
          }
        }
        break;

      case PlaybackPhase.waitingForInternet:
        setState(() {
          _hasError = true;
          _errorMessage = smState.error?.userMessage ?? 'No internet connection';
          _isBuffering = false;
        });
        break;

      case PlaybackPhase.retrying:
        // Show retrying state — not a hard error
        setState(() {
          _hasError = false;
          _isBuffering = true;
        });
        break;

      case PlaybackPhase.skipping:
        // Show skipping countdown — not a hard error
        setState(() {
          _hasError = false;
          _isBuffering = false;
        });
        break;

      case PlaybackPhase.preparing:
        setState(() {
          _hasError = false;
          _errorMessage = null;
          _isBuffering = true;
        });
        break;

      case PlaybackPhase.playing:
        setState(() {
          _hasError = false;
          _errorMessage = null;
        });
        break;

      default:
        break;
    }
  }

  // ─── Progress timer ──────────────────────────────────────────────

  void _startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted && _isPlaying) {
        _updateProgress();
      }
    });
  }

  void _stopProgressTimer() {
    _progressTimer?.cancel();
  }

  Future<void> _updateProgress() async {
    if (_methodChannel == null || _isScrubbing) return;
    try {
      final state = await _methodChannel!.invokeMethod<Map>('getState');
      if (state != null && mounted) {
        if (_isScrubbing) return;
        final newPlaying = state['isPlaying'] as bool? ?? _isPlaying;
        final newPos = Duration(milliseconds: (state['position'] as int? ?? 0));
        final newDur = Duration(milliseconds: (state['duration'] as int? ?? 0));
        final newBuf = Duration(milliseconds: (state['bufferedPosition'] as int? ?? 0));
        final isLive = state['isLive'] as bool? ?? false;

        // Skip rebuild when controls are hidden AND position delta is <2s
        if (!widget.showControls &&
            newPlaying == _isPlaying &&
            (newPos - _position).abs() < const Duration(seconds: 2) &&
            newDur == _duration &&
            isLive == _isLive) {
          _isPlaying = newPlaying;
          _position = newPos;
          _duration = newDur;
          _bufferedPosition = newBuf;
          _isLive = isLive;
          return;
        }

        // Skip rebuild if nothing actually changed
        if (newPlaying == _isPlaying &&
            newPos == _position &&
            newDur == _duration &&
            newBuf == _bufferedPosition &&
            isLive == _isLive) {
          return;
        }

        setState(() {
          _isPlaying = newPlaying;
          _position = newPos;
          _duration = newDur;
          _bufferedPosition = newBuf;
          _isLive = isLive;
        });
      }
    } catch (e) {
      debugPrint('Error getting player state: $e');
    }
  }

  // ─── Playback controls ───────────────────────────────────────────

  void _retryPlaybackInternal() {
    _cachedParams = null;
    if (!mounted) return;
    setState(() {
      _hasError = false;
      _errorMessage = null;
      _isBuffering = true;
      _position = Duration.zero;
      _duration = Duration.zero;
      _bufferedPosition = Duration.zero;
    });
    _methodChannel?.invokeMethod('play', _getCreationParams());
  }

  /// Manual retry.
  void _retryPlayback() {
    _stateMachine.manualRetry();
  }

  void _seekTo(Duration position) {
    _methodChannel?.invokeMethod('seekTo', position.inMilliseconds);
    setState(() {
      _position = position;
    });
  }

  void _setVolume(double value) {
    setState(() {
      _volume = value;
      _isMuted = value == 0.0;
    });
    _methodChannel?.invokeMethod('setVolume', value);
  }

  void _toggleMute() {
    if (_isMuted) {
      _setVolume(_prevVolume > 0 ? _prevVolume : 1.0);
    } else {
      _prevVolume = _volume;
      _setVolume(0.0);
    }
  }

  void _setQuality(String label, int height) {
    setState(() {
      _currentQuality = label;
    });
    _methodChannel?.invokeMethod('setQuality', height);
  }

  void _toggleAspectRatio() {
    setState(() {
      _aspectRatioIndex = (_aspectRatioIndex + 1) % _resizeModes.length;
    });
    final mode = _resizeModes[_aspectRatioIndex];
    _methodChannel?.invokeMethod('setResizeMode', mode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Aspect Ratio: ${_aspectLabels[_aspectRatioIndex]}'),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  // ignore: unused_element
  void _enterPiP() async {
    try {
      await _pipChannel.invokeMethod('enterPiP');
    } catch (e) {
      debugPrint('Failed to enter PiP: $e');
    }
  }

  // ignore: unused_element
  void _toggleSubtitles() async {
    if (_methodChannel == null) return;
    try {
      final enabled = await _methodChannel!.invokeMethod<bool>('toggleSubtitles');
      if (enabled != null && mounted) {
        setState(() {
          _subtitlesEnabled = enabled;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_subtitlesEnabled ? 'Subtitles Enabled' : 'Subtitles Disabled'),
            duration: const Duration(milliseconds: 800),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error toggling subtitles: $e');
    }
  }

  // ignore: unused_element
  void _cycleAudioTrack() async {
    if (_methodChannel == null) return;
    try {
      final lang = await _methodChannel!.invokeMethod<String>('cycleAudioTrack');
      if (lang != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(lang == "Default" || lang == "None"
                ? 'Audio Track: Default'
                : 'Audio Track Language: $lang'),
            duration: const Duration(milliseconds: 800),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error cycling audio track: $e');
    }
  }

  // ignore: unused_element
  void _cyclePlaybackSpeed() async {
    if (_methodChannel == null) return;
    final speeds = [1.0, 1.25, 1.5, 2.0, 0.5];
    final currentIdx = speeds.indexOf(_playbackSpeed);
    final nextSpeed = speeds[(currentIdx + 1) % speeds.length];
    try {
      final success = await _methodChannel!.invokeMethod<bool>('setPlaybackSpeed', nextSpeed);
      if (success == true && mounted) {
        setState(() {
          _playbackSpeed = nextSpeed;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Playback Speed: ${nextSpeed}x'),
            duration: const Duration(milliseconds: 800),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error setting playback speed: $e');
    }
  }

  // ignore: unused_element
  void _showQualityMenu(TapDownDetails details) async {
    final position = details.globalPosition;

    List<int> qualities = [];
    try {
      if (_methodChannel != null) {
        final result = await _methodChannel!.invokeListMethod<int>('getVideoQualities');
        if (result != null) {
          qualities = result;
        }
      }
    } catch (e) {
      debugPrint('Error getting video qualities: $e');
    }

    if (qualities.isEmpty) {
      qualities = [1080, 720, 480, 360];
    }

    if (!mounted) return;

    final List<PopupMenuEntry<String>> menuItems = [
      PopupMenuItem<String>(
        value: 'Auto',
        child: Row(
          children: [
            Icon(
              Icons.check_rounded,
              color: _currentQuality == 'Auto' ? Colors.orange : Colors.transparent,
              size: 18,
            ),
            const SizedBox(width: 8),
            const Text(
              'Auto (Adaptive)',
              style: TextStyle(color: Colors.white, fontSize: GoPlayType.base),
            ),
          ],
        ),
      ),
      const PopupMenuDivider(height: 1),
      ...qualities.map((q) {
        final label = '${q}p';
        final isSelected = _currentQuality == label;
        return PopupMenuItem<String>(
          value: label,
          child: Row(
            children: [
              Icon(
                Icons.check_rounded,
                color: isSelected ? Colors.orange : Colors.transparent,
                size: 18,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: GoPlayType.family,
                    color: Colors.white,
                    fontSize: GoPlayType.base,
                    height: GoPlayType.leadingSnug,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }),
    ];

    final messenger = ScaffoldMessenger.of(context);

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx - 60,
        position.dy - 200,
        position.dx + 60,
        position.dy,
      ),
      color: const Color(0xE61F1F23),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white12, width: 0.8),
      ),
      items: menuItems,
      elevation: 8,
    );

    if (selected != null && mounted) {
      int height = -1;
      if (selected != 'Auto') {
        height = int.tryParse(selected.replaceAll('p', '')) ?? -1;
      }
      _setQuality(selected, height);
      messenger.showSnackBar(
        SnackBar(
          content: Text('Quality set to: $selected'),
          duration: const Duration(milliseconds: 800),
        ),
      );
    }
  }


  // ─── Widget lifecycle ────────────────────────────────────────────

  late final FocusNode _focusNode;
  // GlobalKey used to find the play/pause TvFocusable's FocusNode so we can
  // explicitly request focus when controls are shown via remote.
  final GlobalKey _playPauseKey = GlobalKey();

  // Explicit FocusNodes for Row 3a (Seek Bar) and Row 3b (Bottom Buttons)
  // to ensure 100% deterministic D-Pad Up/Down navigation between all 4 control rows.
  final FocusNode _seekBarFocusNode = FocusNode(debugLabel: 'SeekBarFocusNode');
  final FocusNode _bottomControlsFocusNode = FocusNode(debugLabel: 'BottomControlsFocusNode');

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode(debugLabel: 'PlayerFocusNode');
    // NOTE: The play/pause TvFocusable button has autoFocus:true so it
    // grabs focus first within the player scope. The outer _focusNode then
    // acts as a passive event-bubbling catcher for media keys.

    // Initialize the connectivity service and state machine
    _connectivityService = ConnectivityService();
    _connectivityService.initialize();

    _stateMachine = PlaybackStateMachine(
      connectivityService: _connectivityService,
      telemetry: PlaybackTelemetry(),
    );

    // Wire state machine callbacks
    _stateMachine.onRetryPlayback = _retryPlaybackInternal;
    _stateMachine.onSwitchChannel = (channelId) {
      if (widget.onNextChannel != null || widget.onPreviousChannel != null) {
        widget.onNextChannel?.call();
      }
    };
    _stateMachine.onSkipRequest = () {
      final servers = widget.servers;
      if (servers != null &&
          servers.length > 1 &&
          widget.activeServerIndex < servers.length - 1) {
        debugPrint(
            'PlayerWidget: error on server ${widget.activeServerIndex}, auto-falling back to server ${widget.activeServerIndex + 1}');
        widget.onServerSelected?.call(widget.activeServerIndex + 1);
        return;
      }
      if (widget.onNextChannel != null) {
        debugPrint('PlayerWidget: skipping to next channel (immediate skip)');
        widget.onNextChannel!();
      } else if (widget.onPreviousChannel != null) {
        debugPrint('PlayerWidget: skipping to previous channel (immediate skip)');
        widget.onPreviousChannel!();
      } else {
        debugPrint('PlayerWidget: no next/prev channel to skip to — showing error screen');
        _stateMachine.forceFail(const ClassifiedError(
          type: ErrorType.unknown,
          strategy: RecoveryStrategy.showError,
          rawMessage: 'No adjacent channels available to skip to.',
          isRecoverable: false,
        ));
      }
    };

    // Listen for state machine changes
    _stateMachine.addListener(_onStateMachineChanged);

    // Tell the state machine about the initial channel
    _stateMachine.playChannel(widget.channel);
  }

  @override
  void didUpdateWidget(ChannelVideoPlayerNative oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.channel.id != widget.channel.id ||
        oldWidget.channel.streamUrl != widget.channel.streamUrl) {
      // Stop old Toffee auth timer if needed
      if (oldWidget.channel.streamUrl.contains('otte.cache.aiv-cdn.net')) {
        LocalProxy.stopKkx4Auth();
      }
      if (widget.channel.streamUrl.contains('otte.cache.aiv-cdn.net')) {
        LocalProxy.startKkx4Auth();
      }

      // Tell state machine about the new channel
      _stateMachine.playChannel(widget.channel);

      _cachedParams = null;

      setState(() {
        _hasError = false;
        _errorMessage = null;
        _isBuffering = true;
        _position = Duration.zero;
        _duration = Duration.zero;
        _bufferedPosition = Duration.zero;
      });

      _methodChannel?.invokeMethod('play', _getCreationParams());

      // In fullscreen, after a channel switch (e.g. from chip selection in the
      // top bar), autoFocus does NOT re-fire (it only fires on first insert).
      // Explicitly move focus back to play/pause so the user is not stuck on
      // the top-bar chip and can reach all center/bottom controls via D-Pad.
      if (widget.isFullscreen) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final ctx = _playPauseKey.currentContext;
          if (ctx != null) {
            Focus.of(ctx).requestFocus();
          }
        });
      }
    }
  }

  Timer? _osdTimer;
  String? _osdText;
  IconData? _osdIcon;

  void _showOsd(String text, IconData icon) {
    _osdTimer?.cancel();
    if (mounted) {
      setState(() {
        _osdText = text;
        _osdIcon = icon;
      });
    }
    _osdTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _osdText = null;
          _osdIcon = null;
        });
      }
    });
  }

  void _seekRelative(int seconds, {bool wakeControls = true}) {
    if (_duration <= Duration.zero) return;
    final newPos = _position + Duration(seconds: seconds);
    final target = newPos < Duration.zero
        ? Duration.zero
        : (newPos > _duration ? _duration : newPos);
    _seekTo(target);
    if (wakeControls) {
      if (!widget.showControls) {
        widget.onTap?.call();
      }
      widget.onInteract?.call();
    }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _methodChannel?.invokeMethod('pause');
    } else {
      _methodChannel?.invokeMethod('resume');
    }
    if (!widget.showControls) {
      widget.onTap?.call();
    }
    widget.onInteract?.call();
  }

  /// D-Pad key mapping on TV remote:
  ///
  ///  OK / Select / Enter / Space → Show controls if hidden, then activate
  ///                                  focused button or toggle play/pause.
  ///  Up / Down (non-fullscreen)   → Previous / next channel.
  ///  Up / Down (fullscreen)       → Ignored — Flutter traversal moves focus
  ///                                  between rows (top bar → center → bottom).
  ///  Left / Right                 → Ignored — Flutter traversal moves focus
  ///                                  between buttons in the same row.
  ///  Media keys                   → Play, pause, rewind, fast-forward.
  KeyEventResult _handlePlayerKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;

    // Any key press → ensure controls are visible and timer is refreshed.
    // This is the TV "wake up controls" behaviour.
    if (!widget.showControls) {
      widget.onTap?.call(); // toggles controls visible in parent
      // After showing controls, move focus to play/pause so the user can
      // immediately navigate with D-Pad without an extra key press.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.playPauseFocusNode != null) {
          widget.playPauseFocusNode!.requestFocus();
        } else {
          final ctx = _playPauseKey.currentContext;
          if (ctx != null) {
            Focus.of(ctx).requestFocus();
          }
        }
      });
      return KeyEventResult.handled;
    } else {
      widget.onInteract?.call(); // just resets the hide timer
    }

    // ── Play / Pause (fallback when no child button is focused) ──
    // TvFocusable buttons handle OK themselves; this covers the case where
    // the outer node has focus (e.g. error state, buffering).
    if (key == LogicalKeyboardKey.select ||
        key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.space ||
        key == LogicalKeyboardKey.gameButtonA ||
        key == LogicalKeyboardKey.accept ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.mediaPlayPause ||
        key == LogicalKeyboardKey.mediaPlay ||
        key == LogicalKeyboardKey.mediaPause) {
      // Only act if the outer node (not a TvFocusable child) has primary focus
      if (_focusNode.hasPrimaryFocus) {
        _togglePlayPause();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored; // let TvFocusable child handle it
    }

    // ── Media rewind/fast-forward keys (dedicated remote buttons) ──
    // These are DISTINCT from D-Pad Left/Right and should always seek.
    if (key == LogicalKeyboardKey.mediaRewind ||
        key == LogicalKeyboardKey.mediaStepBackward) {
      _seekRelative(-10);
      _showOsd('-10s', Icons.replay_10_rounded);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.mediaFastForward ||
        key == LogicalKeyboardKey.mediaStepForward) {
      _seekRelative(10);
      _showOsd('+10s', Icons.forward_10_rounded);
      return KeyEventResult.handled;
    }

    // ── D-Pad Left / Right ──
    // Return `ignored` — Flutter's directional traversal policy will move
    // focus to the prev/next TvFocusable button automatically.
    if (key == LogicalKeyboardKey.arrowLeft ||
        key == LogicalKeyboardKey.arrowRight) {
      return KeyEventResult.ignored;
    }

    // ── Up / Down ──
    // Return `ignored` so Flutter's directional traversal can move focus
    // smoothly between all control buttons (Play/Pause, Fullscreen Toggle, etc.).
    // Dedicated physical channel +/- buttons on TV remotes handle channel switching.
    if (key == LogicalKeyboardKey.channelUp) {
      if (widget.onPreviousChannel != null) {
        widget.onPreviousChannel!();
        return KeyEventResult.handled;
      }
    }

    if (key == LogicalKeyboardKey.channelDown) {
      if (widget.onNextChannel != null) {
        widget.onNextChannel!();
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _osdTimer?.cancel();
    _osdHideTimer?.cancel();
    _doubleTapResetTimer?.cancel();
    _brightnessOsdNotifier.dispose();
    _volumeOsdNotifier.dispose();
    _scrubPositionNotifier.dispose();
    _seekDeltaNotifier.dispose();
    _stopProgressTimer();
    _focusNode.dispose();
    _seekBarFocusNode.dispose();
    _bottomControlsFocusNode.dispose();
    _stateMachine.removeListener(_onStateMachineChanged);
    _stateMachine.dispose();
    _connectivityService.dispose();
    if (widget.channel.streamUrl.contains('otte.cache.aiv-cdn.net')) {
      LocalProxy.stopKkx4Auth();
    }
    _methodChannel?.setMethodCallHandler(null);
    super.dispose();
  }

  // ─── Build ───────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_hasError) return _buildErrorWidget();

    return Focus(
      focusNode: _focusNode,
      // autofocus: false — the play/pause TvFocusable inside has autoFocus:true.
      // This outer Focus only serves as an event-bubbling catcher for Up/Down
      // channel switching. It must NOT steal focus from the child buttons.
      autofocus: false,
      onKeyEvent: _handlePlayerKeyEvent,
      child: ColoredBox(
        color: Colors.black,
        child: SizedBox.expand(
          child: Stack(
            children: [
              // Native ExoPlayer view — disabled from taking D-Pad focus
              Focus(
                canRequestFocus: false,
                child: AndroidView(
                  viewType: 'com.goplay/native_player',
                  creationParams: _getCreationParams(),
                  creationParamsCodec: const StandardMessageCodec(),
                  onPlatformViewCreated: _onPlatformViewCreated,
                ),
              ),

              // Buffering indicator (isolated — when controls are hidden)
              if (_isBuffering && !widget.showControls)
                const Center(
                  child: RepaintBoundary(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),

              // Tap & gesture overlay to show/hide controls or double-tap / pan scrub when controls are hidden
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.onTap,
                  onDoubleTapDown: _handleDoubleTapDown,
                  onDoubleTap: () {},
                  onPanStart: _handlePanStart,
                  onPanUpdate: _handlePanUpdate,
                  onPanEnd: _handlePanEnd,
                  onPanCancel: _handlePanCancel,
                  child: const SizedBox.shrink(),
                ),
              ),

              // Controls UI layer
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: !widget.showControls,
                  child: Listener(
                    onPointerDown: (_) {
                      widget.onInteract?.call();
                    },
                    child: AnimatedOpacity(
                      opacity: widget.showControls ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: _isLocked
                          ? _buildLockedControls()
                          : _buildUnlockedControls(),
                    ),
                  ),
                ),
              ),

              // ── 3-Zone Double Tap Seek Ripple Overlay (Left & Right) ──
              Positioned.fill(
                child: IgnorePointer(
                  child: _DoubleTapSeekOverlay(
                    showLeft: _showDoubleTapLeft,
                    showRight: _showDoubleTapRight,
                    seconds: _doubleTapSeekSeconds,
                  ),
                ),
              ),

              // ── Swipe Scrub HUD Overlay (Centered) ──
              Positioned.fill(
                child: IgnorePointer(
                  child: _SwipeScrubOsd(
                    scrubPositionNotifier: _scrubPositionNotifier,
                    seekDeltaNotifier: _seekDeltaNotifier,
                    duration: _duration,
                  ),
                ),
              ),

              // ── Brightness & Volume OSD (Fullscreen) ──
              if (widget.isFullscreen) ...[
                Positioned(
                  left: 36,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: RepaintBoundary(
                      child: IgnorePointer(
                        child: _BrightnessOsd(notifier: _brightnessOsdNotifier),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 36,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: RepaintBoundary(
                      child: IgnorePointer(
                        child: _VolumeOsd(notifier: _volumeOsdNotifier),
                      ),
                    ),
                  ),
                ),
              ],

              // ── State machine status overlay ──
              Positioned(
                left: 0,
                right: 0,
                bottom: widget.isFullscreen ? 80 : 56,
                child: Center(
                  child: _StateMachineOverlay(stateMachine: _stateMachine),
                ),
              ),

              // ── Android TV Remote OSD Feedback ──
              Positioned.fill(
                child: IgnorePointer(
                  child: _TvPlayerOsd(
                    message: _osdText,
                    icon: _osdIcon,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Locked controls ─────────────────────────────────────────────

  Widget _buildLockedControls() {
    return Stack(
      children: [
        Positioned(
          left: widget.isFullscreen ? 24 : 12,
          bottom: widget.isFullscreen ? 24 : 12,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isLocked = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(color: Colors.white30, width: 1.0),
                ),
              ),
              child: const Icon(
                Icons.lock_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Unlocked controls ───────────────────────────────────────────

  Widget _buildUnlockedControls() {
    return Stack(
      children: [
        // Dark gradient overlay — pre-cached decorations
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            onDoubleTapDown: _handleDoubleTapDown,
            onDoubleTap: () {},
            onPanStart: _handlePanStart,
            onPanUpdate: _handlePanUpdate,
            onPanEnd: _handlePanEnd,
            onPanCancel: _handlePanCancel,
            child: DecoratedBox(
              decoration: widget.isFullscreen
                  ? _kGradientOverlayFS
                  : _kGradientOverlayPortrait,
            ),
          ),
        ),

        // Central Playback Controls — isolated from seek-bar repaints
        Center(
          child: RepaintBoundary(
            child: _CentralControls(
              isPlaying: _isPlaying,
              isBuffering: _isBuffering,
              playPauseKey: _playPauseKey,
              playPauseFocusNode: widget.playPauseFocusNode,
              onPlayPause: () {
                if (_isPlaying) {
                  _methodChannel?.invokeMethod('pause');
                } else {
                  _methodChannel?.invokeMethod('resume');
                }
              },
              onPrev: widget.onPreviousChannel,
              onNext: widget.onNextChannel,
              onRewind: () {
                final newPos = _position - const Duration(seconds: 10);
                _seekTo(newPos < Duration.zero ? Duration.zero : newPos);
              },
              onForward: () {
                final newPos = _position + const Duration(seconds: 10);
                _seekTo(newPos > _duration ? _duration : newPos);
              },
              isFullscreen: widget.isFullscreen,
              autoFocus: widget.isFullscreen,
              onFocusDown: () => _seekBarFocusNode.requestFocus(),
              onInteract: widget.onInteract,
            ),
          ),
        ),

        // Bottom Controls Bar — isolated from central controls repaints
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: RepaintBoundary(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.95),
                    Colors.black.withValues(alpha: 0.72),
                    Colors.black.withValues(alpha: 0.32),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.45, 0.80, 1.0],
                ),
              ),
              padding: EdgeInsets.only(
                top: widget.isFullscreen ? 22.0 : 8.0,
                bottom: widget.isFullscreen ? 10.0 : 8.0,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth;
                  final isCompact = availableWidth < 580;
                  final hPadding = isCompact ? 14.0 : 24.0;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Seek Bar / Timeline — inset horizontally to align with bottom buttons & time row
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: hPadding),
                        child: RepaintBoundary(
                          child: _FocusableSeekBar(
                            position: _position,
                            duration: _duration,
                            bufferedPosition: _bufferedPosition,
                            onSeek: _seekTo,
                            onScrubbingChanged: (scrubbing) {
                              setState(() {
                                _isScrubbing = scrubbing;
                              });
                            },
                            isFullscreen: widget.isFullscreen,
                            onSeekRelative: _seekRelative,
                            onInteract: widget.onInteract,
                            focusNode: _seekBarFocusNode,
                            onFocusDown: () => _bottomControlsFocusNode.requestFocus(),
                            onFocusUp: () {
                              if (widget.playPauseFocusNode != null) {
                                widget.playPauseFocusNode!.requestFocus();
                              } else {
                                final ctx = _playPauseKey.currentContext;
                                if (ctx != null) Focus.of(ctx).requestFocus();
                              }
                            },
                          ),
                        ),
                      ),

                      // Bottom Buttons row — tightened immediately under seek bar
                      Padding(
                        padding: EdgeInsets.only(
                          left: hPadding,
                          right: hPadding,
                          bottom: widget.isFullscreen ? 4.0 : 0.0,
                          top: 0.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Time text / Adaptive Live badge with Tabular Figures
                            if (_isLive && _duration == Duration.zero)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFC8FF00),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFC8FF00).withValues(alpha: 0.8),
                                          blurRadius: 8,
                                          spreadRadius: 1.5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'LIVE',
                                    style: TextStyle(
                                      fontFamily: GoPlayType.family,
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.4,
                                    ),
                                  ),
                                ],
                              )
                            else
                              Flexible(
                                fit: FlexFit.loose,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        _formatDuration(_position),
                                        style: TextStyle(
                                          fontFamily: GoPlayType.family,
                                          color: Colors.white,
                                          fontSize: isCompact ? 12.5 : 14,
                                          fontWeight: FontWeight.w600,
                                          fontFeatures: const [FontFeature.tabularFigures()],
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      Text(
                                        ' / ',
                                        style: TextStyle(
                                          fontFamily: GoPlayType.family,
                                          color: Colors.white.withValues(alpha: 0.45),
                                          fontSize: isCompact ? 11.5 : 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        _formatDuration(_duration),
                                        style: TextStyle(
                                          fontFamily: GoPlayType.family,
                                          color: Colors.white.withValues(alpha: 0.70),
                                          fontSize: isCompact ? 12.5 : 14,
                                          fontWeight: FontWeight.w500,
                                          fontFeatures: const [FontFeature.tabularFigures()],
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            if (widget.isFullscreen)
                              _buildFullscreenRightControls(availableWidth: availableWidth)
                            else
                              _buildPortraitRightControls(),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullscreenRightControls({required double availableWidth}) {
    final bool isCompact = availableWidth < 580;
    final double iconSize = isCompact ? 22.0 : 28.0;
    final double btnPadding = isCompact ? 5.0 : 7.0;
    final double btnSpacing = isCompact ? 4.0 : 6.0;
    // On narrow screens (< 360px), hide PiP to guarantee zero overflow
    final bool showPip = !isCompact || availableWidth >= 360;

    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) {
        if ((event is KeyDownEvent || event is KeyRepeatEvent) &&
            widget.isFullscreen) {
          widget.onInteract?.call();
          final key = event.logicalKey;
          if (key == LogicalKeyboardKey.arrowUp) {
            _seekBarFocusNode.requestFocus();
            return KeyEventResult.handled;
          }
          if (key == LogicalKeyboardKey.arrowDown) {
            // Prevent focus loss when pressing Down on the bottom-most row!
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Picture-in-Picture Button
          if (showPip) ...[
            TvFocusable(
              focusNode: _bottomControlsFocusNode,
              isCircle: true,
              focusColor: GoPlayTheme.primary,
              onTap: _enterPiP,
              child: Padding(
                padding: EdgeInsets.all(btnPadding),
                child: Icon(Icons.picture_in_picture_alt_rounded, color: Colors.white, size: iconSize),
              ),
            ),
            SizedBox(width: btnSpacing),
          ],

          // 2. Aspect Ratio Button
          TvFocusable(
            focusNode: showPip ? null : _bottomControlsFocusNode,
            isCircle: true,
            focusColor: GoPlayTheme.primary,
            onTap: _toggleAspectRatio,
            child: Padding(
              padding: EdgeInsets.all(btnPadding),
              child: Icon(Icons.fit_screen_rounded, color: Colors.white, size: iconSize),
            ),
          ),
          SizedBox(width: btnSpacing),

          // 3. Volume Button
          TvFocusable(
            isCircle: true,
            focusColor: GoPlayTheme.primary,
            onTap: _toggleMute,
            child: Padding(
              padding: EdgeInsets.all(btnPadding),
              child: Icon(
                _isMuted || _volume == 0
                    ? Icons.volume_off_rounded
                    : (_volume < 0.5 ? Icons.volume_down_rounded : Icons.volume_up_rounded),
                color: Colors.white,
                size: iconSize,
              ),
            ),
          ),
          SizedBox(width: btnSpacing),

          // 4. Lock Button
          TvFocusable(
            isCircle: true,
            focusColor: GoPlayTheme.primary,
            onTap: () {
              setState(() {
                _isLocked = true;
              });
            },
            child: Padding(
              padding: EdgeInsets.all(btnPadding),
              child: Icon(Icons.lock_open_rounded, color: Colors.white, size: iconSize),
            ),
          ),
          SizedBox(width: btnSpacing),

          // 5. Settings / Server Selection Button (when channel has multiple servers)
          if (widget.servers != null && widget.servers!.length > 1) ...[
            TvFocusable(
              isCircle: true,
              focusColor: GoPlayTheme.primary,
              onTap: _showServerSelectionModal,
              child: Padding(
                padding: EdgeInsets.all(btnPadding),
                child: Icon(Icons.tune_rounded, color: Colors.white, size: iconSize),
              ),
            ),
            SizedBox(width: btnSpacing),
          ],

          // 6. Fullscreen Toggle Button
          if (widget.onFullscreenToggle != null)
            TvFocusable(
              isCircle: true,
              focusColor: GoPlayTheme.primary,
              onTap: widget.onFullscreenToggle,
              child: Padding(
                padding: EdgeInsets.all(btnPadding),
                child: Icon(
                  widget.isFullscreen ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
                  color: Colors.white,
                  size: iconSize,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPortraitRightControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Picture-in-Picture Button
        TvFocusable(
          isCircle: true,
          focusColor: GoPlayTheme.primary,
          onTap: _enterPiP,
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(
              Icons.picture_in_picture_alt_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 6),

        // 2. Volume Button
        TvFocusable(
          isCircle: true,
          focusColor: GoPlayTheme.primary,
          onTap: _toggleMute,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              _isMuted || _volume == 0
                  ? Icons.volume_off_rounded
                  : (_volume < 0.5 ? Icons.volume_down_rounded : Icons.volume_up_rounded),
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 6),

        // 3. Fullscreen Toggle Button
        if (widget.onFullscreenToggle != null)
          TvFocusable(
            isCircle: true,
            focusColor: GoPlayTheme.primary,
            onTap: widget.onFullscreenToggle,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                widget.isFullscreen ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
      ],
    );
  }

  void _showServerSelectionModal() {
    final servers = widget.servers;
    if (servers == null || servers.isEmpty) return;
    widget.onInteract?.call();

    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 290,
              height: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xF2121216),
                border: Border(
                  left: BorderSide(
                    color: Colors.white.withValues(alpha: 0.12),
                    width: 1,
                  ),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x99000000),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: SafeArea(
                left: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header: "Servers" + Close (X)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 12, 14),
                      child: Row(
                        children: [
                          const Text(
                            'Servers',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const Spacer(),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => Navigator.of(dialogContext).pop(),
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                    // Server list
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        itemCount: servers.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final s = servers[index];
                          final isSelected = index == widget.activeServerIndex;
                          final displayName = s.name.isNotEmpty ? s.name : 'Server ${index + 1}';
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Navigator.of(dialogContext).pop();
                                if (index != widget.activeServerIndex) {
                                  widget.onServerSelected?.call(index);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? GoPlayTheme.primary.withValues(alpha: 0.15)
                                      : const Color(0xFF1E1E22),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? GoPlayTheme.primary
                                        : Colors.white.withValues(alpha: 0.08),
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        displayName,
                                        style: TextStyle(
                                          color: isSelected ? GoPlayTheme.primary : Colors.white,
                                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: GoPlayTheme.primary,
                                        size: 20,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
        final slideIn = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ));
        return SlideTransition(position: slideIn, child: child);
      },
    );
  }

  // ─── Error widget (state-machine aware) ───────────────────────────

  Widget _buildErrorWidget() {
    final smState = _stateMachine.state;
    final errorType = smState.error?.type;
    final isDrm = errorType == ErrorType.drmFailure || widget.channel.hasDrm;
    final isNoInternet = errorType == ErrorType.noInternet ||
        smState.phase == PlaybackPhase.waitingForInternet;
    final isGeoBlock = errorType == ErrorType.geoBlock;
    final hasNext = widget.onNextChannel != null;
    final hasPrev = widget.onPreviousChannel != null;

    // Choose icon based on error type
    IconData errorIcon;
    Color iconColor;
    String errorTitle;

    if (isNoInternet) {
      errorIcon = Icons.wifi_off_rounded;
      iconColor = Colors.orange;
      errorTitle = 'No Internet Connection';
    } else if (isDrm) {
      errorIcon = Icons.lock_outline;
      iconColor = Colors.orange;
      errorTitle = 'DRM Protected Content';
    } else if (isGeoBlock) {
      errorIcon = Icons.shield_outlined;
      iconColor = Colors.redAccent;
      errorTitle = 'Content Not Available';
    } else {
      errorIcon = Icons.signal_wifi_statusbar_connected_no_internet_4_rounded;
      iconColor = Colors.redAccent;
      errorTitle = 'Stream Unavailable';
    }

    return ColoredBox(
      color: Colors.black,
      child: SizedBox.expand(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(errorIcon, color: iconColor, size: 48),
              const SizedBox(height: 14),
              Text(
                errorTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: GoPlayType.family,
                  color: Colors.white,
                  fontSize: GoPlayType.md,
                  fontWeight: FontWeight.w700,
                  height: GoPlayType.leadingSnug,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  widget.channel.displayName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: GoPlayType.family,
                    color: Colors.white70,
                    fontSize: GoPlayType.sm,
                    fontWeight: FontWeight.w400,
                    height: GoPlayType.leadingSnug,
                  ),
                  // Channel names come from the remote catalogue.
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _errorMessage ?? 'Unable to play this stream',
                  style: const TextStyle(
                    fontFamily: GoPlayType.family,
                    color: Colors.white70,
                    fontSize: GoPlayType.sm,
                    height: GoPlayType.leadingBody,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 20),
              // Action buttons row
              Wrap(
                spacing: 10,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  // Retry button
                  _ErrorActionButton(
                    icon: Icons.refresh_rounded,
                    label: isNoInternet ? 'Check Connection' : 'Retry',
                    onTap: _retryPlayback,
                    isPrimary: true,
                  ),
                  // Next Channel button
                  if (hasNext)
                    _ErrorActionButton(
                      icon: Icons.skip_next_rounded,
                      label: 'Next Channel',
                      onTap: () {
                        widget.onNextChannel!();
                      },
                      isPrimary: false,
                    ),
                  // Previous Channel button (fallback if no next)
                  if (!hasNext && hasPrev)
                    _ErrorActionButton(
                      icon: Icons.skip_previous_rounded,
                      label: 'Prev Channel',
                      onTap: () {
                        widget.onPreviousChannel!();
                      },
                      isPrimary: false,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ─── Error Action Button ─────────────────────────────────────────

class _ErrorActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ErrorActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: isPrimary ? Colors.white : Colors.white70,
        backgroundColor: isPrimary
            ? Colors.orange.shade800
            : Colors.white.withAlpha(25),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isPrimary
              ? BorderSide.none
              : const BorderSide(color: Colors.white24, width: 0.8),
        ),
      ),
    );
  }
}

// ─── State Machine Status Overlay ─────────────────────────────────

/// Shows contextual overlays based on the [PlaybackStateMachine] state:
/// - Retrying: "Retrying (2/3)..."
/// - Skipping: "Skipping in 5s... [Cancel] [Skip Now]"
/// - Waiting for Internet: "Waiting for internet..."
class _StateMachineOverlay extends StatelessWidget {
  final PlaybackStateMachine stateMachine;

  const _StateMachineOverlay({required this.stateMachine});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: stateMachine,
      builder: (context, _) {
        final state = stateMachine.state;

        switch (state.phase) {
          case PlaybackPhase.retrying:
            return _StatusPill(
              icon: Icons.refresh_rounded,
              iconColor: Colors.orangeAccent,
              message: 'Retrying (${state.retryAttempt}/${state.maxRetries})…',
              showSpinner: true,
            );

          case PlaybackPhase.skipping:
            return _SkipCountdownPill(
              secondsRemaining: state.skipCountdown ?? 0,
              onCancel: () => stateMachine.cancelSkip(),
              onSkipNow: () => stateMachine.skipNow(),
            );

          case PlaybackPhase.waitingForInternet:
            return const _StatusPill(
              icon: Icons.wifi_off_rounded,
              iconColor: Colors.orange,
              message: 'Waiting for internet…',
              showSpinner: true,
            );

          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}

/// Simple status pill with icon/spinner + message.
class _StatusPill extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String message;
  final bool showSpinner;

  const _StatusPill({
    required this.icon,
    required this.iconColor,
    required this.message,
    this.showSpinner = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(200),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showSpinner)
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                color: Colors.orangeAccent,
                strokeWidth: 1.5,
              ),
            )
          else
            Icon(icon, color: iconColor, size: 14),
          const SizedBox(width: 8),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: GoPlayType.sm,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Skip countdown pill with [Cancel] and [Skip Now] buttons.
class _SkipCountdownPill extends StatelessWidget {
  final int secondsRemaining;
  final VoidCallback onCancel;
  final VoidCallback onSkipNow;

  const _SkipCountdownPill({
    required this.secondsRemaining,
    required this.onCancel,
    required this.onSkipNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(210),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.orange.withAlpha(100), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              color: Colors.orangeAccent,
              strokeWidth: 1.5,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Skipping in ${secondsRemaining}s',
            style: const TextStyle(
              color: Colors.white,
              fontSize: GoPlayType.sm,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onCancel,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white38, width: 0.8),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: GoPlayType.xs,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onSkipNow,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.shade800,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Skip Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: GoPlayType.xs,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ─── Central Playback Controls ────────────────────────────────────

/// Extracted central playback controls (prev, rewind, play/pause, forward, next)
class _CentralControls extends StatelessWidget {
  final bool isPlaying;
  final bool isBuffering;
  final VoidCallback onPlayPause;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback onRewind;
  final VoidCallback onForward;
  final bool isFullscreen;
  /// When true, the play/pause button requests autofocus so it's the first
  /// button reachable by D-Pad when the player opens.
  final bool autoFocus;
  /// Key placed on the play/pause TvFocusable so its FocusNode can be looked
  /// up from the parent state to auto-focus when controls appear.
  final GlobalKey? playPauseKey;
  final FocusNode? playPauseFocusNode;
  final VoidCallback? onFocusDown;
  final VoidCallback? onInteract;

  const _CentralControls({
    required this.isPlaying,
    required this.isBuffering,
    required this.onPlayPause,
    required this.onPrev,
    required this.onNext,
    required this.onRewind,
    required this.onForward,
    required this.isFullscreen,
    this.autoFocus = false,
    this.playPauseKey,
    this.playPauseFocusNode,
    this.onFocusDown,
    this.onInteract,
  });

  @override
  Widget build(BuildContext context) {
    final double iconSize = isFullscreen ? 34 : 24;
    final double playSize = isFullscreen ? 60 : 44;
    final double buttonSize = isFullscreen ? 48 : 36;
    final double spacing = isFullscreen ? 20 : 12;

    final hasPrev = onPrev != null;
    final hasNext = onNext != null;

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 1. Previous Channel Button
        TvFocusable(
          isCircle: true,
          onTap: onPrev,
          child: SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: Icon(
              Icons.skip_previous_rounded,
              color: hasPrev ? Colors.white : Colors.white38,
              size: iconSize,
            ),
          ),
        ),
        SizedBox(width: spacing),

        // 2. Rewind 10s Button
        TvFocusable(
          isCircle: true,
          onTap: onRewind,
          child: SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: Icon(
              Icons.replay_10_rounded,
              color: Colors.white,
              size: iconSize,
            ),
          ),
        ),
        SizedBox(width: spacing),

        // 3. Play / Pause Button — autofocus so D-Pad starts here
        TvFocusable(
          key: playPauseKey,
          focusNode: playPauseFocusNode,
          isCircle: true,
          autoFocus: autoFocus,
          onTap: onPlayPause,
          child: Container(
            width: playSize,
            height: playSize,
            decoration: const BoxDecoration(
              color: Colors.black45,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isBuffering
                  ? SizedBox(
                      width: playSize * 0.5,
                      height: playSize * 0.5,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: isFullscreen ? 2.5 : 2.0,
                      ),
                    )
                  : Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: playSize * 0.75,
                    ),
            ),
          ),
        ),
        SizedBox(width: spacing),

        // 4. Forward 10s Button
        TvFocusable(
          isCircle: true,
          onTap: onForward,
          child: SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: Icon(
              Icons.forward_10_rounded,
              color: Colors.white,
              size: iconSize,
            ),
          ),
        ),
        SizedBox(width: spacing),

        // 5. Next Channel Button
        TvFocusable(
          isCircle: true,
          onTap: onNext,
          child: SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: Icon(
              Icons.skip_next_rounded,
              color: hasNext ? Colors.white : Colors.white38,
              size: iconSize,
            ),
          ),
        ),
      ],
    );

    if (onFocusDown == null) return row;

    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent || event is KeyRepeatEvent) {
          onInteract?.call();
          if (event.logicalKey == LogicalKeyboardKey.arrowDown && isFullscreen) {
            onFocusDown?.call();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: row,
    );
  }
}

// ─── Focusable Seek Bar ──────────────────────────────────────────

/// TV-focusable wrapper around [PlayerProgressBar].
/// When focused, D-Pad Left seeks -10s and D-Pad Right seeks +10s.
class _FocusableSeekBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final Duration bufferedPosition;
  final ValueChanged<Duration> onSeek;
  final ValueChanged<bool>? onScrubbingChanged;
  final bool isFullscreen;
  final void Function(int seconds) onSeekRelative;
  final VoidCallback? onInteract;
  final FocusNode? focusNode;
  final VoidCallback? onFocusDown;
  final VoidCallback? onFocusUp;

  const _FocusableSeekBar({
    required this.position,
    required this.duration,
    required this.bufferedPosition,
    required this.onSeek,
    this.onScrubbingChanged,
    required this.isFullscreen,
    required this.onSeekRelative,
    this.onInteract,
    this.focusNode,
    this.onFocusDown,
    this.onFocusUp,
  });

  @override
  State<_FocusableSeekBar> createState() => _FocusableSeekBarState();
}

class _FocusableSeekBarState extends State<_FocusableSeekBar> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Focused label
        if (_isFocused && widget.isFullscreen)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.keyboard_arrow_left, color: Colors.white54, size: 14),
                SizedBox(width: 2),
                Text(
                  '← Seek →',
                  style: TextStyle(color: Colors.white70, fontSize: GoPlayType.xs, letterSpacing: GoPlayType.trackingMeta),
                ),
                SizedBox(width: 2),
                Icon(Icons.keyboard_arrow_right, color: Colors.white54, size: 14),
              ],
            ),
          ),
        TvFocusable(
          focusNode: widget.focusNode,
          borderRadius: BorderRadius.circular(4),
          onFocusChange: (focused) {
            setState(() {
              _isFocused = focused;
            });
          },
          onKeyEvent: (node, event) {
            if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
              return KeyEventResult.ignored;
            }
            final key = event.logicalKey;
            if (key == LogicalKeyboardKey.arrowLeft) {
              widget.onSeekRelative(-10);
              widget.onInteract?.call();
              return KeyEventResult.handled;
            }
            if (key == LogicalKeyboardKey.arrowRight) {
              widget.onSeekRelative(10);
              widget.onInteract?.call();
              return KeyEventResult.handled;
            }
            if (key == LogicalKeyboardKey.arrowDown && widget.isFullscreen) {
              widget.onFocusDown?.call();
              return KeyEventResult.handled;
            }
            if (key == LogicalKeyboardKey.arrowUp && widget.isFullscreen) {
              widget.onFocusUp?.call();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          onTap: () {},
          child: PlayerProgressBar(
            position: widget.position,
            duration: widget.duration,
            bufferedPosition: widget.bufferedPosition,
            onSeek: widget.onSeek,
            onScrubbingChanged: widget.onScrubbingChanged,
            isFullscreen: widget.isFullscreen,
          ),
        ),
      ],
    );
  }
}

// ─── Progress Bar ─────────────────────────────────────────────────

/// Custom Seek Bar ProgressBar with Buffer Indicator, 44px Touch Target & Floating Time Pill
class PlayerProgressBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final Duration bufferedPosition;
  final ValueChanged<Duration> onSeek;
  final ValueChanged<bool>? onScrubbingChanged;
  final bool isFullscreen;

  const PlayerProgressBar({
    super.key,
    required this.position,
    required this.duration,
    required this.bufferedPosition,
    required this.onSeek,
    this.onScrubbingChanged,
    required this.isFullscreen,
  });

  @override
  State<PlayerProgressBar> createState() => _PlayerProgressBarState();
}

class _PlayerProgressBarState extends State<PlayerProgressBar> {
  bool _isDragging = false;
  double _dragProgress = 0.0;

  double get _currentProgress {
    if (_isDragging) return _dragProgress;
    if (widget.duration <= Duration.zero) return 0.0;
    return (widget.position.inMilliseconds / widget.duration.inMilliseconds).clamp(0.0, 1.0);
  }

  Duration get _currentScrubDuration {
    if (widget.duration <= Duration.zero) return Duration.zero;
    final ms = (widget.duration.inMilliseconds * _currentProgress).round();
    return Duration(milliseconds: ms);
  }

  void _onDragStart(BuildContext context, double localX) {
    if (widget.duration <= Duration.zero) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final width = box.size.width;
    if (width <= 0) return;

    final pct = (localX / width).clamp(0.0, 1.0);
    setState(() {
      _isDragging = true;
      _dragProgress = pct;
    });
    widget.onScrubbingChanged?.call(true);
  }

  void _onDragUpdate(BuildContext context, double localX) {
    if (!_isDragging || widget.duration <= Duration.zero) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final width = box.size.width;
    if (width <= 0) return;

    final pct = (localX / width).clamp(0.0, 1.0);
    setState(() {
      _dragProgress = pct;
    });
  }

  void _onDragEnd() {
    if (!_isDragging) return;
    final target = _currentScrubDuration;
    setState(() {
      _isDragging = false;
    });
    widget.onSeek(target);
    widget.onScrubbingChanged?.call(false);
  }

  void _onDragCancel() {
    if (!_isDragging) return;
    setState(() {
      _isDragging = false;
    });
    widget.onScrubbingChanged?.call(false);
  }

  void _onTapDown(BuildContext context, double localX) {
    if (widget.duration <= Duration.zero) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final width = box.size.width;
    if (width <= 0) return;

    final pct = (localX / width).clamp(0.0, 1.0);
    final targetMs = (widget.duration.inMilliseconds * pct).round();
    widget.onSeek(Duration(milliseconds: targetMs));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.duration <= Duration.zero) {
      return const SizedBox(height: 12);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final thumbX = totalWidth * _currentProgress;
        final pillLeft = (thumbX - 35).clamp(0.0, totalWidth > 70 ? totalWidth - 70 : 0.0);

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // 44px comfortable touch target
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragStart: (details) => _onDragStart(context, details.localPosition.dx),
              onHorizontalDragUpdate: (details) => _onDragUpdate(context, details.localPosition.dx),
              onHorizontalDragEnd: (_) => _onDragEnd(),
              onHorizontalDragCancel: () => _onDragCancel(),
              onTapDown: (details) => _onTapDown(context, details.localPosition.dx),
              child: SizedBox(
                height: widget.isFullscreen ? 28.0 : 20.0,
                width: double.infinity,
                child: Center(
                  child: CustomPaint(
                    size: Size(totalWidth, _isDragging ? 5.0 : 3.0),
                    painter: _ProgressBarPainter(
                      progress: _currentProgress,
                      bufferedProgress: widget.duration.inMilliseconds > 0
                          ? (widget.bufferedPosition.inMilliseconds / widget.duration.inMilliseconds).clamp(0.0, 1.0)
                          : 0.0,
                      isDragging: _isDragging,
                    ),
                  ),
                ),
              ),
            ),

            // Floating Time Pill hovering above finger when dragging
            if (_isDragging)
              Positioned(
                left: pillLeft,
                top: -24,
                child: IgnorePointer(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xE6141418),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: GoPlayTheme.primary.withValues(alpha: 0.6),
                        width: 1.0,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black87,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Text(
                      _formatDuration(_currentScrubDuration),
                      style: const TextStyle(
                        fontFamily: GoPlayType.family,
                        color: GoPlayTheme.primary,
                        fontSize: GoPlayType.xs,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  final double progress;
  final double bufferedProgress;
  final bool isDragging;

  static final _paintBg = Paint()..color = Colors.white.withValues(alpha: 0.18);
  static final _paintBuf = Paint()..color = Colors.white.withValues(alpha: 0.38);
  static final _paintAct = Paint()..color = GoPlayTheme.primary;
  static final _paintThumb = Paint()..color = GoPlayTheme.primary;
  static final _paintThumbGlow = Paint()
    ..color = GoPlayTheme.primary.withValues(alpha: 0.35)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

  _ProgressBarPainter({
    required this.progress,
    required this.bufferedProgress,
    required this.isDragging,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final h = size.height;
    final r = Radius.circular(h / 2);

    // Background track
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, y - h / 2, size.width, h), r),
      _paintBg,
    );

    // Buffered track
    if (bufferedProgress > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, y - h / 2, size.width * bufferedProgress, h),
          r,
        ),
        _paintBuf,
      );
    }

    // Active track
    if (progress > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, y - h / 2, size.width * progress, h),
          r,
        ),
        _paintAct,
      );
    }

    // Thumb handle
    final thumbX = size.width * progress;
    if (isDragging) {
      // Glow ring
      canvas.drawCircle(Offset(thumbX, y), 12.0, _paintThumbGlow);
      // Main Thumb
      canvas.drawCircle(Offset(thumbX, y), 7.5, _paintThumb);
      // Inner dot
      canvas.drawCircle(Offset(thumbX, y), 2.5, Paint()..color = Colors.black);
    } else {
      canvas.drawCircle(Offset(thumbX, y), 5.0, _paintThumb);
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressBarPainter old) {
    return old.progress != progress ||
        old.bufferedProgress != bufferedProgress ||
        old.isDragging != isDragging;
  }
}

class _TvPlayerOsd extends StatelessWidget {
  final String? message;
  final IconData? icon;

  const _TvPlayerOsd({this.message, this.icon});

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: GoPlayTheme.primary.withValues(alpha: 0.6), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: GoPlayTheme.primary.withValues(alpha: 0.3),
              blurRadius: 16,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, color: GoPlayTheme.primary, size: 24),
            if (icon != null) const SizedBox(width: 10),
            Flexible(
              child: Text(
                message!,
                style: const TextStyle(
                  fontFamily: GoPlayType.family,
                  color: Colors.white,
                  fontSize: GoPlayType.md,
                  fontWeight: FontWeight.w700,
                  height: GoPlayType.leadingSnug,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoubleTapSeekOverlay extends StatelessWidget {
  final bool showLeft;
  final bool showRight;
  final int seconds;

  const _DoubleTapSeekOverlay({
    required this.showLeft,
    required this.showRight,
    required this.seconds,
  });

  @override
  Widget build(BuildContext context) {
    if (!showLeft && !showRight) return const SizedBox.shrink();

    final isLeft = showLeft;
    final width = MediaQuery.of(context).size.width;

    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        width: width * 0.35,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          borderRadius: BorderRadius.horizontal(
            right: isLeft ? const Radius.elliptical(80, 220) : Radius.zero,
            left: !isLeft ? const Radius.elliptical(80, 220) : Radius.zero,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isLeft ? Icons.fast_rewind_rounded : Icons.fast_forward_rounded,
                color: GoPlayTheme.primary,
                size: 38,
                shadows: const [
                  Shadow(
                    color: Colors.black87,
                    blurRadius: 8,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${seconds.abs()}s',
                style: const TextStyle(
                  fontFamily: GoPlayType.family,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: GoPlayType.base,
                  shadows: [
                    Shadow(
                      color: Colors.black87,
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwipeScrubOsd extends StatelessWidget {
  final ValueNotifier<Duration?> scrubPositionNotifier;
  final ValueNotifier<Duration?> seekDeltaNotifier;
  final Duration duration;

  const _SwipeScrubOsd({
    required this.scrubPositionNotifier,
    required this.seekDeltaNotifier,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Duration?>(
      valueListenable: scrubPositionNotifier,
      builder: (context, scrubPos, _) {
        if (scrubPos == null) return const SizedBox.shrink();

        return ValueListenableBuilder<Duration?>(
          valueListenable: seekDeltaNotifier,
          builder: (context, delta, _) {
            final deltaDuration = delta ?? Duration.zero;
            final isNeg = deltaDuration.isNegative;
            final progress = duration.inMilliseconds > 0
                ? (scrubPos.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
                : 0.0;

            return Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xE6141418),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: GoPlayTheme.primary.withValues(alpha: 0.5),
                    width: 1.2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black87,
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isNeg ? Icons.fast_rewind_rounded : Icons.fast_forward_rounded,
                          color: GoPlayTheme.primary,
                          size: 26,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${isNeg ? '-' : '+'}${_formatDuration(deltaDuration.abs())}',
                          style: const TextStyle(
                            fontFamily: GoPlayType.family,
                            color: GoPlayTheme.primary,
                            fontSize: GoPlayType.lg,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${_formatDuration(scrubPos)} / ${_formatDuration(duration)}',
                      style: const TextStyle(
                        fontFamily: GoPlayType.family,
                        color: Colors.white,
                        fontSize: GoPlayType.sm,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 160,
                      height: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Stack(
                          children: [
                            Container(color: Colors.white24),
                            FractionallySizedBox(
                              widthFactor: progress,
                              child: Container(color: GoPlayTheme.primary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _BrightnessOsd extends StatelessWidget {
  final ValueNotifier<double?> notifier;

  const _BrightnessOsd({required this.notifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double?>(
      valueListenable: notifier,
      builder: (context, value, _) {
        if (value == null) return const SizedBox.shrink();
        final percentage = (value * 100).round();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                value > 0.6
                    ? Icons.wb_sunny_rounded
                    : (value > 0.3 ? Icons.wb_sunny_outlined : Icons.brightness_3_rounded),
                color: GoPlayTheme.primary,
                size: 24,
                shadows: const [Shadow(color: Colors.black87, blurRadius: 4)],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 5,
                height: 90,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    FractionallySizedBox(
                      heightFactor: value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: GoPlayTheme.primary,
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 3)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$percentage%',
                style: const TextStyle(
                  fontFamily: GoPlayType.family,
                  color: Colors.white,
                  fontSize: GoPlayType.xs,
                  fontWeight: FontWeight.w700,
                  shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _VolumeOsd extends StatelessWidget {
  final ValueNotifier<double?> notifier;

  const _VolumeOsd({required this.notifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double?>(
      valueListenable: notifier,
      builder: (context, value, _) {
        if (value == null) return const SizedBox.shrink();
        final percentage = (value * 100).round();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                value == 0
                    ? Icons.volume_off_rounded
                    : (value < 0.5 ? Icons.volume_down_rounded : Icons.volume_up_rounded),
                color: GoPlayTheme.primary,
                size: 24,
                shadows: const [Shadow(color: Colors.black87, blurRadius: 4)],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 5,
                height: 90,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    FractionallySizedBox(
                      heightFactor: value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: GoPlayTheme.primary,
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 3)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$percentage%',
                style: const TextStyle(
                  fontFamily: GoPlayType.family,
                  color: Colors.white,
                  fontSize: GoPlayType.xs,
                  fontWeight: FontWeight.w700,
                  shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
