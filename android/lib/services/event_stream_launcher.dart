import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../models/event.dart';
import 'stream_decryptor.dart';

/// Instant stream launcher for live events.
/// Navigates immediately (0ms) to the player screen, resolving streams on-demand
/// inside the native player buffering state without any blocking modal popups.
class EventStreamLauncher {
  EventStreamLauncher._();

  /// Resolves the event's streams and navigates to the player immediately.
  static Future<void> launch(BuildContext context, SportEvent event) async {
    // 1. Direct channel list if present
    if (event.channels.isNotEmpty) {
      final safeId = Uri.encodeComponent(event.channels.first);
      context.push(
        '/player/$safeId',
        extra: {
          'eventChannels': event.channels,
          'sportEvent': event,
          'forceFullscreen': true,
        },
      );
      return;
    }

    // 2. Encrypted stream link resolution
    final linksPath = event.links;
    if (linksPath != null && linksPath.isNotEmpty) {
      // Check if streams are already available in fast memory cache
      final cachedStreams = StreamDecryptor.getCachedStreams(linksPath, event.id);
      if (cachedStreams != null && cachedStreams.isNotEmpty) {
        final safeId = Uri.encodeComponent(cachedStreams.first.id);
        context.push(
          '/player/$safeId',
          extra: {
            'eventChannels': cachedStreams.map((c) => c.id).toList(),
            'dynamicChannels': cachedStreams,
            'sportEvent': event,
            'forceFullscreen': true,
          },
        );
        return;
      }

      // Fast 0ms transition: navigate immediately to player and resolve inside the player state
      final safeEventId = Uri.encodeComponent('live_${event.id.replaceAll('/', '_')}_0');
      context.push(
        '/player/$safeEventId',
        extra: {
          'sportEvent': event,
          'forceFullscreen': true,
        },
      );
      return;
    }

    // 3. Fallback notice
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No active streams available yet. Check back closer to kickoff.'),
        backgroundColor: GoPlayTheme.error,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
