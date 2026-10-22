'use client';

import React, { useState, useEffect, useMemo } from 'react';
import { createAdminSupabaseClient } from '../utils/supabase';
import {
  Palette, Tv, Layers, Layout, Compass, Search, PlayCircle,
  MessageCircle, AlertOctagon, CheckCircle2, RefreshCw, Undo2, Save,
  ArrowUp, ArrowDown, Plus, Trash2, ShieldAlert, Sparkles,
  Check, Sliders, Monitor, SlidersHorizontal, Settings2, Heart, Radio, Activity,
  RotateCcw, Flame, Link2, Unlink
} from 'lucide-react';

interface AppUiManagerProps {
  adminToken: string;
  onRefreshStats?: () => void;
}

// ─── Default Fallback Baseline ─────────────────────────────────────
const DEFAULT_UI_CONFIG = {
  theme: {
    preset: 'volt',
    primary_color: '#C8FF00',
    surface_color: '#0F0F0F',
    card_color: '#272727',
  },
  channels_tab: {
    show_tab_icons: true,
    show_tab_counts: true,
    show_trending_tab: true,
    show_favorite_tab: true,
    auto_hide_favorite_tab_when_empty: true,
    show_all_tab: true,
    channel_grid_columns: 3,
    card_layout_mode: 'compact',
    show_quality_badge: true,
    show_card_logos: true,
    show_card_names: true,
    show_card_favorites: true,
  },
  categories_screen: {
    show_category_emblems: true,
    show_category_channel_counts: true,
    category_grid_columns: 2,
    show_category_search: true,
    show_category_favorites: true,
  },
  home_screen: {
    section_order: ['hero', 'trending', 'matches', 'recent', 'announcements'],
    show_hero_banner: true,
    show_trending_section: true,
    show_todays_matches: true,
    show_recently_watched: true,
    show_announcements: true,
    hero_banner_autoplay_speed: 5,
  },
  promo_banner: {
    enabled: false,
    position_index: 6,
    title: 'Join Official VIP Channel',
    subtitle: 'Get instant live match updates & HD backups',
    badge_text: 'VIP',
    image_url: '',
    action_url: 'https://t.me/goplay_official',
  },
  tv_experience: {
    default_start_screen: 'home',
    focus_scale: 1.08,
    enable_focus_glow: true,
  },
  navigation_branding: {
    brand_wordmark: 'GOPLAY',
    enabled_tabs: ['home', 'categories', 'channels', 'upcoming', 'settings'],
    tab_order: ['home', 'categories', 'channels', 'upcoming', 'settings'],
  },
  search_config: {
    popular_tags: [
      { label: '⚽ Football', query: 'Football' },
      { label: '🏏 Cricket', query: 'Cricket' },
      { label: '🔥 Live', query: 'Live' },
      { label: '🍿 Movies', query: 'Movies' },
      { label: '📺 Sports', query: 'Sports' },
      { label: '🌐 News', query: 'News' },
      { label: '🎬 Entertainment', query: 'Entertainment' },
      { label: '🎵 Music', query: 'Music' },
    ],
  },
  sports_cards: {
    show_live_pulse: true,
    show_countdown_timer: true,
    show_sport_filter_chips: true,
  },
  player_defaults: {
    default_buffer_mode: 'Balanced',
    default_aspect_ratio: '16:9 (Fit)',
    auto_retry_on_error: true,
    enable_pip: true,
  },
  stream_reporting: {
    enabled: true,
    report_url: 'https://t.me/goplay_support_bot',
  },
  community_links: {
    telegram_url: 'https://t.me/goplay_official',
    discord_url: '',
    whatsapp_url: '',
    website_url: 'https://goplay.tv',
  },
  ota_updates: {
    latest_version: '2.2.0',
    min_version: '2.0.0',
    apk_url: 'https://cdn.ntechbd.app/goplay-latest.apk',
    release_notes: 'UI customization, performance optimizations and enhanced streaming reliability.',
  },
  broadcasts: {
    is_maintenance_enabled: false,
    maintenance_title: 'Under Scheduled Maintenance',
    maintenance_message: 'We are upgrading our streaming servers. Live TV will be back online shortly.',
    is_popup_enabled: false,
    popup_id: 'popup_v1',
    popup_title: 'Welcome to GoPlay TV!',
    popup_message: 'Enjoy hundreds of HD live channels and sports matches directly on your device.',
    popup_image_url: '',
    popup_action_label: 'Explore Channels',
    popup_action_url: '',
  },
  component_styles: {
    event_card: {
      use_custom_override: false,
      background_color: '#121212',
      border_color: '#272727',
      border_width: 1.0,
      border_radius: 14.0,
      live_badge_color: '#FF2B2B',
      elevation: 0.0,
      enable_glow: true,
      hot_badge: {
        enabled: true,
        text: 'HOT',
        bg_color: '#C8FF00',
        text_color: '#0F0F0F',
        radius_top_left: 14.0,
        radius_top_right: 0.0,
        radius_bottom_left: 0.0,
        radius_bottom_right: 11.0,
        is_radius_linked: false,
        position: 'bottom_right' as 'bottom_right' | 'top_right' | 'top_left' | 'bottom_left',
      },
    },
    channel_card: {
      use_custom_override: false,
      background_color: '#272727',
      border_color: '#333333',
      border_width: 1.0,
      border_radius: 14.0,
      quality_badge_color: '#C8FF00',
      elevation: 0.0,
    },
    category_chips: {
      use_custom_override: false,
      active_bg_color: '#C8FF00',
      active_text_color: '#0F0F0F',
      inactive_bg_color: '#272727',
      inactive_text_color: '#FFFFFF',
      border_radius: 20.0,
      border_color: 'transparent',
      border_width: 0.0,
      separate_home_and_upcoming: false,
      home_override: {
        active_bg_color: '#C8FF00',
        active_text_color: '#0F0F0F',
        inactive_bg_color: '#272727',
        inactive_text_color: '#FFFFFF',
        border_radius: 8.0,
        border_color: 'transparent',
        border_width: 0.0,
      },
      upcoming_override: {
        active_bg_color: '#C8FF00',
        active_text_color: '#0F0F0F',
        inactive_bg_color: '#272727',
        inactive_text_color: '#FFFFFF',
        border_radius: 20.0,
        border_color: 'transparent',
        border_width: 0.0,
      },
    },
    settings_screen: {
      use_custom_override: false,
      card_bg_color: '#272727',
      card_border_color: '#333333',
      card_border_width: 1.0,
      card_border_radius: 16.0,
      icon_container_color: '#1E1E1E',
      icon_accent_color: '#C8FF00',
      header_gradient_start: '#C8FF00',
      header_gradient_end: '#00E5FF',
    },
  },
};

type ActiveDomain =
  | 'theme'
  | 'components'
  | 'channels'
  | 'categories'
  | 'home'
  | 'navigation'
  | 'search'
  | 'player'
  | 'community'
  | 'broadcasts';

const THEME_PRESETS = [
  { id: 'volt', name: 'GoPlay Volt (Default)', primary: '#C8FF00', surface: '#0F0F0F', card: '#272727' },
  { id: 'ocean', name: 'Cyber Ocean', primary: '#00D2FF', surface: '#0A1118', card: '#142230' },
  { id: 'crimson', name: 'Neon Crimson', primary: '#FF3366', surface: '#120A0D', card: '#23141B' },
  { id: 'emerald', name: 'Nordic Emerald', primary: '#10B981', surface: '#0A1510', card: '#142820' },
  { id: 'amber', name: 'Sunset Amber', primary: '#FF9900', surface: '#140E0A', card: '#291C14' },
];

export default function AppUiManager({ adminToken, onRefreshStats }: AppUiManagerProps) {
  const [activeDomain, setActiveDomain] = useState<ActiveDomain>('theme');
  const [activeComponentTab, setActiveComponentTab] = useState<'event_card' | 'channel_card' | 'category_chips' | 'settings_screen'>('event_card');
  const [config, setConfig] = useState<typeof DEFAULT_UI_CONFIG>(DEFAULT_UI_CONFIG);
  const [initialConfig, setInitialConfig] = useState<typeof DEFAULT_UI_CONFIG>(DEFAULT_UI_CONFIG);
  const [currentVersion, setCurrentVersion] = useState<number>(1);
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);
  const [showResetModal, setShowResetModal] = useState(false);
  const [notification, setNotification] = useState<{ type: 'success' | 'error'; message: string } | null>(null);

  // New tag draft in search
  const [newTagLabel, setNewTagLabel] = useState('');
  const [newTagQuery, setNewTagQuery] = useState('');

  // Check if draft has unsaved edits
  const isDirty = useMemo(() => {
    return JSON.stringify(config) !== JSON.stringify(initialConfig);
  }, [config, initialConfig]);

  // Fetch from Supabase
  useEffect(() => {
    let isCancelled = false;

    const fetchConfig = async () => {
      try {
        const supabase = createAdminSupabaseClient(adminToken);
        const { data, error } = await supabase
          .from('app_settings')
          .select('id, ui_config, ui_config_version')
          .eq('id', 1)
          .single();

        if (error) throw error;

        if (data && !isCancelled) {
          setCurrentVersion(data.ui_config_version || 1);
          const merged = {
            ...DEFAULT_UI_CONFIG,
            ...(data.ui_config || {}),
            theme: { ...DEFAULT_UI_CONFIG.theme, ...(data.ui_config?.theme || {}) },
            channels_tab: { ...DEFAULT_UI_CONFIG.channels_tab, ...(data.ui_config?.channels_tab || {}) },
            categories_screen: { ...DEFAULT_UI_CONFIG.categories_screen, ...(data.ui_config?.categories_screen || {}) },
            home_screen: { ...DEFAULT_UI_CONFIG.home_screen, ...(data.ui_config?.home_screen || {}) },
            promo_banner: { ...DEFAULT_UI_CONFIG.promo_banner, ...(data.ui_config?.promo_banner || {}) },
            tv_experience: { ...DEFAULT_UI_CONFIG.tv_experience, ...(data.ui_config?.tv_experience || {}) },
            navigation_branding: { ...DEFAULT_UI_CONFIG.navigation_branding, ...(data.ui_config?.navigation_branding || {}) },
            search_config: { ...DEFAULT_UI_CONFIG.search_config, ...(data.ui_config?.search_config || {}) },
            sports_cards: { ...DEFAULT_UI_CONFIG.sports_cards, ...(data.ui_config?.sports_cards || {}) },
            player_defaults: { ...DEFAULT_UI_CONFIG.player_defaults, ...(data.ui_config?.player_defaults || {}) },
            stream_reporting: { ...DEFAULT_UI_CONFIG.stream_reporting, ...(data.ui_config?.stream_reporting || {}) },
            community_links: { ...DEFAULT_UI_CONFIG.community_links, ...(data.ui_config?.community_links || {}) },
            ota_updates: { ...DEFAULT_UI_CONFIG.ota_updates, ...(data.ui_config?.ota_updates || {}) },
            broadcasts: { ...DEFAULT_UI_CONFIG.broadcasts, ...(data.ui_config?.broadcasts || {}) },
            component_styles: {
              ...DEFAULT_UI_CONFIG.component_styles,
              ...(data.ui_config?.component_styles || {}),
              event_card: {
                ...DEFAULT_UI_CONFIG.component_styles.event_card,
                ...(data.ui_config?.component_styles?.event_card || {}),
                hot_badge: {
                  ...DEFAULT_UI_CONFIG.component_styles.event_card.hot_badge,
                  ...(data.ui_config?.component_styles?.event_card?.hot_badge || {}),
                },
              },
              channel_card: {
                ...DEFAULT_UI_CONFIG.component_styles.channel_card,
                ...(data.ui_config?.component_styles?.channel_card || {}),
              },
              category_chips: {
                ...DEFAULT_UI_CONFIG.component_styles.category_chips,
                ...(data.ui_config?.component_styles?.category_chips || {}),
                home_override: {
                  ...DEFAULT_UI_CONFIG.component_styles.category_chips.home_override,
                  ...(data.ui_config?.component_styles?.category_chips?.home_override || {}),
                },
                upcoming_override: {
                  ...DEFAULT_UI_CONFIG.component_styles.category_chips.upcoming_override,
                  ...(data.ui_config?.component_styles?.category_chips?.upcoming_override || {}),
                },
              },
              settings_screen: {
                ...DEFAULT_UI_CONFIG.component_styles.settings_screen,
                ...(data.ui_config?.component_styles?.settings_screen || {}),
              },
            },
          };
          setConfig(merged);
          setInitialConfig(merged);
        }
      } catch (err: unknown) {
        if (!isCancelled) {
          const e = err as Error;
          console.error('Failed to load ui_config:', e);
          setNotification({ type: 'error', message: e?.message || 'Could not load UI settings' });
        }
      } finally {
        if (!isCancelled) {
          setIsLoading(false);
        }
      }
    };

    fetchConfig();

    return () => {
      isCancelled = true;
    };
  }, [adminToken]);

  // Save to Supabase and increment version
  const handleSaveAndPublish = async () => {
    setIsSaving(true);
    setNotification(null);
    try {
      const supabase = createAdminSupabaseClient(adminToken);
      const nextVersion = (currentVersion || 1) + 1;

      const { error } = await supabase
        .from('app_settings')
        .update({
          ui_config: config,
          ui_config_version: nextVersion,
          updated_at: new Date().toISOString(),
        })
        .eq('id', 1);

      if (error) throw error;

      setCurrentVersion(nextVersion);
      setInitialConfig(config);
      setNotification({
        type: 'success',
        message: `Published successfully! App UI bumped to v${nextVersion}. Client apps will sync automatically.`,
      });
      if (onRefreshStats) onRefreshStats();
    } catch (err: unknown) {
      const e = err as Error;
      console.error('Failed to save UI config:', e);
      setNotification({ type: 'error', message: e?.message || 'Failed to save UI settings' });
    } finally {
      setIsSaving(false);
    }
  };

  const handleDiscard = () => {
    setConfig(initialConfig);
    setNotification({ type: 'success', message: 'Reverted all unsaved changes to active DB state.' });
  };

  // Reset entire Studio configuration to factory defaults
  const handleResetAllToDefaults = () => {
    setConfig(JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG)));
    setNotification({
      type: 'success',
      message: 'All settings reset to system defaults (Volt Theme, baseline components). Click "Save & Publish Changes" to push to all mobile apps.',
    });
  };

  // Reset only the currently active domain/screen to defaults
  const handleResetCurrentDomain = () => {
    if (activeDomain === 'theme') {
      updateDomain('theme', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.theme)));
      setNotification({ type: 'success', message: 'Theme & Palette reset to GoPlay Volt default (#C8FF00, #0F0F0F, #272727).' });
    } else if (activeDomain === 'components') {
      updateComponentStyle(activeComponentTab, () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.component_styles[activeComponentTab])));
      setNotification({ type: 'success', message: `Component "${activeComponentTab.replace('_', ' ')}" reset to factory defaults.` });
    } else if (activeDomain === 'channels') {
      updateDomain('channels_tab', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.channels_tab)));
      setNotification({ type: 'success', message: 'Channels Screen settings reset to default.' });
    } else if (activeDomain === 'categories') {
      updateDomain('categories_screen', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.categories_screen)));
      setNotification({ type: 'success', message: 'Categories Screen settings reset to default.' });
    } else if (activeDomain === 'home') {
      updateDomain('home_screen', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.home_screen)));
      updateDomain('promo_banner', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.promo_banner)));
      setNotification({ type: 'success', message: 'Home Sections & Promotional Banner reset to default.' });
    } else if (activeDomain === 'navigation') {
      updateDomain('navigation_branding', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.navigation_branding)));
      setNotification({ type: 'success', message: 'Navigation & Branding reset to default.' });
    } else if (activeDomain === 'search') {
      updateDomain('search_config', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.search_config)));
      updateDomain('sports_cards', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.sports_cards)));
      setNotification({ type: 'success', message: 'Search & Sports settings reset to default.' });
    } else if (activeDomain === 'player') {
      updateDomain('player_defaults', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.player_defaults)));
      updateDomain('tv_experience', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.tv_experience)));
      setNotification({ type: 'success', message: 'Player Engine & Android TV defaults reset to default.' });
    } else if (activeDomain === 'community') {
      updateDomain('community_links', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.community_links)));
      updateDomain('stream_reporting', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.stream_reporting)));
      setNotification({ type: 'success', message: 'Community Links & Reporting reset to default.' });
    } else if (activeDomain === 'broadcasts') {
      updateDomain('broadcasts', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.broadcasts)));
      setNotification({ type: 'success', message: 'Emergency Mode settings reset to default.' });
    }
  };

  // ─── Helpers for Modifying Sub-domain Objects ───────────────────
  const updateDomain = <K extends keyof typeof DEFAULT_UI_CONFIG>(
    key: K,
    updater: (prev: (typeof DEFAULT_UI_CONFIG)[K]) => (typeof DEFAULT_UI_CONFIG)[K]
  ) => {
    setConfig((prev) => ({
      ...prev,
      [key]: updater(prev[key]),
    }));
  };

  const updateComponentStyle = <K extends keyof typeof DEFAULT_UI_CONFIG.component_styles>(
    compKey: K,
    updater: (prev: (typeof DEFAULT_UI_CONFIG.component_styles)[K]) => (typeof DEFAULT_UI_CONFIG.component_styles)[K]
  ) => {
    setConfig((prev) => ({
      ...prev,
      component_styles: {
        ...prev.component_styles,
        [compKey]: updater(prev.component_styles[compKey]),
      },
    }));
  };

  const updateHotBadge = (
    updater: (
      prev: typeof DEFAULT_UI_CONFIG.component_styles.event_card.hot_badge
    ) => typeof DEFAULT_UI_CONFIG.component_styles.event_card.hot_badge
  ) => {
    updateComponentStyle('event_card', (s) => ({
      ...s,
      hot_badge: updater(s.hot_badge || DEFAULT_UI_CONFIG.component_styles.event_card.hot_badge),
    }));
  };

  // ─── Navigation Domains ─────────────────────────────────────────
  const navDomains: { id: ActiveDomain; label: string; icon: React.ComponentType<{ className?: string }>; countNotice?: string }[] = [
    { id: 'theme', label: 'Theme & Palette', icon: Palette },
    { id: 'components', label: 'Component Studio', icon: SlidersHorizontal, countNotice: 'STUDIO' },
    { id: 'channels', label: 'Channels Screen', icon: Tv },
    { id: 'categories', label: 'Categories Screen', icon: Layers },
    { id: 'home', label: 'Home Sections', icon: Layout },
    { id: 'navigation', label: 'Navigation & Branding', icon: Compass },
    { id: 'search', label: 'Search & Sports', icon: Search },
    { id: 'player', label: 'Player Engine', icon: PlayCircle },
    { id: 'community', label: 'Community & OTA', icon: MessageCircle },
    { id: 'broadcasts', label: 'Emergency Mode', icon: AlertOctagon },
  ];

  if (isLoading) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[600px] gap-4">
        <div className="w-10 h-10 border-4 border-lime-400 border-t-transparent rounded-full animate-spin" />
        <p className="text-zinc-400 text-sm font-medium">Fetching dynamic UI configuration from Supabase...</p>
      </div>
    );
  }

  return (
    <div className="flex flex-col h-[calc(100vh-65px)] bg-zinc-950 text-zinc-100 overflow-hidden">
      {/* ── Top Command Bar ──────────────────────────────────────── */}
      <header className="flex-shrink-0 flex items-center justify-between px-6 py-3.5 bg-zinc-900 border-b border-zinc-800/80 z-20">
        <div className="flex items-center gap-4">
          <div className="flex items-center gap-2.5">
            <div className="w-9 h-9 rounded-xl bg-gradient-to-tr from-lime-400 to-emerald-500 flex items-center justify-center text-zinc-950 font-black shadow-md shadow-lime-400/20">
              <Sliders className="w-5 h-5" />
            </div>
            <div>
              <h1 className="text-base font-bold text-white leading-tight flex items-center gap-2">
                App UI Studio
                <span className="text-[10px] font-mono uppercase px-2 py-0.5 rounded-full bg-zinc-800 text-lime-400 border border-lime-400/30">
                  Live v{currentVersion}
                </span>
              </h1>
              <p className="text-xs text-zinc-400">Dynamic Flutter Mobile & Android TV Interface Control</p>
            </div>
          </div>

          {/* Status Indicator */}
          <div className="hidden md:flex items-center gap-2 px-3 py-1 rounded-full text-xs font-medium bg-zinc-800/70 border border-zinc-700/60">
            {isDirty ? (
              <span className="flex items-center gap-1.5 text-amber-400 font-medium">
                <span className="w-2 h-2 rounded-full bg-amber-400 animate-pulse" />
                Unsaved Draft
              </span>
            ) : (
              <span className="flex items-center gap-1.5 text-emerald-400 font-medium">
                <span className="w-2 h-2 rounded-full bg-emerald-400" />
                Synced with Mobile Apps
              </span>
            )}
          </div>
        </div>

        {/* Action Controls */}
        <div className="flex items-center gap-3">
          <button
            onClick={handleDiscard}
            disabled={!isDirty || isSaving}
            className={`px-3.5 py-2 rounded-xl text-xs font-semibold flex items-center gap-2 transition-all cursor-pointer ${
              isDirty
                ? 'bg-zinc-800 hover:bg-zinc-700 text-zinc-300 border border-zinc-700'
                : 'opacity-40 cursor-not-allowed bg-zinc-900 text-zinc-600 border border-zinc-800'
            }`}
          >
            <Undo2 className="w-3.5 h-3.5" />
            Discard Draft
          </button>

          <button
            type="button"
            onClick={() => setShowResetModal(true)}
            disabled={isSaving}
            className="px-3.5 py-2 rounded-xl text-xs font-semibold flex items-center gap-2 transition-all cursor-pointer bg-zinc-800 hover:bg-rose-500/15 hover:text-rose-400 hover:border-rose-500/30 text-zinc-300 border border-zinc-700 active:scale-95"
            title="Reset settings to factory defaults"
          >
            <RotateCcw className="w-3.5 h-3.5 text-rose-400" />
            Reset Defaults
          </button>

          <button
            onClick={handleSaveAndPublish}
            disabled={isSaving}
            className="px-5 py-2 rounded-xl text-xs font-bold bg-lime-400 hover:bg-lime-300 text-zinc-950 shadow-lg shadow-lime-400/25 transition-all flex items-center gap-2 cursor-pointer active:scale-95 disabled:opacity-50"
          >
            {isSaving ? (
              <>
                <RefreshCw className="w-3.5 h-3.5 animate-spin" />
                Publishing...
              </>
            ) : (
              <>
                <Save className="w-3.5 h-3.5" />
                Save & Publish Changes
              </>
            )}
          </button>
        </div>
      </header>

      {/* Toast Notification Banner */}
      {notification && (
        <div
          className={`flex-shrink-0 px-6 py-2.5 text-xs font-medium flex items-center justify-between border-b ${
            notification.type === 'success'
              ? 'bg-emerald-950/80 border-emerald-800/60 text-emerald-200'
              : 'bg-red-950/80 border-red-800/60 text-red-200'
          }`}
        >
          <div className="flex items-center gap-2">
            {notification.type === 'success' ? (
              <CheckCircle2 className="w-4 h-4 text-emerald-400" />
            ) : (
              <ShieldAlert className="w-4 h-4 text-red-400" />
            )}
            <span>{notification.message}</span>
          </div>
          <button
            onClick={() => setNotification(null)}
            className="text-zinc-400 hover:text-white text-xs font-bold cursor-pointer"
          >
            Dismiss
          </button>
        </div>
      )}

      {/* ── Master-Detail Main Layout ────────────────────────────── */}
      <div className="flex-1 flex overflow-hidden">
        {/* Left Vertical Navigation Rail (~260px) */}
        <aside className="w-64 flex-shrink-0 bg-zinc-900/90 border-r border-zinc-800/80 p-3 overflow-y-auto space-y-1">
          <p className="px-3 py-2 text-[10px] font-bold uppercase tracking-wider text-zinc-500">
            Control Domains
          </p>
          {navDomains.map((domain) => {
            const isActive = activeDomain === domain.id;
            const Icon = domain.icon;
            return (
              <button
                key={domain.id}
                onClick={() => setActiveDomain(domain.id)}
                className={`w-full flex items-center justify-between px-3.5 py-3 rounded-xl text-xs font-semibold transition-all cursor-pointer text-left ${
                  isActive
                    ? 'bg-lime-400/15 text-lime-400 border border-lime-400/30 shadow-sm'
                    : 'text-zinc-400 hover:bg-zinc-800/60 hover:text-zinc-200 border border-transparent'
                }`}
              >
                <div className="flex items-center gap-3">
                  <Icon className={`w-4 h-4 ${isActive ? 'text-lime-400' : 'text-zinc-400'}`} />
                  <span>{domain.label}</span>
                </div>
                <div className="flex items-center gap-1.5">
                  {domain.countNotice && (
                    <span className="text-[9px] font-extrabold uppercase px-1.5 py-0.5 rounded bg-lime-400 text-zinc-950 shadow-sm">
                      {domain.countNotice}
                    </span>
                  )}
                  {domain.id === 'broadcasts' && config.broadcasts.is_maintenance_enabled && (
                    <span className="w-2 h-2 rounded-full bg-red-500 animate-pulse" />
                  )}
                </div>
              </button>
            );
          })}

          <div className="pt-6 px-3">
            <div className="p-3.5 rounded-xl bg-zinc-950/80 border border-zinc-800/70 text-[11px] text-zinc-400 space-y-1.5">
              <div className="flex items-center gap-1.5 text-zinc-300 font-semibold">
                <Sparkles className="w-3.5 h-3.5 text-lime-400" />
                <span>Zero-Latency Sync</span>
              </div>
              <p className="leading-relaxed text-[11px] text-zinc-500">
                Changes saved here propagate to the client app Hive cache upon its next query cycle.
              </p>
            </div>
          </div>
        </aside>

        {/* Right Expansive Workspace Detail Area */}
        <main className="flex-1 overflow-y-auto p-6 lg:p-8 space-y-6 max-w-5xl">
          {/* ─────────────────────────────────────────────────────────── */}
          {/* DOMAIN 1: THEME & PALETTE                                  */}
          {/* ─────────────────────────────────────────────────────────── */}
          {activeDomain === 'theme' && (
            <div className="space-y-6">
              <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                <div>
                  <h2 className="text-xl font-bold text-white flex items-center gap-2">
                    <Palette className="w-5 h-5 text-lime-400" />
                    Smart Theming Engine
                  </h2>
                  <p className="text-xs text-zinc-400 mt-1">
                    Change the color scheme and visual vibe across both Android phones and Smart TVs.
                  </p>
                </div>
                <button
                  type="button"
                  onClick={() => {
                    updateDomain('theme', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.theme)));
                    setNotification({ type: 'success', message: 'Theme & Palette reset to GoPlay Volt default (#C8FF00, #0F0F0F, #272727).' });
                  }}
                  className="inline-flex items-center gap-2 px-3.5 py-2 rounded-xl bg-zinc-800/80 hover:bg-zinc-700 text-xs font-semibold text-zinc-300 hover:text-white border border-zinc-700/70 transition-all cursor-pointer self-start sm:self-auto active:scale-95"
                >
                  <RotateCcw className="w-3.5 h-3.5 text-lime-400" />
                  Reset Palette Defaults
                </button>
              </div>

              {/* Theme Presets */}
              <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-3">
                <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                  Curated Presets
                </h3>
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
                  {THEME_PRESETS.map((p) => {
                    const isSelected =
                      config.theme.primary_color.toUpperCase() === p.primary.toUpperCase();
                    return (
                      <button
                        key={p.id}
                        onClick={() => {
                          updateDomain('theme', (t) => ({
                            ...t,
                            preset: p.id,
                            primary_color: p.primary,
                            surface_color: p.surface,
                            card_color: p.card,
                          }));
                        }}
                        className={`p-3.5 rounded-xl border text-left transition-all cursor-pointer flex items-center justify-between ${
                          isSelected
                            ? 'bg-zinc-800 border-lime-400/60 shadow-md shadow-lime-400/10'
                            : 'bg-zinc-950/60 border-zinc-800/80 hover:bg-zinc-800/40 hover:border-zinc-700'
                        }`}
                      >
                        <div className="flex items-center gap-3">
                          <div
                            className="w-7 h-7 rounded-lg shadow-sm border border-white/20"
                            style={{ backgroundColor: p.primary }}
                          />
                          <div>
                            <span className="text-xs font-bold text-white block">{p.name}</span>
                            <span className="text-[10px] text-zinc-500 font-mono">{p.primary}</span>
                          </div>
                        </div>
                        {isSelected && <Check className="w-4 h-4 text-lime-400" />}
                      </button>
                    );
                  })}
                </div>
              </div>

              {/* Hex Color Customizer */}
              <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4">
                <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                  Custom Palette Colors
                </h3>
                <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
                  {/* Primary Accent */}
                  <div className="space-y-2">
                    <label className="text-xs font-semibold text-zinc-300 block">
                      Primary Accent Color
                    </label>
                    <div className="flex items-center gap-2">
                      <input
                        type="color"
                        value={config.theme.primary_color}
                        onChange={(e) =>
                          updateDomain('theme', (t) => ({ ...t, primary_color: e.target.value }))
                        }
                        className="w-10 h-10 rounded-lg cursor-pointer bg-transparent border-0"
                      />
                      <input
                        type="text"
                        value={config.theme.primary_color}
                        onChange={(e) =>
                          updateDomain('theme', (t) => ({ ...t, primary_color: e.target.value }))
                        }
                        className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs font-mono text-zinc-200 uppercase"
                      />
                    </div>
                  </div>

                  {/* Canvas Surface */}
                  <div className="space-y-2">
                    <label className="text-xs font-semibold text-zinc-300 block">
                      Background Surface (Canvas)
                    </label>
                    <div className="flex items-center gap-2">
                      <input
                        type="color"
                        value={config.theme.surface_color}
                        onChange={(e) =>
                          updateDomain('theme', (t) => ({ ...t, surface_color: e.target.value }))
                        }
                        className="w-10 h-10 rounded-lg cursor-pointer bg-transparent border-0"
                      />
                      <input
                        type="text"
                        value={config.theme.surface_color}
                        onChange={(e) =>
                          updateDomain('theme', (t) => ({ ...t, surface_color: e.target.value }))
                        }
                        className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs font-mono text-zinc-200 uppercase"
                      />
                    </div>
                  </div>

                  {/* Card Surface */}
                  <div className="space-y-2">
                    <div className="flex items-center justify-between">
                      <label className="text-xs font-semibold text-zinc-300 block">
                        Card Container Color
                      </label>
                      <span className="text-[10px] text-lime-400 font-mono font-bold">
                        Universal Master Fallback
                      </span>
                    </div>
                    <div className="flex items-center gap-2">
                      <input
                        type="color"
                        value={config.theme.card_color}
                        onChange={(e) =>
                          updateDomain('theme', (t) => ({ ...t, card_color: e.target.value }))
                        }
                        className="w-10 h-10 rounded-lg cursor-pointer bg-transparent border-0"
                      />
                      <input
                        type="text"
                        value={config.theme.card_color}
                        onChange={(e) =>
                          updateDomain('theme', (t) => ({ ...t, card_color: e.target.value }))
                        }
                        className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs font-mono text-zinc-200 uppercase"
                      />
                    </div>
                    <p className="text-[11px] text-zinc-400">
                      Default color for all cards (Events, Channels, Chips, Settings). Customize any component individually in{' '}
                      <button
                        type="button"
                        onClick={() => setActiveDomain('components')}
                        className="text-lime-400 underline font-semibold hover:text-lime-300 cursor-pointer"
                      >
                        Component Studio
                      </button>
                      .
                    </p>
                  </div>
                </div>
              </div>

              {/* Live Specimen Preview */}
              <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-3">
                <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                  Live Preview Specimen
                </h3>
                <div
                  className="p-6 rounded-xl border border-zinc-700/50 flex flex-col gap-4"
                  style={{ backgroundColor: config.theme.surface_color }}
                >
                  <div className="flex items-center justify-between">
                    <span className="font-extrabold tracking-wider text-sm" style={{ color: '#FFFFFF' }}>
                      {config.navigation_branding.brand_wordmark || 'GOPLAY'}
                    </span>
                    <span
                      className="px-2.5 py-1 rounded-md text-[11px] font-bold"
                      style={{
                        backgroundColor: config.theme.primary_color,
                        color: '#000000',
                      }}
                    >
                      LIVE MATCH
                    </span>
                  </div>

                  <div
                    className="p-4 rounded-xl border border-white/10 flex items-center justify-between"
                    style={{ backgroundColor: config.theme.card_color }}
                  >
                    <div>
                      <div className="text-xs font-bold text-white">Sky Sports Main Event FHD</div>
                      <div className="text-[11px] text-zinc-400">Premier League Live • 1080p60</div>
                    </div>
                    <button
                      className="px-3.5 py-1.5 rounded-lg text-xs font-bold"
                      style={{
                        backgroundColor: config.theme.primary_color,
                        color: '#000000',
                      }}
                    >
                      Watch
                    </button>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* ─────────────────────────────────────────────────────────── */}
          {/* DOMAIN: COMPONENT STYLING STUDIO                           */}
          {/* ─────────────────────────────────────────────────────────── */}
          {activeDomain === 'components' && (
            <div className="space-y-6">
              <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                <div>
                  <h2 className="text-xl font-bold text-white flex items-center gap-2">
                    <SlidersHorizontal className="w-5 h-5 text-lime-400" />
                    Component Styling Studio
                  </h2>
                  <p className="text-xs text-zinc-400 mt-1">
                    Granular styling engines for Event Cards, Channel Cards, Category Filter Buttons, and Settings Page.
                  </p>
                </div>
                <div className="flex items-center gap-3">
                  <button
                    type="button"
                    onClick={() => {
                      updateComponentStyle(activeComponentTab, () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.component_styles[activeComponentTab])));
                      setNotification({ type: 'success', message: `Component "${activeComponentTab.replace('_', ' ')}" reset to factory defaults.` });
                    }}
                    className="inline-flex items-center gap-2 px-3 py-1.5 rounded-xl bg-zinc-800/80 hover:bg-zinc-700 text-xs font-semibold text-zinc-300 hover:text-white border border-zinc-700/70 transition-all cursor-pointer active:scale-95"
                  >
                    <RotateCcw className="w-3.5 h-3.5 text-lime-400" />
                    Reset Component Defaults
                  </button>
                  <div className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-zinc-900 border border-zinc-800 text-xs text-zinc-400">
                    <span className="text-zinc-500">Universal Card Fallback:</span>
                    <div
                      className="w-4 h-4 rounded border border-white/20"
                      style={{ backgroundColor: config.theme.card_color }}
                    />
                    <span className="font-mono text-zinc-300 font-bold uppercase">{config.theme.card_color}</span>
                  </div>
                </div>
              </div>

              {/* Sub-Navigation Tabs */}
              <div className="flex items-center gap-2 p-1.5 bg-zinc-900 border border-zinc-800 rounded-2xl overflow-x-auto">
                {[
                  { id: 'event_card', label: 'Event Matchup Cards', icon: Activity, count: config.component_styles.event_card.use_custom_override ? 'Active' : 'Inherited' },
                  { id: 'channel_card', label: 'Channel Cards', icon: Tv, count: config.component_styles.channel_card.use_custom_override ? 'Active' : 'Inherited' },
                  { id: 'category_chips', label: 'Category Buttons', icon: Radio, count: config.component_styles.category_chips.use_custom_override ? 'Active' : 'Inherited' },
                  { id: 'settings_screen', label: 'Settings Page UI', icon: Settings2, count: config.component_styles.settings_screen.use_custom_override ? 'Active' : 'Inherited' },
                ].map((tab) => {
                  const isTabActive = activeComponentTab === tab.id;
                  const TabIcon = tab.icon;
                  const isCustom = tab.count === 'Active';
                  return (
                    <button
                      key={tab.id}
                      type="button"
                      onClick={() => setActiveComponentTab(tab.id as typeof activeComponentTab)}
                      className={`flex-1 min-w-[150px] px-3.5 py-2.5 rounded-xl text-xs font-semibold flex items-center justify-between gap-2 transition-all cursor-pointer ${
                        isTabActive
                          ? 'bg-zinc-800 text-white shadow-sm border border-zinc-700'
                          : 'text-zinc-400 hover:text-zinc-200 hover:bg-zinc-800/40 border border-transparent'
                      }`}
                    >
                      <div className="flex items-center gap-2">
                        <TabIcon className={`w-3.5 h-3.5 ${isTabActive ? 'text-lime-400' : 'text-zinc-500'}`} />
                        <span>{tab.label}</span>
                      </div>
                      <span
                        className={`text-[9px] font-extrabold uppercase px-1.5 py-0.5 rounded ${
                          isCustom
                            ? 'bg-lime-400/20 text-lime-400 border border-lime-400/30'
                            : 'bg-zinc-800 text-zinc-500 border border-zinc-700/60'
                        }`}
                      >
                        {tab.count}
                      </span>
                    </button>
                  );
                })}
              </div>

              {/* ── Sub-Tab 1: Event Cards ──────────────────────────── */}
              {activeComponentTab === 'event_card' && (
                <div className="space-y-6">
                  {/* Override Toggle Card */}
                  <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 flex items-center justify-between gap-4">
                    <div>
                      <h3 className="text-sm font-bold text-white flex items-center gap-2">
                        Custom Styling Override
                        {config.component_styles.event_card.use_custom_override ? (
                          <span className="text-[10px] uppercase font-bold text-lime-400 bg-lime-400/10 px-2 py-0.5 rounded-full border border-lime-400/30">
                            Active Override
                          </span>
                        ) : (
                          <span className="text-[10px] uppercase font-bold text-zinc-400 bg-zinc-800 px-2 py-0.5 rounded-full border border-zinc-700">
                            Inheriting Master Card Color ({config.theme.card_color})
                          </span>
                        )}
                      </h3>
                      <p className="text-xs text-zinc-400 mt-1">
                        When enabled, uses a custom container background color. Corner radius, border width, and badge colors configured below are always applied.
                      </p>
                    </div>
                    <label className="relative inline-flex items-center cursor-pointer">
                      <input
                        type="checkbox"
                        checked={config.component_styles.event_card.use_custom_override}
                        onChange={(e) =>
                          updateComponentStyle('event_card', (s) => ({ ...s, use_custom_override: e.target.checked }))
                        }
                        className="sr-only peer"
                      />
                      <div className="w-11 h-6 bg-zinc-800 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-lime-400" />
                    </label>
                  </div>

                  {/* Event Card Controls Grid */}
                  <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-5">
                    <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                      Card Container & Border Properties
                    </h3>
                    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                      {/* Background Color */}
                      <div className="space-y-2">
                        <div className="flex items-center justify-between">
                          <label className="text-xs font-semibold text-zinc-300">Background Color</label>
                          {!config.component_styles.event_card.use_custom_override && (
                            <span className="text-[10px] text-zinc-500 font-mono">Inherited</span>
                          )}
                        </div>
                        <div className="flex items-center gap-2">
                          <input
                            type="color"
                            value={
                              config.component_styles.event_card.use_custom_override
                                ? config.component_styles.event_card.background_color
                                : config.theme.card_color
                            }
                            disabled={!config.component_styles.event_card.use_custom_override}
                            onChange={(e) =>
                              updateComponentStyle('event_card', (s) => ({ ...s, background_color: e.target.value }))
                            }
                            className="w-10 h-10 rounded-lg cursor-pointer bg-transparent border-0 disabled:opacity-40"
                          />
                          <input
                            type="text"
                            value={
                              config.component_styles.event_card.use_custom_override
                                ? config.component_styles.event_card.background_color
                                : config.theme.card_color
                            }
                            disabled={!config.component_styles.event_card.use_custom_override}
                            onChange={(e) =>
                              updateComponentStyle('event_card', (s) => ({ ...s, background_color: e.target.value }))
                            }
                            className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs font-mono text-zinc-200 uppercase disabled:opacity-40"
                          />
                        </div>
                      </div>

                      {/* Border Color */}
                      <div className="space-y-2">
                        <label className="text-xs font-semibold text-zinc-300">Border Color</label>
                        <div className="flex items-center gap-2">
                          <input
                            type="color"
                            value={config.component_styles.event_card.border_color}
                            onChange={(e) =>
                              updateComponentStyle('event_card', (s) => ({ ...s, border_color: e.target.value }))
                            }
                            className="w-10 h-10 rounded-lg cursor-pointer bg-transparent border-0"
                          />
                          <input
                            type="text"
                            value={config.component_styles.event_card.border_color}
                            onChange={(e) =>
                              updateComponentStyle('event_card', (s) => ({ ...s, border_color: e.target.value }))
                            }
                            className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs font-mono text-zinc-200 uppercase"
                          />
                        </div>
                      </div>

                      {/* LIVE Badge Color */}
                      <div className="space-y-2">
                        <label className="text-xs font-semibold text-zinc-300">LIVE Badge Color</label>
                        <div className="flex items-center gap-2">
                          <input
                            type="color"
                            value={config.component_styles.event_card.live_badge_color}
                            onChange={(e) =>
                              updateComponentStyle('event_card', (s) => ({ ...s, live_badge_color: e.target.value }))
                            }
                            className="w-10 h-10 rounded-lg cursor-pointer bg-transparent border-0"
                          />
                          <input
                            type="text"
                            value={config.component_styles.event_card.live_badge_color}
                            onChange={(e) =>
                              updateComponentStyle('event_card', (s) => ({ ...s, live_badge_color: e.target.value }))
                            }
                            className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs font-mono text-zinc-200 uppercase"
                          />
                        </div>
                      </div>
                    </div>

                    {/* Sliders */}
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-2 border-t border-zinc-800">
                      <div className="space-y-2">
                        <div className="flex items-center justify-between">
                          <label className="text-xs font-semibold text-zinc-300">Border Width</label>
                          <span className="text-xs font-mono font-bold text-lime-400">
                            {config.component_styles.event_card.border_width}px
                          </span>
                        </div>
                        <input
                          type="range"
                          min="0"
                          max="4"
                          step="0.5"
                          value={config.component_styles.event_card.border_width}
                          onChange={(e) =>
                            updateComponentStyle('event_card', (s) => ({
                              ...s,
                              border_width: parseFloat(e.target.value),
                            }))
                          }
                          className="w-full accent-lime-400 cursor-pointer"
                        />
                      </div>

                      <div className="space-y-2">
                        <div className="flex items-center justify-between">
                          <label className="text-xs font-semibold text-zinc-300">Corner Radius</label>
                          <span className="text-xs font-mono font-bold text-lime-400">
                            {config.component_styles.event_card.border_radius}px
                          </span>
                        </div>
                        <input
                          type="range"
                          min="4"
                          max="28"
                          step="1"
                          value={config.component_styles.event_card.border_radius}
                          onChange={(e) =>
                            updateComponentStyle('event_card', (s) => ({
                              ...s,
                              border_radius: parseFloat(e.target.value),
                            }))
                          }
                          className="w-full accent-lime-400 cursor-pointer"
                        />
                      </div>
                    </div>

                    {/* Outer Card Glow Effect Toggle */}
                    <div className="pt-3 border-t border-zinc-800 flex items-center justify-between">
                      <div>
                        <span className="text-xs font-semibold text-zinc-200 block">
                          Outer Card Glow Effect
                        </span>
                        <span className="text-[11px] text-zinc-400">
                          Renders a vibrant ambient neon aura box-shadow around live match event cards
                        </span>
                      </div>
                      <label className="relative inline-flex items-center cursor-pointer">
                        <input
                          type="checkbox"
                          checked={config.component_styles.event_card.enable_glow ?? true}
                          onChange={(e) =>
                            updateComponentStyle('event_card', (s) => ({
                              ...s,
                              enable_glow: e.target.checked,
                            }))
                          }
                          className="sr-only peer"
                        />
                        <div className="w-11 h-6 bg-zinc-800 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-lime-400" />
                      </label>
                    </div>
                  </div>

                  {/* ── HOT / Featured Badge Studio ── */}
                  <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4">
                    <div className="flex items-center justify-between pb-3 border-b border-zinc-800">
                      <div className="flex items-center gap-2.5">
                        <div className="w-8 h-8 rounded-lg bg-lime-400/10 border border-lime-400/30 flex items-center justify-center text-lime-400">
                          <Flame className="w-4 h-4" />
                        </div>
                        <div>
                          <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-200">
                            HOT / Featured Badge Studio
                          </h3>
                          <p className="text-[11px] text-zinc-400">
                            Configure tag text, palette, corner placement, and 4-corner radii for featured events
                          </p>
                        </div>
                      </div>
                      <label className="relative inline-flex items-center cursor-pointer">
                        <input
                          type="checkbox"
                          checked={config.component_styles.event_card.hot_badge?.enabled ?? true}
                          onChange={(e) =>
                            updateHotBadge((b) => ({ ...b, enabled: e.target.checked }))
                          }
                          className="sr-only peer"
                        />
                        <div className="w-11 h-6 bg-zinc-800 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-lime-400" />
                      </label>
                    </div>

                    {(config.component_styles.event_card.hot_badge?.enabled ?? true) && (
                      <div className="space-y-4">
                        {/* Label Text & Placement */}
                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                          {/* Badge Label Text */}
                          <div className="space-y-2">
                            <label className="text-xs font-semibold text-zinc-300">Badge Label Text</label>
                            <input
                              type="text"
                              value={config.component_styles.event_card.hot_badge?.text ?? 'HOT'}
                              onChange={(e) =>
                                updateHotBadge((b) => ({ ...b, text: e.target.value }))
                              }
                              placeholder="e.g. HOT, FEATURED, LIVE NOW"
                              className="w-full bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs font-semibold text-zinc-100 placeholder:text-zinc-600 focus:outline-none focus:border-lime-400"
                            />
                          </div>

                          {/* Corner Placement */}
                          <div className="space-y-2">
                            <label className="text-xs font-semibold text-zinc-300">Corner Placement</label>
                            <div className="grid grid-cols-4 gap-1.5 bg-zinc-950 p-1 rounded-lg border border-zinc-700">
                              {[
                                { id: 'bottom_right', label: 'Bottom-R' },
                                { id: 'top_right', label: 'Top-R' },
                                { id: 'top_left', label: 'Top-L' },
                                { id: 'bottom_left', label: 'Bottom-L' },
                              ].map((pos) => {
                                const active =
                                  (config.component_styles.event_card.hot_badge?.position ?? 'bottom_right') === pos.id;
                                return (
                                  <button
                                    key={pos.id}
                                    type="button"
                                    onClick={() =>
                                      updateHotBadge((b) => ({
                                        ...b,
                                        position: pos.id as any,
                                      }))
                                    }
                                    className={`px-2 py-1.5 rounded-md text-[11px] font-semibold transition-all ${
                                      active
                                        ? 'bg-lime-400 text-zinc-950 shadow-sm'
                                        : 'text-zinc-400 hover:text-zinc-200 hover:bg-zinc-800/50'
                                    }`}
                                  >
                                    {pos.label}
                                  </button>
                                );
                              })}
                            </div>
                          </div>
                        </div>

                        {/* Palette Colors */}
                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                          {/* Background Color */}
                          <div className="space-y-2">
                            <label className="text-xs font-semibold text-zinc-300">Badge Background Color</label>
                            <div className="flex items-center gap-2">
                              <input
                                type="color"
                                value={config.component_styles.event_card.hot_badge?.bg_color ?? '#C8FF00'}
                                onChange={(e) =>
                                  updateHotBadge((b) => ({ ...b, bg_color: e.target.value }))
                                }
                                className="w-10 h-10 rounded-lg cursor-pointer bg-transparent border-0"
                              />
                              <input
                                type="text"
                                value={config.component_styles.event_card.hot_badge?.bg_color ?? '#C8FF00'}
                                onChange={(e) =>
                                  updateHotBadge((b) => ({ ...b, bg_color: e.target.value }))
                                }
                                className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs font-mono text-zinc-200 uppercase"
                              />
                            </div>
                          </div>

                          {/* Text Color */}
                          <div className="space-y-2">
                            <label className="text-xs font-semibold text-zinc-300">Badge Text Color</label>
                            <div className="flex items-center gap-2">
                              <input
                                type="color"
                                value={config.component_styles.event_card.hot_badge?.text_color ?? '#0F0F0F'}
                                onChange={(e) =>
                                  updateHotBadge((b) => ({ ...b, text_color: e.target.value }))
                                }
                                className="w-10 h-10 rounded-lg cursor-pointer bg-transparent border-0"
                              />
                              <input
                                type="text"
                                value={config.component_styles.event_card.hot_badge?.text_color ?? '#0F0F0F'}
                                onChange={(e) =>
                                  updateHotBadge((b) => ({ ...b, text_color: e.target.value }))
                                }
                                className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs font-mono text-zinc-200 uppercase"
                              />
                            </div>
                          </div>
                        </div>

                        {/* 4-Corner Radius Control (Figma style) */}
                        <div className="pt-3 border-t border-zinc-800 space-y-3">
                          <div className="flex items-center justify-between">
                            <div className="flex items-center gap-2">
                              <label className="text-xs font-semibold text-zinc-300">
                                Badge Corner Radii Control
                              </label>
                              <span className="text-[10px] text-zinc-400 bg-zinc-800 px-2 py-0.5 rounded">
                                {config.component_styles.event_card.hot_badge?.is_radius_linked
                                  ? 'Uniform (Linked)'
                                  : 'Independent 4-Corners'}
                              </span>
                            </div>

                            {/* Link / Unlink toggle button */}
                            <button
                              type="button"
                              onClick={() => {
                                const currentLinked =
                                  config.component_styles.event_card.hot_badge?.is_radius_linked ?? false;
                                if (!currentLinked) {
                                  // When linking, synchronize all corners to top-left
                                  const uniformVal =
                                    config.component_styles.event_card.hot_badge?.radius_top_left ?? 14.0;
                                  updateHotBadge((b) => ({
                                    ...b,
                                    is_radius_linked: true,
                                    radius_top_left: uniformVal,
                                    radius_top_right: uniformVal,
                                    radius_bottom_left: uniformVal,
                                    radius_bottom_right: uniformVal,
                                  }));
                                } else {
                                  updateHotBadge((b) => ({ ...b, is_radius_linked: false }));
                                }
                              }}
                              className={`flex items-center gap-1.5 px-2.5 py-1 rounded-lg text-xs font-medium border transition-all ${
                                config.component_styles.event_card.hot_badge?.is_radius_linked
                                  ? 'bg-lime-400/10 border-lime-400/40 text-lime-400'
                                  : 'bg-zinc-800 border-zinc-700 text-zinc-400 hover:text-zinc-200'
                              }`}
                              title={
                                config.component_styles.event_card.hot_badge?.is_radius_linked
                                  ? 'Click to adjust individual corners'
                                  : 'Click to link all corners together'
                              }
                            >
                              {config.component_styles.event_card.hot_badge?.is_radius_linked ? (
                                <>
                                  <Link2 className="w-3.5 h-3.5" />
                                  <span>Linked</span>
                                </>
                              ) : (
                                <>
                                  <Unlink className="w-3.5 h-3.5" />
                                  <span>Unlinked</span>
                                </>
                              )}
                            </button>
                          </div>

                          {/* Radius Sliders */}
                          {config.component_styles.event_card.hot_badge?.is_radius_linked ? (
                            // Uniform Slider
                            <div className="space-y-2 bg-zinc-950/60 p-3 rounded-xl border border-zinc-800/80">
                              <div className="flex items-center justify-between">
                                <span className="text-xs text-zinc-400">All Corners Radius</span>
                                <span className="text-xs font-mono font-bold text-lime-400">
                                  {config.component_styles.event_card.hot_badge?.radius_top_left ?? 14}px
                                </span>
                              </div>
                              <input
                                type="range"
                                min="0"
                                max="24"
                                step="1"
                                value={config.component_styles.event_card.hot_badge?.radius_top_left ?? 14}
                                onChange={(e) => {
                                  const val = parseFloat(e.target.value);
                                  updateHotBadge((b) => ({
                                    ...b,
                                    radius_top_left: val,
                                    radius_top_right: val,
                                    radius_bottom_left: val,
                                    radius_bottom_right: val,
                                  }));
                                }}
                                className="w-full accent-lime-400 cursor-pointer"
                              />
                            </div>
                          ) : (
                            // 4 Independent Corner Sliders in 2x2 Grid
                            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 bg-zinc-950/60 p-3.5 rounded-xl border border-zinc-800/80">
                              {/* Top-Left */}
                              <div className="space-y-1.5 p-2 rounded-lg bg-zinc-900/60 border border-zinc-800/50">
                                <div className="flex items-center justify-between">
                                  <span className="text-[11px] font-semibold text-zinc-300">Top-Left Radius</span>
                                  <span className="text-xs font-mono font-bold text-lime-400">
                                    {config.component_styles.event_card.hot_badge?.radius_top_left ?? 14}px
                                  </span>
                                </div>
                                <input
                                  type="range"
                                  min="0"
                                  max="24"
                                  step="1"
                                  value={config.component_styles.event_card.hot_badge?.radius_top_left ?? 14}
                                  onChange={(e) =>
                                    updateHotBadge((b) => ({
                                      ...b,
                                      radius_top_left: parseFloat(e.target.value),
                                    }))
                                  }
                                  className="w-full accent-lime-400 cursor-pointer"
                                />
                              </div>

                              {/* Top-Right */}
                              <div className="space-y-1.5 p-2 rounded-lg bg-zinc-900/60 border border-zinc-800/50">
                                <div className="flex items-center justify-between">
                                  <span className="text-[11px] font-semibold text-zinc-300">Top-Right Radius</span>
                                  <span className="text-xs font-mono font-bold text-lime-400">
                                    {config.component_styles.event_card.hot_badge?.radius_top_right ?? 0}px
                                  </span>
                                </div>
                                <input
                                  type="range"
                                  min="0"
                                  max="24"
                                  step="1"
                                  value={config.component_styles.event_card.hot_badge?.radius_top_right ?? 0}
                                  onChange={(e) =>
                                    updateHotBadge((b) => ({
                                      ...b,
                                      radius_top_right: parseFloat(e.target.value),
                                    }))
                                  }
                                  className="w-full accent-lime-400 cursor-pointer"
                                />
                              </div>

                              {/* Bottom-Left */}
                              <div className="space-y-1.5 p-2 rounded-lg bg-zinc-900/60 border border-zinc-800/50">
                                <div className="flex items-center justify-between">
                                  <span className="text-[11px] font-semibold text-zinc-300">Bottom-Left Radius</span>
                                  <span className="text-xs font-mono font-bold text-lime-400">
                                    {config.component_styles.event_card.hot_badge?.radius_bottom_left ?? 0}px
                                  </span>
                                </div>
                                <input
                                  type="range"
                                  min="0"
                                  max="24"
                                  step="1"
                                  value={config.component_styles.event_card.hot_badge?.radius_bottom_left ?? 0}
                                  onChange={(e) =>
                                    updateHotBadge((b) => ({
                                      ...b,
                                      radius_bottom_left: parseFloat(e.target.value),
                                    }))
                                  }
                                  className="w-full accent-lime-400 cursor-pointer"
                                />
                              </div>

                              {/* Bottom-Right */}
                              <div className="space-y-1.5 p-2 rounded-lg bg-zinc-900/60 border border-zinc-800/50">
                                <div className="flex items-center justify-between">
                                  <span className="text-[11px] font-semibold text-zinc-300">Bottom-Right Radius</span>
                                  <span className="text-xs font-mono font-bold text-lime-400">
                                    {config.component_styles.event_card.hot_badge?.radius_bottom_right ?? 11}px
                                  </span>
                                </div>
                                <input
                                  type="range"
                                  min="0"
                                  max="24"
                                  step="1"
                                  value={config.component_styles.event_card.hot_badge?.radius_bottom_right ?? 11}
                                  onChange={(e) =>
                                    updateHotBadge((b) => ({
                                      ...b,
                                      radius_bottom_right: parseFloat(e.target.value),
                                    }))
                                  }
                                  className="w-full accent-lime-400 cursor-pointer"
                                />
                              </div>
                            </div>
                          )}
                        </div>
                      </div>
                    )}
                  </div>

                  {/* Event Card Specimen Preview */}
                  <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-3">
                    <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                      Live Specimen Preview: PlayZ Event Card
                    </h3>
                    <div
                      className="p-6 rounded-2xl border border-zinc-800 flex flex-col items-center justify-center min-h-[140px]"
                      style={{ backgroundColor: config.theme.surface_color }}
                    >
                      <div
                        className="w-full max-w-md p-3.5 transition-all relative overflow-hidden"
                        style={{
                          backgroundColor: config.component_styles.event_card.use_custom_override
                            ? config.component_styles.event_card.background_color
                            : config.theme.card_color,
                          borderRadius: `${config.component_styles.event_card.border_radius}px`,
                          border: `${config.component_styles.event_card.border_width}px solid ${
                            config.component_styles.event_card.use_custom_override
                              ? config.component_styles.event_card.border_color
                              : config.theme.primary_color
                          }`,
                          boxShadow: (config.component_styles.event_card.enable_glow ?? true)
                            ? `0 0 16px ${
                                config.component_styles.event_card.use_custom_override
                                  ? config.component_styles.event_card.border_color
                                  : config.theme.primary_color
                              }44, 0 4px 12px rgba(0,0,0,0.4)`
                            : '0 4px 12px rgba(0,0,0,0.3)',
                        }}
                      >
                        {/* Top Header */}
                        <div className="text-[11px] font-semibold text-zinc-400 uppercase text-center tracking-wider mb-2">
                          CRICKET || ICC T20 WORLD CUP
                        </div>
                        {/* Matchup Center */}
                        <div className="flex items-center justify-between px-3">
                          <div className="flex items-center gap-2">
                            <div className="w-8 h-8 rounded-full bg-emerald-700 flex items-center justify-center font-bold text-xs text-white">
                              BAN
                            </div>
                            <span className="text-xs font-bold text-white">Bangladesh</span>
                          </div>

                          <div className="flex flex-col items-center">
                            <span
                              className="px-2 py-0.5 rounded text-[10px] font-bold text-white flex items-center gap-1"
                              style={{
                                backgroundColor: config.component_styles.event_card.use_custom_override
                                  ? config.component_styles.event_card.live_badge_color
                                  : '#FF2B2B',
                              }}
                            >
                              <span className="w-1.5 h-1.5 rounded-full bg-white animate-pulse" />
                              LIVE
                            </span>
                            <span className="text-[10px] font-mono text-zinc-400 mt-1">12:45</span>
                          </div>

                          <div className="flex items-center gap-2">
                            <span className="text-xs font-bold text-white">India</span>
                            <div className="w-8 h-8 rounded-full bg-blue-700 flex items-center justify-center font-bold text-xs text-white">
                              IND
                            </div>
                          </div>
                        </div>

                        {/* HOT / Featured Badge Preview */}
                        {(config.component_styles.event_card.hot_badge?.enabled ?? true) && (
                          <div
                            className="absolute text-[8.5px] font-black uppercase px-2 py-0.5 tracking-wider select-none leading-tight"
                            style={{
                              backgroundColor:
                                config.component_styles.event_card.hot_badge?.bg_color || '#C8FF00',
                              color:
                                config.component_styles.event_card.hot_badge?.text_color || '#0F0F0F',
                              borderTopLeftRadius: `${
                                config.component_styles.event_card.hot_badge?.radius_top_left ?? 14
                              }px`,
                              borderTopRightRadius: `${
                                config.component_styles.event_card.hot_badge?.radius_top_right ?? 0
                              }px`,
                              borderBottomLeftRadius: `${
                                config.component_styles.event_card.hot_badge?.radius_bottom_left ?? 0
                              }px`,
                              borderBottomRightRadius: `${
                                config.component_styles.event_card.hot_badge?.radius_bottom_right ?? 11
                              }px`,
                              ...(config.component_styles.event_card.hot_badge?.position === 'top_right'
                                ? { top: 0, right: 0 }
                                : config.component_styles.event_card.hot_badge?.position === 'top_left'
                                ? { top: 0, left: 0 }
                                : config.component_styles.event_card.hot_badge?.position === 'bottom_left'
                                ? { bottom: 0, left: 0 }
                                : { bottom: 0, right: 0 }),
                            }}
                          >
                            {config.component_styles.event_card.hot_badge?.text || 'HOT'}
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                </div>
              )}

              {/* ── Sub-Tab 2: Channel Cards ─────────────────────────── */}
              {activeComponentTab === 'channel_card' && (
                <div className="space-y-6">
                  {/* Override Toggle Card */}
                  <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 flex items-center justify-between gap-4">
                    <div>
                      <h3 className="text-sm font-bold text-white flex items-center gap-2">
                        Custom Styling Override
                        {config.component_styles.channel_card.use_custom_override ? (
                          <span className="text-[10px] uppercase font-bold text-lime-400 bg-lime-400/10 px-2 py-0.5 rounded-full border border-lime-400/30">
                            Active Override
                          </span>
                        ) : (
                          <span className="text-[10px] uppercase font-bold text-zinc-400 bg-zinc-800 px-2 py-0.5 rounded-full border border-zinc-700">
                            Inheriting Master Card Color ({config.theme.card_color})
                          </span>
                        )}
                      </h3>
                      <p className="text-xs text-zinc-400 mt-1">
                        When enabled, uses a custom container background color. Corner radius, border width, and badge colors configured below are always applied.
                      </p>
                    </div>
                    <label className="relative inline-flex items-center cursor-pointer">
                      <input
                        type="checkbox"
                        checked={config.component_styles.channel_card.use_custom_override}
                        onChange={(e) =>
                          updateComponentStyle('channel_card', (s) => ({ ...s, use_custom_override: e.target.checked }))
                        }
                        className="sr-only peer"
                      />
                      <div className="w-11 h-6 bg-zinc-800 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-lime-400" />
                    </label>
                  </div>

                  {/* Channel Card Controls */}
                  <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-5">
                    <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                      Channel Card Properties
                    </h3>
                    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                      {/* Background Color */}
                      <div className="space-y-2">
                        <div className="flex items-center justify-between">
                          <label className="text-xs font-semibold text-zinc-300">Background Color</label>
                          {!config.component_styles.channel_card.use_custom_override && (
                            <span className="text-[10px] text-zinc-500 font-mono">Inherited</span>
                          )}
                        </div>
                        <div className="flex items-center gap-2">
                          <input
                            type="color"
                            value={
                              config.component_styles.channel_card.use_custom_override
                                ? config.component_styles.channel_card.background_color
                                : config.theme.card_color
                            }
                            disabled={!config.component_styles.channel_card.use_custom_override}
                            onChange={(e) =>
                              updateComponentStyle('channel_card', (s) => ({ ...s, background_color: e.target.value }))
                            }
                            className="w-10 h-10 rounded-lg cursor-pointer bg-transparent border-0 disabled:opacity-40"
                          />
                          <input
                            type="text"
                            value={
                              config.component_styles.channel_card.use_custom_override
                                ? config.component_styles.channel_card.background_color
                                : config.theme.card_color
                            }
                            disabled={!config.component_styles.channel_card.use_custom_override}
                            onChange={(e) =>
                              updateComponentStyle('channel_card', (s) => ({ ...s, background_color: e.target.value }))
                            }
                            className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs font-mono text-zinc-200 uppercase disabled:opacity-40"
                          />
                        </div>
                      </div>

                      {/* Border Color */}
                      <div className="space-y-2">
                        <label className="text-xs font-semibold text-zinc-300">Border Color</label>
                        <div className="flex items-center gap-2">
                          <input
                            type="color"
                            value={config.component_styles.channel_card.border_color}
                            onChange={(e) =>
                              updateComponentStyle('channel_card', (s) => ({ ...s, border_color: e.target.value }))
                            }
                            className="w-10 h-10 rounded-lg cursor-pointer bg-transparent border-0"
                          />
                          <input
                            type="text"
                            value={config.component_styles.channel_card.border_color}
                            onChange={(e) =>
                              updateComponentStyle('channel_card', (s) => ({ ...s, border_color: e.target.value }))
                            }
                            className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs font-mono text-zinc-200 uppercase"
                          />
                        </div>
                      </div>

                      {/* Quality Badge Color */}
                      <div className="space-y-2">
                        <label className="text-xs font-semibold text-zinc-300">Quality Badge Color</label>
                        <div className="flex items-center gap-2">
                          <input
                            type="color"
                            value={config.component_styles.channel_card.quality_badge_color}
                            onChange={(e) =>
                              updateComponentStyle('channel_card', (s) => ({
                                ...s,
                                quality_badge_color: e.target.value,
                              }))
                            }
                            className="w-10 h-10 rounded-lg cursor-pointer bg-transparent border-0"
                          />
                          <input
                            type="text"
                            value={config.component_styles.channel_card.quality_badge_color}
                            onChange={(e) =>
                              updateComponentStyle('channel_card', (s) => ({
                                ...s,
                                quality_badge_color: e.target.value,
                              }))
                            }
                            className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs font-mono text-zinc-200 uppercase"
                          />
                        </div>
                      </div>
                    </div>

                    {/* Sliders */}
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-2 border-t border-zinc-800">
                      <div className="space-y-2">
                        <div className="flex items-center justify-between">
                          <label className="text-xs font-semibold text-zinc-300">Border Width</label>
                          <span className="text-xs font-mono font-bold text-lime-400">
                            {config.component_styles.channel_card.border_width}px
                          </span>
                        </div>
                        <input
                          type="range"
                          min="0"
                          max="4"
                          step="0.5"
                          value={config.component_styles.channel_card.border_width}
                          onChange={(e) =>
                            updateComponentStyle('channel_card', (s) => ({
                              ...s,
                              border_width: parseFloat(e.target.value),
                            }))
                          }
                          className="w-full accent-lime-400 cursor-pointer"
                        />
                      </div>

                      <div className="space-y-2">
                        <div className="flex items-center justify-between">
                          <label className="text-xs font-semibold text-zinc-300">Corner Radius</label>
                          <span className="text-xs font-mono font-bold text-lime-400">
                            {config.component_styles.channel_card.border_radius}px
                          </span>
                        </div>
                        <input
                          type="range"
                          min="4"
                          max="24"
                          step="1"
                          value={config.component_styles.channel_card.border_radius}
                          onChange={(e) =>
                            updateComponentStyle('channel_card', (s) => ({
                              ...s,
                              border_radius: parseFloat(e.target.value),
                            }))
                          }
                          className="w-full accent-lime-400 cursor-pointer"
                        />
                      </div>
                    </div>
                  </div>

                  {/* Channel Card Specimen */}
                  <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-3">
                    <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                      Live Specimen Preview: Channel Tile
                    </h3>
                    <div
                      className="p-6 rounded-2xl border border-zinc-800 flex items-center justify-center gap-4"
                      style={{ backgroundColor: config.theme.surface_color }}
                    >
                      <div
                        className="w-36 h-40 p-3 flex flex-col items-center justify-between shadow-md relative"
                        style={{
                          backgroundColor: config.component_styles.channel_card.use_custom_override
                            ? config.component_styles.channel_card.background_color
                            : config.theme.card_color,
                          borderRadius: `${config.component_styles.channel_card.border_radius}px`,
                          border: `${config.component_styles.channel_card.border_width}px solid ${
                            config.component_styles.channel_card.use_custom_override
                              ? config.component_styles.channel_card.border_color
                              : '#333333'
                          }`,
                        }}
                      >
                        <div className="w-full flex items-center justify-between">
                          <span
                            className="px-1.5 py-0.5 rounded text-[9px] font-extrabold uppercase"
                            style={{
                              backgroundColor: `${
                                config.component_styles.channel_card.use_custom_override
                                  ? config.component_styles.channel_card.quality_badge_color
                                  : config.theme.primary_color
                              }22`,
                              color: config.component_styles.channel_card.use_custom_override
                                ? config.component_styles.channel_card.quality_badge_color
                                : config.theme.primary_color,
                              border: `1px solid ${
                                config.component_styles.channel_card.use_custom_override
                                  ? config.component_styles.channel_card.quality_badge_color
                                  : config.theme.primary_color
                              }44`,
                            }}
                          >
                            FHD
                          </span>
                          <Heart className="w-3.5 h-3.5 text-zinc-500 fill-zinc-500" />
                        </div>

                        <div className="w-12 h-12 rounded-full bg-zinc-800 flex items-center justify-center font-bold text-xs text-zinc-300">
                          TS
                        </div>

                        <div className="text-xs font-bold text-white text-center leading-tight">
                          T Sports HD
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              )}

              {/* ── Sub-Tab 3: Category Buttons ─────────────────────── */}
              {activeComponentTab === 'category_chips' && (
                <div className="space-y-6">
                  {/* Override Toggle Card */}
                  <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 flex items-center justify-between gap-4">
                    <div>
                      <h3 className="text-sm font-bold text-white flex items-center gap-2">
                        Custom Styling Override
                        {config.component_styles.category_chips.use_custom_override ? (
                          <span className="text-[10px] uppercase font-bold text-lime-400 bg-lime-400/10 px-2 py-0.5 rounded-full border border-lime-400/30">
                            Active Override
                          </span>
                        ) : (
                          <span className="text-[10px] uppercase font-bold text-zinc-400 bg-zinc-800 px-2 py-0.5 rounded-full border border-zinc-700">
                            Inheriting Master Theme
                          </span>
                        )}
                      </h3>
                      <p className="text-xs text-zinc-400 mt-1">
                        When disabled, chips use Primary Accent ({config.theme.primary_color}) for selected and Card Container Color ({config.theme.card_color}) for unselected.
                      </p>
                    </div>
                    <label className="relative inline-flex items-center cursor-pointer">
                      <input
                        type="checkbox"
                        checked={config.component_styles.category_chips.use_custom_override}
                        onChange={(e) =>
                          updateComponentStyle('category_chips', (s) => ({ ...s, use_custom_override: e.target.checked }))
                        }
                        className="sr-only peer"
                      />
                      <div className="w-11 h-6 bg-zinc-800 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-lime-400" />
                    </label>
                  </div>

                  {/* Surface Separation Toggle */}
                  <div className="p-4 rounded-xl bg-zinc-900/60 border border-zinc-800 flex items-center justify-between">
                    <div>
                      <span className="text-xs font-bold text-white block">
                        Style Home & Live Events Buttons Separately
                      </span>
                      <span className="text-[11px] text-zinc-400">
                        Enable if you want different roundness or colors on the Home page vs the Live Events page.
                      </span>
                    </div>
                    <input
                      type="checkbox"
                      checked={config.component_styles.category_chips.separate_home_and_upcoming}
                      onChange={(e) =>
                        updateComponentStyle('category_chips', (s) => ({
                          ...s,
                          separate_home_and_upcoming: e.target.checked,
                        }))
                      }
                      className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                    />
                  </div>

                  {/* Unified Configuration */}
                  {!config.component_styles.category_chips.separate_home_and_upcoming ? (
                    <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-5">
                      <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                        Unified Button Colors & Radius
                      </h3>
                      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                        {/* Active BG */}
                        <div className="space-y-2">
                          <label className="text-xs font-semibold text-zinc-300">Active Background</label>
                          <div className="flex items-center gap-2">
                            <input
                              type="color"
                              value={config.component_styles.category_chips.active_bg_color}
                              onChange={(e) =>
                                updateComponentStyle('category_chips', (s) => ({ ...s, active_bg_color: e.target.value }))
                              }
                              className="w-10 h-10 rounded-lg cursor-pointer bg-transparent border-0"
                            />
                            <input
                              type="text"
                              value={config.component_styles.category_chips.active_bg_color}
                              onChange={(e) =>
                                updateComponentStyle('category_chips', (s) => ({ ...s, active_bg_color: e.target.value }))
                              }
                              className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs font-mono text-zinc-200 uppercase"
                            />
                          </div>
                        </div>

                        {/* Active Text */}
                        <div className="space-y-2">
                          <label className="text-xs font-semibold text-zinc-300">Active Text Color</label>
                          <div className="flex items-center gap-2">
                            <input
                              type="color"
                              value={config.component_styles.category_chips.active_text_color}
                              onChange={(e) =>
                                updateComponentStyle('category_chips', (s) => ({ ...s, active_text_color: e.target.value }))
                              }
                              className="w-10 h-10 rounded-lg cursor-pointer bg-transparent border-0"
                            />
                            <input
                              type="text"
                              value={config.component_styles.category_chips.active_text_color}
                              onChange={(e) =>
                                updateComponentStyle('category_chips', (s) => ({ ...s, active_text_color: e.target.value }))
                              }
                              className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs font-mono text-zinc-200 uppercase"
                            />
                          </div>
                        </div>

                        {/* Inactive BG */}
                        <div className="space-y-2">
                          <label className="text-xs font-semibold text-zinc-300">Inactive Background</label>
                          <div className="flex items-center gap-2">
                            <input
                              type="color"
                              value={config.component_styles.category_chips.inactive_bg_color}
                              onChange={(e) =>
                                updateComponentStyle('category_chips', (s) => ({ ...s, inactive_bg_color: e.target.value }))
                              }
                              className="w-10 h-10 rounded-lg cursor-pointer bg-transparent border-0"
                            />
                            <input
                              type="text"
                              value={config.component_styles.category_chips.inactive_bg_color}
                              onChange={(e) =>
                                updateComponentStyle('category_chips', (s) => ({ ...s, inactive_bg_color: e.target.value }))
                              }
                              className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs font-mono text-zinc-200 uppercase"
                            />
                          </div>
                        </div>

                        {/* Inactive Text */}
                        <div className="space-y-2">
                          <label className="text-xs font-semibold text-zinc-300">Inactive Text Color</label>
                          <div className="flex items-center gap-2">
                            <input
                              type="color"
                              value={config.component_styles.category_chips.inactive_text_color}
                              onChange={(e) =>
                                updateComponentStyle('category_chips', (s) => ({ ...s, inactive_text_color: e.target.value }))
                              }
                              className="w-10 h-10 rounded-lg cursor-pointer bg-transparent border-0"
                            />
                            <input
                              type="text"
                              value={config.component_styles.category_chips.inactive_text_color}
                              onChange={(e) =>
                                updateComponentStyle('category_chips', (s) => ({ ...s, inactive_text_color: e.target.value }))
                              }
                              className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs font-mono text-zinc-200 uppercase"
                            />
                          </div>
                        </div>
                      </div>

                      {/* Slider */}
                      <div className="pt-2 border-t border-zinc-800 space-y-2 max-w-sm">
                        <div className="flex items-center justify-between">
                          <label className="text-xs font-semibold text-zinc-300">Corner Radius</label>
                          <span className="text-xs font-mono font-bold text-lime-400">
                            {config.component_styles.category_chips.border_radius}px
                          </span>
                        </div>
                        <input
                          type="range"
                          min="4"
                          max="28"
                          step="1"
                          value={config.component_styles.category_chips.border_radius}
                          onChange={(e) =>
                            updateComponentStyle('category_chips', (s) => ({
                              ...s,
                              border_radius: parseFloat(e.target.value),
                            }))
                          }
                          className="w-full accent-lime-400 cursor-pointer"
                        />
                      </div>
                    </div>
                  ) : (
                    /* Separated Configuration */
                    <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
                      {/* Home Screen Chips */}
                      <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4">
                        <h4 className="text-xs font-bold uppercase tracking-wider text-lime-400">
                          Home Screen: Today&apos;s Matches Chips
                        </h4>
                        <div className="grid grid-cols-2 gap-3">
                          <div className="space-y-1.5">
                            <label className="text-[11px] font-semibold text-zinc-300">Active BG</label>
                            <input
                              type="color"
                              value={config.component_styles.category_chips.home_override.active_bg_color}
                              onChange={(e) =>
                                updateComponentStyle('category_chips', (s) => ({
                                  ...s,
                                  home_override: { ...s.home_override, active_bg_color: e.target.value },
                                }))
                              }
                              className="w-full h-8 rounded cursor-pointer bg-transparent"
                            />
                          </div>
                          <div className="space-y-1.5">
                            <label className="text-[11px] font-semibold text-zinc-300">Inactive BG</label>
                            <input
                              type="color"
                              value={config.component_styles.category_chips.home_override.inactive_bg_color}
                              onChange={(e) =>
                                updateComponentStyle('category_chips', (s) => ({
                                  ...s,
                                  home_override: { ...s.home_override, inactive_bg_color: e.target.value },
                                }))
                              }
                              className="w-full h-8 rounded cursor-pointer bg-transparent"
                            />
                          </div>
                        </div>
                        <div className="space-y-1.5">
                          <div className="flex justify-between text-xs">
                            <span className="text-zinc-300">Home Radius</span>
                            <span className="font-mono text-lime-400 font-bold">
                              {config.component_styles.category_chips.home_override.border_radius}px
                            </span>
                          </div>
                          <input
                            type="range"
                            min="4"
                            max="20"
                            step="1"
                            value={config.component_styles.category_chips.home_override.border_radius}
                            onChange={(e) =>
                              updateComponentStyle('category_chips', (s) => ({
                                ...s,
                                home_override: { ...s.home_override, border_radius: parseFloat(e.target.value) },
                              }))
                            }
                            className="w-full accent-lime-400 cursor-pointer"
                          />
                        </div>
                      </div>

                      {/* Live Events Screen Chips */}
                      <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4">
                        <h4 className="text-xs font-bold uppercase tracking-wider text-lime-400">
                          Live Events Page Chips
                        </h4>
                        <div className="grid grid-cols-2 gap-3">
                          <div className="space-y-1.5">
                            <label className="text-[11px] font-semibold text-zinc-300">Active BG</label>
                            <input
                              type="color"
                              value={config.component_styles.category_chips.upcoming_override.active_bg_color}
                              onChange={(e) =>
                                updateComponentStyle('category_chips', (s) => ({
                                  ...s,
                                  upcoming_override: { ...s.upcoming_override, active_bg_color: e.target.value },
                                }))
                              }
                              className="w-full h-8 rounded cursor-pointer bg-transparent"
                            />
                          </div>
                          <div className="space-y-1.5">
                            <label className="text-[11px] font-semibold text-zinc-300">Inactive BG</label>
                            <input
                              type="color"
                              value={config.component_styles.category_chips.upcoming_override.inactive_bg_color}
                              onChange={(e) =>
                                updateComponentStyle('category_chips', (s) => ({
                                  ...s,
                                  upcoming_override: { ...s.upcoming_override, inactive_bg_color: e.target.value },
                                }))
                              }
                              className="w-full h-8 rounded cursor-pointer bg-transparent"
                            />
                          </div>
                        </div>
                        <div className="space-y-1.5">
                          <div className="flex justify-between text-xs">
                            <span className="text-zinc-300">Upcoming Radius</span>
                            <span className="font-mono text-lime-400 font-bold">
                              {config.component_styles.category_chips.upcoming_override.border_radius}px
                            </span>
                          </div>
                          <input
                            type="range"
                            min="4"
                            max="28"
                            step="1"
                            value={config.component_styles.category_chips.upcoming_override.border_radius}
                            onChange={(e) =>
                              updateComponentStyle('category_chips', (s) => ({
                                ...s,
                                upcoming_override: { ...s.upcoming_override, border_radius: parseFloat(e.target.value) },
                              }))
                            }
                            className="w-full accent-lime-400 cursor-pointer"
                          />
                        </div>
                      </div>
                    </div>
                  )}

                  {/* Category Chips Specimen */}
                  <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-3">
                    <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                      Live Specimen Preview: Category Buttons
                    </h3>
                    <div
                      className="p-6 rounded-2xl border border-zinc-800 flex flex-col gap-3"
                      style={{ backgroundColor: config.theme.surface_color }}
                    >
                      <div className="text-[11px] text-zinc-400 font-semibold">Chips Row Preview:</div>
                      <div className="flex items-center gap-2 overflow-x-auto pb-1">
                        {['All Matches', 'Cricket', 'Football', 'Tennis'].map((sport, idx) => {
                          const isSelected = idx === 0;
                          const chipsConfig = config.component_styles.category_chips;
                          const activeBg = chipsConfig.use_custom_override
                            ? chipsConfig.active_bg_color
                            : config.theme.primary_color;
                          const inactiveBg = chipsConfig.use_custom_override
                            ? chipsConfig.inactive_bg_color
                            : config.theme.card_color;
                          const activeText = chipsConfig.use_custom_override
                            ? chipsConfig.active_text_color
                            : '#0F0F0F';
                          const inactiveText = chipsConfig.use_custom_override
                            ? chipsConfig.inactive_text_color
                            : '#FFFFFF';
                          const radius = chipsConfig.use_custom_override
                            ? chipsConfig.border_radius
                            : 8;

                          return (
                            <span
                              key={sport}
                              className="px-3.5 py-1.5 text-xs font-bold transition-all shadow-sm"
                              style={{
                                backgroundColor: isSelected ? activeBg : inactiveBg,
                                color: isSelected ? activeText : inactiveText,
                                borderRadius: `${radius}px`,
                              }}
                            >
                              {sport}
                            </span>
                          );
                        })}
                      </div>
                    </div>
                  </div>
                </div>
              )}

              {/* ── Sub-Tab 4: Settings Page UI ──────────────────────── */}
              {activeComponentTab === 'settings_screen' && (
                <div className="space-y-6">
                  {/* Override Toggle Card */}
                  <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 flex items-center justify-between gap-4">
                    <div>
                      <h3 className="text-sm font-bold text-white flex items-center gap-2">
                        Custom Styling Override
                        {config.component_styles.settings_screen.use_custom_override ? (
                          <span className="text-[10px] uppercase font-bold text-lime-400 bg-lime-400/10 px-2 py-0.5 rounded-full border border-lime-400/30">
                            Active Override
                          </span>
                        ) : (
                          <span className="text-[10px] uppercase font-bold text-zinc-400 bg-zinc-800 px-2 py-0.5 rounded-full border border-zinc-700">
                            Inheriting Master Card Color ({config.theme.card_color})
                          </span>
                        )}
                      </h3>
                      <p className="text-xs text-zinc-400 mt-1">
                        When enabled, the App Settings page renders with custom card backgrounds, border radiuses, icon badges, and header avatars.
                      </p>
                    </div>
                    <label className="relative inline-flex items-center cursor-pointer">
                      <input
                        type="checkbox"
                        checked={config.component_styles.settings_screen.use_custom_override}
                        onChange={(e) =>
                          updateComponentStyle('settings_screen', (s) => ({
                            ...s,
                            use_custom_override: e.target.checked,
                          }))
                        }
                        className="sr-only peer"
                      />
                      <div className="w-11 h-6 bg-zinc-800 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-lime-400" />
                    </label>
                  </div>

                  {/* Settings Page Controls */}
                  <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-5">
                    <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                      Settings Cards & Brand Header
                    </h3>
                    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                      {/* Card Background */}
                      <div className="space-y-2">
                        <div className="flex items-center justify-between">
                          <label className="text-xs font-semibold text-zinc-300">Card Background</label>
                          {!config.component_styles.settings_screen.use_custom_override && (
                            <span className="text-[10px] text-zinc-500 font-mono">Inherited</span>
                          )}
                        </div>
                        <div className="flex items-center gap-2">
                          <input
                            type="color"
                            value={
                              config.component_styles.settings_screen.use_custom_override
                                ? config.component_styles.settings_screen.card_bg_color
                                : config.theme.card_color
                            }
                            disabled={!config.component_styles.settings_screen.use_custom_override}
                            onChange={(e) =>
                              updateComponentStyle('settings_screen', (s) => ({ ...s, card_bg_color: e.target.value }))
                            }
                            className="w-10 h-10 rounded-lg cursor-pointer bg-transparent border-0 disabled:opacity-40"
                          />
                          <input
                            type="text"
                            value={
                              config.component_styles.settings_screen.use_custom_override
                                ? config.component_styles.settings_screen.card_bg_color
                                : config.theme.card_color
                            }
                            disabled={!config.component_styles.settings_screen.use_custom_override}
                            onChange={(e) =>
                              updateComponentStyle('settings_screen', (s) => ({ ...s, card_bg_color: e.target.value }))
                            }
                            className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs font-mono text-zinc-200 uppercase disabled:opacity-40"
                          />
                        </div>
                      </div>

                      {/* Card Border Color */}
                      <div className="space-y-2">
                        <label className="text-xs font-semibold text-zinc-300">Card Border Color</label>
                        <div className="flex items-center gap-2">
                          <input
                            type="color"
                            value={config.component_styles.settings_screen.card_border_color}
                            onChange={(e) =>
                              updateComponentStyle('settings_screen', (s) => ({ ...s, card_border_color: e.target.value }))
                            }
                            className="w-10 h-10 rounded-lg cursor-pointer bg-transparent border-0"
                          />
                          <input
                            type="text"
                            value={config.component_styles.settings_screen.card_border_color}
                            onChange={(e) =>
                              updateComponentStyle('settings_screen', (s) => ({ ...s, card_border_color: e.target.value }))
                            }
                            className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs font-mono text-zinc-200 uppercase"
                          />
                        </div>
                      </div>

                      {/* Icon Accent Color */}
                      <div className="space-y-2">
                        <label className="text-xs font-semibold text-zinc-300">Icon Accent Color</label>
                        <div className="flex items-center gap-2">
                          <input
                            type="color"
                            value={config.component_styles.settings_screen.icon_accent_color}
                            onChange={(e) =>
                              updateComponentStyle('settings_screen', (s) => ({ ...s, icon_accent_color: e.target.value }))
                            }
                            className="w-10 h-10 rounded-lg cursor-pointer bg-transparent border-0"
                          />
                          <input
                            type="text"
                            value={config.component_styles.settings_screen.icon_accent_color}
                            onChange={(e) =>
                              updateComponentStyle('settings_screen', (s) => ({ ...s, icon_accent_color: e.target.value }))
                            }
                            className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs font-mono text-zinc-200 uppercase"
                          />
                        </div>
                      </div>

                      {/* Header Avatar Start Gradient */}
                      <div className="space-y-2">
                        <label className="text-xs font-semibold text-zinc-300">Avatar Gradient Start</label>
                        <div className="flex items-center gap-2">
                          <input
                            type="color"
                            value={config.component_styles.settings_screen.header_gradient_start}
                            onChange={(e) =>
                              updateComponentStyle('settings_screen', (s) => ({
                                ...s,
                                header_gradient_start: e.target.value,
                              }))
                            }
                            className="w-10 h-10 rounded-lg cursor-pointer bg-transparent border-0"
                          />
                          <input
                            type="text"
                            value={config.component_styles.settings_screen.header_gradient_start}
                            onChange={(e) =>
                              updateComponentStyle('settings_screen', (s) => ({
                                ...s,
                                header_gradient_start: e.target.value,
                              }))
                            }
                            className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs font-mono text-zinc-200 uppercase"
                          />
                        </div>
                      </div>

                      {/* Header Avatar End Gradient */}
                      <div className="space-y-2">
                        <label className="text-xs font-semibold text-zinc-300">Avatar Gradient End</label>
                        <div className="flex items-center gap-2">
                          <input
                            type="color"
                            value={config.component_styles.settings_screen.header_gradient_end}
                            onChange={(e) =>
                              updateComponentStyle('settings_screen', (s) => ({
                                ...s,
                                header_gradient_end: e.target.value,
                              }))
                            }
                            className="w-10 h-10 rounded-lg cursor-pointer bg-transparent border-0"
                          />
                          <input
                            type="text"
                            value={config.component_styles.settings_screen.header_gradient_end}
                            onChange={(e) =>
                              updateComponentStyle('settings_screen', (s) => ({
                                ...s,
                                header_gradient_end: e.target.value,
                              }))
                            }
                            className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs font-mono text-zinc-200 uppercase"
                          />
                        </div>
                      </div>

                      {/* Corner Radius */}
                      <div className="space-y-2">
                        <div className="flex items-center justify-between">
                          <label className="text-xs font-semibold text-zinc-300">Card Corner Radius</label>
                          <span className="text-xs font-mono font-bold text-lime-400">
                            {config.component_styles.settings_screen.card_border_radius}px
                          </span>
                        </div>
                        <input
                          type="range"
                          min="8"
                          max="28"
                          step="1"
                          value={config.component_styles.settings_screen.card_border_radius}
                          onChange={(e) =>
                            updateComponentStyle('settings_screen', (s) => ({
                              ...s,
                              card_border_radius: parseFloat(e.target.value),
                            }))
                          }
                          className="w-full accent-lime-400 cursor-pointer"
                        />
                      </div>
                    </div>
                  </div>

                  {/* Settings Specimen Preview */}
                  <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-3">
                    <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                      Live Specimen Preview: Settings UI
                    </h3>
                    <div
                      className="p-6 rounded-2xl border border-zinc-800 flex flex-col items-center gap-4"
                      style={{ backgroundColor: config.theme.surface_color }}
                    >
                      {/* Avatar */}
                      <div
                        className="w-16 h-16 rounded-full flex items-center justify-center font-black text-xl text-white shadow-lg"
                        style={{
                          background: `linear-gradient(135deg, ${
                            config.component_styles.settings_screen.use_custom_override
                              ? config.component_styles.settings_screen.header_gradient_start
                              : '#C8FF00'
                          }, ${
                            config.component_styles.settings_screen.use_custom_override
                              ? config.component_styles.settings_screen.header_gradient_end
                              : '#00E5FF'
                          })`,
                        }}
                      >
                        GP
                      </div>
                      <div className="text-center">
                        <div className="text-sm font-bold text-white">GoPlay Stream</div>
                        <div className="text-[11px] text-zinc-400">v2.1.0 • High-Performance IPTV</div>
                      </div>

                      {/* Group Card Preview */}
                      <div
                        className="w-full max-w-md p-4 transition-all shadow-md flex items-center justify-between"
                        style={{
                          backgroundColor: config.component_styles.settings_screen.use_custom_override
                            ? config.component_styles.settings_screen.card_bg_color
                            : config.theme.card_color,
                          borderRadius: `${config.component_styles.settings_screen.card_border_radius}px`,
                          border: `${config.component_styles.settings_screen.card_border_width}px solid ${
                            config.component_styles.settings_screen.use_custom_override
                              ? config.component_styles.settings_screen.card_border_color
                              : '#333333'
                          }`,
                        }}
                      >
                        <div className="flex items-center gap-3">
                          <div
                            className="w-9 h-9 rounded-xl flex items-center justify-center"
                            style={{
                              backgroundColor: `${
                                config.component_styles.settings_screen.use_custom_override
                                  ? config.component_styles.settings_screen.icon_accent_color
                                  : config.theme.primary_color
                              }22`,
                            }}
                          >
                            <PlayCircle
                              className="w-5 h-5"
                              style={{
                                color: config.component_styles.settings_screen.use_custom_override
                                  ? config.component_styles.settings_screen.icon_accent_color
                                  : config.theme.primary_color,
                              }}
                            />
                          </div>
                          <div>
                            <div className="text-xs font-bold text-white">Playback Engine</div>
                            <div className="text-[11px] text-zinc-400">GPU acceleration, auto-play & buffer controls</div>
                          </div>
                        </div>
                        <span className="text-zinc-500 font-bold text-lg">›</span>
                      </div>
                    </div>
                  </div>
                </div>
              )}
            </div>
          )}

          {/* ─────────────────────────────────────────────────────────── */}
          {/* DOMAIN 2: CHANNELS & CARDS                                 */}
          {/* ─────────────────────────────────────────────────────────── */}
          {activeDomain === 'channels' && (
            <div className="space-y-6">
              <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                <div>
                  <h2 className="text-xl font-bold text-white flex items-center gap-2">
                    <Tv className="w-5 h-5 text-lime-400" />
                    Channels Screen & Card Configuration
                  </h2>
                  <p className="text-xs text-zinc-400 mt-1">
                    Manage category tab strip elements, grid columns, and individual channel tile cards.
                  </p>
                </div>
                <button
                  type="button"
                  onClick={() => {
                    updateDomain('channels_tab', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.channels_tab)));
                    setNotification({ type: 'success', message: 'Channels Screen settings reset to default.' });
                  }}
                  className="inline-flex items-center gap-2 px-3.5 py-2 rounded-xl bg-zinc-800/80 hover:bg-zinc-700 text-xs font-semibold text-zinc-300 hover:text-white border border-zinc-700/70 transition-all cursor-pointer self-start sm:self-auto active:scale-95"
                >
                  <RotateCcw className="w-3.5 h-3.5 text-lime-400" />
                  Reset Screen Defaults
                </button>
              </div>

              {/* Tab Strip Controls */}
              <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4">
                <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                  Category Tab Strip Badges & Icons
                </h3>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <label className="flex items-center justify-between p-3.5 rounded-xl bg-zinc-950/70 border border-zinc-800 hover:border-zinc-700 cursor-pointer">
                    <div>
                      <span className="text-xs font-bold text-white block">Show Tab Category Icons</span>
                      <span className="text-[11px] text-zinc-400">Displays SVG/emblem icons inside tab chips</span>
                    </div>
                    <input
                      type="checkbox"
                      checked={config.channels_tab.show_tab_icons}
                      onChange={(e) =>
                        updateDomain('channels_tab', (c) => ({ ...c, show_tab_icons: e.target.checked }))
                      }
                      className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                    />
                  </label>

                  <label className="flex items-center justify-between p-3.5 rounded-xl bg-zinc-950/70 border border-zinc-800 hover:border-zinc-700 cursor-pointer">
                    <div>
                      <span className="text-xs font-bold text-white block">Show Tab Channel Counts</span>
                      <span className="text-[11px] text-zinc-400">Displays total channel number badge on each tab</span>
                    </div>
                    <input
                      type="checkbox"
                      checked={config.channels_tab.show_tab_counts}
                      onChange={(e) =>
                        updateDomain('channels_tab', (c) => ({ ...c, show_tab_counts: e.target.checked }))
                      }
                      className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                    />
                  </label>

                  <label className="flex items-center justify-between p-3.5 rounded-xl bg-zinc-950/70 border border-zinc-800 hover:border-zinc-700 cursor-pointer">
                    <div>
                      <span className="text-xs font-bold text-white block">Show &apos;Trending&apos; Tab</span>
                      <span className="text-[11px] text-zinc-400">Includes trending channels tab first</span>
                    </div>
                    <input
                      type="checkbox"
                      checked={config.channels_tab.show_trending_tab}
                      onChange={(e) =>
                        updateDomain('channels_tab', (c) => ({ ...c, show_trending_tab: e.target.checked }))
                      }
                      className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                    />
                  </label>

                  <label className="flex items-center justify-between p-3.5 rounded-xl bg-zinc-950/70 border border-zinc-800 hover:border-zinc-700 cursor-pointer">
                    <div>
                      <span className="text-xs font-bold text-white block">Show &apos;Favorites&apos; Tab</span>
                      <span className="text-[11px] text-zinc-400">Enables user starred channel tab</span>
                    </div>
                    <input
                      type="checkbox"
                      checked={config.channels_tab.show_favorite_tab}
                      onChange={(e) =>
                        updateDomain('channels_tab', (c) => ({ ...c, show_favorite_tab: e.target.checked }))
                      }
                      className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                    />
                  </label>

                  <label className={`flex items-center justify-between p-3.5 rounded-xl bg-zinc-950/70 border border-zinc-800 hover:border-zinc-700 transition-all ${!config.channels_tab.show_favorite_tab ? 'opacity-40 pointer-events-none' : 'cursor-pointer'}`}>
                    <div>
                      <span className="text-xs font-bold text-white block">Auto-Hide &apos;Favorites&apos; When Empty</span>
                      <span className="text-[11px] text-zinc-400">Hides the tab until the user bookmarks at least one channel</span>
                    </div>
                    <input
                      type="checkbox"
                      checked={config.channels_tab.auto_hide_favorite_tab_when_empty ?? true}
                      disabled={!config.channels_tab.show_favorite_tab}
                      onChange={(e) =>
                        updateDomain('channels_tab', (c) => ({ ...c, auto_hide_favorite_tab_when_empty: e.target.checked }))
                      }
                      className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                    />
                  </label>

                  <label className="flex items-center justify-between p-3.5 rounded-xl bg-zinc-950/70 border border-zinc-800 hover:border-zinc-700 cursor-pointer">
                    <div>
                      <span className="text-xs font-bold text-white block">Show &apos;All Channels&apos; Tab</span>
                      <span className="text-[11px] text-zinc-400">Full combined catalog tab</span>
                    </div>
                    <input
                      type="checkbox"
                      checked={config.channels_tab.show_all_tab}
                      onChange={(e) =>
                        updateDomain('channels_tab', (c) => ({ ...c, show_all_tab: e.target.checked }))
                      }
                      className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                    />
                  </label>
                </div>

                {/* Live Tab Strip Simulation */}
                <div className="pt-3 border-t border-zinc-800 space-y-2">
                  <div className="flex items-center justify-between text-xs text-zinc-400">
                    <span className="font-semibold text-zinc-300">Live Tab Strip Simulation</span>
                    <span className="text-[11px] text-zinc-500">
                      {config.channels_tab.auto_hide_favorite_tab_when_empty
                        ? 'Simulating User with 0 Bookmarks (Favorites hidden)'
                        : 'Favorites tab permanently visible'}
                    </span>
                  </div>
                  <div
                    className="p-3 rounded-xl border border-zinc-800 flex items-center gap-4 overflow-x-auto"
                    style={{ backgroundColor: config.theme.surface_color }}
                  >
                    {config.channels_tab.show_trending_tab && (
                      <div className="flex items-center gap-1.5 text-xs font-bold text-lime-400 border-b-2 border-lime-400 pb-1 px-1">
                        <span>Trending</span>
                        {config.channels_tab.show_tab_counts && (
                          <span className="text-[10px] bg-lime-400/20 text-lime-300 px-1.5 py-0.2 rounded-full font-mono">
                            12
                          </span>
                        )}
                      </div>
                    )}
                    {config.channels_tab.show_favorite_tab && (
                      <div
                        className={`flex items-center gap-1.5 text-xs font-medium transition-all pb-1 px-1 ${
                          config.channels_tab.auto_hide_favorite_tab_when_empty
                            ? 'text-zinc-600 line-through opacity-50'
                            : 'text-zinc-400 hover:text-zinc-200'
                        }`}
                      >
                        <Heart className="w-3.5 h-3.5" />
                        <span>Favorite</span>
                        {config.channels_tab.show_tab_counts && (
                          <span className="text-[10px] bg-zinc-800 text-zinc-400 px-1.5 py-0.2 rounded-full font-mono">
                            0
                          </span>
                        )}
                        {config.channels_tab.auto_hide_favorite_tab_when_empty && (
                          <span className="text-[9px] not-italic no-underline bg-amber-500/10 text-amber-400 border border-amber-500/30 px-1 rounded">
                            Auto-Hidden
                          </span>
                        )}
                      </div>
                    )}
                    <div className="flex items-center gap-1.5 text-xs font-medium text-zinc-400 pb-1 px-1">
                      {config.channels_tab.show_tab_icons && <Tv className="w-3.5 h-3.5" />}
                      <span>Sports</span>
                      {config.channels_tab.show_tab_counts && (
                        <span className="text-[10px] bg-zinc-800 text-zinc-400 px-1.5 py-0.2 rounded-full font-mono">
                          8
                        </span>
                      )}
                    </div>
                    <div className="flex items-center gap-1.5 text-xs font-medium text-zinc-400 pb-1 px-1">
                      {config.channels_tab.show_tab_icons && <Tv className="w-3.5 h-3.5" />}
                      <span>News</span>
                      {config.channels_tab.show_tab_counts && (
                        <span className="text-[10px] bg-zinc-800 text-zinc-400 px-1.5 py-0.2 rounded-full font-mono">
                          15
                        </span>
                      )}
                    </div>
                    {config.channels_tab.show_all_tab && (
                      <div className="flex items-center gap-1.5 text-xs font-medium text-zinc-400 pb-1 px-1">
                        <span>All</span>
                        {config.channels_tab.show_tab_counts && (
                          <span className="text-[10px] bg-zinc-800 text-zinc-400 px-1.5 py-0.2 rounded-full font-mono">
                            35
                          </span>
                        )}
                      </div>
                    )}
                  </div>
                </div>
              </div>

              {/* Grid Column Layout */}
              <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4">
                <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                  Channel Grid Density
                </h3>
                <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                  {[2, 3, 4].map((col) => (
                    <button
                      key={col}
                      onClick={() =>
                        updateDomain('channels_tab', (c) => ({ ...c, channel_grid_columns: col }))
                      }
                      className={`p-4 rounded-xl border text-center transition-all cursor-pointer ${
                        config.channels_tab.channel_grid_columns === col
                          ? 'bg-zinc-800 border-lime-400 text-white font-bold'
                          : 'bg-zinc-950/60 border-zinc-800 text-zinc-400 hover:text-white'
                      }`}
                    >
                      <span className="text-base block font-extrabold">{col} Columns</span>
                      <span className="text-[11px] text-zinc-500">
                        {col === 2 ? 'Large Thumbnails' : col === 3 ? 'Standard / Recommended' : 'Compact Grid'}
                      </span>
                    </button>
                  ))}
                </div>
              </div>

              {/* Channel Card Elements */}
              <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4">
                <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                  Channel Card Elements
                </h3>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <label className="flex items-center justify-between p-3.5 rounded-xl bg-zinc-950/70 border border-zinc-800 hover:border-zinc-700 cursor-pointer">
                    <div>
                      <span className="text-xs font-bold text-white block">Quality Badge (HD / FHD)</span>
                      <span className="text-[11px] text-zinc-400">Top-right resolution pill badge</span>
                    </div>
                    <input
                      type="checkbox"
                      checked={config.channels_tab.show_quality_badge}
                      onChange={(e) =>
                        updateDomain('channels_tab', (c) => ({ ...c, show_quality_badge: e.target.checked }))
                      }
                      className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                    />
                  </label>

                  <label className="flex items-center justify-between p-3.5 rounded-xl bg-zinc-950/70 border border-zinc-800 hover:border-zinc-700 cursor-pointer">
                    <div>
                      <span className="text-xs font-bold text-white block">Channel Logos</span>
                      <span className="text-[11px] text-zinc-400">Render network station logo emblem</span>
                    </div>
                    <input
                      type="checkbox"
                      checked={config.channels_tab.show_card_logos}
                      onChange={(e) =>
                        updateDomain('channels_tab', (c) => ({ ...c, show_card_logos: e.target.checked }))
                      }
                      className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                    />
                  </label>

                  <label className="flex items-center justify-between p-3.5 rounded-xl bg-zinc-950/70 border border-zinc-800 hover:border-zinc-700 cursor-pointer">
                    <div>
                      <span className="text-xs font-bold text-white block">Channel Names</span>
                      <span className="text-[11px] text-zinc-400">Bottom typography label</span>
                    </div>
                    <input
                      type="checkbox"
                      checked={config.channels_tab.show_card_names}
                      onChange={(e) =>
                        updateDomain('channels_tab', (c) => ({ ...c, show_card_names: e.target.checked }))
                      }
                      className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                    />
                  </label>

                  <label className="flex items-center justify-between p-3.5 rounded-xl bg-zinc-950/70 border border-zinc-800 hover:border-zinc-700 cursor-pointer">
                    <div>
                      <span className="text-xs font-bold text-white block">Bookmark Star Button</span>
                      <span className="text-[11px] text-zinc-400">Allows instant starring directly on tile</span>
                    </div>
                    <input
                      type="checkbox"
                      checked={config.channels_tab.show_card_favorites}
                      onChange={(e) =>
                        updateDomain('channels_tab', (c) => ({ ...c, show_card_favorites: e.target.checked }))
                      }
                      className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                    />
                  </label>
                </div>
              </div>
            </div>
          )}

          {/* ─────────────────────────────────────────────────────────── */}
          {/* DOMAIN 3: CATEGORIES SCREEN                                */}
          {/* ─────────────────────────────────────────────────────────── */}
          {activeDomain === 'categories' && (
            <div className="space-y-6">
              <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                <div>
                  <h2 className="text-xl font-bold text-white flex items-center gap-2">
                    <Layers className="w-5 h-5 text-lime-400" />
                    Categories Screen Customizer
                  </h2>
                  <p className="text-xs text-zinc-400 mt-1">
                    Adjust grid columns and visual emblems for the dedicated Categories page.
                  </p>
                </div>
                <button
                  type="button"
                  onClick={() => {
                    updateDomain('categories_screen', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.categories_screen)));
                    setNotification({ type: 'success', message: 'Categories Screen settings reset to default.' });
                  }}
                  className="inline-flex items-center gap-2 px-3.5 py-2 rounded-xl bg-zinc-800/80 hover:bg-zinc-700 text-xs font-semibold text-zinc-300 hover:text-white border border-zinc-700/70 transition-all cursor-pointer self-start sm:self-auto active:scale-95"
                >
                  <RotateCcw className="w-3.5 h-3.5 text-lime-400" />
                  Reset Screen Defaults
                </button>
              </div>

              {/* Grid Columns */}
              <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4">
                <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                  Category Grid Columns
                </h3>
                <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                  {[1, 2, 3].map((col) => (
                    <button
                      key={col}
                      onClick={() =>
                        updateDomain('categories_screen', (c) => ({ ...c, category_grid_columns: col }))
                      }
                      className={`p-4 rounded-xl border text-center transition-all cursor-pointer ${
                        config.categories_screen.category_grid_columns === col
                          ? 'bg-zinc-800 border-lime-400 text-white font-bold'
                          : 'bg-zinc-950/60 border-zinc-800 text-zinc-400 hover:text-white'
                      }`}
                    >
                      <span className="text-base block font-extrabold">{col} Column{col > 1 ? 's' : ''}</span>
                      <span className="text-[11px] text-zinc-500">
                        {col === 1 ? 'Full-width List' : col === 2 ? 'Two-Column Grid (Standard)' : 'Dense Grid'}
                      </span>
                    </button>
                  ))}
                </div>
              </div>

              {/* Toggles */}
              <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4">
                <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                  Category Card Elements
                </h3>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <label className="flex items-center justify-between p-3.5 rounded-xl bg-zinc-950/70 border border-zinc-800 hover:border-zinc-700 cursor-pointer">
                    <div>
                      <span className="text-xs font-bold text-white block">Category Emblems</span>
                      <span className="text-[11px] text-zinc-400">Icon or emblem graphic for category</span>
                    </div>
                    <input
                      type="checkbox"
                      checked={config.categories_screen.show_category_emblems}
                      onChange={(e) =>
                        updateDomain('categories_screen', (c) => ({
                          ...c,
                          show_category_emblems: e.target.checked,
                        }))
                      }
                      className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                    />
                  </label>

                  <label className="flex items-center justify-between p-3.5 rounded-xl bg-zinc-950/70 border border-zinc-800 hover:border-zinc-700 cursor-pointer">
                    <div>
                      <span className="text-xs font-bold text-white block">Channel Count Badge</span>
                      <span className="text-[11px] text-zinc-400">e.g. &apos;14 Channels&apos; counter pill</span>
                    </div>
                    <input
                      type="checkbox"
                      checked={config.categories_screen.show_category_channel_counts}
                      onChange={(e) =>
                        updateDomain('categories_screen', (c) => ({
                          ...c,
                          show_category_channel_counts: e.target.checked,
                        }))
                      }
                      className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                    />
                  </label>

                  <label className="flex items-center justify-between p-3.5 rounded-xl bg-zinc-950/70 border border-zinc-800 hover:border-zinc-700 cursor-pointer">
                    <div>
                      <span className="text-xs font-bold text-white block">Search Filter Bar</span>
                      <span className="text-[11px] text-zinc-400">Top search bar for categories screen</span>
                    </div>
                    <input
                      type="checkbox"
                      checked={config.categories_screen.show_category_search}
                      onChange={(e) =>
                        updateDomain('categories_screen', (c) => ({
                          ...c,
                          show_category_search: e.target.checked,
                        }))
                      }
                      className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                    />
                  </label>

                  <label className="flex items-center justify-between p-3.5 rounded-xl bg-zinc-950/70 border border-zinc-800 hover:border-zinc-700 cursor-pointer">
                    <div>
                      <span className="text-xs font-bold text-white block">Favorites Filter Chip</span>
                      <span className="text-[11px] text-zinc-400">Quick-toggle for starred categories</span>
                    </div>
                    <input
                      type="checkbox"
                      checked={config.categories_screen.show_category_favorites}
                      onChange={(e) =>
                        updateDomain('categories_screen', (c) => ({
                          ...c,
                          show_category_favorites: e.target.checked,
                        }))
                      }
                      className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                    />
                  </label>
                </div>
              </div>
            </div>
          )}

          {/* ─────────────────────────────────────────────────────────── */}
          {/* DOMAIN 4: HOME MODULAR SECTIONS                            */}
          {/* ─────────────────────────────────────────────────────────── */}
          {activeDomain === 'home' && (
            <div className="space-y-6">
              <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                <div>
                  <h2 className="text-xl font-bold text-white flex items-center gap-2">
                    <Layout className="w-5 h-5 text-lime-400" />
                    Home Screen Modular Sections
                  </h2>
                  <p className="text-xs text-zinc-400 mt-1">
                    Reorder and toggle sections dynamically on the mobile & TV Home tab.
                  </p>
                </div>
                <button
                  type="button"
                  onClick={() => {
                    updateDomain('home_screen', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.home_screen)));
                    updateDomain('promo_banner', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.promo_banner)));
                    setNotification({ type: 'success', message: 'Home Sections & Promotional Banner reset to default.' });
                  }}
                  className="inline-flex items-center gap-2 px-3.5 py-2 rounded-xl bg-zinc-800/80 hover:bg-zinc-700 text-xs font-semibold text-zinc-300 hover:text-white border border-zinc-700/70 transition-all cursor-pointer self-start sm:self-auto active:scale-95"
                >
                  <RotateCcw className="w-3.5 h-3.5 text-lime-400" />
                  Reset Home Defaults
                </button>
              </div>

              {/* Section Order & Visibility */}
              <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4">
                <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                  Section Layout & Order
                </h3>
                <div className="space-y-2.5">
                  {config.home_screen.section_order.map((secId, index) => {
                    const isFirst = index === 0;
                    const isLast = index === config.home_screen.section_order.length - 1;

                    type HomeToggleKey = 'show_hero_banner' | 'show_trending_section' | 'show_todays_matches' | 'show_recently_watched' | 'show_announcements';

                    const secNameMap: Record<string, { label: string; desc: string; toggleKey: HomeToggleKey | null }> = {
                      hero: { label: 'Hero Carousel Banner', desc: 'Top featured promotions & live matches', toggleKey: 'show_hero_banner' },
                      trending: { label: 'Trending Channels Strip', desc: 'Horizontally scrollable popular channels', toggleKey: 'show_trending_section' },
                      matches: { label: "Today's Live Sports Matches", desc: 'PlayZ sports fixture match cards', toggleKey: 'show_todays_matches' },
                      recent: { label: 'Recently Watched History', desc: 'Resume quick channel watch history', toggleKey: 'show_recently_watched' },
                      announcements: { label: 'Announcements Strip', desc: 'Important platform updates', toggleKey: 'show_announcements' },
                    };

                    const meta = secNameMap[secId] || { label: secId, desc: '', toggleKey: null };
                    const isEnabled = meta.toggleKey ? config.home_screen[meta.toggleKey] : true;

                    const moveUp = () => {
                      if (isFirst) return;
                      const newOrder = [...config.home_screen.section_order];
                      const temp = newOrder[index - 1];
                      newOrder[index - 1] = newOrder[index];
                      newOrder[index] = temp;
                      updateDomain('home_screen', (h) => ({ ...h, section_order: newOrder }));
                    };

                    const moveDown = () => {
                      if (isLast) return;
                      const newOrder = [...config.home_screen.section_order];
                      const temp = newOrder[index + 1];
                      newOrder[index + 1] = newOrder[index];
                      newOrder[index] = temp;
                      updateDomain('home_screen', (h) => ({ ...h, section_order: newOrder }));
                    };

                    return (
                      <div
                        key={secId}
                        className={`p-4 rounded-xl border flex items-center justify-between transition-all ${
                          isEnabled
                            ? 'bg-zinc-950/80 border-zinc-800'
                            : 'bg-zinc-950/30 border-zinc-800/40 opacity-50'
                        }`}
                      >
                        <div className="flex items-center gap-3">
                          <span className="w-6 h-6 rounded-full bg-zinc-800 text-zinc-400 font-mono text-xs flex items-center justify-center font-bold">
                            {index + 1}
                          </span>
                          <div>
                            <span className="text-xs font-bold text-white block">{meta.label}</span>
                            <span className="text-[11px] text-zinc-500">{meta.desc}</span>
                          </div>
                        </div>

                        <div className="flex items-center gap-3">
                          {/* Visibility Toggle */}
                          {meta.toggleKey && (
                            <label className="flex items-center gap-2 cursor-pointer">
                              <span className="text-[10px] text-zinc-400 font-medium">
                                {isEnabled ? 'Visible' : 'Hidden'}
                              </span>
                              <input
                                type="checkbox"
                                checked={isEnabled}
                                onChange={(e) => {
                                  const key = meta.toggleKey;
                                  if (key) {
                                    updateDomain('home_screen', (h) => ({
                                      ...h,
                                      [key]: e.target.checked,
                                    }));
                                  }
                                }}
                                className="w-4 h-4 accent-lime-400 rounded cursor-pointer"
                              />
                            </label>
                          )}

                          {/* Up / Down Controls */}
                          <div className="flex items-center gap-1 border-l border-zinc-800 pl-3">
                            <button
                              onClick={moveUp}
                              disabled={isFirst}
                              className="p-1.5 rounded-lg bg-zinc-800 hover:bg-zinc-700 text-zinc-300 disabled:opacity-20 cursor-pointer"
                              title="Move Up"
                            >
                              <ArrowUp className="w-3.5 h-3.5" />
                            </button>
                            <button
                              onClick={moveDown}
                              disabled={isLast}
                              className="p-1.5 rounded-lg bg-zinc-800 hover:bg-zinc-700 text-zinc-300 disabled:opacity-20 cursor-pointer"
                              title="Move Down"
                            >
                              <ArrowDown className="w-3.5 h-3.5" />
                            </button>
                          </div>
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>

              {/* Hero Banner Autoplay */}
              <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-3">
                <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                  Hero Banner Autoplay Speed
                </h3>
                <div className="flex items-center gap-4">
                  <input
                    type="range"
                    min="3"
                    max="15"
                    step="1"
                    value={config.home_screen.hero_banner_autoplay_speed || 5}
                    onChange={(e) =>
                      updateDomain('home_screen', (h) => ({
                        ...h,
                        hero_banner_autoplay_speed: parseInt(e.target.value, 10),
                      }))
                    }
                    className="flex-1 accent-lime-400 cursor-pointer"
                  />
                  <span className="text-sm font-mono font-bold text-lime-400 min-w-16 text-right">
                    {config.home_screen.hero_banner_autoplay_speed || 5}s
                  </span>
                </div>
                <p className="text-[11px] text-zinc-500">
                  Controls how many seconds each banner slide stays visible before transitioning.
                </p>
              </div>

              {/* Promo Banner Control */}
              <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4">
                <div className="flex items-center justify-between">
                  <div>
                    <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                      Channel Stream Promo Card
                    </h3>
                    <p className="text-[11px] text-zinc-500">
                      Inject a promotional VIP / Telegram banner card inside channel lists.
                    </p>
                  </div>
                  <input
                    type="checkbox"
                    checked={config.promo_banner.enabled}
                    onChange={(e) =>
                      updateDomain('promo_banner', (p) => ({ ...p, enabled: e.target.checked }))
                    }
                    className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                  />
                </div>

                {config.promo_banner.enabled && (
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-2">
                    <div>
                      <label className="text-xs font-semibold text-zinc-400 block mb-1">Title</label>
                      <input
                        type="text"
                        value={config.promo_banner.title}
                        onChange={(e) =>
                          updateDomain('promo_banner', (p) => ({ ...p, title: e.target.value }))
                        }
                        className="w-full bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs text-zinc-200"
                      />
                    </div>
                    <div>
                      <label className="text-xs font-semibold text-zinc-400 block mb-1">Subtitle</label>
                      <input
                        type="text"
                        value={config.promo_banner.subtitle}
                        onChange={(e) =>
                          updateDomain('promo_banner', (p) => ({ ...p, subtitle: e.target.value }))
                        }
                        className="w-full bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs text-zinc-200"
                      />
                    </div>
                    <div>
                      <label className="text-xs font-semibold text-zinc-400 block mb-1">Action URL</label>
                      <input
                        type="text"
                        value={config.promo_banner.action_url}
                        onChange={(e) =>
                          updateDomain('promo_banner', (p) => ({ ...p, action_url: e.target.value }))
                        }
                        className="w-full bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs text-zinc-200 font-mono"
                      />
                    </div>
                    <div>
                      <label className="text-xs font-semibold text-zinc-400 block mb-1">Badge Text</label>
                      <input
                        type="text"
                        value={config.promo_banner.badge_text}
                        onChange={(e) =>
                          updateDomain('promo_banner', (p) => ({ ...p, badge_text: e.target.value }))
                        }
                        className="w-full bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs text-zinc-200"
                      />
                    </div>
                  </div>
                )}
              </div>
            </div>
          )}

          {/* ─────────────────────────────────────────────────────────── */}
          {/* DOMAIN 5: NAVIGATION & BRANDING                            */}
          {/* ─────────────────────────────────────────────────────────── */}
          {activeDomain === 'navigation' && (
            <div className="space-y-6">
              <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                <div>
                  <h2 className="text-xl font-bold text-white flex items-center gap-2">
                    <Compass className="w-5 h-5 text-lime-400" />
                    Navigation & Branding Studio
                  </h2>
                  <p className="text-xs text-zinc-400 mt-1">
                    Customize the brand wordmark, bottom navigation bar items, and Smart TV defaults.
                  </p>
                </div>
                <button
                  type="button"
                  onClick={() => {
                    updateDomain('navigation_branding', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.navigation_branding)));
                    setNotification({ type: 'success', message: 'Navigation & Branding settings reset to default.' });
                  }}
                  className="inline-flex items-center gap-2 px-3.5 py-2 rounded-xl bg-zinc-800/80 hover:bg-zinc-700 text-xs font-semibold text-zinc-300 hover:text-white border border-zinc-700/70 transition-all cursor-pointer self-start sm:self-auto active:scale-95"
                >
                  <RotateCcw className="w-3.5 h-3.5 text-lime-400" />
                  Reset Navigation Defaults
                </button>
              </div>

              {/* Brand Wordmark */}
              <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-3">
                <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                  Global Brand Wordmark
                </h3>
                <div className="flex items-center gap-4">
                  <input
                    type="text"
                    value={config.navigation_branding.brand_wordmark}
                    onChange={(e) =>
                      updateDomain('navigation_branding', (n) => ({ ...n, brand_wordmark: e.target.value }))
                    }
                    className="flex-1 bg-zinc-950 border border-zinc-700 rounded-xl px-4 py-2.5 text-sm font-bold text-white tracking-widest uppercase"
                  />
                  <div className="px-4 py-2.5 rounded-xl bg-zinc-950 border border-zinc-800 text-xs font-mono text-zinc-400">
                    Header & Splash Text
                  </div>
                </div>
              </div>

              {/* Bottom Nav Bar Tabs */}
              <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4">
                <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                  Bottom Navigation Bar Tabs
                </h3>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  {[
                    { id: 'home', label: 'Home', desc: 'Main home feed' },
                    { id: 'categories', label: 'Categories', desc: 'Category cards screen' },
                    { id: 'channels', label: 'Channels', desc: 'Full channel directory' },
                    { id: 'upcoming', label: 'Upcoming', desc: 'PlayZ sports matches' },
                    { id: 'settings', label: 'Settings', desc: 'App preferences & updates' },
                  ].map((tab) => {
                    const isEnabled = config.navigation_branding.enabled_tabs.includes(tab.id);
                    return (
                      <label
                        key={tab.id}
                        className={`flex items-center justify-between p-3.5 rounded-xl border transition-all cursor-pointer ${
                          isEnabled
                            ? 'bg-zinc-950/80 border-zinc-800'
                            : 'bg-zinc-950/30 border-zinc-800/40 opacity-50'
                        }`}
                      >
                        <div>
                          <span className="text-xs font-bold text-white block">{tab.label}</span>
                          <span className="text-[11px] text-zinc-500">{tab.desc}</span>
                        </div>
                        <input
                          type="checkbox"
                          checked={isEnabled}
                          onChange={(e) => {
                            const newTabs = e.target.checked
                              ? [...config.navigation_branding.enabled_tabs, tab.id]
                              : config.navigation_branding.enabled_tabs.filter((t) => t !== tab.id);
                            // Safety guarantee: at least one tab must stay active
                            if (newTabs.length > 0) {
                              updateDomain('navigation_branding', (n) => ({
                                ...n,
                                enabled_tabs: newTabs,
                              }));
                            }
                          }}
                          className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                        />
                      </label>
                    );
                  })}
                </div>
              </div>

              {/* TV Experience */}
              <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4">
                <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400 flex items-center gap-2">
                  <Monitor className="w-4 h-4 text-lime-400" />
                  Android TV & Remote Experience
                </h3>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="text-xs font-semibold text-zinc-300 block mb-1.5">
                      Default Launch Screen for TV
                    </label>
                    <select
                      value={config.tv_experience.default_start_screen}
                      onChange={(e) =>
                        updateDomain('tv_experience', (tv) => ({
                          ...tv,
                          default_start_screen: e.target.value,
                        }))
                      }
                      className="w-full bg-zinc-950 border border-zinc-700 rounded-xl px-3.5 py-2.5 text-xs text-zinc-200"
                    >
                      <option value="home">Home Feed</option>
                      <option value="channels">Channels Grid</option>
                    </select>
                  </div>

                  <label className="flex items-center justify-between p-3.5 rounded-xl bg-zinc-950/70 border border-zinc-800 hover:border-zinc-700 cursor-pointer">
                    <div>
                      <span className="text-xs font-bold text-white block">Focus Glow Effect</span>
                      <span className="text-[11px] text-zinc-400">Vibrant border shadow on D-Pad focus</span>
                    </div>
                    <input
                      type="checkbox"
                      checked={config.tv_experience.enable_focus_glow}
                      onChange={(e) =>
                        updateDomain('tv_experience', (tv) => ({
                          ...tv,
                          enable_focus_glow: e.target.checked,
                        }))
                      }
                      className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                    />
                  </label>
                </div>
              </div>
            </div>
          )}

          {/* ─────────────────────────────────────────────────────────── */}
          {/* DOMAIN 6: SEARCH & SPORTS                                  */}
          {/* ─────────────────────────────────────────────────────────── */}
          {activeDomain === 'search' && (
            <div className="space-y-6">
              <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                <div>
                  <h2 className="text-xl font-bold text-white flex items-center gap-2">
                    <Search className="w-5 h-5 text-lime-400" />
                    Search & Sports Fixtures Configuration
                  </h2>
                  <p className="text-xs text-zinc-400 mt-1">
                    Manage discovery tags in the search screen and fixture card animation indicators.
                  </p>
                </div>
                <button
                  type="button"
                  onClick={() => {
                    updateDomain('search_config', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.search_config)));
                    updateDomain('sports_cards', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.sports_cards)));
                    setNotification({ type: 'success', message: 'Search & Sports settings reset to default.' });
                  }}
                  className="inline-flex items-center gap-2 px-3.5 py-2 rounded-xl bg-zinc-800/80 hover:bg-zinc-700 text-xs font-semibold text-zinc-300 hover:text-white border border-zinc-700/70 transition-all cursor-pointer self-start sm:self-auto active:scale-95"
                >
                  <RotateCcw className="w-3.5 h-3.5 text-lime-400" />
                  Reset Search Defaults
                </button>
              </div>

              {/* Popular Search Tags */}
              <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4">
                <div className="flex items-center justify-between">
                  <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                    Popular Search Discovery Chips ({config.search_config.popular_tags.length})
                  </h3>
                </div>

                {/* Tag Pills */}
                <div className="flex flex-wrap gap-2">
                  {config.search_config.popular_tags.map((tag, i) => (
                    <div
                      key={i}
                      className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-zinc-950 border border-zinc-800 text-xs text-zinc-200"
                    >
                      <span>{tag.label}</span>
                      <button
                        onClick={() => {
                          const updated = config.search_config.popular_tags.filter((_, idx) => idx !== i);
                          updateDomain('search_config', (s) => ({ ...s, popular_tags: updated }));
                        }}
                        className="text-zinc-500 hover:text-red-400 ml-1 cursor-pointer"
                        title="Remove tag"
                      >
                        <Trash2 className="w-3 h-3" />
                      </button>
                    </div>
                  ))}
                </div>

                {/* Add New Tag */}
                <div className="flex flex-col sm:flex-row items-center gap-2 pt-2 border-t border-zinc-800">
                  <input
                    type="text"
                    placeholder="Display Label (e.g. 🎾 Tennis)"
                    value={newTagLabel}
                    onChange={(e) => setNewTagLabel(e.target.value)}
                    className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs text-zinc-200"
                  />
                  <input
                    type="text"
                    placeholder="Search Query (e.g. Tennis)"
                    value={newTagQuery}
                    onChange={(e) => setNewTagQuery(e.target.value)}
                    className="flex-1 bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs text-zinc-200"
                  />
                  <button
                    onClick={() => {
                      if (!newTagLabel.trim() || !newTagQuery.trim()) return;
                      const updated = [
                        ...config.search_config.popular_tags,
                        { label: newTagLabel.trim(), query: newTagQuery.trim() },
                      ];
                      updateDomain('search_config', (s) => ({ ...s, popular_tags: updated }));
                      setNewTagLabel('');
                      setNewTagQuery('');
                    }}
                    disabled={!newTagLabel.trim() || !newTagQuery.trim()}
                    className="px-4 py-2 rounded-lg bg-lime-400 hover:bg-lime-300 disabled:opacity-40 text-zinc-950 text-xs font-bold flex items-center gap-1.5 cursor-pointer"
                  >
                    <Plus className="w-3.5 h-3.5" />
                    Add Tag
                  </button>
                </div>
              </div>

              {/* Sports Cards Options */}
              <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4">
                <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                  PlayZ TV Sports Cards Indicators
                </h3>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <label className="flex items-center justify-between p-3.5 rounded-xl bg-zinc-950/70 border border-zinc-800 hover:border-zinc-700 cursor-pointer">
                    <div>
                      <span className="text-xs font-bold text-white block">Pulsing Live Indicator</span>
                      <span className="text-[11px] text-zinc-400">Animated glowing red pulse for live events</span>
                    </div>
                    <input
                      type="checkbox"
                      checked={config.sports_cards.show_live_pulse}
                      onChange={(e) =>
                        updateDomain('sports_cards', (s) => ({ ...s, show_live_pulse: e.target.checked }))
                      }
                      className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                    />
                  </label>

                  <label className="flex items-center justify-between p-3.5 rounded-xl bg-zinc-950/70 border border-zinc-800 hover:border-zinc-700 cursor-pointer">
                    <div>
                      <span className="text-xs font-bold text-white block">Upcoming Countdown Timer</span>
                      <span className="text-[11px] text-zinc-400">Live countdown to kickoff (e.g. 02:45:10)</span>
                    </div>
                    <input
                      type="checkbox"
                      checked={config.sports_cards.show_countdown_timer}
                      onChange={(e) =>
                        updateDomain('sports_cards', (s) => ({
                          ...s,
                          show_countdown_timer: e.target.checked,
                        }))
                      }
                      className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                    />
                  </label>
                </div>
              </div>
            </div>
          )}

          {/* ─────────────────────────────────────────────────────────── */}
          {/* DOMAIN 7: PLAYER ENGINE DEFAULTS                           */}
          {/* ─────────────────────────────────────────────────────────── */}
          {activeDomain === 'player' && (
            <div className="space-y-6">
              <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                <div>
                  <h2 className="text-xl font-bold text-white flex items-center gap-2">
                    <PlayCircle className="w-5 h-5 text-lime-400" />
                    Player Engine Defaults
                  </h2>
                  <p className="text-xs text-zinc-400 mt-1">
                    Configure default video playback settings, retry strategies, and aspect ratios.
                  </p>
                </div>
                <button
                  type="button"
                  onClick={() => {
                    updateDomain('player_defaults', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.player_defaults)));
                    updateDomain('tv_experience', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.tv_experience)));
                    setNotification({ type: 'success', message: 'Player Engine & Android TV defaults reset to default.' });
                  }}
                  className="inline-flex items-center gap-2 px-3.5 py-2 rounded-xl bg-zinc-800/80 hover:bg-zinc-700 text-xs font-semibold text-zinc-300 hover:text-white border border-zinc-700/70 transition-all cursor-pointer self-start sm:self-auto active:scale-95"
                >
                  <RotateCcw className="w-3.5 h-3.5 text-lime-400" />
                  Reset Player Defaults
                </button>
              </div>

              <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4">
                <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                  Buffer & Display Defaults
                </h3>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="text-xs font-semibold text-zinc-300 block mb-1.5">
                      Stream Buffer Strategy
                    </label>
                    <select
                      value={config.player_defaults.default_buffer_mode}
                      onChange={(e) =>
                        updateDomain('player_defaults', (p) => ({
                          ...p,
                          default_buffer_mode: e.target.value,
                        }))
                      }
                      className="w-full bg-zinc-950 border border-zinc-700 rounded-xl px-3.5 py-2.5 text-xs text-zinc-200"
                    >
                      <option value="Fast Load">Fast Load (Minimal prebuffering)</option>
                      <option value="Balanced">Balanced (Standard 4s buffer)</option>
                      <option value="High Stability">High Stability (Deeper buffer)</option>
                    </select>
                  </div>

                  <div>
                    <label className="text-xs font-semibold text-zinc-300 block mb-1.5">
                      Default Aspect Ratio
                    </label>
                    <select
                      value={config.player_defaults.default_aspect_ratio}
                      onChange={(e) =>
                        updateDomain('player_defaults', (p) => ({
                          ...p,
                          default_aspect_ratio: e.target.value,
                        }))
                      }
                      className="w-full bg-zinc-950 border border-zinc-700 rounded-xl px-3.5 py-2.5 text-xs text-zinc-200"
                    >
                      <option value="16:9 (Fit)">16:9 (Fit screen without distortion)</option>
                      <option value="Stretch">Stretch (Fill full viewport)</option>
                      <option value="Original">Original (Source dimensions)</option>
                    </select>
                  </div>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-2">
                  <label className="flex items-center justify-between p-3.5 rounded-xl bg-zinc-950/70 border border-zinc-800 hover:border-zinc-700 cursor-pointer">
                    <div>
                      <span className="text-xs font-bold text-white block">Auto-Retry On Stream Error</span>
                      <span className="text-[11px] text-zinc-400">Re-requests token & reconnects automatically</span>
                    </div>
                    <input
                      type="checkbox"
                      checked={config.player_defaults.auto_retry_on_error}
                      onChange={(e) =>
                        updateDomain('player_defaults', (p) => ({
                          ...p,
                          auto_retry_on_error: e.target.checked,
                        }))
                      }
                      className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                    />
                  </label>

                  <label className="flex items-center justify-between p-3.5 rounded-xl bg-zinc-950/70 border border-zinc-800 hover:border-zinc-700 cursor-pointer">
                    <div>
                      <span className="text-xs font-bold text-white block">Picture-in-Picture (PiP)</span>
                      <span className="text-[11px] text-zinc-400">Allow floating mini player on home exit</span>
                    </div>
                    <input
                      type="checkbox"
                      checked={config.player_defaults.enable_pip}
                      onChange={(e) =>
                        updateDomain('player_defaults', (p) => ({
                          ...p,
                          enable_pip: e.target.checked,
                        }))
                      }
                      className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                    />
                  </label>
                </div>
              </div>

              {/* Stream Reporting */}
              <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4">
                <div className="flex items-center justify-between">
                  <div>
                    <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                      Broken Stream Report Button
                    </h3>
                    <p className="text-[11px] text-zinc-500">
                      Allows viewers to report offline or broken streams directly to support.
                    </p>
                  </div>
                  <input
                    type="checkbox"
                    checked={config.stream_reporting.enabled}
                    onChange={(e) =>
                      updateDomain('stream_reporting', (s) => ({ ...s, enabled: e.target.checked }))
                    }
                    className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                  />
                </div>

                {config.stream_reporting.enabled && (
                  <div>
                    <label className="text-xs font-semibold text-zinc-300 block mb-1">
                      Support Telegram Bot / Report URL
                    </label>
                    <input
                      type="text"
                      value={config.stream_reporting.report_url}
                      onChange={(e) =>
                        updateDomain('stream_reporting', (s) => ({ ...s, report_url: e.target.value }))
                      }
                      className="w-full bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs text-zinc-200 font-mono"
                    />
                  </div>
                )}
              </div>
            </div>
          )}

          {/* ─────────────────────────────────────────────────────────── */}
          {/* DOMAIN 8: COMMUNITY & OTA UPDATES                          */}
          {/* ─────────────────────────────────────────────────────────── */}
          {activeDomain === 'community' && (
            <div className="space-y-6">
              <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                <div>
                  <h2 className="text-xl font-bold text-white flex items-center gap-2">
                    <MessageCircle className="w-5 h-5 text-lime-400" />
                    Community Links & In-App OTA Updates
                  </h2>
                  <p className="text-xs text-zinc-400 mt-1">
                    Manage social support channels and set over-the-air client APK version thresholds.
                  </p>
                </div>
                <button
                  type="button"
                  onClick={() => {
                    updateDomain('community_links', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.community_links)));
                    updateDomain('stream_reporting', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.stream_reporting)));
                    setNotification({ type: 'success', message: 'Community Links & Reporting reset to default.' });
                  }}
                  className="inline-flex items-center gap-2 px-3.5 py-2 rounded-xl bg-zinc-800/80 hover:bg-zinc-700 text-xs font-semibold text-zinc-300 hover:text-white border border-zinc-700/70 transition-all cursor-pointer self-start sm:self-auto active:scale-95"
                >
                  <RotateCcw className="w-3.5 h-3.5 text-lime-400" />
                  Reset Community Defaults
                </button>
              </div>

              {/* Community Links */}
              <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4">
                <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                  Official Community & Social Links
                </h3>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="text-xs font-semibold text-zinc-300 block mb-1">
                      Telegram Channel URL
                    </label>
                    <input
                      type="text"
                      value={config.community_links.telegram_url}
                      onChange={(e) =>
                        updateDomain('community_links', (c) => ({ ...c, telegram_url: e.target.value }))
                      }
                      className="w-full bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs text-zinc-200 font-mono"
                      placeholder="https://t.me/goplay_official"
                    />
                  </div>

                  <div>
                    <label className="text-xs font-semibold text-zinc-300 block mb-1">
                      Discord Server URL
                    </label>
                    <input
                      type="text"
                      value={config.community_links.discord_url}
                      onChange={(e) =>
                        updateDomain('community_links', (c) => ({ ...c, discord_url: e.target.value }))
                      }
                      className="w-full bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs text-zinc-200 font-mono"
                      placeholder="https://discord.gg/..."
                    />
                  </div>

                  <div>
                    <label className="text-xs font-semibold text-zinc-300 block mb-1">
                      WhatsApp Support URL
                    </label>
                    <input
                      type="text"
                      value={config.community_links.whatsapp_url}
                      onChange={(e) =>
                        updateDomain('community_links', (c) => ({ ...c, whatsapp_url: e.target.value }))
                      }
                      className="w-full bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs text-zinc-200 font-mono"
                      placeholder="https://wa.me/..."
                    />
                  </div>

                  <div>
                    <label className="text-xs font-semibold text-zinc-300 block mb-1">
                      Official Portal Website
                    </label>
                    <input
                      type="text"
                      value={config.community_links.website_url}
                      onChange={(e) =>
                        updateDomain('community_links', (c) => ({ ...c, website_url: e.target.value }))
                      }
                      className="w-full bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs text-zinc-200 font-mono"
                      placeholder="https://goplay.tv"
                    />
                  </div>
                </div>
              </div>

              {/* OTA Updates */}
              <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4">
                <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                  Over-The-Air (OTA) APK Distribution
                </h3>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="text-xs font-semibold text-zinc-300 block mb-1">
                      Latest Released Version
                    </label>
                    <input
                      type="text"
                      value={config.ota_updates.latest_version}
                      onChange={(e) =>
                        updateDomain('ota_updates', (u) => ({ ...u, latest_version: e.target.value }))
                      }
                      className="w-full bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs text-zinc-200 font-mono"
                      placeholder="2.2.0"
                    />
                  </div>

                  <div>
                    <label className="text-xs font-semibold text-zinc-300 block mb-1">
                      Minimum Supported Version (Mandatory update cutoff)
                    </label>
                    <input
                      type="text"
                      value={config.ota_updates.min_version}
                      onChange={(e) =>
                        updateDomain('ota_updates', (u) => ({ ...u, min_version: e.target.value }))
                      }
                      className="w-full bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs text-zinc-200 font-mono"
                      placeholder="2.0.0"
                    />
                  </div>

                  <div className="sm:col-span-2">
                    <label className="text-xs font-semibold text-zinc-300 block mb-1">
                      Direct APK Download URL
                    </label>
                    <input
                      type="text"
                      value={config.ota_updates.apk_url}
                      onChange={(e) =>
                        updateDomain('ota_updates', (u) => ({ ...u, apk_url: e.target.value }))
                      }
                      className="w-full bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs text-zinc-200 font-mono"
                      placeholder="https://cdn.ntechbd.app/goplay-latest.apk"
                    />
                  </div>

                  <div className="sm:col-span-2">
                    <label className="text-xs font-semibold text-zinc-300 block mb-1">
                      Release Notes (Changelog)
                    </label>
                    <textarea
                      rows={3}
                      value={config.ota_updates.release_notes}
                      onChange={(e) =>
                        updateDomain('ota_updates', (u) => ({ ...u, release_notes: e.target.value }))
                      }
                      className="w-full bg-zinc-950 border border-zinc-700 rounded-lg p-3 text-xs text-zinc-200"
                    />
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* ─────────────────────────────────────────────────────────── */}
          {/* DOMAIN 9: BROADCASTS & EMERGENCY LOCK                      */}
          {/* ─────────────────────────────────────────────────────────── */}
          {activeDomain === 'broadcasts' && (
            <div className="space-y-6">
              <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                <div>
                  <h2 className="text-xl font-bold text-white flex items-center gap-2">
                    <AlertOctagon className="w-5 h-5 text-red-400" />
                    Emergency Maintenance & Broadcast Modals
                  </h2>
                  <p className="text-xs text-zinc-400 mt-1">
                    Trigger full maintenance lockdowns or push launch modal popups to all app instances.
                  </p>
                </div>
                <button
                  type="button"
                  onClick={() => {
                    updateDomain('broadcasts', () => JSON.parse(JSON.stringify(DEFAULT_UI_CONFIG.broadcasts)));
                    setNotification({ type: 'success', message: 'Emergency Mode settings reset to default.' });
                  }}
                  className="inline-flex items-center gap-2 px-3.5 py-2 rounded-xl bg-zinc-800/80 hover:bg-zinc-700 text-xs font-semibold text-zinc-300 hover:text-white border border-zinc-700/70 transition-all cursor-pointer self-start sm:self-auto active:scale-95"
                >
                  <RotateCcw className="w-3.5 h-3.5 text-lime-400" />
                  Reset Emergency Defaults
                </button>
              </div>

              {/* Maintenance Mode Lock */}
              <div
                className={`p-5 rounded-2xl border transition-all ${
                  config.broadcasts.is_maintenance_enabled
                    ? 'bg-red-950/30 border-red-600/70 shadow-lg shadow-red-900/20'
                    : 'bg-zinc-900 border-zinc-800'
                }`}
              >
                <div className="flex items-center justify-between pb-3 border-b border-zinc-800">
                  <div className="flex items-center gap-2.5">
                    <ShieldAlert
                      className={`w-5 h-5 ${
                        config.broadcasts.is_maintenance_enabled ? 'text-red-400' : 'text-zinc-400'
                      }`}
                    />
                    <div>
                      <h3 className="text-sm font-bold text-white">Emergency Maintenance Mode Lock</h3>
                      <p className="text-[11px] text-zinc-400">
                        Locks the entire mobile and TV app behind an animated maintenance screen.
                      </p>
                    </div>
                  </div>
                  <input
                    type="checkbox"
                    checked={config.broadcasts.is_maintenance_enabled}
                    onChange={(e) =>
                      updateDomain('broadcasts', (b) => ({
                        ...b,
                        is_maintenance_enabled: e.target.checked,
                      }))
                    }
                    className="w-6 h-6 accent-red-500 rounded cursor-pointer"
                  />
                </div>

                {config.broadcasts.is_maintenance_enabled && (
                  <div className="mt-4 space-y-3">
                    <div>
                      <label className="text-xs font-semibold text-red-300 block mb-1">
                        Maintenance Screen Title
                      </label>
                      <input
                        type="text"
                        value={config.broadcasts.maintenance_title}
                        onChange={(e) =>
                          updateDomain('broadcasts', (b) => ({
                            ...b,
                            maintenance_title: e.target.value,
                          }))
                        }
                        className="w-full bg-zinc-950 border border-red-800/80 rounded-lg px-3 py-2 text-xs text-white"
                      />
                    </div>
                    <div>
                      <label className="text-xs font-semibold text-red-300 block mb-1">
                        Maintenance Explanation Message
                      </label>
                      <textarea
                        rows={2}
                        value={config.broadcasts.maintenance_message}
                        onChange={(e) =>
                          updateDomain('broadcasts', (b) => ({
                            ...b,
                            maintenance_message: e.target.value,
                          }))
                        }
                        className="w-full bg-zinc-950 border border-red-800/80 rounded-lg p-3 text-xs text-white"
                      />
                    </div>
                  </div>
                )}
              </div>

              {/* Popup Modal Announcement */}
              <div className="p-5 rounded-2xl bg-zinc-900 border border-zinc-800 space-y-4">
                <div className="flex items-center justify-between pb-3 border-b border-zinc-800">
                  <div>
                    <h3 className="text-xs font-bold uppercase tracking-wider text-zinc-400">
                      Launch Announcement Popup Modal
                    </h3>
                    <p className="text-[11px] text-zinc-500">
                      Shows a beautiful launch modal to users once when they open the app.
                    </p>
                  </div>
                  <input
                    type="checkbox"
                    checked={config.broadcasts.is_popup_enabled}
                    onChange={(e) =>
                      updateDomain('broadcasts', (b) => ({
                        ...b,
                        is_popup_enabled: e.target.checked,
                      }))
                    }
                    className="w-5 h-5 accent-lime-400 rounded cursor-pointer"
                  />
                </div>

                {config.broadcasts.is_popup_enabled && (
                  <div className="space-y-4 pt-1">
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                      <div>
                        <label className="text-xs font-semibold text-zinc-300 block mb-1">
                          Unique Popup ID (Bumping this resets dismissed status for all users)
                        </label>
                        <input
                          type="text"
                          value={config.broadcasts.popup_id}
                          onChange={(e) =>
                            updateDomain('broadcasts', (b) => ({ ...b, popup_id: e.target.value }))
                          }
                          className="w-full bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs text-zinc-200 font-mono"
                        />
                      </div>

                      <div>
                        <label className="text-xs font-semibold text-zinc-300 block mb-1">
                          Popup Title
                        </label>
                        <input
                          type="text"
                          value={config.broadcasts.popup_title}
                          onChange={(e) =>
                            updateDomain('broadcasts', (b) => ({ ...b, popup_title: e.target.value }))
                          }
                          className="w-full bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs text-zinc-200"
                        />
                      </div>

                      <div className="sm:col-span-2">
                        <label className="text-xs font-semibold text-zinc-300 block mb-1">
                          Announcement Body Text
                        </label>
                        <textarea
                          rows={2}
                          value={config.broadcasts.popup_message}
                          onChange={(e) =>
                            updateDomain('broadcasts', (b) => ({ ...b, popup_message: e.target.value }))
                          }
                          className="w-full bg-zinc-950 border border-zinc-700 rounded-lg p-3 text-xs text-zinc-200"
                        />
                      </div>

                      <div>
                        <label className="text-xs font-semibold text-zinc-300 block mb-1">
                          Banner Image URL (Optional)
                        </label>
                        <input
                          type="text"
                          value={config.broadcasts.popup_image_url}
                          onChange={(e) =>
                            updateDomain('broadcasts', (b) => ({ ...b, popup_image_url: e.target.value }))
                          }
                          className="w-full bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs text-zinc-200 font-mono"
                          placeholder="https://..."
                        />
                      </div>

                      <div>
                        <label className="text-xs font-semibold text-zinc-300 block mb-1">
                          Action Button Label
                        </label>
                        <input
                          type="text"
                          value={config.broadcasts.popup_action_label}
                          onChange={(e) =>
                            updateDomain('broadcasts', (b) => ({
                              ...b,
                              popup_action_label: e.target.value,
                            }))
                          }
                          className="w-full bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs text-zinc-200"
                        />
                      </div>

                      <div className="sm:col-span-2">
                        <label className="text-xs font-semibold text-zinc-300 block mb-1">
                          Action Target URL (Opens browser or external link)
                        </label>
                        <input
                          type="text"
                          value={config.broadcasts.popup_action_url}
                          onChange={(e) =>
                            updateDomain('broadcasts', (b) => ({
                              ...b,
                              popup_action_url: e.target.value,
                            }))
                          }
                          className="w-full bg-zinc-950 border border-zinc-700 rounded-lg px-3 py-2 text-xs text-zinc-200 font-mono"
                          placeholder="https://t.me/..."
                        />
                      </div>
                    </div>
                  </div>
                )}
              </div>
            </div>
          )}
        </main>
      </div>

      {/* ── Reset to Defaults Modal ─────────────────────────────── */}
      {showResetModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm animate-in fade-in duration-200">
          <div className="w-full max-w-md bg-zinc-900 border border-zinc-700/80 rounded-2xl p-6 shadow-2xl space-y-5">
            <div className="flex items-start gap-4">
              <div className="w-10 h-10 rounded-xl bg-rose-500/15 border border-rose-500/30 flex items-center justify-center text-rose-400 flex-shrink-0">
                <RotateCcw className="w-5 h-5" />
              </div>
              <div>
                <h3 className="text-base font-bold text-white">Reset to Default Settings?</h3>
                <p className="text-xs text-zinc-400 mt-1 leading-relaxed">
                  Choose how you want to restore the defaults. Changes will be staged so you can inspect before publishing.
                </p>
              </div>
            </div>

            <div className="space-y-3 pt-1">
              <button
                type="button"
                onClick={() => {
                  handleResetCurrentDomain();
                  setShowResetModal(false);
                }}
                className="w-full p-3.5 rounded-xl bg-zinc-800/80 hover:bg-zinc-800 border border-zinc-700 text-left transition-all cursor-pointer group"
              >
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold text-zinc-200 group-hover:text-lime-400 transition-colors">
                    Reset Current Tab ({navDomains.find((d) => d.id === activeDomain)?.label || activeDomain})
                  </span>
                  <RotateCcw className="w-3.5 h-3.5 text-zinc-500 group-hover:text-lime-400 transition-colors" />
                </div>
                <p className="text-[11px] text-zinc-400 mt-1">
                  Only restores the settings on the currently open screen/tab to their initial baseline.
                </p>
              </button>

              <button
                type="button"
                onClick={() => {
                  handleResetAllToDefaults();
                  setShowResetModal(false);
                }}
                className="w-full p-3.5 rounded-xl bg-rose-500/10 hover:bg-rose-500/20 border border-rose-500/30 text-left transition-all cursor-pointer group"
              >
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold text-rose-300 group-hover:text-rose-200 transition-colors">
                    Reset Entire App Studio to Factory Defaults
                  </span>
                  <RotateCcw className="w-3.5 h-3.5 text-rose-400" />
                </div>
                <p className="text-[11px] text-rose-300/70 mt-1">
                  Reverts all palettes (GoPlay Volt #C8FF00, #0F0F0F), component styles, cards, and layouts.
                </p>
              </button>
            </div>

            <div className="flex items-center justify-end gap-3 pt-2 border-t border-zinc-800">
              <button
                type="button"
                onClick={() => setShowResetModal(false)}
                className="px-4 py-2 rounded-xl text-xs font-semibold text-zinc-400 hover:text-white hover:bg-zinc-800 transition-all cursor-pointer"
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
