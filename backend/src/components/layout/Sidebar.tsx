'use client';

import React from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import {
  ChevronRight,
  LogOut,
  X,
  PanelLeftClose,
  PanelLeftOpen,
  Radio,
  Sparkles,
  ShieldCheck,
  CheckCircle2,
} from 'lucide-react';
import { NAV_GROUPS, NavItemDef } from './nav-data';

interface SidebarProps {
  isMobileMenuOpen: boolean;
  onCloseMobileMenu: () => void;
  isCollapsed: boolean;
  onToggleCollapse: () => void;
  onLogout: () => void;
  liveChannelsCount?: number;
  activeUsersCount?: number;
}

export default function Sidebar({
  isMobileMenuOpen,
  onCloseMobileMenu,
  isCollapsed,
  onToggleCollapse,
  onLogout,
  liveChannelsCount = 0,
  activeUsersCount = 0,
}: SidebarProps) {
  const pathname = usePathname();

  const getBadgeStyle = (variant?: 'violet' | 'amber' | 'rose' | 'emerald' | 'cyan') => {
    switch (variant) {
      case 'rose':
        return 'bg-rose-500/15 text-rose-300 border-rose-500/30';
      case 'amber':
        return 'bg-amber-500/15 text-amber-300 border-amber-500/30';
      case 'emerald':
        return 'bg-emerald-500/15 text-emerald-300 border-emerald-500/30';
      case 'cyan':
        return 'bg-cyan-500/15 text-cyan-300 border-cyan-500/30';
      case 'violet':
      default:
        return 'bg-violet-500/15 text-violet-300 border-violet-500/30';
    }
  };

  return (
    <>
      {/* Mobile backdrop */}
      {isMobileMenuOpen && (
        <div
          className="fixed inset-0 bg-black/75 backdrop-blur-sm z-40 lg:hidden transition-opacity duration-300"
          onClick={onCloseMobileMenu}
        />
      )}

      {/* Sidebar container */}
      <aside
        className={`fixed top-0 left-0 bottom-0 z-50 flex flex-col justify-between bg-zinc-900/95 border-r border-zinc-800/80 backdrop-blur-xl transition-all duration-300 ease-in-out lg:static ${
          isMobileMenuOpen
            ? 'translate-x-0 w-64'
            : '-translate-x-full lg:translate-x-0'
        } ${isCollapsed ? 'lg:w-[76px]' : 'lg:w-64'}`}
      >
        {/* Top Header & Navigation */}
        <div className="flex-1 flex flex-col min-h-0 overflow-y-auto scrollbar-none">
          {/* Brand Row */}
          <div
            className={`flex items-center justify-between border-b border-zinc-800/80 px-4 py-4 ${
              isCollapsed ? 'lg:px-3 lg:justify-center' : ''
            }`}
          >
            <Link
              href="/dashboard/overview"
              onClick={onCloseMobileMenu}
              className="flex items-center gap-3 group"
              title="GoPlay TV Platform"
            >
              <div className="relative">
                <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-violet-600 via-purple-600 to-pink-500 flex items-center justify-center text-white font-black text-lg shadow-lg shadow-purple-900/30 ring-1 ring-white/20 group-hover:scale-105 transition-transform duration-200">
                  G
                </div>
                <span className="absolute -bottom-0.5 -right-0.5 w-3 h-3 bg-emerald-500 border-2 border-zinc-900 rounded-full animate-pulse" />
              </div>

              {!isCollapsed && (
                <div className="min-w-0">
                  <div className="flex items-center gap-1.5">
                    <span className="font-bold text-white text-base tracking-tight leading-none group-hover:text-violet-300 transition-colors">
                      GoPlay TV
                    </span>
                    <span className="px-1.5 py-0.5 text-[9px] font-mono font-bold tracking-wider rounded bg-violet-500/20 text-violet-300 border border-violet-500/30">
                      PRO
                    </span>
                  </div>
                  <span className="text-[10px] text-zinc-500 font-mono tracking-wider block mt-1">
                    v2.4 CONSOLE
                  </span>
                </div>
              )}
            </Link>

            {/* Desktop Collapse toggle */}
            {!isCollapsed && (
              <button
                onClick={onToggleCollapse}
                className="hidden lg:flex p-1.5 rounded-lg text-zinc-500 hover:text-zinc-200 hover:bg-zinc-800/70 transition-colors"
                title="Collapse sidebar (compact mode)"
              >
                <PanelLeftClose className="w-4 h-4" />
              </button>
            )}

            {/* Mobile close button */}
            <button
              onClick={onCloseMobileMenu}
              className="lg:hidden p-1.5 rounded-lg hover:bg-zinc-800 text-zinc-400 hover:text-white transition-colors"
              aria-label="Close navigation"
            >
              <X className="w-5 h-5" />
            </button>
          </div>

          {/* Collapsed rail expand button */}
          {isCollapsed && (
            <div className="hidden lg:flex justify-center py-2 border-b border-zinc-800/50">
              <button
                onClick={onToggleCollapse}
                className="p-1.5 rounded-lg text-zinc-400 hover:text-white hover:bg-zinc-800/70 transition-colors"
                title="Expand sidebar"
              >
                <PanelLeftOpen className="w-4 h-4" />
              </button>
            </div>
          )}

          {/* Navigation Items Grouped */}
          <nav className="p-3 space-y-5">
            {NAV_GROUPS.map((group) => (
              <div key={group.groupTitle} className="space-y-1">
                {!isCollapsed && (
                  <p className="px-3 text-[10px] font-bold uppercase tracking-wider text-zinc-500">
                    {group.groupTitle}
                  </p>
                )}

                {isCollapsed && (
                  <div className="w-6 h-[1px] bg-zinc-800/80 mx-auto my-2" />
                )}

                <div className="space-y-1">
                  {group.items.map((item: NavItemDef) => {
                    const isActive = pathname.startsWith(item.href);
                    const Icon = item.icon;

                    return (
                      <Link
                        key={item.id}
                        href={item.href}
                        onClick={onCloseMobileMenu}
                        title={isCollapsed ? `${item.label} — ${item.description}` : undefined}
                        className={`group relative flex items-center rounded-xl text-sm font-medium transition-all duration-200 ${
                          isCollapsed
                            ? 'justify-center p-2.5 my-1'
                            : 'justify-between px-3 py-2.5'
                        } ${
                          isActive
                            ? 'bg-gradient-to-r from-violet-600/20 via-purple-600/10 to-transparent border border-violet-500/30 text-white shadow-sm'
                            : 'text-zinc-400 hover:text-zinc-100 hover:bg-zinc-800/60 border border-transparent'
                        }`}
                      >
                        {/* Active vertical accent bar */}
                        {isActive && !isCollapsed && (
                          <span className="absolute left-0 top-1.5 bottom-1.5 w-1 rounded-r-full bg-violet-400 shadow-sm shadow-violet-400" />
                        )}

                        <div className={`flex items-center gap-3 ${isCollapsed ? 'justify-center' : ''}`}>
                          <div
                            className={`flex items-center justify-center rounded-lg transition-colors ${
                              isActive
                                ? 'text-violet-400'
                                : 'text-zinc-400 group-hover:text-zinc-200'
                            }`}
                          >
                            <Icon className="w-4 h-4" />
                          </div>

                          {!isCollapsed && (
                            <span className="truncate">{item.label}</span>
                          )}

                          {!isCollapsed && item.badge && (
                            <span
                              className={`px-1.5 py-0.5 rounded-full text-[9px] font-mono font-bold tracking-wider border ${getBadgeStyle(
                                item.badge.variant
                              )}`}
                            >
                              {item.badge.text}
                            </span>
                          )}
                        </div>

                        {!isCollapsed && (
                          <ChevronRight
                            className={`w-3.5 h-3.5 transition-all duration-200 ${
                              isActive
                                ? 'text-violet-400 opacity-100 translate-x-0'
                                : 'text-zinc-600 opacity-0 group-hover:opacity-60 -translate-x-1 group-hover:translate-x-0'
                            }`}
                          />
                        )}
                      </Link>
                    );
                  })}
                </div>
              </div>
            ))}
          </nav>
        </div>

        {/* Sidebar Footer */}
        <div className="p-3 border-t border-zinc-800/80 space-y-2 bg-zinc-950/40">
          {/* Live Sync Box */}
          {!isCollapsed ? (
            <div className="px-3 py-2.5 rounded-xl bg-zinc-950/70 border border-zinc-800/70">
              <div className="flex items-center justify-between mb-1">
                <div className="flex items-center gap-1.5">
                  <span className="relative flex h-2 w-2">
                    <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
                    <span className="relative inline-flex rounded-full h-2 w-2 bg-emerald-500"></span>
                  </span>
                  <span className="text-[11px] font-semibold text-zinc-200">Supabase Realtime</span>
                </div>
                <span className="text-[9px] font-mono text-emerald-400 bg-emerald-500/10 px-1.5 py-0.2 rounded border border-emerald-500/20">
                  SYNCED
                </span>
              </div>
              <div className="flex items-center justify-between text-[10px] text-zinc-500 font-mono mt-1">
                <span>{liveChannelsCount > 0 ? `${liveChannelsCount} live streams` : 'WebSocket Active'}</span>
                <span>{activeUsersCount > 0 ? `${activeUsersCount} users` : '100% Health'}</span>
              </div>
            </div>
          ) : (
            <div
              className="flex justify-center py-2"
              title={`Supabase Realtime Synced · ${liveChannelsCount} Live Streams`}
            >
              <div className="w-8 h-8 rounded-lg bg-zinc-950/70 border border-zinc-800 flex items-center justify-center">
                <span className="relative flex h-2.5 w-2.5">
                  <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
                  <span className="relative inline-flex rounded-full h-2.5 w-2.5 bg-emerald-500"></span>
                </span>
              </div>
            </div>
          )}

          {/* User Session Bar & Exit Button */}
          <div
            className={`flex items-center rounded-xl bg-zinc-900 border border-zinc-800/80 p-2 ${
              isCollapsed ? 'justify-center' : 'justify-between'
            }`}
          >
            {!isCollapsed ? (
              <div className="flex items-center gap-2.5 min-w-0">
                <div className="w-7 h-7 rounded-lg bg-gradient-to-tr from-violet-600 to-pink-600 flex items-center justify-center text-white text-xs font-bold ring-1 ring-white/10 flex-shrink-0">
                  <ShieldCheck className="w-3.5 h-3.5" />
                </div>
                <div className="min-w-0">
                  <span className="text-xs font-semibold text-zinc-200 block truncate">Administrator</span>
                  <span className="text-[9px] text-zinc-500 font-mono block truncate">root@goplay.tv</span>
                </div>
              </div>
            ) : null}

            <button
              onClick={onLogout}
              className={`p-1.5 rounded-lg text-zinc-400 hover:text-rose-400 hover:bg-rose-950/20 border border-transparent hover:border-rose-900/30 transition-all ${
                isCollapsed ? 'w-full flex justify-center' : ''
              }`}
              title="Sign Out of GoPlay Console"
            >
              <LogOut className="w-4 h-4" />
            </button>
          </div>
        </div>
      </aside>
    </>
  );
}
