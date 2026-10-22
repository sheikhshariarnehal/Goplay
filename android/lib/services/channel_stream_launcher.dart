import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/channel.dart';
import 'stream_decryptor.dart';

/// Instant stream launcher for TV channels.
/// Navigates immediately (0ms) to the player screen, resolving dynamic streams
/// inside the native player buffering state without any blocking modal popups.
class ChannelStreamLauncher {
  ChannelStreamLauncher._();

  /// Resolves the channel's stream and navigates to the player immediately.
  /// If [channel.streamUrl] points to an encrypted manifest (`pro/*.txt`),
  /// resolves dynamic streams in the background while the native player loads.
  static Future<void> launch(
    BuildContext context,
    Channel channel, {
    List<Channel>? scope,
  }) async {
    final rawUrl = channel.streamUrl.trim();

    // 0. Native Multi-Server Channel from Supabase DB (Instant Launch, 0 JIT delay)
    final activeServers = channel.streamServers
        .where((s) => s.active && s.streamUrl.isNotEmpty && !s.streamUrl.startsWith('pro/') && !s.streamUrl.contains('.txt'))
        .toList();
    if (activeServers.length > 1) {
      final safeId = Uri.encodeComponent(channel.id);
      final dynamicChannels = activeServers.map((s) => s.toPlayableChannel(
        parentChannelId: channel.id,
        parentName: channel.name,
        logo: channel.logo,
        category: channel.category,
      )).toList();

      context.push(
        '/player/$safeId',
        extra: {
          'eventChannels': (scope != null && scope.length > 1)
              ? scope.map((c) => c.id).toList(growable: false)
              : null,
          'dynamicChannels': dynamicChannels,
          'forceFullscreen': false,
        },
      );
      return;
    }

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
    // Check fast memory cache first (0ms)
    final cachedStreams = StreamDecryptor.getCachedStreams(rawUrl, channel.id);
    if (cachedStreams != null && cachedStreams.isNotEmpty) {
      final safeId = Uri.encodeComponent(channel.id);
      context.push(
        '/player/$safeId',
        extra: {
          'eventChannels': (scope != null && scope.length > 1)
              ? scope.map((c) => c.id).toList(growable: false)
              : null,
          'dynamicChannels': cachedStreams,
          'forceFullscreen': false,
        },
      );
      return;
    }

    // 3. Fast 0ms transition: navigate directly to player without any blocking modal popups
    final safeId = Uri.encodeComponent(channel.id);
    context.push(
      '/player/$safeId',
      extra: {
        'eventChannels': (scope != null && scope.length > 1)
            ? scope.map((c) => c.id).toList(growable: false)
            : null,
        'forceFullscreen': false,
      },
    );
  }
}

