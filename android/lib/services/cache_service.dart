// `show` is required: flutter/foundation also exports a `Category` annotation
// class, which would otherwise clash with our Category model.
import 'dart:convert';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants.dart';
import '../models/channel.dart';
import '../models/event.dart';
import '../models/category.dart';
import '../models/announcement.dart';
import '../models/hero_banner_item.dart';
import '../models/app_ui_config.dart';

/// Service for managing local Hive cache operations for channels, categories,
/// events, favorites and sync versions.
///
/// Every `getLocal*` call used to re-decode the whole Hive payload into model
/// objects on the UI isolate. For a multi-thousand channel list that is a
/// visible frame drop, and it ran again on every `ref.invalidate`. Decoded
/// results are now memoized in memory and only dropped when the corresponding
/// `saveLocal*` writes new data.
class CacheService {
  List<Channel>? _channelsMemo;
  List<Category>? _categoriesMemo;
  List<SportEvent>? _eventsMemo;
  List<Announcement>? _announcementsMemo;
  List<HeroBannerItem>? _heroBannersMemo;
  Set<String>? _favoritesMemo;
  Map<String, List<Channel>>? _directCategoryChannelsMemo;
  AppUiConfig? _uiConfigMemo;

  static const List<String> directCategoryIds = [];

  /// Drops every memoized decode. Used after a cache wipe.
  void invalidateMemo() {
    _channelsMemo = null;
    _categoriesMemo = null;
    _eventsMemo = null;
    _announcementsMemo = null;
    _heroBannersMemo = null;
    _favoritesMemo = null;
    _directCategoryChannelsMemo = null;
    _uiConfigMemo = null;
  }

  /// Reads a Hive box without throwing when the box failed to open at startup.
  Box? _boxOrNull(String name) {
    try {
      if (!Hive.isBoxOpen(name)) return null;
      return Hive.box(name);
    } catch (e) {
      debugPrint('CacheService: box "$name" unavailable: $e');
      return null;
    }
  }

  List<T> _decodeList<T>(
    String boxName,
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final box = _boxOrNull(boxName);
    final List<dynamic>? rawList = box?.get(key) as List<dynamic>?;
    if (rawList == null) return const [];
    final out = <T>[];
    for (final e in rawList) {
      if (e is! Map) continue;
      try {
        out.add(fromJson(Map<String, dynamic>.from(e)));
      } catch (err) {
        // A single malformed row must never take down the whole list.
        debugPrint('CacheService: skipping malformed $T row: $err');
      }
    }
    return out;
  }

  // ─── Channels ───────────────────────────────────────────────
  List<Channel> getLocalChannels() {
    return _channelsMemo ??= _decodeList(
      AppConstants.channelsBox,
      'channels',
      Channel.fromJson,
    );
  }

  Future<void> saveLocalChannels(List<Channel> channels) async {
    // Prime rather than clear. SyncService already holds these objects freshly
    // parsed from Supabase, then invalidates `channelsProvider` — which used to
    // force a full re-decode of ~15k channels on the main thread immediately
    // after every sync. Adopting the caller's list skips that entirely.
    _channelsMemo = List<Channel>.unmodifiable(channels);
    final box = _boxOrNull(AppConstants.channelsBox);
    if (box == null) return;
    await box.put('channels', channels.map((c) => c.toJson()).toList());
  }

  // ─── Direct Category Channels (Bangla, India, Kids) ──────────
  List<Channel> getDirectCategoryChannels(String categoryId) {
    _directCategoryChannelsMemo ??= {};
    if (_directCategoryChannelsMemo!.containsKey(categoryId)) {
      return _directCategoryChannelsMemo![categoryId]!;
    }
    final channels = _decodeList(
      AppConstants.channelsBox,
      'direct_channels_$categoryId',
      Channel.fromJson,
    );
    _directCategoryChannelsMemo![categoryId] = channels;
    return channels;
  }

  Future<void> saveDirectCategoryChannels(String categoryId, List<Channel> channels) async {
    _directCategoryChannelsMemo ??= {};
    _directCategoryChannelsMemo![categoryId] = List<Channel>.unmodifiable(channels);
    final box = _boxOrNull(AppConstants.channelsBox);
    if (box == null) return;
    await box.put('direct_channels_$categoryId', channels.map((c) => c.toJson()).toList());
  }

  List<Channel> getAllDirectChannels() {
    final list = <Channel>[];
    for (final catId in directCategoryIds) {
      list.addAll(getDirectCategoryChannels(catId));
    }
    return list;
  }

  // ─── Events ─────────────────────────────────────────────────
  List<SportEvent> getLocalEvents() {
    return _eventsMemo ??= () {
      final events = _decodeList(
        AppConstants.eventsBox,
        'events',
        SportEvent.fromJson,
      ).toList();
      events.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      return events;
    }();
  }

  Future<void> saveLocalEvents(List<SportEvent> events) async {
    // Primed, matching saveLocalChannels. Sorted here so the memo and a later
    // cold decode agree on ordering.
    final sorted = events.toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    _eventsMemo = List<SportEvent>.unmodifiable(sorted);
    final box = _boxOrNull(AppConstants.eventsBox);
    if (box == null) return;
    await box.put('events', events.map((e) => e.toJson()).toList());
  }

  // ─── Categories ─────────────────────────────────────────────
  List<Category> getLocalCategories() {
    return _categoriesMemo ??= _decodeList(
      AppConstants.categoriesBox,
      'categories',
      Category.fromJson,
    );
  }

  Future<void> saveLocalCategories(List<Category> categories) async {
    _categoriesMemo = List<Category>.unmodifiable(categories);
    final box = _boxOrNull(AppConstants.categoriesBox);
    if (box == null) return;
    await box.put('categories', categories.map((c) => c.toJson()).toList());
  }

  // ─── Favorites ──────────────────────────────────────────────
  Set<String> getFavoriteChannelIds() {
    return _favoritesMemo ??= () {
      final box = _boxOrNull(AppConstants.favoritesBox);
      final raw = box?.get('channel_ids') as List<dynamic>?;
      if (raw == null) return <String>{};
      return raw.whereType<String>().toSet();
    }();
  }

  Future<void> saveFavoriteChannelIds(Set<String> ids) async {
    _favoritesMemo = Set<String>.unmodifiable(ids);
    final box = _boxOrNull(AppConstants.favoritesBox);
    if (box == null) return;
    await box.put('channel_ids', ids.toList(growable: false));
  }

  // ─── User Preference: Show Trending Tab ─────────────────────
  bool getShowTrendingTabUserPref() {
    final box = _boxOrNull(AppConstants.settingsBox);
    return box?.get('user_show_trending_tab') as bool? ?? false;
  }

  Future<void> saveShowTrendingTabUserPref(bool enabled) async {
    final box = _boxOrNull(AppConstants.settingsBox);
    if (box == null) return;
    await box.put('user_show_trending_tab', enabled);
  }

  // ─── Sync Versions ──────────────────────────────────────────
  int? getLocalChannelsVersion() =>
      _boxOrNull(AppConstants.settingsBox)?.get('channels_version') as int?;

  Future<void> saveLocalChannelsVersion(int version) async {
    await _boxOrNull(AppConstants.settingsBox)?.put('channels_version', version);
  }

  int? getLocalEventsVersion() =>
      _boxOrNull(AppConstants.settingsBox)?.get('events_version') as int?;

  Future<void> saveLocalEventsVersion(int version) async {
    await _boxOrNull(AppConstants.settingsBox)?.put('events_version', version);
  }

  Future<void> clearAllCache() async {
    invalidateMemo();
    _uiConfigMemo = null;
    await _boxOrNull(AppConstants.channelsBox)?.clear();
    await _boxOrNull(AppConstants.eventsBox)?.clear();
    await _boxOrNull(AppConstants.categoriesBox)?.clear();
    await _boxOrNull(AppConstants.heroBannersBox)?.clear();
    final settingsBox = _boxOrNull(AppConstants.settingsBox);
    await settingsBox?.delete('channels_version');
    await settingsBox?.delete('events_version');
    await settingsBox?.delete('ui_config');
    await settingsBox?.delete('ui_config_version');
  }

  Future<void> resetLocalUiConfigToDefaults() async {
    _uiConfigMemo = AppUiConfig.defaults();
    final box = _boxOrNull(AppConstants.settingsBox);
    await box?.delete('ui_config');
    await box?.delete('ui_config_version');
  }

  // ─── Announcements ──────────────────────────────────────────
  List<Announcement> getLocalAnnouncements() {
    return _announcementsMemo ??= _decodeList(
      AppConstants.announcementsBox,
      'announcements',
      Announcement.fromJson,
    );
  }

  Future<void> saveLocalAnnouncements(List<Announcement> announcements) async {
    _announcementsMemo = List<Announcement>.unmodifiable(announcements);
    final box = _boxOrNull(AppConstants.announcementsBox);
    if (box == null) return;
    await box.put('announcements', announcements.map((a) => a.toJson()).toList());
  }

  // ─── Hero Banners ───────────────────────────────────────────
  List<HeroBannerItem> getLocalHeroBanners() {
    return _heroBannersMemo ??= _decodeList(
      AppConstants.heroBannersBox,
      'hero_banners',
      HeroBannerItem.fromJson,
    );
  }

  Future<void> saveLocalHeroBanners(List<HeroBannerItem> banners) async {
    _heroBannersMemo = List<HeroBannerItem>.unmodifiable(banners);
    final box = _boxOrNull(AppConstants.heroBannersBox);
    if (box == null) return;
    await box.put('hero_banners', banners.map((b) => b.toJson()).toList());
  }

  // ─── App UI Configuration ────────────────────────────────────
  bool hasLocalUiConfig() {
    final box = _boxOrNull(AppConstants.settingsBox);
    if (box == null) return false;
    final jsonStr = box.get('ui_config_json');
    if (jsonStr is String && jsonStr.isNotEmpty) return true;
    final raw = box.get('ui_config');
    return raw != null;
  }

  AppUiConfig getLocalUiConfig() {
    if (_uiConfigMemo != null) return _uiConfigMemo!;
    final box = _boxOrNull(AppConstants.settingsBox);
    if (box == null) {
      // Box is not open yet (e.g. during very early first frame).
      // Return defaults for this frame but do NOT memoize it,
      // so subsequent calls once the box opens load the real saved user theme!
      return AppUiConfig.defaults();
    }

    // 1. Try reading clean JSON string
    final jsonStr = box.get('ui_config_json');
    if (jsonStr is String && jsonStr.isNotEmpty) {
      try {
        final decoded = jsonDecode(jsonStr);
        _uiConfigMemo = AppUiConfig.fromJson(decoded);
        return _uiConfigMemo!;
      } catch (e) {
        debugPrint('CacheService: failed to decode ui_config_json: $e');
      }
    }

    // 2. Fallback to raw map
    final raw = box.get('ui_config');
    if (raw != null) {
      try {
        _uiConfigMemo = AppUiConfig.fromJson(raw);
        return _uiConfigMemo!;
      } catch (e) {
        debugPrint('CacheService: failed to decode raw cached ui_config: $e');
      }
    }

    // Only memoize defaults when the box is open and has no saved config
    return _uiConfigMemo = AppUiConfig.defaults();
  }

  Future<void> saveLocalUiConfig(AppUiConfig config) async {
    _uiConfigMemo = config;
    final box = _boxOrNull(AppConstants.settingsBox);
    if (box == null) return;
    try {
      final jsonStr = jsonEncode(config.toJson());
      await box.put('ui_config_json', jsonStr);
    } catch (e) {
      debugPrint('CacheService: failed to jsonEncode ui_config: $e');
    }
    await box.put('ui_config', config.toJson());
  }

  int? getLocalUiConfigVersion() {
    final box = _boxOrNull(AppConstants.settingsBox);
    return box?.get('ui_config_version') as int?;
  }

  Future<void> saveLocalUiConfigVersion(int version) async {
    final box = _boxOrNull(AppConstants.settingsBox);
    if (box == null) return;
    await box.put('ui_config_version', version);
  }
}

