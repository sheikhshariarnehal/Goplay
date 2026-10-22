'use client';

import React, { useState, useEffect, useMemo, type ReactNode } from 'react';
import { useAuth } from '../../providers/auth-provider';
import { createAdminSupabaseClient } from '../../utils/supabase';
import Sidebar from '../../components/layout/Sidebar';
import Header from '../../components/layout/Header';
import CommandPalette from '../../components/layout/CommandPalette';

export default function DashboardLayout({ children }: { children: ReactNode }) {
  const { isAuthenticated, isLoading, logout, adminToken, stats, refreshStats } = useAuth();
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const [isCollapsed, setIsCollapsed] = useState(false);
  const [isCommandPaletteOpen, setIsCommandPaletteOpen] = useState(false);

  // Restore sidebar collapsed preference
  useEffect(() => {
    try {
      const saved = localStorage.getItem('goplay_sidebar_collapsed');
      if (saved !== null) {
        setIsCollapsed(saved === 'true');
      }
    } catch {
      // localStorage may fail in private mode
    }
  }, []);

  const handleToggleCollapse = () => {
    setIsCollapsed((prev) => {
      const next = !prev;
      try {
        localStorage.setItem('goplay_sidebar_collapsed', String(next));
      } catch {}
      return next;
    });
  };

  // Keyboard shortcut: [ to toggle sidebar, Cmd+K / Ctrl+K for command palette
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      // Don't trigger if user is typing in input or textarea
      const target = e.target as HTMLElement | null;
      if (target && (target.tagName === 'INPUT' || target.tagName === 'TEXTAREA' || target.isContentEditable)) {
        return;
      }

      if (e.key === '[' && !e.metaKey && !e.ctrlKey) {
        e.preventDefault();
        handleToggleCollapse();
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, []);

  // Real-time active users logic
  const [users, setUsers] = useState<any[]>([]);
  const [nowTime, setNowTime] = useState(new Date());

  useEffect(() => {
    if (!isAuthenticated) return;
    const timer = setInterval(() => {
      setNowTime(new Date());
    }, 15000);
    return () => clearInterval(timer);
  }, [isAuthenticated]);

  useEffect(() => {
    if (!isAuthenticated || !adminToken) return;

    const supabase = createAdminSupabaseClient(adminToken);
    let channel: any;

    const fetchPresence = async () => {
      try {
        const { data } = await supabase
          .from('user_presence')
          .select('device_id, status, last_active_at');
        setUsers(data || []);
      } catch (err) {
        console.error('Error fetching presence:', err);
      }
    };

    fetchPresence();

    channel = supabase
      .channel('header-dashboard-presence')
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: 'user_presence',
        },
        (payload: any) => {
          setUsers((prev) => {
            const updated = [...prev];
            const eventType = payload.eventType;
            const newRow = payload.new;
            const oldRow = payload.old;

            if (eventType === 'INSERT') {
              return [newRow, ...updated.filter((u) => u.device_id !== newRow.device_id)];
            } else if (eventType === 'UPDATE') {
              const index = updated.findIndex((u) => u.device_id === newRow.device_id);
              if (index > -1) {
                updated[index] = newRow;
                return updated;
              } else {
                return [newRow, ...updated];
              }
            } else if (eventType === 'DELETE') {
              const id = oldRow.id || payload.old.id;
              return updated.filter((u) => u.id !== id);
            }
            return prev;
          });
        }
      )
      .subscribe();

    return () => {
      if (channel) {
        supabase.removeChannel(channel);
      }
    };
  }, [isAuthenticated, adminToken]);

  const activeUsersCount = useMemo(() => {
    return users.filter((u) => {
      if (u.status === 'offline') return false;
      const diffMs = nowTime.getTime() - new Date(u.last_active_at).getTime();
      return diffMs <= 120000;
    }).length;
  }, [users, nowTime]);

  // Auth gate — guard renders a spinner or redirects
  if (isLoading) {
    return (
      <main className="min-h-screen bg-zinc-950 flex items-center justify-center">
        <div className="flex flex-col items-center gap-3">
          <div className="w-9 h-9 border-2 border-violet-500 border-t-transparent rounded-full animate-spin"></div>
          <span className="text-xs font-mono text-zinc-500 tracking-wider">INITIALIZING CONSOLE...</span>
        </div>
      </main>
    );
  }

  if (!isAuthenticated) return null;

  return (
    <div className="min-h-screen bg-zinc-950 flex text-zinc-300 relative selection:bg-violet-600 selection:text-white">
      {/* ── Sidebar ────────────────────────────────── */}
      <Sidebar
        isMobileMenuOpen={isMobileMenuOpen}
        onCloseMobileMenu={() => setIsMobileMenuOpen(false)}
        isCollapsed={isCollapsed}
        onToggleCollapse={handleToggleCollapse}
        onLogout={logout}
        liveChannelsCount={stats.liveChannelsCount}
        activeUsersCount={activeUsersCount}
      />

      {/* ── Topbar + Workspace ────────────────────── */}
      <div className="flex-1 flex flex-col min-w-0 lg:h-screen lg:overflow-hidden">
        {/* Header */}
        <Header
          onToggleMobileMenu={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
          onOpenCommandPalette={() => setIsCommandPaletteOpen(true)}
          activeUsersCount={activeUsersCount}
          announcementsCount={stats.announcementsCount}
          onRefreshStats={refreshStats}
          onLogout={logout}
        />

        {/* Workspace */}
        <main className="flex-1 p-4 sm:p-6 lg:p-8 lg:overflow-y-auto">
          <div className="w-full max-w-[1600px] mx-auto">{children}</div>
        </main>
      </div>

      {/* ── Command Palette (⌘K / Ctrl+K) ─────────── */}
      <CommandPalette
        isOpen={isCommandPaletteOpen}
        onClose={() => setIsCommandPaletteOpen(false)}
        onRefreshStats={refreshStats}
        onToggleSidebar={handleToggleCollapse}
        onLogout={logout}
      />
    </div>
  );
}
