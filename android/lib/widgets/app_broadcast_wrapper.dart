import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants.dart';
import '../core/typography.dart';
import '../providers/app_providers.dart';

/// Wraps the root app tree to provide global Emergency Maintenance Lock
/// and Launch Announcement Popup Modal based on dashboard ui_config.
class AppBroadcastWrapper extends ConsumerStatefulWidget {
  final Widget child;
  const AppBroadcastWrapper({super.key, required this.child});

  @override
  ConsumerState<AppBroadcastWrapper> createState() => _AppBroadcastWrapperState();
}

class _AppBroadcastWrapperState extends ConsumerState<AppBroadcastWrapper> {
  String? _lastShownPopupId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowPopup();
    });
  }

  void _checkAndShowPopup() {
    final uiConfig = ref.read(uiConfigProvider);
    final popup = uiConfig.broadcasts;

    if (!popup.isPopupEnabled || popup.popupId.isEmpty) return;

    // Check if dismissed previously
    final settingsBox = Hive.isBoxOpen(AppConstants.settingsBox)
        ? Hive.box(AppConstants.settingsBox)
        : null;
    final dismissedId = settingsBox?.get('dismissed_popup_id') as String?;

    if (dismissedId == popup.popupId) return;
    if (_lastShownPopupId == popup.popupId) return;

    _lastShownPopupId = popup.popupId;

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => _AnnouncementPopupDialog(
        popupId: popup.popupId,
        title: popup.popupTitle,
        message: popup.popupMessage,
        imageUrl: popup.popupImageUrl,
        actionLabel: popup.popupActionLabel,
        actionUrl: popup.popupActionUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uiConfig = ref.watch(uiConfigProvider);
    final isMaintenance = uiConfig.broadcasts.isMaintenanceEnabled;

    if (isMaintenance) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ref.watch(appThemeProvider),
        home: _MaintenanceScreen(
          title: uiConfig.broadcasts.maintenanceTitle,
          message: uiConfig.broadcasts.maintenanceMessage,
          onRetry: () async {
            try {
              await ref.read(syncServiceProvider).sync();
            } catch (_) {}
          },
        ),
      );
    }

    return widget.child;
  }
}

class _AnnouncementPopupDialog extends StatelessWidget {
  final String popupId;
  final String title;
  final String message;
  final String imageUrl;
  final String actionLabel;
  final String actionUrl;

  const _AnnouncementPopupDialog({
    required this.popupId,
    required this.title,
    required this.message,
    required this.imageUrl,
    required this.actionLabel,
    required this.actionUrl,
  });

  void _dismiss(BuildContext context) {
    if (Hive.isBoxOpen(AppConstants.settingsBox)) {
      Hive.box(AppConstants.settingsBox).put('dismissed_popup_id', popupId);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: cs.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (imageUrl.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    height: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                title.isNotEmpty ? title : 'Announcement',
                style: GoPlayType.subtitle.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: cs.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: GoPlayType.body.copyWith(
                  color: cs.onSurfaceVariant,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: cs.onSurface.withValues(alpha: 0.2)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _dismiss(context),
                      child: Text('Dismiss', style: TextStyle(color: cs.onSurface)),
                    ),
                  ),
                  if (actionUrl.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: cs.primary,
                          foregroundColor: cs.onPrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          _dismiss(context);
                          final uri = Uri.tryParse(actionUrl);
                          if (uri != null && await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        },
                        child: Text(
                          actionLabel.isNotEmpty ? actionLabel : 'Open',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MaintenanceScreen extends StatelessWidget {
  final String title;
  final String message;
  final Future<void> Function() onRetry;

  const _MaintenanceScreen({
    required this.title,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.build_circle_rounded, size: 40, color: Colors.amber),
              ),
              const SizedBox(height: 24),
              Text(
                title.isNotEmpty ? title : 'Under Maintenance',
                textAlign: TextAlign.center,
                style: GoPlayType.headline.copyWith(
                  color: cs.onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message.isNotEmpty
                    ? message
                    : 'We are upgrading our servers to serve you better. Please check back shortly.',
                textAlign: TextAlign.center,
                style: GoPlayType.body.copyWith(
                  color: cs.onSurfaceVariant,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  await onRetry();
                },
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text('Check Again', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
