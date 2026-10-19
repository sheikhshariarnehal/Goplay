import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../core/typography.dart';
import '../models/channel.dart';
import 'stream_decryptor.dart';

/// Unified helper for resolving and launching channel streams with JIT HUD.
/// Automatically handles Tier-1 PlayZ TV dynamic manifests (`pro/*.txt`)
/// and direct stream URLs.
class ChannelStreamLauncher {
  ChannelStreamLauncher._();

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

  /// Resolves the channel's stream and navigates to the player.
  /// If [channel.streamUrl] points to an encrypted manifest (`pro/*.txt`),
  /// fetches and decrypts stream servers on-the-fly.
  static Future<void> launch(
    BuildContext context,
    Channel channel, {
    List<Channel>? scope,
  }) async {
    final rawUrl = channel.streamUrl.trim();

    // 1. Direct stream URL (standard channel)
    if (!rawUrl.startsWith('pro/') && !rawUrl.contains('.txt')) {
      final ids = scope;
      if (ids == null || ids.length < 2) {
        context.push('/player/${channel.id}');
        return;
      }
      context.push(
        '/player/${channel.id}',
        extra: {
          'eventChannels': ids.map((c) => c.id).toList(growable: false),
        },
      );
      return;
    }

    // 2. PlayZ dynamic encrypted stream manifest (`pro/*.txt`)
    _showJitLoadingDialog(context);

    try {
      final streams = await StreamDecryptor.fetchChannelStreams(
        linksPath: rawUrl,
        channelId: channel.id,
        channelName: channel.name,
        category: channel.category,
        logo: channel.logo,
      );

      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // Dismiss HUD

      if (streams.isNotEmpty) {
        final safeId = Uri.encodeComponent(channel.id);
        context.push(
          '/player/$safeId',
          extra: {
            'eventChannels': (scope != null && scope.length > 1)
                ? scope.map((c) => c.id).toList(growable: false)
                : null,
            'dynamicChannels': streams,
            'forceFullscreen': false,
          },
        );
        return;
      }
    } catch (_) {
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // Dismiss HUD
    }

    // 3. Fallback notice if stream could not be decrypted
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Stream currently unavailable. Please try again shortly.'),
        backgroundColor: GoPlayTheme.error,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
