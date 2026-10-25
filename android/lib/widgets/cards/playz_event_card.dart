import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../core/typography.dart';
import '../../models/event.dart';
import '../../providers/app_providers.dart';
import '../countdown_timer.dart';
import '../team_flag.dart';
import '../tv_focus_wrapper.dart';
import 'event_card.dart';

/// PlayZ TV Event Card for GoPlay
///
/// Combines PlayZ TV's compact layout with GoPlay's official theme palette,
/// typography tokens, and elevation design system.
///
/// 100% theme-aware (supports dark & light themes, TV focus, and smooth 12dp rounded cards).
class PlayZEventCard extends ConsumerStatefulWidget {
  final SportEvent event;
  final VoidCallback? onTap;

  const PlayZEventCard({
    super.key,
    required this.event,
    this.onTap,
  });

  /// Painted height of the tile card
  static double tileHeight(BuildContext context) => EventCard.tileHeight(context);

  /// Total extent including vertical gap for SliverFixedExtentList / Grid
  static double tileExtent(BuildContext context) => EventCard.tileExtent(context);

  @override
  ConsumerState<PlayZEventCard> createState() => _PlayZEventCardState();
}

class _PlayZEventCardState extends ConsumerState<PlayZEventCard>
    with SingleTickerProviderStateMixin {
  Timer? _liveTimer;
  late AnimationController _pulseController;
  late Animation<double> _dotFade;

  static const _kMonths = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _dotFade = Tween<double>(begin: 0.35, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.event.isLive) {
      _startLiveEffects();
    }
  }

  @override
  void didUpdateWidget(covariant PlayZEventCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.event.isLive && !oldWidget.event.isLive) {
      _startLiveEffects();
    } else if (!widget.event.isLive && oldWidget.event.isLive) {
      _stopLiveEffects();
    }
  }

  void _startLiveEffects() {
    _pulseController.repeat(reverse: true);
    _liveTimer ??= Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  void _stopLiveEffects() {
    _pulseController.stop();
    _liveTimer?.cancel();
    _liveTimer = null;
  }

  @override
  void dispose() {
    _liveTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  static bool _checkIsToday(DateTime startTime) {
    final now = DateTime.now();
    final localStart = startTime.toLocal();
    final isSameCalendarDay = localStart.year == now.year &&
        localStart.month == now.month &&
        localStart.day == now.day;
    final diff = startTime.difference(now);
    return isSameCalendarDay || (!diff.isNegative && diff.inHours < 24);
  }

  static String _formatTime(DateTime time) {
    final t = time.toLocal();
    final h = t.hour;
    final m = t.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final display = h % 12 == 0 ? 12 : h % 12;
    return '$display:$m $period';
  }

  static String _formatTimeInfo(SportEvent event) {
    final t = event.startTime.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final eventDay = DateTime(t.year, t.month, t.day);

    if (eventDay == today) return 'TODAY';
    if (eventDay == tomorrow) return 'TOMORROW';
    return '${_kMonths[t.month - 1]} ${t.day.toString().padLeft(2, '0')}';
  }

  String _formatElapsed(DateTime startTime) {
    final now = DateTime.now();
    final elapsed = now.difference(startTime);
    if (elapsed.isNegative) return '00:00:00';
    final h = elapsed.inHours.toString().padLeft(2, '0');
    final m = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final s = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final uiConfig = ref.watch(uiConfigProvider);
    final sportsCardsConfig = uiConfig.sportsCards;
    final eventCardStyle = uiConfig.componentStyles.eventCard;
    final event = widget.event;
    final isLive = event.isLive;
    final isToday = _checkIsToday(event.startTime);
    final elapsedText = _formatElapsed(event.startTime);

    // Resolves card background: uses custom override if active; otherwise global theme.cardColor
    final cardBg = GoPlayTheme.parseHex(uiConfig.resolveEventCardBg());
    final onSurface = theme.colorScheme.onSurface; // #F1F1F1 in dark mode
    final onSurfaceVariant = theme.colorScheme.onSurfaceVariant; // #AAAAAA in dark mode
    final onSurfaceMuted = isDark ? GoPlayTheme.darkOnSurfaceMuted : GoPlayTheme.lightOnSurfaceMuted;

    // Border & radius styling - always applies the configured component radius and border width
    final cardRadius = eventCardStyle.borderRadius;
    final borderColor = eventCardStyle.useCustomOverride
        ? GoPlayTheme.parseHex(eventCardStyle.borderColor)
        : (isLive ? GoPlayTheme.primary : (isDark ? const Color(0x28FFFFFF) : GoPlayTheme.lightCardBorder));
    final borderWidth = eventCardStyle.borderWidth;
    final cardBorder = borderWidth > 0
        ? Border.all(
            color: borderColor,
            width: borderWidth,
          )
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0), // matches _kTileGap
      child: RepaintBoundary(
        child: TvFocusable(
          borderRadius: BorderRadius.circular(cardRadius),
          onTap: widget.onTap,
          child: SizedBox(
            height: EventCard.tileHeight(context),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(cardRadius),
                border: cardBorder,
                boxShadow: (isLive && eventCardStyle.enableGlow)
                    ? [
                        BoxShadow(
                          color: (eventCardStyle.useCustomOverride
                                  ? GoPlayTheme.parseHex(eventCardStyle.borderColor)
                                  : GoPlayTheme.primary)
                              .withValues(alpha: 0.20),
                          blurRadius: 8,
                          spreadRadius: 0.5,
                        ),
                      ]
                    : const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(cardRadius),
                child: Stack(
                  children: [
                    // Main Card Content
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 5.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // --- TOP HEADER (Sport/Category || League Name) ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (event.banner != null && event.banner!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Image.network(
                                    event.banner!,
                                    width: 14.0,
                                    height: 14.0,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => Icon(
                                      Icons.sports,
                                      size: 13.0,
                                      color: onSurfaceVariant,
                                    ),
                                  ),
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Icon(
                                    Icons.sports,
                                    size: 13.0,
                                    color: onSurfaceVariant,
                                  ),
                                ),
                              Flexible(
                                child: Text(
                                  '${event.sport.toUpperCase()} || ${event.league.toUpperCase()}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: GoPlayType.family,
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w600,
                                    color: onSurfaceVariant,
                                    height: 1.1,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // --- MATCHUP ROW (Team A vs Center Badge/Time vs Team B) ---
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Home Team (Left) - closer to left card edge
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TeamFlagWidget(
                                          flag: event.homeTeam.flag,
                                          size: 26,
                                          fit: BoxFit.contain,
                                          showBorder: false,
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          event.homeTeam.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: GoPlayType.family,
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w500,
                                            color: onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const Spacer(flex: 1),

                                // Center: Live Glowing Badge & Timer OR Kickoff Time & Countdown
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                  child: isLive
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 6.0,
                                                vertical: 2.0,
                                              ),
                                              decoration: BoxDecoration(
                                                color: eventCardStyle.useCustomOverride
                                                    ? GoPlayTheme.parseHex(eventCardStyle.liveBadgeColor)
                                                    : GoPlayTheme.liveBadge,
                                                borderRadius: BorderRadius.circular(4.0),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  sportsCardsConfig.showLivePulse
                                                      ? FadeTransition(
                                                          opacity: _dotFade,
                                                          child: const Icon(
                                                            Icons.circle,
                                                            size: 5.0,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      : const Icon(
                                                          Icons.circle,
                                                          size: 5.0,
                                                          color: Colors.white,
                                                        ),
                                                  const SizedBox(width: 3.5),
                                                  const Text(
                                                    'LIVE',
                                                    style: TextStyle(
                                                      fontFamily: GoPlayType.family,
                                                      fontSize: 9.5,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.white,
                                                      letterSpacing: 0.4,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 3.0),
                                            Text(
                                              elapsedText,
                                              style: TextStyle(
                                                fontFamily: GoPlayType.family,
                                                fontSize: 10.0,
                                                color: onSurfaceVariant,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (event.isEnded)
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 7.0,
                                                  vertical: 2.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(0x14FFFFFF),
                                                  borderRadius: BorderRadius.circular(4.0),
                                                ),
                                                child: Text(
                                                  'ENDED',
                                                  style: TextStyle(
                                                    fontFamily: GoPlayType.family,
                                                    fontSize: 10.0,
                                                    fontWeight: FontWeight.w700,
                                                    color: onSurfaceMuted,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              )
                                            else ...[
                                              Text(
                                                _formatTime(event.startTime),
                                                style: TextStyle(
                                                  fontFamily: GoPlayType.family,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w800,
                                                  color: onSurface,
                                                  height: 1.1,
                                                ),
                                              ),
                                              const SizedBox(height: 2.5),
                                              if (event.isUpcoming && isToday && sportsCardsConfig.showCountdownTimer)
                                                CountdownTimerWidget(
                                                  startTime: event.startTime,
                                                  style: const TextStyle(
                                                    fontFamily: GoPlayType.family,
                                                    fontSize: 10.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: GoPlayTheme.primary,
                                                  ),
                                                  onTimerFinished: () {
                                                    if (mounted) {
                                                      _startLiveEffects();
                                                      setState(() {});
                                                    }
                                                  },
                                                )
                                              else
                                                Text(
                                                  _formatTimeInfo(event),
                                                  style: TextStyle(
                                                    fontFamily: GoPlayType.family,
                                                    fontSize: 10.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: onSurfaceMuted,
                                                  ),
                                                ),
                                            ],
                                          ],
                                        ),
                                ),

                                const Spacer(flex: 1),

                                // Away Team (Right) - closer to right card edge
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TeamFlagWidget(
                                          flag: event.awayTeam.flag,
                                          size: 26,
                                          fit: BoxFit.contain,
                                          showBorder: false,
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          event.awayTeam.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: GoPlayType.family,
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w500,
                                            color: onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // --- FEATURED / HOT BADGE ---
                    if (event.isFeatured && eventCardStyle.hotBadge.enabled)
                      Builder(
                        builder: (context) {
                          final pos = eventCardStyle.hotBadge.position;
                          final isTop = pos == 'top_right' || pos == 'top_left';
                          final isLeft = pos == 'top_left' || pos == 'bottom_left';
                          return Positioned(
                            top: isTop ? 0 : null,
                            bottom: isTop ? null : 0,
                            left: isLeft ? 0 : null,
                            right: isLeft ? null : 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9.0,
                                vertical: 1.5,
                              ),
                              decoration: BoxDecoration(
                                color: GoPlayTheme.parseHex(eventCardStyle.hotBadge.bgColor),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(eventCardStyle.hotBadge.radiusTopLeft),
                                  topRight: Radius.circular(eventCardStyle.hotBadge.radiusTopRight),
                                  bottomLeft: Radius.circular(eventCardStyle.hotBadge.radiusBottomLeft),
                                  bottomRight: Radius.circular(eventCardStyle.hotBadge.radiusBottomRight),
                                ),
                              ),
                              child: Text(
                                eventCardStyle.hotBadge.text.isNotEmpty
                                    ? eventCardStyle.hotBadge.text
                                    : 'HOT',
                                style: TextStyle(
                                  fontFamily: GoPlayType.family,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w800,
                                  color: GoPlayTheme.parseHex(eventCardStyle.hotBadge.textColor),
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
