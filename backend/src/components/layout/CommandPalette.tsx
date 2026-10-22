'use client';

import React, { useState, useEffect, useRef, useMemo } from 'react';
import { useRouter } from 'next/navigation';
import {
  Search,
  X,
  ArrowRight,
  PlusCircle,
  Radio,
  Sliders,
  RefreshCw,
  LogOut,
  PanelLeftClose,
  Zap,
} from 'lucide-react';
import { ALL_NAV_ITEMS, NavItemDef } from './nav-data';

interface CommandAction {
  id: string;
  label: string;
  description: string;
  icon: React.ComponentType<{ className?: string }>;
  group: 'Actions' | 'Navigation';
  perform: () => void;
  badge?: string;
}

interface CommandPaletteProps {
  isOpen: boolean;
  onClose: () => void;
  onRefreshStats?: () => void;
  onToggleSidebar?: () => void;
  onLogout?: () => void;
}

export default function CommandPalette({
  isOpen,
  onClose,
  onRefreshStats,
  onToggleSidebar,
  onLogout,
}: CommandPaletteProps) {
  const router = useRouter();
  const [query, setQuery] = useState('');
  const [selectedIndex, setSelectedIndex] = useState(0);
  const inputRef = useRef<HTMLInputElement>(null);
  const listRef = useRef<HTMLDivElement>(null);

  // Focus input when opened
  useEffect(() => {
    if (isOpen) {
      setQuery('');
      setSelectedIndex(0);
      setTimeout(() => {
        inputRef.current?.focus();
      }, 50);
    }
  }, [isOpen]);

  // Global keydown listener for Cmd+K / Ctrl+K
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === 'k') {
        e.preventDefault();
        if (isOpen) onClose();
      } else if (e.key === 'Escape' && isOpen) {
        e.preventDefault();
        onClose();
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [isOpen, onClose]);

  // Build command items
  const allCommands = useMemo<CommandAction[]>(() => {
    const navCommands: CommandAction[] = ALL_NAV_ITEMS.map((item: NavItemDef) => ({
      id: `nav-${item.id}`,
      label: item.label,
      description: item.description,
      icon: item.icon,
      group: 'Navigation',
      badge: item.badge?.text,
      perform: () => {
        router.push(item.href);
        onClose();
      },
    }));

    const quickActions: CommandAction[] = [
      {
        id: 'action-add-channel',
        label: 'Add New TV Channel',
        description: 'Configure a new live HLS broadcast stream with proxy options',
        icon: PlusCircle,
        group: 'Actions',
        badge: 'STREAM',
        perform: () => {
          router.push('/dashboard/channels?action=new');
          onClose();
        },
      },
      {
        id: 'action-schedule-match',
        label: 'Schedule Sports Match',
        description: 'Publish upcoming football, cricket or basketball fixtures',
        icon: PlusCircle,
        group: 'Actions',
        badge: 'SPORTS',
        perform: () => {
          router.push('/dashboard/events?action=new');
          onClose();
        },
      },
      {
        id: 'action-announcement',
        label: 'Publish Announcement',
        description: 'Broadcast urgent messages or banners to all app users',
        icon: Zap,
        group: 'Actions',
        badge: 'BROADCAST',
        perform: () => {
          router.push('/dashboard/announcements?action=new');
          onClose();
        },
      },
      {
        id: 'action-livetv-debugger',
        label: 'Live Stream Diagnostic Studio',
        description: 'Test playback URLs, inspect audio tracks & verify codecs in real-time',
        icon: Radio,
        group: 'Actions',
        badge: 'DIAGNOSE',
        perform: () => {
          router.push('/dashboard/livetv');
          onClose();
        },
      },
      {
        id: 'action-app-ui',
        label: 'Customize Mobile App UI & Themes',
        description: 'Update live border radii, primary gradients, and card dimensions',
        icon: Sliders,
        group: 'Actions',
        badge: 'DYNAMIC UI',
        perform: () => {
          router.push('/dashboard/app-ui');
          onClose();
        },
      },
      {
        id: 'action-refresh-stats',
        label: 'Refresh Database Telemetry & KPIs',
        description: 'Query live count of categories, channels, and active broadcasts',
        icon: RefreshCw,
        group: 'Actions',
        perform: () => {
          onRefreshStats?.();
          onClose();
        },
      },
      {
        id: 'action-toggle-rail',
        label: 'Toggle Sidebar Collapse (Icon Rail)',
        description: 'Switch between compact 72px rail and full navigation width',
        icon: PanelLeftClose,
        group: 'Actions',
        perform: () => {
          onToggleSidebar?.();
          onClose();
        },
      },
      {
        id: 'action-logout',
        label: 'Sign Out of GoPlay Console',
        description: 'Terminate administrator session and return to secure login',
        icon: LogOut,
        group: 'Actions',
        perform: () => {
          onLogout?.();
          onClose();
        },
      },
    ];

    return [...quickActions, ...navCommands];
  }, [router, onClose, onRefreshStats, onToggleSidebar, onLogout]);

  // Filter commands by query
  const filteredCommands = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return allCommands;
    return allCommands.filter((cmd) => {
      const matchLabel = cmd.label.toLowerCase().includes(q);
      const matchDesc = cmd.description.toLowerCase().includes(q);
      const matchGroup = cmd.group.toLowerCase().includes(q);
      const matchBadge = cmd.badge?.toLowerCase().includes(q);
      return matchLabel || matchDesc || matchGroup || matchBadge;
    });
  }, [allCommands, query]);

  // Keep selected index within bounds
  useEffect(() => {
    setSelectedIndex(0);
  }, [query]);

  // Keyboard navigation within list
  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'ArrowDown') {
      e.preventDefault();
      setSelectedIndex((prev) => (prev + 1) % (filteredCommands.length || 1));
      scrollSelectedIntoView((selectedIndex + 1) % (filteredCommands.length || 1));
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      setSelectedIndex((prev) => (prev - 1 + filteredCommands.length) % (filteredCommands.length || 1));
      scrollSelectedIntoView((selectedIndex - 1 + filteredCommands.length) % (filteredCommands.length || 1));
    } else if (e.key === 'Enter') {
      e.preventDefault();
      if (filteredCommands[selectedIndex]) {
        filteredCommands[selectedIndex].perform();
      }
    }
  };

  const scrollSelectedIntoView = (index: number) => {
    const el = listRef.current?.children[index] as HTMLElement | undefined;
    if (el) {
      el.scrollIntoView({ block: 'nearest' });
    }
  };

  if (!isOpen) return null;

  return (
    <div
      role="dialog"
      aria-modal="true"
      className="fixed inset-0 z-50 flex items-start justify-center pt-16 sm:pt-24 px-4 bg-black/70 backdrop-blur-md animate-fadeIn"
      onClick={onClose}
    >
      <div
        className="w-full max-w-2xl bg-zinc-900/95 border border-zinc-700/70 rounded-2xl shadow-2xl shadow-purple-950/30 overflow-hidden flex flex-col max-h-[80vh] animate-slideDown"
        onClick={(e) => e.stopPropagation()}
        onKeyDown={handleKeyDown}
      >
        {/* Top search input */}
        <div className="relative flex items-center px-4 py-3.5 border-b border-zinc-800/80 bg-zinc-900">
          <Search className="w-5 h-5 text-violet-400 mr-3 flex-shrink-0" />
          <input
            ref={inputRef}
            type="text"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="Type a command, page name, or quick action..."
            className="w-full bg-transparent text-zinc-100 placeholder-zinc-500 text-sm sm:text-base outline-none font-medium"
          />
          {query ? (
            <button
              onClick={() => setQuery('')}
              className="p-1 rounded-md text-zinc-500 hover:text-zinc-200 hover:bg-zinc-800 mr-2"
              title="Clear"
            >
              <X className="w-4 h-4" />
            </button>
          ) : null}
          <kbd className="hidden sm:inline-flex items-center gap-1 px-2 py-0.5 text-[10px] font-mono text-zinc-400 bg-zinc-800 border border-zinc-700 rounded-md">
            ESC
          </kbd>
        </div>

        {/* Results List */}
        <div
          ref={listRef}
          className="flex-1 overflow-y-auto p-2 space-y-1 divide-y divide-zinc-800/30"
          style={{ maxHeight: '420px' }}
        >
          {filteredCommands.length === 0 ? (
            <div className="py-12 text-center text-zinc-500">
              <p className="text-sm">No commands or pages matching &ldquo;{query}&rdquo;</p>
              <p className="text-xs text-zinc-600 mt-1">Try searching for &ldquo;Channels&rdquo;, &ldquo;Add&rdquo;, or &ldquo;Live TV&rdquo;</p>
            </div>
          ) : (
            filteredCommands.map((item, index) => {
              const isSelected = index === selectedIndex;
              const Icon = item.icon;
              return (
                <div
                  key={item.id}
                  onClick={() => item.perform()}
                  onMouseEnter={() => setSelectedIndex(index)}
                  className={`flex items-center justify-between px-3 py-2.5 rounded-xl cursor-pointer transition-colors ${
                    isSelected
                      ? 'bg-violet-600/20 border border-violet-500/30 text-white'
                      : 'text-zinc-300 hover:bg-zinc-800/50'
                  }`}
                >
                  <div className="flex items-center gap-3 min-w-0">
                    <div
                      className={`w-8 h-8 rounded-lg flex items-center justify-center flex-shrink-0 transition-colors ${
                        isSelected
                          ? 'bg-violet-600 text-white shadow-sm shadow-violet-500/40'
                          : 'bg-zinc-800 text-zinc-400'
                      }`}
                    >
                      <Icon className="w-4 h-4" />
                    </div>
                    <div className="min-w-0">
                      <div className="flex items-center gap-2">
                        <span className={`text-sm font-semibold truncate ${isSelected ? 'text-white' : 'text-zinc-200'}`}>
                          {item.label}
                        </span>
                        {item.badge && (
                          <span className="px-1.5 py-0.5 rounded-full text-[9px] font-bold font-mono tracking-wider bg-zinc-800 text-zinc-300 border border-zinc-700">
                            {item.badge}
                          </span>
                        )}
                      </div>
                      <p className="text-xs text-zinc-400 truncate mt-0.5">{item.description}</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-2 ml-3 flex-shrink-0">
                    <span className="text-[10px] text-zinc-400 font-mono hidden sm:inline">
                      {item.group}
                    </span>
                    <ArrowRight
                      className={`w-4 h-4 transition-transform ${
                        isSelected ? 'text-violet-400 translate-x-0.5' : 'text-zinc-600 opacity-40'
                      }`}
                    />
                  </div>
                </div>
              );
            })
          )}
        </div>

        {/* Footer shortcuts hint */}
        <div className="flex items-center justify-between px-4 py-2.5 bg-zinc-950/80 border-t border-zinc-800/80 text-[11px] text-zinc-400 font-mono">
          <div className="flex items-center gap-3">
            <span>
              <kbd className="px-1.5 py-0.5 bg-zinc-800 rounded text-zinc-300 mr-1">↑</kbd>
              <kbd className="px-1.5 py-0.5 bg-zinc-800 rounded text-zinc-300 mr-1">↓</kbd>
              Navigate
            </span>
            <span>
              <kbd className="px-1.5 py-0.5 bg-zinc-800 rounded text-zinc-300 mr-1">↵</kbd>
              Select
            </span>
          </div>
          <span>
            <kbd className="px-1.5 py-0.5 bg-zinc-800 rounded text-zinc-300 mr-1">ESC</kbd>
            Close
          </span>
        </div>
      </div>
    </div>
  );
}
