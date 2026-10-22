import React from 'react';
import {
  LayoutDashboard,
  Radio,
  Sliders,
  Workflow,
  Layers,
  Tv,
  TrendingUp,
  List,
  ImageIcon,
  Calendar,
  Bell,
  Shield,
  Users,
} from 'lucide-react';

export interface NavItemDef {
  id: string;
  label: string;
  href: string;
  icon: React.ComponentType<{ className?: string }>;
  badge?: {
    text: string;
    variant: 'violet' | 'amber' | 'rose' | 'emerald' | 'cyan';
  };
  description: string;
  keywords: string[];
}

export interface NavGroupDef {
  groupTitle: string;
  items: NavItemDef[];
}

export const NAV_GROUPS: NavGroupDef[] = [
  {
    groupTitle: 'Core',
    items: [
      {
        id: 'overview',
        label: 'Overview',
        href: '/dashboard/overview',
        icon: LayoutDashboard,
        description: 'System metrics, telemetry KPIs & quick management shortcuts',
        keywords: ['home', 'dashboard', 'stats', 'analytics', 'kpi', 'summary'],
      },
    ],
  },
  {
    groupTitle: 'Studios & Engine',
    items: [
      {
        id: 'livetv',
        label: 'Live TV Studio',
        href: '/dashboard/livetv',
        icon: Radio,
        badge: { text: 'STUDIO', variant: 'rose' },
        description: 'Interactive HLS player, stream tester & bitrate diagnostic lab',
        keywords: ['stream', 'player', 'hls', 'video', 'm3u8', 'test', 'tester'],
      },
      {
        id: 'app-ui',
        label: 'App UI Studio',
        href: '/dashboard/app-ui',
        icon: Sliders,
        badge: { text: 'DYNAMIC', variant: 'violet' },
        description: 'Live layout builder, card radii, color schemes & component tokens',
        keywords: ['design', 'ui', 'mobile', 'theme', 'colors', 'layout', 'cards', 'customization'],
      },
      {
        id: 'automations',
        label: 'Automations & Sync',
        href: '/dashboard/automations',
        icon: Workflow,
        badge: { text: 'AUTO', variant: 'amber' },
        description: 'Automated M3U playlist ingest, EPG cron jobs & auto-sync tasks',
        keywords: ['cron', 'sync', 'automation', 'm3u', 'epg', 'import', 'playlist'],
      },
    ],
  },
  {
    groupTitle: 'Content Catalog',
    items: [
      {
        id: 'categories',
        label: 'Categories',
        href: '/dashboard/categories',
        icon: Layers,
        description: 'Channel categories, icon mappings, display orders & genre filters',
        keywords: ['genres', 'sections', 'groups', 'organize', 'taxonomy'],
      },
      {
        id: 'channels',
        label: 'Channels',
        href: '/dashboard/channels',
        icon: Tv,
        description: 'Live broadcast channels, proxy routing toggles & stream configurations',
        keywords: ['tv', 'streams', 'proxy', 'm3u8', 'links', 'broadcast', 'stations'],
      },
      {
        id: 'trending',
        label: 'Trending',
        href: '/dashboard/trending',
        icon: TrendingUp,
        description: 'Curated trending channels, featured ranks & hot list management',
        keywords: ['popular', 'featured', 'hot', 'curation', 'top channels'],
      },
      {
        id: 'playlists',
        label: 'Playlists',
        href: '/dashboard/playlists',
        icon: List,
        description: 'Custom curated station collections, regional packages & themes',
        keywords: ['bundles', 'collections', 'packages', 'grouping'],
      },
      {
        id: 'banners',
        label: 'Hero Banners',
        href: '/dashboard/banners',
        icon: ImageIcon,
        description: 'Mobile top carousel spotlights, promotional promos & action links',
        keywords: ['slider', 'hero', 'promotions', 'carousel', 'ads', 'spotlight'],
      },
      {
        id: 'events',
        label: 'Sports Matches',
        href: '/dashboard/events',
        icon: Calendar,
        description: 'Live match fixtures, league banners, team emblems & countdown timers',
        keywords: ['football', 'cricket', 'soccer', 'sports', 'fixtures', 'live score', 'matches'],
      },
    ],
  },
  {
    groupTitle: 'Operations & Health',
    items: [
      {
        id: 'announcements',
        label: 'Announcements',
        href: '/dashboard/announcements',
        icon: Bell,
        description: 'Global push broadcasts, emergency alert bars & user popups',
        keywords: ['alerts', 'notifications', 'messages', 'broadcast', 'banner message'],
      },
      {
        id: 'channel-monitor',
        label: 'Channel Monitor',
        href: '/admin/channel-monitor',
        icon: Shield,
        description: 'Automated 24/7 stream health probing, response latency & uptime',
        keywords: ['uptime', 'health', 'probe', 'ping', 'status', 'broken links'],
      },
      {
        id: 'analytics',
        label: 'User Analytics',
        href: '/admin/analytics',
        icon: Users,
        description: 'Real-time viewer telemetry, device breakdowns, peak times & geo-stats',
        keywords: ['viewers', 'dau', 'traffic', 'devices', 'metrics', 'retention'],
      },
    ],
  },
];

export const ALL_NAV_ITEMS: NavItemDef[] = NAV_GROUPS.flatMap((g) => g.items);

export function getNavItemByPath(pathname: string): NavItemDef | undefined {
  return ALL_NAV_ITEMS.find((item) => pathname.startsWith(item.href));
}
