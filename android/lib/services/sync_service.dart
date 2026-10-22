import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cache_service.dart';
import 'supabase_service.dart';
import 'stream_decryptor.dart';
import '../providers/app_providers.dart';
import '../providers/playz_providers.dart';
import '../models/app_ui_config.dart';

/// Orchestrates version-based background synchronization for channels and events.
class SyncService {
  final Ref _ref;

  SyncService(this._ref);

  /// Compares local cache versions with remote Supabase versions,
  /// downloads any modified tables, and updates Riverpod states.
  Future<void> sync() async {
    debugPrint('SyncService: Starting background sync...');
    try {
      final SupabaseService supabase = _ref.read(supabaseServiceProvider);
      final CacheService cache = _ref.read(cacheServiceProvider);

      // 1. Fetch remote versions from Supabase
      final remoteVersions = await supabase.getSyncVersions();
      if (remoteVersions == null) {
        debugPrint('SyncService: Failed to fetch remote versions. Sync skipped.');
        if (cache.getLocalChannels().isEmpty) {
          throw Exception('Failed to connect to server. Please check your internet connection.');
        }
        return;
      }

      final remoteChannelsVer = remoteVersions['channels_version'] as int;
      final remoteEventsVer = remoteVersions['events_version'] as int;

      final localChannelsVer = cache.getLocalChannelsVersion();
      final localEventsVer = cache.getLocalEventsVersion();

      debugPrint(
        'SyncService: Version check - Channels: local=$localChannelsVer, remote=$remoteChannelsVer | Events: local=$localEventsVer, remote=$remoteEventsVer',
      );

      bool channelsUpdated = false;

      // 2. Synchronize Channels and Categories
      if (localChannelsVer == null || remoteChannelsVer > localChannelsVer || cache.getLocalChannels().isEmpty) {
        debugPrint('SyncService: Channels version changed or cache empty. Downloading from Supabase...');
        
        // Sync categories first since channels have foreign-key-like category IDs
        final remoteCategories = await supabase.getCategories();
        await cache.saveLocalCategories(remoteCategories);

        // Sync channels (includes stream URLs, playz_links, stream_servers)
        final remoteChannels = await supabase.getChannels();
        await cache.saveLocalChannels(remoteChannels);

        // Update local version
        await cache.saveLocalChannelsVersion(remoteChannelsVer);
        channelsUpdated = true;
        debugPrint('SyncService: Channels and categories synchronized (${remoteChannels.length} channels, ${remoteCategories.length} categories).');
      }

      // 3. Synchronize Events directly from pabbdyzone.shop API
      try {
        debugPrint('SyncService: Syncing live events directly from pabbdyzone.shop...');
        final directEvents = await StreamDecryptor.fetchLiveEvents();
        if (directEvents.isNotEmpty) {
          await cache.saveLocalEvents(directEvents);
          _ref.invalidate(eventsProvider);
          _ref.invalidate(eventCategoriesProvider);
          debugPrint('SyncService: Live events synchronized directly (${directEvents.length} events).');
        }
      } catch (e) {
        debugPrint('SyncService: Direct events sync non-fatal error: $e');
      }



      // 5. Invalidate channels/categories providers if anything changed
      if (channelsUpdated) {
        debugPrint('SyncService: Invalidating channels and categories providers...');
        _ref.invalidate(channelsProvider);
        _ref.invalidate(categoriesProvider);
        _ref.invalidate(playzCategoriesProvider);
      }

      // 5. Sync announcements (lightweight — no version check, always refresh)
      try {
        final remoteAnnouncements = await supabase.getAnnouncements();
        await cache.saveLocalAnnouncements(remoteAnnouncements);
      } catch (e) {
        debugPrint('SyncService: Announcements sync failed (non-fatal): $e');
      }

      // 6. Sync hero banners (lightweight — always refresh on sync)
      try {
        final remoteHeroBanners = await supabase.getHeroBanners();
        await cache.saveLocalHeroBanners(remoteHeroBanners);
        _ref.invalidate(heroBannersProvider);
      } catch (e) {
        debugPrint('SyncService: Hero banners sync failed (non-fatal): $e');
      }

      // 7. Synchronize Dynamic App UI Configuration
      try {
        final remoteUiVer = remoteVersions['ui_config_version'] as int? ?? 1;
        final localUiVer = cache.getLocalUiConfigVersion();
        final rawRemoteUiConfig = remoteVersions['ui_config'];

        if (localUiVer == null || remoteUiVer != localUiVer || localUiVer == 0 || !cache.hasLocalUiConfig()) {
          debugPrint('SyncService: UI Config version changed ($localUiVer -> $remoteUiVer). Updating local cache...');
          AppUiConfig? newConfig;
          if (rawRemoteUiConfig is Map) {
            newConfig = AppUiConfig.fromJson(rawRemoteUiConfig);
          } else {
            newConfig = await supabase.getUiConfig();
          }

          if (newConfig != null) {
            await cache.saveLocalUiConfig(newConfig);
            await cache.saveLocalUiConfigVersion(remoteUiVer);
            _ref.invalidate(uiConfigProvider);
            debugPrint('SyncService: UI Config synchronized successfully (v$remoteUiVer).');
          }
        }
      } catch (e) {
        debugPrint('SyncService: UI Config sync failed (non-fatal): $e');
      }

      debugPrint('SyncService: Background sync check completed successfully.');
    } catch (e, stackTrace) {
      debugPrint('SyncService: Error occurred during synchronization: $e\n$stackTrace');
      final cache = _ref.read(cacheServiceProvider);
      if (cache.getLocalChannels().isEmpty) {
        rethrow;
      }
    }
  }
}
