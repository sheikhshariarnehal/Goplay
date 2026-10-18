import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../core/typography.dart';
import '../models/event.dart';
import 'stream_decryptor.dart';

/// Unified helper for resolving and launching live event streams with JIT HUD.
class EventStreamLauncher {
  EventStreamLauncher._();

  static void _showJitLoadingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (ctx) => Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x28FFFFFF)),
            boxShadow: const [
              BoxShadow(color: Color(0xDD000000), blurRadius: 20, spreadRadius: 4),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(GoPlayTheme.primary),
                ),
              ),
              SizedBox(width: 16),
              Text(
                'Connecting to live feed...',
                style: TextStyle(
                  fontFamily: GoPlayType.family,
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Resolves the event's streams and navigates to the player.
  /// If streams are encrypted in [linksPath], fetches and decrypts on-the-fly.
  static Future<void> launch(BuildContext context, SportEvent event) async {
    // 1. Direct channel list if present
    if (event.channels.isNotEmpty) {
      final safeId = Uri.encodeComponent(event.channels.first);
      context.push(
        '/player/$safeId',
        extra: {
          'eventChannels': event.channels,
          'forceFullscreen': true,
        },
      );
      return;
    }

    // 2. Encrypted stream link resolution
    final linksPath = event.links;
    if (linksPath != null && linksPath.isNotEmpty) {
      _showJitLoadingDialog(context);

      try {
        final streams = await StreamDecryptor.fetchAndDecryptStreams(
          linksPath: linksPath,
          eventId: event.id,
          eventTitle: '${event.homeTeam.name} vs ${event.awayTeam.name}',
          logo: event.banner,
        );

        if (!context.mounted) return;
        Navigator.of(context, rootNavigator: true).pop(); // Dismiss HUD

        if (streams.isNotEmpty) {
          final safeId = Uri.encodeComponent(streams.first.id);
          context.push(
            '/player/$safeId',
            extra: {
              'eventChannels': streams.map((c) => c.id).toList(),
              'dynamicChannels': streams,
              'forceFullscreen': true,
            },
          );
          return;
        }
      } catch (_) {
        if (!context.mounted) return;
        Navigator.of(context, rootNavigator: true).pop(); // Dismiss HUD
      }
    }

    // 3. Fallback notice
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No active streams available yet. Check back closer to kickoff.'),
        backgroundColor: GoPlayTheme.error,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
