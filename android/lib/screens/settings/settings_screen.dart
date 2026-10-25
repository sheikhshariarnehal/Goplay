import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme.dart';
import '../../core/typography.dart';
import '../../providers/app_providers.dart';
import '../../providers/update_notifier.dart';
import '../../widgets/tv_focus_wrapper.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Expansion States
  bool _playbackExpanded = true;
  bool _contentTabsExpanded = true;
  bool _syncExpanded = false;
  bool _updateExpanded = false;

  // Playback Preferences
  bool _isHwAccelEnabled = true;
  bool _isAutoPlayEnabled = true;
  bool _isBackgroundAudioEnabled = false;
  String _selectedBufferMode = 'Balanced';
  String _selectedAspectRatio = '16:9 (Fit)';

  // Sync Preferences
  String _selectedSyncRate = '6 Hours';
  bool _isSyncing = false;
  bool _isClearingCache = false;
  bool _isResettingUi = false;

  final List<String> _bufferModes = ['Fast Load', 'Balanced', 'High Stability'];
  final List<String> _aspectRatios = ['16:9 (Fit)', 'Stretch', 'Original'];
  final List<String> _syncRates = ['1 Hour', '6 Hours', 'Manual'];

  Future<void> _handleForceSync() async {
    setState(() => _isSyncing = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(syncServiceProvider).sync();
      ref.invalidate(channelsProvider);
      ref.invalidate(eventsProvider);
      ref.invalidate(categoriesProvider);

      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_outline_rounded, color: GoPlayTheme.primary),
                SizedBox(width: 10),
                Text(
                  'Channels and events synchronized successfully!',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ],
            ),
            backgroundColor: GoPlayTheme.surfaceContainerHigh,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: GoPlayTheme.error),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Sync failed: $e',
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: GoPlayTheme.surfaceContainerHigh,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  Future<void> _handleClearCache() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GoPlayTheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Clear Application Cache?',
          style: TextStyle(color: GoPlayTheme.onSurface, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'This will clear stored channel icons and offline schedule data. Fresh data will be redownloaded automatically.',
          style: TextStyle(color: GoPlayTheme.onSurfaceVariant, fontSize: GoPlayType.base, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: GoPlayTheme.onSurfaceVariant)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: GoPlayTheme.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Clear Cache', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() => _isClearingCache = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(cacheServiceProvider).clearAllCache();
      ref.invalidate(channelsProvider);
      ref.invalidate(eventsProvider);
      ref.invalidate(categoriesProvider);

      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.cleaning_services_rounded, color: GoPlayTheme.primary),
                SizedBox(width: 10),
                Text(
                  'Application cache cleared!',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ],
            ),
            backgroundColor: GoPlayTheme.surfaceContainerHigh,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isClearingCache = false);
    }
  }

  Future<void> _handleResetUiToDefaults() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Reset UI to Default Theme?',
          style: TextStyle(color: GoPlayTheme.onSurface, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'This will reset your local cached colors, card styles, and layout back to default GoPlay Volt styling (#C8FF00 / #0F0F0F).',
          style: TextStyle(color: GoPlayTheme.onSurfaceVariant, fontSize: GoPlayType.base, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: GoPlayTheme.onSurfaceVariant)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: GoPlayTheme.primary,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Reset Theme', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() => _isResettingUi = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(cacheServiceProvider).resetLocalUiConfigToDefaults();
      ref.invalidate(uiConfigProvider);

      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.restart_alt_rounded, color: GoPlayTheme.primary),
                SizedBox(width: 10),
                Text(
                  'UI theme reset to default GoPlay Volt!',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isResettingUi = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final updateState = ref.watch(updateProvider);
    final notifier = ref.read(updateProvider.notifier);
    final uiConfig = ref.watch(uiConfigProvider);
    final settingsStyle = uiConfig.componentStyles.settingsScreen;
    final headerGradStart = settingsStyle.useCustomOverride
        ? GoPlayTheme.parseHex(settingsStyle.headerGradientStart)
        : const Color(0xFFFF7A85);
    final headerGradEnd = settingsStyle.useCustomOverride
        ? GoPlayTheme.parseHex(settingsStyle.headerGradientEnd)
        : const Color(0xFFFF5263);

    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top App Bar
            SliverAppBar(
              floating: false,
              pinned: true,
              backgroundColor: cs.surface,
              elevation: 0,
              automaticallyImplyLeading: false,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: GoPlayTheme.onSurface,
                  size: 24,
                ),
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(
                'App Settings',
                style: TextStyle(
                  color: GoPlayTheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
              centerTitle: true,
            ),

            // Main Settings List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ─── Compact Profile / Brand Header ───
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 6),
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [headerGradStart, headerGradEnd],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: headerGradEnd.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'GP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'GoPlay Stream',
                          style: TextStyle(
                            color: GoPlayTheme.onSurface,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'v2.1.0 • High-Performance IPTV',
                          style: TextStyle(
                            color: GoPlayTheme.onSurfaceVariant,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  // ─── Group 1: Stream & Playback Engine ───
                  _buildExpandableGroupCard(
                    icon: Icons.play_circle_outline_rounded,
                    iconColor: const Color(0xFFFF7A85),
                    title: 'Playback Engine',
                    description: 'GPU acceleration, auto-play & buffer controls',
                    isExpanded: _playbackExpanded,
                    onToggleExpand: () => setState(() => _playbackExpanded = !_playbackExpanded),
                    children: [
                      _buildNestedToggleTile(
                        title: 'Hardware Acceleration (GPU)',
                        description: 'Enable GPU decoding for smooth 60fps playback',
                        value: _isHwAccelEnabled,
                        onChanged: (val) => setState(() => _isHwAccelEnabled = val),
                      ),
                      const Divider(color: Color(0x14FFFFFF), height: 1),
                      _buildNestedToggleTile(
                        title: 'Auto-Play Channel Stream',
                        description: 'Immediately start video when channel is selected',
                        value: _isAutoPlayEnabled,
                        onChanged: (val) => setState(() => _isAutoPlayEnabled = val),
                      ),
                      const Divider(color: Color(0x14FFFFFF), height: 1),
                      _buildNestedToggleTile(
                        title: 'Background Audio Playback',
                        description: 'Keep playing audio when switching apps or locking',
                        value: _isBackgroundAudioEnabled,
                        onChanged: (val) => setState(() => _isBackgroundAudioEnabled = val),
                      ),
                      const Divider(color: Color(0x14FFFFFF), height: 1),
                      _buildNestedOptionTile(
                        title: 'Stream Buffer Strategy',
                        description: 'Control stream buffer depth for network stability',
                        currentValue: _selectedBufferMode,
                        options: _bufferModes,
                        onSelected: (val) => setState(() => _selectedBufferMode = val),
                      ),
                      const Divider(color: Color(0x14FFFFFF), height: 1),
                      _buildNestedOptionTile(
                        title: 'Default Aspect Ratio',
                        description: 'Preferred video display ratio for live broadcasts',
                        currentValue: _selectedAspectRatio,
                        options: _aspectRatios,
                        onSelected: (val) => setState(() => _selectedAspectRatio = val),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ─── Group: Content & Tabs ───
                  _buildExpandableGroupCard(
                    icon: Icons.view_carousel_outlined,
                    iconColor: const Color(0xFFA78BFA),
                    title: 'Content & Tabs',
                    description: 'Channel category tabs and screen display preferences',
                    isExpanded: _contentTabsExpanded,
                    onToggleExpand: () => setState(() => _contentTabsExpanded = !_contentTabsExpanded),
                    children: [
                      _buildNestedToggleTile(
                        title: 'Show Trending Category Tab',
                        description: 'Display the top 20 trending channels tab in Channels page',
                        value: ref.watch(showTrendingTabProvider),
                        onChanged: (val) {
                          ref.read(showTrendingTabProvider.notifier).toggle(val);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ─── Group 2: Data & Synchronization ───
                  _buildExpandableGroupCard(
                    icon: Icons.cloud_sync_outlined,
                    iconColor: GoPlayTheme.primary,
                    title: 'Data & Synchronization',
                    description: 'Channel catalog sync frequency & cache controls',
                    isExpanded: _syncExpanded,
                    onToggleExpand: () => setState(() => _syncExpanded = !_syncExpanded),
                    children: [
                      _buildNestedOptionTile(
                        title: 'Background Sync Frequency',
                        description: 'How often to sync channels from server',
                        currentValue: _selectedSyncRate,
                        options: _syncRates,
                        onSelected: (val) => setState(() => _selectedSyncRate = val),
                      ),
                      const Divider(color: Color(0x14FFFFFF), height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildActionButton(
                                    label: _isSyncing ? 'Syncing...' : 'Force Sync',
                                    icon: Icons.sync_rounded,
                                    isLoading: _isSyncing,
                                    color: GoPlayTheme.primary,
                                    onPressed: _isSyncing ? null : _handleForceSync,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildActionButton(
                                    label: _isClearingCache ? 'Clearing...' : 'Clear Cache',
                                    icon: Icons.cleaning_services_rounded,
                                    isLoading: _isClearingCache,
                                    color: GoPlayTheme.error,
                                    onPressed: _isClearingCache ? null : _handleClearCache,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: _buildActionButton(
                                label: _isResettingUi ? 'Resetting UI...' : 'Reset UI to Default Theme',
                                icon: Icons.restart_alt_rounded,
                                isLoading: _isResettingUi,
                                color: GoPlayTheme.onSurfaceVariant,
                                onPressed: _isResettingUi ? null : _handleResetUiToDefaults,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ─── Group 3: App Maintenance & Updates ───
                  _buildExpandableGroupCard(
                    icon: Icons.system_update_rounded,
                    iconColor: const Color(0xFF60A5FA),
                    title: 'App Maintenance & Updates',
                    description: 'OTA self-hosted updates & version status',
                    isExpanded: _updateExpanded,
                    onToggleExpand: () => setState(() => _updateExpanded = !_updateExpanded),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildVersionRow('Current Version', 'v${updateState.currentVersion}'),
                            const SizedBox(height: 10),
                            _buildVersionRow(
                              'Latest Online Version',
                              updateState.updateInfo?.latestVersion != null
                                  ? 'v${updateState.updateInfo!.latestVersion}'
                                  : 'Up to date',
                              isHighlight: updateState.updateInfo != null,
                            ),
                            const SizedBox(height: 10),
                            _buildVersionRow(
                              'Last Checked',
                              updateState.lastCheckTime != null
                                  ? DateFormat('MMM dd, hh:mm a').format(updateState.lastCheckTime!)
                                  : 'Never',
                            ),

                            // Error Alerts
                            if (updateState.status == UpdateStatus.error && updateState.errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: _buildErrorDisplay(updateState.errorMessage!),
                              )
                            else if (updateState.status == UpdateStatus.downloadFailed && updateState.errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: _buildErrorDisplay(updateState.errorMessage!),
                              ),

                            // Download Progress Indicator
                            if (updateState.status == UpdateStatus.downloading) ...[
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: updateState.downloadProgress,
                                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                                  valueColor: const AlwaysStoppedAnimation<Color>(GoPlayTheme.primary),
                                  minHeight: 6,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Downloading: ${(updateState.downloadProgress * 100).toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      fontSize: GoPlayType.sm,
                                      fontWeight: FontWeight.w600,
                                      color: GoPlayTheme.primary,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => notifier.cancelDownload(),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: GoPlayType.sm,
                                        fontWeight: FontWeight.w600,
                                        color: GoPlayTheme.error,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            const SizedBox(height: 14),
                            _buildCardActionButton(context, updateState, notifier),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ─── Group 4: Community & Support ───
                  if (uiConfig.communityLinks.telegramUrl.isNotEmpty) ...[
                    _buildSingleActionCard(
                      icon: Icons.send_rounded,
                      iconColor: const Color(0xFF0088CC),
                      title: 'Join Telegram Channel',
                      description: 'Get real-time updates, announcements & live support',
                      onTap: () {
                        launchUrl(
                          Uri.parse(uiConfig.communityLinks.telegramUrl),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                  ],
                  if (uiConfig.communityLinks.discordUrl.isNotEmpty) ...[
                    _buildSingleActionCard(
                      icon: Icons.forum_rounded,
                      iconColor: const Color(0xFF5865F2),
                      title: 'Join Discord Server',
                      description: 'Connect with community members & report issues',
                      onTap: () {
                        launchUrl(
                          Uri.parse(uiConfig.communityLinks.discordUrl),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                  ],

                  // ─── Group 5: About & Privacy Action Tile ───
                  _buildSingleActionCard(
                    icon: Icons.info_outline_rounded,
                    iconColor: const Color(0xFFA78BFA),
                    title: 'About GoPlay',
                    description: 'Licenses, terms of service and legal information',
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'GoPlay Stream',
                        applicationVersion: 'v2.1.0 (Build 210)',
                        applicationLegalese: '© 2026 GoPlay Streaming Platform. All rights reserved.',
                      );
                    },
                  ),

                  const SizedBox(height: 36),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── UI Helpers matching Reference Mockup ───

  Widget _buildExpandableGroupCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required bool isExpanded,
    required VoidCallback onToggleExpand,
    required List<Widget> children,
  }) {
    final uiConfig = ref.watch(uiConfigProvider);
    final settingsStyle = uiConfig.componentStyles.settingsScreen;
    final cardBg = GoPlayTheme.parseHex(uiConfig.resolveSettingsCardBg());
    final cardBorderColor = settingsStyle.useCustomOverride
        ? GoPlayTheme.parseHex(settingsStyle.cardBorderColor)
        : const Color(0x14FFFFFF);
    final cardBorderWidth = settingsStyle.cardBorderWidth;
    final cardBorderRadius = settingsStyle.cardBorderRadius;
    final cardBorder = cardBorderWidth > 0
        ? Border.all(
            color: cardBorderColor,
            width: cardBorderWidth,
          )
        : null;
    final effectiveIconBg = settingsStyle.useCustomOverride
        ? GoPlayTheme.parseHex(settingsStyle.iconContainerColor)
        : iconColor.withValues(alpha: 0.12);
    final effectiveIconColor = settingsStyle.useCustomOverride
        ? GoPlayTheme.parseHex(settingsStyle.iconAccentColor)
        : iconColor;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: cardBorder,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cardBorderRadius),
        child: Column(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onToggleExpand();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: effectiveIconBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: effectiveIconColor, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: GoPlayTheme.onSurface,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              description,
                              style: const TextStyle(
                                color: GoPlayTheme.onSurfaceVariant,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOutCubic,
                        turns: isExpanded ? 0.5 : 0.0,
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: GoPlayTheme.onSurfaceVariant,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              child: isExpanded
                  ? Column(
                      children: [
                        const Divider(color: Color(0x14FFFFFF), height: 1),
                        ...children,
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleActionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    final uiConfig = ref.watch(uiConfigProvider);
    final settingsStyle = uiConfig.componentStyles.settingsScreen;
    final cardBg = GoPlayTheme.parseHex(uiConfig.resolveSettingsCardBg());
    final cardBorderColor = settingsStyle.useCustomOverride
        ? GoPlayTheme.parseHex(settingsStyle.cardBorderColor)
        : const Color(0x14FFFFFF);
    final cardBorderWidth = settingsStyle.useCustomOverride ? settingsStyle.cardBorderWidth : 0.6;
    final cardBorderRadius = settingsStyle.useCustomOverride ? settingsStyle.cardBorderRadius : 16.0;
    final effectiveIconBg = settingsStyle.useCustomOverride
        ? GoPlayTheme.parseHex(settingsStyle.iconContainerColor)
        : iconColor.withValues(alpha: 0.12);
    final effectiveIconColor = settingsStyle.useCustomOverride
        ? GoPlayTheme.parseHex(settingsStyle.iconAccentColor)
        : iconColor;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(
          color: cardBorderColor,
          width: cardBorderWidth,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(cardBorderRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: effectiveIconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: effectiveIconColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: GoPlayTheme.onSurface,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        style: const TextStyle(
                          color: GoPlayTheme.onSurfaceVariant,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: GoPlayTheme.onSurfaceVariant,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNestedToggleTile({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: GoPlayTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: GoPlayTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          _SettingsSwitch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildNestedOptionTile({
    required String title,
    required String description,
    required String currentValue,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: GoPlayTheme.onSurface,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: GoPlayTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: options.map((option) {
              final isSelected = option == currentValue;
              final isLast = option == options.last;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: isLast ? 0 : 8),
                  child: TvFocusable(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onSelected(option);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? GoPlayTheme.primary
                            : const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? GoPlayTheme.primary
                              : const Color(0x33FFFFFF),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        option,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? const Color(0xFF0F0F0F) : const Color(0xFFE0E0E0),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13.5,
            color: GoPlayTheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: isHighlight ? GoPlayTheme.primary : GoPlayTheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorDisplay(String error) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GoPlayTheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GoPlayTheme.error.withValues(alpha: 0.3), width: 0.8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded, color: GoPlayTheme.error, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(
                color: GoPlayTheme.error,
                fontSize: 12.5,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required bool isLoading,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      height: 42,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.08),
          side: BorderSide(color: color.withValues(alpha: 0.6), width: 1.0),
          foregroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(color: color, strokeWidth: 2),
              )
            else
              Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardActionButton(BuildContext context, UpdateState state, UpdateNotifier notifier) {
    final isChecking = state.status == UpdateStatus.checking;
    final isDownloading = state.status == UpdateStatus.downloading;

    if (isChecking) {
      return SizedBox(
        width: double.infinity,
        height: 42,
        child: OutlinedButton(
          onPressed: null,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0x14FFFFFF)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(color: GoPlayTheme.primary, strokeWidth: 2),
              ),
              SizedBox(width: 8),
              Text(
                'Checking for updates...',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: GoPlayTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (isDownloading) {
      return const SizedBox.shrink();
    }

    if (state.status == UpdateStatus.downloadSuccess) {
      return SizedBox(
        width: double.infinity,
        height: 42,
        child: FilledButton.icon(
          onPressed: () => notifier.installApk(),
          icon: const Icon(Icons.install_mobile_rounded, color: Colors.black, size: 18),
          label: const Text(
            'Install Update Now',
            style: TextStyle(color: Colors.black, fontSize: 13.5, fontWeight: FontWeight.w600),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      );
    }

    if (state.status == UpdateStatus.downloadFailed) {
      return SizedBox(
        width: double.infinity,
        height: 42,
        child: FilledButton.icon(
          onPressed: () => notifier.retryDownload(),
          icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
          label: const Text(
            'Retry Download',
            style: TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: GoPlayTheme.error,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      );
    }

    if (state.status == UpdateStatus.updateAvailable) {
      return SizedBox(
        width: double.infinity,
        height: 42,
        child: FilledButton.icon(
          onPressed: () => notifier.startDownload(),
          icon: const Icon(Icons.download_rounded, color: Colors.black, size: 18),
          label: const Text(
            'Download & Update',
            style: TextStyle(color: Colors.black, fontSize: 13.5, fontWeight: FontWeight.w600),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: GoPlayTheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 42,
      child: OutlinedButton.icon(
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(context);
          await notifier.checkForUpdates(isManual: true);
          if (ref.read(updateProvider).status == UpdateStatus.alreadyUpToDate) {
            messenger.showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded, color: GoPlayTheme.primary),
                    SizedBox(width: 10),
                    Text(
                      'App is already up to date!',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ],
                ),
                backgroundColor: GoPlayTheme.surfaceContainerHigh,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        },
        icon: const Icon(Icons.refresh_rounded, color: GoPlayTheme.primary, size: 18),
        label: const Text(
          'Check for Updates',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: GoPlayTheme.primary, width: 0.8),
          foregroundColor: GoPlayTheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

/// Sleek custom rounded switch input matching the reference design.
class _SettingsSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitch({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TvFocusable(
      onTap: () {
        HapticFeedback.selectionClick();
        onChanged(!value);
      },
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: value ? GoPlayTheme.primary : const Color(0xFF383838),
          boxShadow: value
              ? [
                  BoxShadow(
                    color: GoPlayTheme.primary.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.all(2.5),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 19,
          height: 19,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
