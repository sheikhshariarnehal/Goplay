import 'package:flutter/foundation.dart';

/// Recursively normalizes any Map / dynamic data into strongly-typed `Map<String, dynamic>`.
/// Completely eliminates Hive binary `_Map<dynamic, dynamic>` TypeError crashes on cold starts.
dynamic _deepCastValue(dynamic value) {
  if (value is Map) {
    return _deepCastMap(value);
  }
  if (value is List) {
    return value.map(_deepCastValue).toList();
  }
  return value;
}

Map<String, dynamic>? _deepCastMap(dynamic map) {
  if (map == null) return null;
  if (map is! Map) return null;
  return map.map((key, value) => MapEntry(key.toString(), _deepCastValue(value)));
}

/// Root model for dynamic App UI Configuration.
@immutable
class AppUiConfig {
  final ThemeConfig theme;
  final ChannelsTabConfig channelsTab;
  final CategoriesScreenConfig categoriesScreen;
  final HomeScreenConfig homeScreen;
  final PromoBannerConfig promoBanner;
  final TvExperienceConfig tvExperience;
  final NavigationBrandingConfig navigationBranding;
  final SearchConfig searchConfig;
  final SportsCardsConfig sportsCards;
  final PlayerDefaultsConfig playerDefaults;
  final StreamReportingConfig streamReporting;
  final CommunityLinksConfig communityLinks;
  final OtaUpdatesConfig otaUpdates;
  final BroadcastsConfig broadcasts;
  final ComponentStylesConfig componentStyles;

  const AppUiConfig({
    required this.theme,
    required this.channelsTab,
    required this.categoriesScreen,
    required this.homeScreen,
    required this.promoBanner,
    required this.tvExperience,
    required this.navigationBranding,
    required this.searchConfig,
    required this.sportsCards,
    required this.playerDefaults,
    required this.streamReporting,
    required this.communityLinks,
    required this.otaUpdates,
    required this.broadcasts,
    required this.componentStyles,
  });

  factory AppUiConfig.defaults() => const AppUiConfig(
        theme: ThemeConfig.defaults(),
        channelsTab: ChannelsTabConfig.defaults(),
        categoriesScreen: CategoriesScreenConfig.defaults(),
        homeScreen: HomeScreenConfig.defaults(),
        promoBanner: PromoBannerConfig.defaults(),
        tvExperience: TvExperienceConfig.defaults(),
        navigationBranding: NavigationBrandingConfig.defaults(),
        searchConfig: SearchConfig.defaults(),
        sportsCards: SportsCardsConfig.defaults(),
        playerDefaults: PlayerDefaultsConfig.defaults(),
        streamReporting: StreamReportingConfig.defaults(),
        communityLinks: CommunityLinksConfig.defaults(),
        otaUpdates: OtaUpdatesConfig.defaults(),
        broadcasts: BroadcastsConfig.defaults(),
        componentStyles: ComponentStylesConfig.defaults(),
      );

  factory AppUiConfig.fromJson(dynamic raw) {
    if (raw == null) return AppUiConfig.defaults();
    final json = _deepCastMap(raw);
    if (json == null) return AppUiConfig.defaults();
    try {
      return AppUiConfig(
        theme: ThemeConfig.fromJson(_deepCastMap(json['theme'])),
        channelsTab: ChannelsTabConfig.fromJson(_deepCastMap(json['channels_tab'])),
        categoriesScreen: CategoriesScreenConfig.fromJson(_deepCastMap(json['categories_screen'])),
        homeScreen: HomeScreenConfig.fromJson(_deepCastMap(json['home_screen'])),
        promoBanner: PromoBannerConfig.fromJson(_deepCastMap(json['promo_banner'])),
        tvExperience: TvExperienceConfig.fromJson(_deepCastMap(json['tv_experience'])),
        navigationBranding: NavigationBrandingConfig.fromJson(_deepCastMap(json['navigation_branding'])),
        searchConfig: SearchConfig.fromJson(_deepCastMap(json['search_config'])),
        sportsCards: SportsCardsConfig.fromJson(_deepCastMap(json['sports_cards'])),
        playerDefaults: PlayerDefaultsConfig.fromJson(_deepCastMap(json['player_defaults'])),
        streamReporting: StreamReportingConfig.fromJson(_deepCastMap(json['stream_reporting'])),
        communityLinks: CommunityLinksConfig.fromJson(_deepCastMap(json['community_links'])),
        otaUpdates: OtaUpdatesConfig.fromJson(_deepCastMap(json['ota_updates'])),
        broadcasts: BroadcastsConfig.fromJson(_deepCastMap(json['broadcasts'])),
        componentStyles: ComponentStylesConfig.fromJson(_deepCastMap(json['component_styles'])),
      );
    } catch (e, stack) {
      debugPrint('AppUiConfig.fromJson error, falling back to defaults: $e\n$stack');
      return AppUiConfig.defaults();
    }
  }

  Map<String, dynamic> toJson() => {
        'theme': theme.toJson(),
        'channels_tab': channelsTab.toJson(),
        'categories_screen': categoriesScreen.toJson(),
        'home_screen': homeScreen.toJson(),
        'promo_banner': promoBanner.toJson(),
        'tv_experience': tvExperience.toJson(),
        'navigation_branding': navigationBranding.toJson(),
        'search_config': searchConfig.toJson(),
        'sports_cards': sportsCards.toJson(),
        'player_defaults': playerDefaults.toJson(),
        'stream_reporting': streamReporting.toJson(),
        'community_links': communityLinks.toJson(),
        'ota_updates': otaUpdates.toJson(),
        'broadcasts': broadcasts.toJson(),
        'component_styles': componentStyles.toJson(),
      };

  // ─── Inheritance Resolvers (Theme Fallback Engine) ─────────────

  /// Resolves Event Card background: uses override if active; otherwise global theme.cardColor.
  String resolveEventCardBg() {
    if (componentStyles.eventCard.useCustomOverride && componentStyles.eventCard.backgroundColor.isNotEmpty) {
      return componentStyles.eventCard.backgroundColor;
    }
    return theme.cardColor;
  }

  /// Resolves Channel Card background: uses override if active; otherwise global theme.cardColor.
  String resolveChannelCardBg() {
    if (componentStyles.channelCard.useCustomOverride && componentStyles.channelCard.backgroundColor.isNotEmpty) {
      return componentStyles.channelCard.backgroundColor;
    }
    return theme.cardColor;
  }

  /// Resolves Category Chip inactive background:
  String resolveCategoryChipInactiveBg({bool isHome = false}) {
    final chips = componentStyles.categoryChips;
    if (chips.useCustomOverride) {
      if (chips.separateHomeAndUpcoming) {
        return isHome ? chips.homeOverride.inactiveBgColor : chips.upcomingOverride.inactiveBgColor;
      }
      return chips.inactiveBgColor;
    }
    return theme.cardColor;
  }

  /// Resolves Category Chip active background:
  String resolveCategoryChipActiveBg({bool isHome = false}) {
    final chips = componentStyles.categoryChips;
    if (chips.useCustomOverride) {
      if (chips.separateHomeAndUpcoming) {
        return isHome ? chips.homeOverride.activeBgColor : chips.upcomingOverride.activeBgColor;
      }
      return chips.activeBgColor;
    }
    return theme.primaryColor;
  }

  /// Resolves Category Chip text color when active:
  String resolveCategoryChipActiveTextColor({bool isHome = false}) {
    final chips = componentStyles.categoryChips;
    if (chips.useCustomOverride) {
      if (chips.separateHomeAndUpcoming) {
        return isHome ? chips.homeOverride.activeTextColor : chips.upcomingOverride.activeTextColor;
      }
      return chips.activeTextColor;
    }
    return '#0F0F0F';
  }

  /// Resolves Category Chip text color when inactive:
  String resolveCategoryChipInactiveTextColor({bool isHome = false}) {
    final chips = componentStyles.categoryChips;
    if (chips.useCustomOverride) {
      if (chips.separateHomeAndUpcoming) {
        return isHome ? chips.homeOverride.inactiveTextColor : chips.upcomingOverride.inactiveTextColor;
      }
      return chips.inactiveTextColor;
    }
    return '#FFFFFF';
  }

  /// Resolves Category Chip border radius:
  double resolveCategoryChipRadius({bool isHome = false}) {
    final chips = componentStyles.categoryChips;
    if (chips.separateHomeAndUpcoming) {
      return isHome ? chips.homeOverride.borderRadius : chips.upcomingOverride.borderRadius;
    }
    return chips.borderRadius;
  }

  /// Resolves Settings Card background:
  String resolveSettingsCardBg() {
    if (componentStyles.settingsScreen.useCustomOverride && componentStyles.settingsScreen.cardBgColor.isNotEmpty) {
      return componentStyles.settingsScreen.cardBgColor;
    }
    return theme.cardColor;
  }
}

// ─── 1. Theme Config ─────────────────────────────────────────────
@immutable
class ThemeConfig {
  final String preset;
  final String primaryColor;
  final String surfaceColor;
  final String cardColor;

  const ThemeConfig({
    required this.preset,
    required this.primaryColor,
    required this.surfaceColor,
    required this.cardColor,
  });

  const ThemeConfig.defaults()
      : preset = 'volt',
        primaryColor = '#C8FF00',
        surfaceColor = '#0F0F0F',
        cardColor = '#272727';

  factory ThemeConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ThemeConfig.defaults();
    return ThemeConfig(
      preset: json['preset'] as String? ?? 'volt',
      primaryColor: json['primary_color'] as String? ?? '#C8FF00',
      surfaceColor: json['surface_color'] as String? ?? '#0F0F0F',
      cardColor: json['card_color'] as String? ?? '#272727',
    );
  }

  Map<String, dynamic> toJson() => {
        'preset': preset,
        'primary_color': primaryColor,
        'surface_color': surfaceColor,
        'card_color': cardColor,
      };
}

// ─── 2. Channels Tab Config ──────────────────────────────────────
@immutable
class ChannelsTabConfig {
  final bool showTabIcons;
  final bool showTabCounts;
  final bool showTrendingTab;
  final bool showFavoriteTab;
  final bool autoHideFavoriteTabWhenEmpty;
  final bool showAllTab;
  final int channelGridColumns;
  final String cardLayoutMode; // 'compact', 'landscape', 'list'
  final bool showQualityBadge;
  final bool showCardLogos;
  final bool showCardNames;
  final bool showCardFavorites;

  const ChannelsTabConfig({
    required this.showTabIcons,
    required this.showTabCounts,
    required this.showTrendingTab,
    required this.showFavoriteTab,
    this.autoHideFavoriteTabWhenEmpty = true,
    required this.showAllTab,
    required this.channelGridColumns,
    required this.cardLayoutMode,
    required this.showQualityBadge,
    required this.showCardLogos,
    required this.showCardNames,
    required this.showCardFavorites,
  });

  const ChannelsTabConfig.defaults()
      : showTabIcons = true,
        showTabCounts = true,
        showTrendingTab = false,
        showFavoriteTab = true,
        autoHideFavoriteTabWhenEmpty = true,
        showAllTab = true,
        channelGridColumns = 3,
        cardLayoutMode = 'compact',
        showQualityBadge = true,
        showCardLogos = true,
        showCardNames = true,
        showCardFavorites = true;

  factory ChannelsTabConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ChannelsTabConfig.defaults();
    return ChannelsTabConfig(
      showTabIcons: json['show_tab_icons'] as bool? ?? true,
      showTabCounts: json['show_tab_counts'] as bool? ?? true,
      showTrendingTab: json['show_trending_tab'] as bool? ?? false,
      showFavoriteTab: json['show_favorite_tab'] as bool? ?? true,
      autoHideFavoriteTabWhenEmpty: json['auto_hide_favorite_tab_when_empty'] as bool? ?? true,
      showAllTab: json['show_all_tab'] as bool? ?? true,
      channelGridColumns: (json['channel_grid_columns'] as num?)?.toInt() ?? 3,
      cardLayoutMode: json['card_layout_mode'] as String? ?? 'compact',
      showQualityBadge: json['show_quality_badge'] as bool? ?? true,
      showCardLogos: json['show_card_logos'] as bool? ?? true,
      showCardNames: json['show_card_names'] as bool? ?? true,
      showCardFavorites: json['show_card_favorites'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'show_tab_icons': showTabIcons,
        'show_tab_counts': showTabCounts,
        'show_trending_tab': showTrendingTab,
        'show_favorite_tab': showFavoriteTab,
        'auto_hide_favorite_tab_when_empty': autoHideFavoriteTabWhenEmpty,
        'show_all_tab': showAllTab,
        'channel_grid_columns': channelGridColumns,
        'card_layout_mode': cardLayoutMode,
        'show_quality_badge': showQualityBadge,
        'show_card_logos': showCardLogos,
        'show_card_names': showCardNames,
        'show_card_favorites': showCardFavorites,
      };
}

// ─── 3. Categories Screen Config ─────────────────────────────────
@immutable
class CategoriesScreenConfig {
  final bool showCategoryEmblems;
  final bool showCategoryChannelCounts;
  final int categoryGridColumns;
  final bool showCategorySearch;
  final bool showCategoryFavorites;

  const CategoriesScreenConfig({
    required this.showCategoryEmblems,
    required this.showCategoryChannelCounts,
    required this.categoryGridColumns,
    required this.showCategorySearch,
    required this.showCategoryFavorites,
  });

  const CategoriesScreenConfig.defaults()
      : showCategoryEmblems = true,
        showCategoryChannelCounts = true,
        categoryGridColumns = 2,
        showCategorySearch = true,
        showCategoryFavorites = true;

  factory CategoriesScreenConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CategoriesScreenConfig.defaults();
    return CategoriesScreenConfig(
      showCategoryEmblems: json['show_category_emblems'] as bool? ?? true,
      showCategoryChannelCounts: json['show_category_channel_counts'] as bool? ?? true,
      categoryGridColumns: (json['category_grid_columns'] as num?)?.toInt() ?? 2,
      showCategorySearch: json['show_category_search'] as bool? ?? true,
      showCategoryFavorites: json['show_category_favorites'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'show_category_emblems': showCategoryEmblems,
        'show_category_channel_counts': showCategoryChannelCounts,
        'category_grid_columns': categoryGridColumns,
        'show_category_search': showCategorySearch,
        'show_category_favorites': showCategoryFavorites,
      };
}

// ─── 4. Home Screen Config ───────────────────────────────────────
@immutable
class HomeScreenConfig {
  final bool showHeroBanner;
  final int heroBannerAutoplaySpeed;
  final bool showTrendingSection;
  final bool showTodaysMatches;
  final bool showRecentlyWatched;
  final bool showAnnouncements;
  final List<String> sectionOrder;

  const HomeScreenConfig({
    required this.showHeroBanner,
    required this.heroBannerAutoplaySpeed,
    required this.showTrendingSection,
    required this.showTodaysMatches,
    required this.showRecentlyWatched,
    required this.showAnnouncements,
    required this.sectionOrder,
  });

  const HomeScreenConfig.defaults()
      : showHeroBanner = true,
        heroBannerAutoplaySpeed = 5,
        showTrendingSection = true,
        showTodaysMatches = true,
        showRecentlyWatched = true,
        showAnnouncements = true,
        sectionOrder = const ['hero', 'trending', 'matches', 'recent', 'announcements'];

  factory HomeScreenConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const HomeScreenConfig.defaults();
    final rawList = json['section_order'] as List<dynamic>?;
    final List<String> parsedOrder = rawList != null
        ? rawList.map((e) => e.toString()).toList()
        : const ['hero', 'trending', 'matches', 'recent', 'announcements'];

    return HomeScreenConfig(
      showHeroBanner: json['show_hero_banner'] as bool? ?? true,
      heroBannerAutoplaySpeed: (json['hero_banner_autoplay_speed'] as num?)?.toInt() ?? 5,
      showTrendingSection: json['show_trending_section'] as bool? ?? true,
      showTodaysMatches: json['show_todays_matches'] as bool? ?? true,
      showRecentlyWatched: json['show_recently_watched'] as bool? ?? true,
      showAnnouncements: json['show_announcements'] as bool? ?? true,
      sectionOrder: parsedOrder.isNotEmpty
          ? parsedOrder
          : const ['hero', 'trending', 'matches', 'recent', 'announcements'],
    );
  }

  Map<String, dynamic> toJson() => {
        'show_hero_banner': showHeroBanner,
        'hero_banner_autoplay_speed': heroBannerAutoplaySpeed,
        'show_trending_section': showTrendingSection,
        'show_todays_matches': showTodaysMatches,
        'show_recently_watched': showRecentlyWatched,
        'show_announcements': showAnnouncements,
        'section_order': sectionOrder,
      };
}

// ─── 5. Promo Banner Config ──────────────────────────────────────
@immutable
class PromoBannerConfig {
  final bool enabled;
  final int positionIndex;
  final String title;
  final String subtitle;
  final String badgeText;
  final String imageUrl;
  final String actionUrl;

  const PromoBannerConfig({
    required this.enabled,
    required this.positionIndex,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.imageUrl,
    required this.actionUrl,
  });

  const PromoBannerConfig.defaults()
      : enabled = false,
        positionIndex = 6,
        title = '',
        subtitle = '',
        badgeText = 'VIP',
        imageUrl = '',
        actionUrl = '';

  factory PromoBannerConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PromoBannerConfig.defaults();
    return PromoBannerConfig(
      enabled: json['enabled'] as bool? ?? false,
      positionIndex: (json['position_index'] as num?)?.toInt() ?? 6,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      badgeText: json['badge_text'] as String? ?? 'VIP',
      imageUrl: json['image_url'] as String? ?? '',
      actionUrl: json['action_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'position_index': positionIndex,
        'title': title,
        'subtitle': subtitle,
        'badge_text': badgeText,
        'image_url': imageUrl,
        'action_url': actionUrl,
      };
}

// ─── 6. TV Experience Config ─────────────────────────────────────
@immutable
class TvExperienceConfig {
  final String defaultStartScreen; // 'home' or 'channels'
  final double focusScale;
  final bool enableFocusGlow;

  const TvExperienceConfig({
    required this.defaultStartScreen,
    required this.focusScale,
    required this.enableFocusGlow,
  });

  const TvExperienceConfig.defaults()
      : defaultStartScreen = 'home',
        focusScale = 1.08,
        enableFocusGlow = true;

  factory TvExperienceConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const TvExperienceConfig.defaults();
    return TvExperienceConfig(
      defaultStartScreen: json['default_start_screen'] as String? ?? 'home',
      focusScale: (json['focus_scale'] as num?)?.toDouble() ?? 1.08,
      enableFocusGlow: json['enable_focus_glow'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'default_start_screen': defaultStartScreen,
        'focus_scale': focusScale,
        'enable_focus_glow': enableFocusGlow,
      };
}

// ─── 7. Navigation Branding Config ───────────────────────────────
@immutable
class NavigationBrandingConfig {
  final String brandWordmark;
  final List<String> enabledTabs;
  final List<String> tabOrder;

  const NavigationBrandingConfig({
    required this.brandWordmark,
    required this.enabledTabs,
    required this.tabOrder,
  });

  const NavigationBrandingConfig.defaults()
      : brandWordmark = 'GOPLAY',
        enabledTabs = const ['home', 'categories', 'channels', 'upcoming', 'settings'],
        tabOrder = const ['home', 'categories', 'channels', 'upcoming', 'settings'];

  factory NavigationBrandingConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const NavigationBrandingConfig.defaults();
    final rawEnabled = json['enabled_tabs'] as List<dynamic>?;
    final rawOrder = json['tab_order'] as List<dynamic>?;

    final enabled = rawEnabled != null
        ? rawEnabled.map((e) => e.toString()).toList()
        : const ['home', 'categories', 'channels', 'upcoming', 'settings'];
    final order = rawOrder != null
        ? rawOrder.map((e) => e.toString()).toList()
        : const ['home', 'categories', 'channels', 'upcoming', 'settings'];

    return NavigationBrandingConfig(
      brandWordmark: json['brand_wordmark'] as String? ?? 'GOPLAY',
      enabledTabs: enabled.isNotEmpty ? enabled : const ['home', 'channels'],
      tabOrder: order.isNotEmpty ? order : const ['home', 'categories', 'channels', 'upcoming', 'settings'],
    );
  }

  Map<String, dynamic> toJson() => {
        'brand_wordmark': brandWordmark,
        'enabled_tabs': enabledTabs,
        'tab_order': tabOrder,
      };
}

// ─── 8. Search Config ────────────────────────────────────────────
@immutable
class SearchTag {
  final String label;
  final String query;

  const SearchTag({required this.label, required this.query});

  factory SearchTag.fromJson(Map<String, dynamic> json) => SearchTag(
        label: json['label'] as String? ?? '',
        query: json['query'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {'label': label, 'query': query};
}

@immutable
class SearchConfig {
  final List<SearchTag> popularTags;

  const SearchConfig({required this.popularTags});

  const SearchConfig.defaults()
      : popularTags = const [
          SearchTag(label: '⚽ Football', query: 'Football'),
          SearchTag(label: '🏏 Cricket', query: 'Cricket'),
          SearchTag(label: '🔥 Live', query: 'Live'),
          SearchTag(label: '🍿 Movies', query: 'Movies'),
          SearchTag(label: '📺 Sports', query: 'Sports'),
          SearchTag(label: '🌐 News', query: 'News'),
          SearchTag(label: '🎬 Entertainment', query: 'Entertainment'),
          SearchTag(label: '🎵 Music', query: 'Music'),
        ];

  factory SearchConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const SearchConfig.defaults();
    final raw = json['popular_tags'] as List<dynamic>?;
    if (raw == null || raw.isEmpty) return const SearchConfig.defaults();
    return SearchConfig(
      popularTags: raw
          .whereType<Map>()
          .map((e) => SearchTag.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'popular_tags': popularTags.map((e) => e.toJson()).toList(),
      };
}

// ─── 9. Sports Cards Config ──────────────────────────────────────
@immutable
class SportsCardsConfig {
  final bool showCountdownTimer;
  final bool showLivePulse;
  final bool showSportFilterChips;

  const SportsCardsConfig({
    required this.showCountdownTimer,
    required this.showLivePulse,
    required this.showSportFilterChips,
  });

  const SportsCardsConfig.defaults()
      : showCountdownTimer = true,
        showLivePulse = true,
        showSportFilterChips = true;

  factory SportsCardsConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const SportsCardsConfig.defaults();
    return SportsCardsConfig(
      showCountdownTimer: json['show_countdown_timer'] as bool? ?? true,
      showLivePulse: json['show_live_pulse'] as bool? ?? true,
      showSportFilterChips: json['show_sport_filter_chips'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'show_countdown_timer': showCountdownTimer,
        'show_live_pulse': showLivePulse,
        'show_sport_filter_chips': showSportFilterChips,
      };
}

// ─── 10. Player Defaults Config ──────────────────────────────────
@immutable
class PlayerDefaultsConfig {
  final String defaultAspectRatio;
  final String defaultBufferMode;
  final bool autoRetryOnError;
  final bool enablePip;

  const PlayerDefaultsConfig({
    required this.defaultAspectRatio,
    required this.defaultBufferMode,
    required this.autoRetryOnError,
    required this.enablePip,
  });

  const PlayerDefaultsConfig.defaults()
      : defaultAspectRatio = '16:9 (Fit)',
        defaultBufferMode = 'Balanced',
        autoRetryOnError = true,
        enablePip = true;

  factory PlayerDefaultsConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PlayerDefaultsConfig.defaults();
    return PlayerDefaultsConfig(
      defaultAspectRatio: json['default_aspect_ratio'] as String? ?? '16:9 (Fit)',
      defaultBufferMode: json['default_buffer_mode'] as String? ?? 'Balanced',
      autoRetryOnError: json['auto_retry_on_error'] as bool? ?? true,
      enablePip: json['enable_pip'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'default_aspect_ratio': defaultAspectRatio,
        'default_buffer_mode': defaultBufferMode,
        'auto_retry_on_error': autoRetryOnError,
        'enable_pip': enablePip,
      };
}

// ─── 11. Stream Reporting Config ─────────────────────────────────
@immutable
class StreamReportingConfig {
  final bool enabled;
  final String reportUrl;

  const StreamReportingConfig({
    required this.enabled,
    required this.reportUrl,
  });

  const StreamReportingConfig.defaults()
      : enabled = true,
        reportUrl = 'https://t.me/goplay_support_bot';

  factory StreamReportingConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const StreamReportingConfig.defaults();
    return StreamReportingConfig(
      enabled: json['enabled'] as bool? ?? true,
      reportUrl: json['report_url'] as String? ?? 'https://t.me/goplay_support_bot',
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'report_url': reportUrl,
      };
}

// ─── 12. Community Links Config ──────────────────────────────────
@immutable
class CommunityLinksConfig {
  final String telegramUrl;
  final String discordUrl;
  final String whatsappUrl;
  final String websiteUrl;

  const CommunityLinksConfig({
    required this.telegramUrl,
    required this.discordUrl,
    required this.whatsappUrl,
    required this.websiteUrl,
  });

  const CommunityLinksConfig.defaults()
      : telegramUrl = 'https://t.me/goplay_official',
        discordUrl = '',
        whatsappUrl = '',
        websiteUrl = 'https://goplay.tv';

  factory CommunityLinksConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const CommunityLinksConfig.defaults();
    return CommunityLinksConfig(
      telegramUrl: json['telegram_url'] as String? ?? '',
      discordUrl: json['discord_url'] as String? ?? '',
      whatsappUrl: json['whatsapp_url'] as String? ?? '',
      websiteUrl: json['website_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'telegram_url': telegramUrl,
        'discord_url': discordUrl,
        'whatsapp_url': whatsappUrl,
        'website_url': websiteUrl,
      };
}

// ─── 13. OTA Updates Config ──────────────────────────────────────
@immutable
class OtaUpdatesConfig {
  final String latestVersion;
  final String minVersion;
  final String apkUrl;
  final String releaseNotes;

  const OtaUpdatesConfig({
    required this.latestVersion,
    required this.minVersion,
    required this.apkUrl,
    required this.releaseNotes,
  });

  const OtaUpdatesConfig.defaults()
      : latestVersion = '2.2.0',
        minVersion = '2.0.0',
        apkUrl = 'https://cdn.ntechbd.app/goplay-latest.apk',
        releaseNotes = 'Performance optimizations & UI enhancements';

  factory OtaUpdatesConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const OtaUpdatesConfig.defaults();
    return OtaUpdatesConfig(
      latestVersion: json['latest_version'] as String? ?? '2.2.0',
      minVersion: json['min_version'] as String? ?? '2.0.0',
      apkUrl: json['apk_url'] as String? ?? '',
      releaseNotes: json['release_notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'latest_version': latestVersion,
        'min_version': minVersion,
        'apk_url': apkUrl,
        'release_notes': releaseNotes,
      };
}

// ─── 14. Broadcasts Config ───────────────────────────────────────
@immutable
class BroadcastsConfig {
  final bool isMaintenanceEnabled;
  final String maintenanceTitle;
  final String maintenanceMessage;
  final bool isPopupEnabled;
  final String popupId;
  final String popupTitle;
  final String popupMessage;
  final String popupImageUrl;
  final String popupActionLabel;
  final String popupActionUrl;

  const BroadcastsConfig({
    required this.isMaintenanceEnabled,
    required this.maintenanceTitle,
    required this.maintenanceMessage,
    required this.isPopupEnabled,
    required this.popupId,
    required this.popupTitle,
    required this.popupMessage,
    required this.popupImageUrl,
    required this.popupActionLabel,
    required this.popupActionUrl,
  });

  const BroadcastsConfig.defaults()
      : isMaintenanceEnabled = false,
        maintenanceTitle = 'Under Scheduled Maintenance',
        maintenanceMessage = 'We are upgrading our streaming servers. Live TV will be back online shortly.',
        isPopupEnabled = false,
        popupId = 'popup_v1',
        popupTitle = 'Welcome to GoPlay TV!',
        popupMessage = 'Enjoy hundreds of HD live channels and sports matches directly on your device.',
        popupImageUrl = '',
        popupActionLabel = 'Explore Channels',
        popupActionUrl = '';

  factory BroadcastsConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BroadcastsConfig.defaults();
    return BroadcastsConfig(
      isMaintenanceEnabled: json['is_maintenance_enabled'] as bool? ?? false,
      maintenanceTitle: json['maintenance_title'] as String? ?? 'Under Scheduled Maintenance',
      maintenanceMessage: json['maintenance_message'] as String? ??
          'We are upgrading our streaming servers. Live TV will be back online shortly.',
      isPopupEnabled: json['is_popup_enabled'] as bool? ?? false,
      popupId: json['popup_id'] as String? ?? 'popup_v1',
      popupTitle: json['popup_title'] as String? ?? '',
      popupMessage: json['popup_message'] as String? ?? '',
      popupImageUrl: json['popup_image_url'] as String? ?? '',
      popupActionLabel: json['popup_action_label'] as String? ?? 'OK',
      popupActionUrl: json['popup_action_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'is_maintenance_enabled': isMaintenanceEnabled,
        'maintenance_title': maintenanceTitle,
        'maintenance_message': maintenanceMessage,
        'is_popup_enabled': isPopupEnabled,
        'popup_id': popupId,
        'popup_title': popupTitle,
        'popup_message': popupMessage,
        'popup_image_url': popupImageUrl,
        'popup_action_label': popupActionLabel,
        'popup_action_url': popupActionUrl,
      };
}

// ─── 15. Component Styles Config ───────────────────────────────
@immutable
class ComponentStylesConfig {
  final EventCardStyleConfig eventCard;
  final ChannelCardStyleConfig channelCard;
  final CategoryChipsStyleConfig categoryChips;
  final SettingsScreenStyleConfig settingsScreen;

  const ComponentStylesConfig({
    required this.eventCard,
    required this.channelCard,
    required this.categoryChips,
    required this.settingsScreen,
  });

  const ComponentStylesConfig.defaults()
      : eventCard = const EventCardStyleConfig.defaults(),
        channelCard = const ChannelCardStyleConfig.defaults(),
        categoryChips = const CategoryChipsStyleConfig.defaults(),
        settingsScreen = const SettingsScreenStyleConfig.defaults();

  factory ComponentStylesConfig.fromJson(dynamic raw) {
    final json = _deepCastMap(raw);
    if (json == null) return const ComponentStylesConfig.defaults();
    return ComponentStylesConfig(
      eventCard: EventCardStyleConfig.fromJson(_deepCastMap(json['event_card'])),
      channelCard: ChannelCardStyleConfig.fromJson(_deepCastMap(json['channel_card'])),
      categoryChips: CategoryChipsStyleConfig.fromJson(_deepCastMap(json['category_chips'])),
      settingsScreen: SettingsScreenStyleConfig.fromJson(_deepCastMap(json['settings_screen'])),
    );
  }

  Map<String, dynamic> toJson() => {
        'event_card': eventCard.toJson(),
        'channel_card': channelCard.toJson(),
        'category_chips': categoryChips.toJson(),
        'settings_screen': settingsScreen.toJson(),
      };
}

@immutable
class HotBadgeConfig {
  final bool enabled;
  final String text;
  final String bgColor;
  final String textColor;
  final double radiusTopLeft;
  final double radiusTopRight;
  final double radiusBottomLeft;
  final double radiusBottomRight;
  final bool isRadiusLinked;
  final String position; // 'bottom_right', 'top_right', 'top_left', 'bottom_left'

  const HotBadgeConfig({
    required this.enabled,
    required this.text,
    required this.bgColor,
    required this.textColor,
    required this.radiusTopLeft,
    required this.radiusTopRight,
    required this.radiusBottomLeft,
    required this.radiusBottomRight,
    required this.isRadiusLinked,
    required this.position,
  });

  const HotBadgeConfig.defaults()
      : enabled = true,
        text = 'HOT',
        bgColor = '#C8FF00',
        textColor = '#0F0F0F',
        radiusTopLeft = 14.0,
        radiusTopRight = 0.0,
        radiusBottomLeft = 0.0,
        radiusBottomRight = 11.0,
        isRadiusLinked = false,
        position = 'bottom_right';

  factory HotBadgeConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const HotBadgeConfig.defaults();
    return HotBadgeConfig(
      enabled: json['enabled'] as bool? ?? true,
      text: json['text'] as String? ?? 'HOT',
      bgColor: json['bg_color'] as String? ?? '#C8FF00',
      textColor: json['text_color'] as String? ?? '#0F0F0F',
      radiusTopLeft: (json['radius_top_left'] as num?)?.toDouble() ?? 14.0,
      radiusTopRight: (json['radius_top_right'] as num?)?.toDouble() ?? 0.0,
      radiusBottomLeft: (json['radius_bottom_left'] as num?)?.toDouble() ?? 0.0,
      radiusBottomRight: (json['radius_bottom_right'] as num?)?.toDouble() ?? 11.0,
      isRadiusLinked: json['is_radius_linked'] as bool? ?? false,
      position: json['position'] as String? ?? 'bottom_right',
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'text': text,
        'bg_color': bgColor,
        'text_color': textColor,
        'radius_top_left': radiusTopLeft,
        'radius_top_right': radiusTopRight,
        'radius_bottom_left': radiusBottomLeft,
        'radius_bottom_right': radiusBottomRight,
        'is_radius_linked': isRadiusLinked,
        'position': position,
      };
}

@immutable
class EventCardStyleConfig {
  final bool useCustomOverride;
  final String backgroundColor;
  final String borderColor;
  final double borderWidth;
  final double borderRadius;
  final String liveBadgeColor;
  final double elevation;
  final bool enableGlow;
  final HotBadgeConfig hotBadge;

  const EventCardStyleConfig({
    required this.useCustomOverride,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.liveBadgeColor,
    required this.elevation,
    this.enableGlow = true,
    this.hotBadge = const HotBadgeConfig.defaults(),
  });

  const EventCardStyleConfig.defaults()
      : useCustomOverride = false,
        backgroundColor = '#121212',
        borderColor = '#272727',
        borderWidth = 1.0,
        borderRadius = 14.0,
        liveBadgeColor = '#FF2B2B',
        elevation = 0.0,
        enableGlow = true,
        hotBadge = const HotBadgeConfig.defaults();

  factory EventCardStyleConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const EventCardStyleConfig.defaults();
    return EventCardStyleConfig(
      useCustomOverride: json['use_custom_override'] as bool? ?? false,
      backgroundColor: json['background_color'] as String? ?? '#121212',
      borderColor: json['border_color'] as String? ?? '#272727',
      borderWidth: (json['border_width'] as num?)?.toDouble() ?? 1.0,
      borderRadius: (json['border_radius'] as num?)?.toDouble() ?? 14.0,
      liveBadgeColor: json['live_badge_color'] as String? ?? '#FF2B2B',
      elevation: (json['elevation'] as num?)?.toDouble() ?? 0.0,
      enableGlow: json['enable_glow'] as bool? ?? true,
      hotBadge: HotBadgeConfig.fromJson(_deepCastMap(json['hot_badge'])),
    );
  }

  Map<String, dynamic> toJson() => {
        'use_custom_override': useCustomOverride,
        'background_color': backgroundColor,
        'border_color': borderColor,
        'border_width': borderWidth,
        'border_radius': borderRadius,
        'live_badge_color': liveBadgeColor,
        'elevation': elevation,
        'enable_glow': enableGlow,
        'hot_badge': hotBadge.toJson(),
      };
}

@immutable
class ChannelCardStyleConfig {
  final bool useCustomOverride;
  final String backgroundColor;
  final String borderColor;
  final double borderWidth;
  final double borderRadius;
  final String qualityBadgeColor;
  final double elevation;

  const ChannelCardStyleConfig({
    required this.useCustomOverride,
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.qualityBadgeColor,
    required this.elevation,
  });

  const ChannelCardStyleConfig.defaults()
      : useCustomOverride = false,
        backgroundColor = '#272727',
        borderColor = '#333333',
        borderWidth = 1.0,
        borderRadius = 14.0,
        qualityBadgeColor = '#C8FF00',
        elevation = 0.0;

  factory ChannelCardStyleConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ChannelCardStyleConfig.defaults();
    return ChannelCardStyleConfig(
      useCustomOverride: json['use_custom_override'] as bool? ?? false,
      backgroundColor: json['background_color'] as String? ?? '#272727',
      borderColor: json['border_color'] as String? ?? '#333333',
      borderWidth: (json['border_width'] as num?)?.toDouble() ?? 1.0,
      borderRadius: (json['border_radius'] as num?)?.toDouble() ?? 14.0,
      qualityBadgeColor: json['quality_badge_color'] as String? ?? '#C8FF00',
      elevation: (json['elevation'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'use_custom_override': useCustomOverride,
        'background_color': backgroundColor,
        'border_color': borderColor,
        'border_width': borderWidth,
        'border_radius': borderRadius,
        'quality_badge_color': qualityBadgeColor,
        'elevation': elevation,
      };
}

@immutable
class ChipOverrideStyle {
  final String activeBgColor;
  final String activeTextColor;
  final String inactiveBgColor;
  final String inactiveTextColor;
  final double borderRadius;
  final String borderColor;
  final double borderWidth;

  const ChipOverrideStyle({
    required this.activeBgColor,
    required this.activeTextColor,
    required this.inactiveBgColor,
    required this.inactiveTextColor,
    required this.borderRadius,
    required this.borderColor,
    required this.borderWidth,
  });

  const ChipOverrideStyle.defaults({double radius = 20.0})
      : activeBgColor = '#C8FF00',
        activeTextColor = '#0F0F0F',
        inactiveBgColor = '#272727',
        inactiveTextColor = '#FFFFFF',
        borderRadius = radius,
        borderColor = 'transparent',
        borderWidth = 0.0;

  factory ChipOverrideStyle.fromJson(Map<String, dynamic>? json, {double defaultRadius = 20.0}) {
    if (json == null) return ChipOverrideStyle.defaults(radius: defaultRadius);
    return ChipOverrideStyle(
      activeBgColor: json['active_bg_color'] as String? ?? '#C8FF00',
      activeTextColor: json['active_text_color'] as String? ?? '#0F0F0F',
      inactiveBgColor: json['inactive_bg_color'] as String? ?? '#272727',
      inactiveTextColor: json['inactive_text_color'] as String? ?? '#FFFFFF',
      borderRadius: (json['border_radius'] as num?)?.toDouble() ?? defaultRadius,
      borderColor: json['border_color'] as String? ?? 'transparent',
      borderWidth: (json['border_width'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'active_bg_color': activeBgColor,
        'active_text_color': activeTextColor,
        'inactive_bg_color': inactiveBgColor,
        'inactive_text_color': inactiveTextColor,
        'border_radius': borderRadius,
        'border_color': borderColor,
        'border_width': borderWidth,
      };
}

@immutable
class CategoryChipsStyleConfig {
  final bool useCustomOverride;
  final String activeBgColor;
  final String activeTextColor;
  final String inactiveBgColor;
  final String inactiveTextColor;
  final double borderRadius;
  final String borderColor;
  final double borderWidth;
  final bool separateHomeAndUpcoming;
  final ChipOverrideStyle homeOverride;
  final ChipOverrideStyle upcomingOverride;

  const CategoryChipsStyleConfig({
    required this.useCustomOverride,
    required this.activeBgColor,
    required this.activeTextColor,
    required this.inactiveBgColor,
    required this.inactiveTextColor,
    required this.borderRadius,
    required this.borderColor,
    required this.borderWidth,
    required this.separateHomeAndUpcoming,
    required this.homeOverride,
    required this.upcomingOverride,
  });

  const CategoryChipsStyleConfig.defaults()
      : useCustomOverride = false,
        activeBgColor = '#C8FF00',
        activeTextColor = '#0F0F0F',
        inactiveBgColor = '#272727',
        inactiveTextColor = '#FFFFFF',
        borderRadius = 20.0,
        borderColor = 'transparent',
        borderWidth = 0.0,
        separateHomeAndUpcoming = false,
        homeOverride = const ChipOverrideStyle.defaults(radius: 8.0),
        upcomingOverride = const ChipOverrideStyle.defaults(radius: 20.0);

  factory CategoryChipsStyleConfig.fromJson(dynamic raw) {
    final json = _deepCastMap(raw);
    if (json == null) return const CategoryChipsStyleConfig.defaults();
    return CategoryChipsStyleConfig(
      useCustomOverride: json['use_custom_override'] as bool? ?? false,
      activeBgColor: json['active_bg_color'] as String? ?? '#C8FF00',
      activeTextColor: json['active_text_color'] as String? ?? '#0F0F0F',
      inactiveBgColor: json['inactive_bg_color'] as String? ?? '#272727',
      inactiveTextColor: json['inactive_text_color'] as String? ?? '#FFFFFF',
      borderRadius: (json['border_radius'] as num?)?.toDouble() ?? 20.0,
      borderColor: json['border_color'] as String? ?? 'transparent',
      borderWidth: (json['border_width'] as num?)?.toDouble() ?? 0.0,
      separateHomeAndUpcoming: json['separate_home_and_upcoming'] as bool? ?? false,
      homeOverride: ChipOverrideStyle.fromJson(
        _deepCastMap(json['home_override']),
        defaultRadius: 8.0,
      ),
      upcomingOverride: ChipOverrideStyle.fromJson(
        _deepCastMap(json['upcoming_override']),
        defaultRadius: 20.0,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'use_custom_override': useCustomOverride,
        'active_bg_color': activeBgColor,
        'active_text_color': activeTextColor,
        'inactive_bg_color': inactiveBgColor,
        'inactive_text_color': inactiveTextColor,
        'border_radius': borderRadius,
        'border_color': borderColor,
        'border_width': borderWidth,
        'separate_home_and_upcoming': separateHomeAndUpcoming,
        'home_override': homeOverride.toJson(),
        'upcoming_override': upcomingOverride.toJson(),
      };
}

@immutable
class SettingsScreenStyleConfig {
  final bool useCustomOverride;
  final String cardBgColor;
  final String cardBorderColor;
  final double cardBorderWidth;
  final double cardBorderRadius;
  final String iconContainerColor;
  final String iconAccentColor;
  final String headerGradientStart;
  final String headerGradientEnd;

  const SettingsScreenStyleConfig({
    required this.useCustomOverride,
    required this.cardBgColor,
    required this.cardBorderColor,
    required this.cardBorderWidth,
    required this.cardBorderRadius,
    required this.iconContainerColor,
    required this.iconAccentColor,
    required this.headerGradientStart,
    required this.headerGradientEnd,
  });

  const SettingsScreenStyleConfig.defaults()
      : useCustomOverride = false,
        cardBgColor = '#272727',
        cardBorderColor = '#333333',
        cardBorderWidth = 1.0,
        cardBorderRadius = 16.0,
        iconContainerColor = '#1E1E1E',
        iconAccentColor = '#C8FF00',
        headerGradientStart = '#C8FF00',
        headerGradientEnd = '#00E5FF';

  factory SettingsScreenStyleConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const SettingsScreenStyleConfig.defaults();
    return SettingsScreenStyleConfig(
      useCustomOverride: json['use_custom_override'] as bool? ?? false,
      cardBgColor: json['card_bg_color'] as String? ?? '#272727',
      cardBorderColor: json['card_border_color'] as String? ?? '#333333',
      cardBorderWidth: (json['card_border_width'] as num?)?.toDouble() ?? 1.0,
      cardBorderRadius: (json['card_border_radius'] as num?)?.toDouble() ?? 16.0,
      iconContainerColor: json['icon_container_color'] as String? ?? '#1E1E1E',
      iconAccentColor: json['icon_accent_color'] as String? ?? '#C8FF00',
      headerGradientStart: json['header_gradient_start'] as String? ?? '#C8FF00',
      headerGradientEnd: json['header_gradient_end'] as String? ?? '#00E5FF',
    );
  }

  Map<String, dynamic> toJson() => {
        'use_custom_override': useCustomOverride,
        'card_bg_color': cardBgColor,
        'card_border_color': cardBorderColor,
        'card_border_width': cardBorderWidth,
        'card_border_radius': cardBorderRadius,
        'icon_container_color': iconContainerColor,
        'icon_accent_color': iconAccentColor,
        'header_gradient_start': headerGradientStart,
        'header_gradient_end': headerGradientEnd,
      };
}

