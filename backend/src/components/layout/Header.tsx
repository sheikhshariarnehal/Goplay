'use client';

import React, { useState, useRef, useEffect } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import {
  Menu,
  Search,
  ChevronRight,
  Shield,
  RefreshCw,
  Bell,
  LogOut,
  Sliders,
  Radio,
  ExternalLink,
  ChevronDown,
  CheckCircle2,
  Sparkles,
} from 'lucide-react';
import { getNavItemByPath } from './nav-data';

interface HeaderProps {
  onToggleMobileMenu: () => void;
  onOpenCommandPalette: () => void;
  activeUsersCount: number;
  announcementsCount?: number;
  onRefreshStats: () => void;
  onLogout: () => void;
}

export default function Header({
  onToggleMobileMenu,
  onOpenCommandPalette,
  activeUsersCount,
  announcementsCount = 0,
  onRefreshStats,
  onLogout,
}: HeaderProps) {
  const pathname = usePathname();
  const currentItem = getNavItemByPath(pathname);

  const [isProfileMenuOpen, setIsProfileMenuOpen] = useState(false);
  const [isRefreshing, setIsRefreshing] = useState(false);
  const profileMenuRef = useRef<HTMLDivElement>(null);

  // Close profile dropdown on outside click
  useEffect(() => {
    const handleOutsideClick = (event: MouseEvent) => {
      if (
        profileMenuRef.current &&
        !profileMenuRef.current.contains(event.target as Node)
      ) {
        setIsProfileMenuOpen(false);
      }
    };
    document.addEventListener('mousedown', handleOutsideClick);
    return () => document.removeEventListener('mousedown', handleOutsideClick);
  }, []);

  const handleRefreshClick = () => {
    setIsRefreshing(true);
    onRefreshStats();
    setTimeout(() => {
      setIsRefreshing(false);
    }, 700);
  };

  const Icon = currentItem?.icon;

  return (
    <header className="sticky top-0 z-30 flex items-center justify-between gap-4 px-4 sm:px-6 lg:px-8 py-3 bg-zinc-900/85 backdrop-blur-md border-b border-zinc-800/80 transition-colors">
      {/* ── Left: Mobile Toggle & Dynamic Breadcrumbs ─────── */}
      <div className="flex items-center gap-3 min-w-0">
        <button
          onClick={onToggleMobileMenu}
          className="lg:hidden p-2 rounded-xl bg-zinc-800/60 border border-zinc-700/60 text-zinc-300 hover:text-white transition-all cursor-pointer focus:outline-none"
          aria-label="Toggle menu"
        >
          <Menu className="w-5 h-5" />
        </button>

        {/* Brand mark on mobile */}
        <div className="flex items-center gap-2 lg:hidden">
          <div className="w-7 h-7 rounded-lg bg-gradient-to-tr from-violet-600 to-pink-600 flex items-center justify-center text-white font-extrabold text-xs shadow-sm">
            G
          </div>
        </div>

        {/* Breadcrumb Navigation */}
        <nav aria-label="Breadcrumb" className="flex items-center gap-2 text-sm min-w-0">
          <Link
            href="/dashboard/overview"
            className="text-zinc-500 hover:text-zinc-300 transition-colors hidden sm:inline-flex items-center gap-1 font-medium"
          >
            Dashboard
          </Link>

          <ChevronRight className="w-3.5 h-3.5 text-zinc-700 hidden sm:inline flex-shrink-0" />

          <div className="flex items-center gap-2 min-w-0">
            {Icon && (
              <div className="w-5 h-5 rounded-md bg-zinc-800/80 border border-zinc-700/60 flex items-center justify-center text-violet-400 flex-shrink-0">
                <Icon className="w-3 h-3" />
              </div>
            )}
            <span className="text-zinc-100 font-semibold truncate tracking-tight text-sm sm:text-base">
              {currentItem?.label ?? 'Dashboard'}
            </span>

            {currentItem?.badge && (
              <span className="hidden md:inline-flex px-1.5 py-0.5 rounded-full text-[9px] font-mono font-bold tracking-wider bg-violet-500/20 text-violet-300 border border-violet-500/30">
                {currentItem.badge.text}
              </span>
            )}
          </div>
        </nav>
      </div>

      {/* ── Center: Search Trigger (Command Palette) ────────── */}
      <div className="flex-1 max-w-md hidden md:block mx-2">
        <button
          type="button"
          onClick={onOpenCommandPalette}
          className="w-full flex items-center justify-between px-3.5 py-1.5 rounded-xl bg-zinc-950/60 hover:bg-zinc-950/90 border border-zinc-800 hover:border-zinc-700 text-zinc-400 hover:text-zinc-300 text-xs transition-all shadow-inner group cursor-pointer"
        >
          <div className="flex items-center gap-2.5">
            <Search className="w-3.5 h-3.5 text-zinc-500 group-hover:text-violet-400 transition-colors" />
            <span className="font-medium text-zinc-500 group-hover:text-zinc-300">
              Quick search or jump to...
            </span>
          </div>
          <div className="flex items-center gap-1">
            <kbd className="px-1.5 py-0.5 rounded bg-zinc-800 border border-zinc-700/80 text-zinc-400 text-[10px] font-mono shadow-sm">
              ⌘K
            </kbd>
          </div>
        </button>
      </div>

      {/* ── Right: Live Telemetry, Quick Actions & Profile ───── */}
      <div className="flex items-center gap-2 sm:gap-3 flex-shrink-0">
        {/* Mobile search button */}
        <button
          onClick={onOpenCommandPalette}
          className="md:hidden p-2 rounded-xl bg-zinc-950/60 border border-zinc-800 text-zinc-400 hover:text-white transition-colors"
          title="Open search (Cmd+K)"
        >
          <Search className="w-4 h-4" />
        </button>

        {/* Vercel-Style Live Active Users Badge */}
        <div
          className="flex items-center gap-2 px-3 py-1.5 rounded-full bg-emerald-500/10 border border-emerald-500/25 text-emerald-400 font-semibold text-xs animate-fadeIn select-none shadow-sm cursor-default"
          title="Active connected users stream via Supabase Presence WebSocket"
        >
          <span className="relative flex h-2 w-2">
            <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
            <span className="relative inline-flex rounded-full h-2 w-2 bg-emerald-500"></span>
          </span>
          <span className="font-mono">{activeUsersCount}</span>
          <span className="hidden sm:inline">active now</span>
        </div>

        {/* Quick Refresh Database Stats Button */}
        <button
          onClick={handleRefreshClick}
          disabled={isRefreshing}
          className="p-2 rounded-xl bg-zinc-950/60 hover:bg-zinc-800/70 border border-zinc-800 hover:border-zinc-700 text-zinc-400 hover:text-zinc-200 transition-all cursor-pointer focus:outline-none"
          title="Refresh realtime database metrics"
        >
          <RefreshCw
            className={`w-3.5 h-3.5 ${isRefreshing ? 'animate-spin text-violet-400' : ''}`}
          />
        </button>

        {/* Announcements Notification Bell */}
        <Link
          href="/dashboard/announcements"
          className="relative p-2 rounded-xl bg-zinc-950/60 hover:bg-zinc-800/70 border border-zinc-800 hover:border-zinc-700 text-zinc-400 hover:text-zinc-200 transition-all"
          title="Broadcast Announcements"
        >
          <Bell className="w-3.5 h-3.5" />
          {announcementsCount > 0 && (
            <span className="absolute -top-1 -right-1 w-4 h-4 rounded-full bg-violet-600 text-[9px] font-bold text-white flex items-center justify-center ring-2 ring-zinc-900 font-mono">
              {announcementsCount}
            </span>
          )}
        </Link>

        {/* Administrator Executive Profile Dropdown */}
        <div className="relative" ref={profileMenuRef}>
          <button
            onClick={() => setIsProfileMenuOpen(!isProfileMenuOpen)}
            className="flex items-center gap-2.5 p-1 sm:px-2.5 sm:py-1 rounded-xl bg-zinc-950/60 hover:bg-zinc-800/80 border border-zinc-800 hover:border-zinc-700 transition-all cursor-pointer select-none"
            aria-expanded={isProfileMenuOpen}
          >
            <div className="w-6 h-6 rounded-lg bg-gradient-to-tr from-violet-600 to-pink-600 flex items-center justify-center text-white ring-1 ring-white/10 flex-shrink-0">
              <Shield className="w-3.5 h-3.5" />
            </div>
            <div className="hidden sm:block text-left leading-tight">
              <span className="text-[11px] text-zinc-200 font-semibold block">
                Administrator
              </span>
              <span className="text-[9px] text-zinc-500 font-mono">root@goplay</span>
            </div>
            <ChevronDown
              className={`w-3 h-3 text-zinc-500 transition-transform hidden sm:block ${
                isProfileMenuOpen ? 'rotate-180 text-zinc-300' : ''
              }`}
            />
          </button>

          {/* Dropdown Menu */}
          {isProfileMenuOpen && (
            <div className="absolute right-0 mt-2 w-64 rounded-2xl bg-zinc-900 border border-zinc-700/80 shadow-2xl shadow-purple-950/40 p-2 z-50 animate-slideDown">
              <div className="px-3 py-2.5 border-b border-zinc-800">
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold text-white">Super Administrator</span>
                  <span className="px-1.5 py-0.5 rounded text-[9px] font-mono font-bold bg-emerald-500/10 text-emerald-400 border border-emerald-500/20">
                    LIVE
                  </span>
                </div>
                <span className="text-[10px] text-zinc-400 font-mono block mt-0.5">
                  root@goplay.tv
                </span>
                <div className="flex items-center gap-1.5 mt-2 text-[10px] text-zinc-500 font-mono">
                  <CheckCircle2 className="w-3 h-3 text-emerald-400" />
                  <span>Session Authenticated</span>
                </div>
              </div>

              {/* Quick links inside dropdown */}
              <div className="py-1">
                <Link
                  href="/dashboard/app-ui"
                  onClick={() => setIsProfileMenuOpen(false)}
                  className="flex items-center gap-2.5 px-3 py-2 rounded-xl text-xs text-zinc-300 hover:text-white hover:bg-zinc-800/70 transition-colors"
                >
                  <Sliders className="w-3.5 h-3.5 text-violet-400" />
                  <span>App UI Studio</span>
                </Link>

                <Link
                  href="/dashboard/livetv"
                  onClick={() => setIsProfileMenuOpen(false)}
                  className="flex items-center gap-2.5 px-3 py-2 rounded-xl text-xs text-zinc-300 hover:text-white hover:bg-zinc-800/70 transition-colors"
                >
                  <Radio className="w-3.5 h-3.5 text-rose-400" />
                  <span>Live TV Studio</span>
                </Link>

                <Link
                  href="/admin/channel-monitor"
                  onClick={() => setIsProfileMenuOpen(false)}
                  className="flex items-center gap-2.5 px-3 py-2 rounded-xl text-xs text-zinc-300 hover:text-white hover:bg-zinc-800/70 transition-colors"
                >
                  <Shield className="w-3.5 h-3.5 text-emerald-400" />
                  <span>Channel Health Monitor</span>
                </Link>
              </div>

              <div className="pt-1 border-t border-zinc-800">
                <button
                  onClick={() => {
                    setIsProfileMenuOpen(false);
                    onLogout();
                  }}
                  className="w-full flex items-center gap-2.5 px-3 py-2 rounded-xl text-xs font-medium text-rose-400 hover:text-rose-300 hover:bg-rose-950/20 transition-colors cursor-pointer"
                >
                  <LogOut className="w-3.5 h-3.5" />
                  <span>Exit Session & Sign Out</span>
                </button>
              </div>
            </div>
          )}
        </div>
      </div>
    </header>
  );
}
