'use client';

import React, { useState, useEffect, useMemo, useRef, useCallback } from 'react';
import { createAdminSupabaseClient } from '../utils/supabase';
import {
  TrendingUp, Plus, Trash2, X, Search, Tv, GripVertical,
  ChevronUp, ChevronDown, Layers, Check, AlertCircle,
  Loader2, Sparkles, Radio, Pin, PinOff, Flame, RefreshCw
} from 'lucide-react';

interface DrmConfig {
  type: 'clearkey' | 'widevine' | 'playready';
  kid?: string;
  key?: string;
  licenseUrl?: string;
  headers?: Record<string, string>;
}

interface Channel {
  id: string;
  name: string;
  logo: string | null;
  category: string | null;
  quality: string | null;
  stream_url: string;
  proxy: boolean;
  is_live: boolean;
  is_trending: boolean;
  sort_order: number;
  drm: DrmConfig | null;
  is_pinned?: boolean;
  play_count?: number;
}

interface Category {
  id: string;
  name: string;
}

interface TrendingChannelManagerProps {
  adminToken: string;
  onRefreshStats: () => void;
}

export default function TrendingChannelManager({ adminToken, onRefreshStats }: TrendingChannelManagerProps) {
  // trendingOrderRef = always-current source of truth for the active 20 trending rail
  const [trendingOrder, setTrendingOrder] = useState<Channel[]>([]);
  const trendingOrderRef = useRef<Channel[]>([]);

  const [draggedIndex, setDraggedIndex] = useState<number | null>(null);
  const draggedIndexRef = useRef<number | null>(null);

  const [availableChannels, setAvailableChannels] = useState<Channel[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  const [syncing, setSyncing] = useState(false);

  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('all');
  const [limit, setLimit] = useState(50);

  const supabaseAdmin = useMemo(() => createAdminSupabaseClient(adminToken), [adminToken]);

  const applyTrendingOrder = useCallback((newOrder: Channel[]) => {
    trendingOrderRef.current = newOrder;
    setTrendingOrder([...newOrder]);
  }, []);

  const showNotification = useCallback((type: 'success' | 'error', msg: string) => {
    if (type === 'success') {
      setSuccess(msg);
      setTimeout(() => setSuccess(null), 3000);
    } else {
      setError(msg);
      setTimeout(() => setError(null), 4000);
    }
  }, []);

  const fetchData = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);

      // 1. Fetch categories
      const { data: catData, error: catErr } = await supabaseAdmin
        .from('categories')
        .select('id, name')
        .order('name', { ascending: true });
      if (catErr) throw catErr;
      setCategories(catData || []);

      // 2. Fetch top 20 dynamic trending channels via real-time RPC
      const { data: trendingRpcData, error: trendingErr } = await supabaseAdmin
        .rpc('get_trending_channels', { p_limit: 20 });
      if (trendingErr) {
        console.warn('RPC get_trending_channels failed, falling back:', trendingErr);
      }

      // 3. Fetch all channels for available/search pool
      const BATCH_SIZE = 1000;
      let offset = 0;
      const allChannels: Channel[] = [];
      while (true) {
        const { data: chData, error: chErr } = await supabaseAdmin
          .from('channels')
          .select('*')
          .order('name', { ascending: true })
          .range(offset, offset + BATCH_SIZE - 1);
        if (chErr) throw chErr;
        const batch = chData || [];
        allChannels.push(...batch);
        if (batch.length < BATCH_SIZE) break;
        offset += BATCH_SIZE;
      }

      let activeRail: Channel[] = [];
      if (trendingRpcData && Array.isArray(trendingRpcData) && trendingRpcData.length > 0) {
        activeRail = trendingRpcData.map((ch: Record<string, unknown>) => ({
          ...ch,
          is_pinned: Boolean(ch.is_pinned ?? ch.is_trending),
          play_count: Number(ch.play_count ?? 0),
        })) as Channel[];
      } else {
        // Fallback: use static is_trending flag
        activeRail = allChannels
          .filter(c => c.is_trending)
          .sort((a, b) => a.sort_order - b.sort_order)
          .slice(0, 20)
          .map(c => ({ ...c, is_pinned: true, play_count: 0 }));
      }

      applyTrendingOrder(activeRail);

      // Exclude channels that are already pinned from available pool
      const pinnedIds = new Set(
        activeRail.filter(c => c.is_pinned || c.is_trending).map(c => c.id)
      );
      setAvailableChannels(allChannels.filter(c => !pinnedIds.has(c.id)));
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to retrieve channels database.');
    } finally {
      setLoading(false);
    }
  }, [supabaseAdmin, applyTrendingOrder]);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  // Persist reordered pinned channels to DB
  const persistPinnedOrder = useCallback(async (orderedList: Channel[]) => {
    setSyncing(true);
    try {
      // Re-assign sort_order to pinned channels 1, 2, 3...
      const pinnedOnly = orderedList.filter(c => c.is_pinned || c.is_trending);
      applyTrendingOrder(orderedList);

      const results = await Promise.all(
        pinnedOnly.map((ch, idx) =>
          supabaseAdmin
            .from('channels')
            .update({ sort_order: idx + 1, is_trending: true })
            .eq('id', ch.id)
        )
      );

      const firstError = results.find(r => r.error)?.error;
      if (firstError) throw firstError;

      showNotification('success', 'Pinned order updated successfully.');
      onRefreshStats();
      await fetchData();
    } catch (err) {
      showNotification('error', err instanceof Error ? err.message : 'Database sync failed.');
      fetchData();
    } finally {
      setSyncing(false);
    }
  }, [supabaseAdmin, applyTrendingOrder, showNotification, onRefreshStats, fetchData]);

  // Move pinned channel up/down
  const moveChannel = useCallback((index: number, direction: 'up' | 'down') => {
    const current = [...trendingOrderRef.current];
    const targetIndex = direction === 'up' ? index - 1 : index + 1;
    if (targetIndex < 0 || targetIndex >= current.length) return;

    // Both items must be pinned to swap order
    const source = current[index];
    const target = current[targetIndex];
    if (!source.is_pinned || !target.is_pinned) return;

    current[index] = target;
    current[targetIndex] = source;

    applyTrendingOrder(current);
    persistPinnedOrder(current);
  }, [applyTrendingOrder, persistPinnedOrder]);

  // Drag and drop for pinned items
  const handleDragStart = useCallback((e: React.DragEvent, index: number) => {
    if (!trendingOrderRef.current[index]?.is_pinned) return;
    draggedIndexRef.current = index;
    setDraggedIndex(index);
    e.dataTransfer.effectAllowed = 'move';
  }, []);

  const handleDragEnter = useCallback((e: React.DragEvent, overIndex: number) => {
    e.preventDefault();
    const currentDragIdx = draggedIndexRef.current;
    if (currentDragIdx === null || currentDragIdx === overIndex) return;
    if (!trendingOrderRef.current[overIndex]?.is_pinned) return;

    const current = [...trendingOrderRef.current];
    const draggedItem = current[currentDragIdx];
    if (!draggedItem) return;

    current.splice(currentDragIdx, 1);
    current.splice(overIndex, 0, draggedItem);

    draggedIndexRef.current = overIndex;
    applyTrendingOrder(current);
    setDraggedIndex(overIndex);
  }, [applyTrendingOrder]);

  const handleDragOver = useCallback((e: React.DragEvent) => {
    e.preventDefault();
    e.dataTransfer.dropEffect = 'move';
  }, []);

  const handleDrop = useCallback((e: React.DragEvent) => {
    e.preventDefault();
  }, []);

  const handleDragEnd = useCallback(async () => {
    draggedIndexRef.current = null;
    setDraggedIndex(null);
    await persistPinnedOrder(trendingOrderRef.current);
  }, [persistPinnedOrder]);

  // Pin a channel (from dynamic slots or available pool)
  const handlePinChannel = useCallback(async (channel: Channel) => {
    setSyncing(true);
    try {
      const currentPinned = trendingOrderRef.current.filter(c => c.is_pinned || c.is_trending);
      const newSortOrder = currentPinned.length + 1;

      const { error: updateErr } = await supabaseAdmin
        .from('channels')
        .update({ is_trending: true, sort_order: newSortOrder })
        .eq('id', channel.id);

      if (updateErr) throw updateErr;

      showNotification('success', `"${channel.name}" pinned to Trending #${newSortOrder}`);
      onRefreshStats();
      await fetchData();
    } catch (err) {
      showNotification('error', err instanceof Error ? err.message : 'Failed to pin channel.');
    } finally {
      setSyncing(false);
    }
  }, [supabaseAdmin, showNotification, onRefreshStats, fetchData]);

  // Unpin a channel (converts it back to dynamic eligibility)
  const handleUnpinChannel = useCallback(async (channel: Channel) => {
    setSyncing(true);
    try {
      const { error: updateErr } = await supabaseAdmin
        .from('channels')
        .update({ is_trending: false })
        .eq('id', channel.id);

      if (updateErr) throw updateErr;

      showNotification('success', `"${channel.name}" unpinned from manual priority.`);
      onRefreshStats();
      await fetchData();
    } catch (err) {
      showNotification('error', err instanceof Error ? err.message : 'Failed to unpin channel.');
    } finally {
      setSyncing(false);
    }
  }, [supabaseAdmin, showNotification, onRefreshStats, fetchData]);

  const availableChannelsFiltered = useMemo(() => {
    return availableChannels
      .filter(c => {
        const matchesSearch =
          c.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
          (c.stream_url && c.stream_url.toLowerCase().includes(searchTerm.toLowerCase()));
        const matchesCategory = selectedCategory === 'all' || c.category === selectedCategory;
        return matchesSearch && matchesCategory;
      })
      .sort((a, b) => {
        const n = a.name.localeCompare(b.name);
        return n !== 0 ? n : a.id.localeCompare(b.id);
      });
  }, [availableChannels, searchTerm, selectedCategory]);

  useEffect(() => { setLimit(50); }, [searchTerm, selectedCategory]);

  const totalTrending = trendingOrder.length;
  const pinnedCount = trendingOrder.filter(c => c.is_pinned || c.is_trending).length;
  const dynamicCount = totalTrending - pinnedCount;
  const liveTrending = trendingOrder.filter(c => c.is_live).length;

  return (
    <div className="space-y-6 animate-fadeIn">
      {success && (
        <div className="fixed bottom-5 right-5 z-50 flex items-center gap-2.5 bg-emerald-500 text-white font-semibold py-3 px-5 rounded-xl shadow-xl shadow-emerald-500/20 border border-emerald-400/30 animate-slideInRight">
          <Check className="w-4 h-4" /><span>{success}</span>
        </div>
      )}
      {error && (
        <div className="fixed bottom-5 right-5 z-50 flex items-center gap-2.5 bg-red-600 text-white font-semibold py-3 px-5 rounded-xl shadow-xl shadow-red-500/20 border border-red-500/30 animate-slideInRight">
          <AlertCircle className="w-4 h-4" /><span>{error}</span>
        </div>
      )}

      {/* Header Panel */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 p-6 rounded-2xl glass-panel relative overflow-hidden bg-gradient-to-r from-zinc-900/60 to-zinc-950/20">
        <div className="space-y-1">
          <h1 className="text-2xl font-bold text-white flex items-center gap-2">
            <TrendingUp className="w-6 h-6 text-purple-400" />
            Dynamic Trending Channels
          </h1>
          <p className="text-xs text-zinc-400">
            Top 20 channels on the homepage. Pinned channels hold fixed priority, while remaining slots fill dynamically from 24–48h user playback sessions.
          </p>
        </div>
        <div className="flex items-center gap-2">
          <button
            onClick={() => fetchData()}
            disabled={loading || syncing}
            className="flex items-center gap-1.5 px-3 py-2 bg-zinc-900 hover:bg-zinc-800 border border-zinc-700/80 rounded-xl text-xs text-zinc-300 hover:text-white transition-all cursor-pointer"
            title="Refresh Rail"
          >
            <RefreshCw className={`w-3.5 h-3.5 ${loading ? 'animate-spin' : ''}`} />
            Refresh
          </button>
          <div className="flex items-center gap-2 bg-zinc-950/60 border border-zinc-800/80 px-4 py-2 rounded-xl text-xs select-none">
            {syncing ? (
              <><Loader2 className="w-3.5 h-3.5 text-amber-400 animate-spin" /><span className="text-amber-400 font-medium font-mono animate-pulse">Saving...</span></>
            ) : (
              <><Sparkles className="w-3.5 h-3.5 text-emerald-400" /><span className="text-emerald-400 font-medium font-mono">Real-time Hybrid</span></>
            )}
          </div>
        </div>
      </div>

      {/* Metrics Row */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
        <div className="p-4 rounded-xl glass-panel bg-gradient-to-br from-purple-500/5 to-transparent border-l-2 border-l-purple-500 flex items-center justify-between">
          <div>
            <span className="text-[10px] text-zinc-500 font-bold uppercase tracking-wider block">Home Rail Total</span>
            <span className="text-2xl font-bold text-white tabular-nums">{loading ? '...' : `${totalTrending}/20`}</span>
          </div>
          <div className="p-2 bg-purple-500/10 rounded-lg text-purple-400"><TrendingUp className="w-5 h-5" /></div>
        </div>

        <div className="p-4 rounded-xl glass-panel bg-gradient-to-br from-indigo-500/5 to-transparent border-l-2 border-l-indigo-500 flex items-center justify-between">
          <div>
            <span className="text-[10px] text-zinc-500 font-bold uppercase tracking-wider block">Admin Pinned</span>
            <span className="text-2xl font-bold text-indigo-400 tabular-nums">{loading ? '...' : pinnedCount}</span>
          </div>
          <div className="p-2 bg-indigo-500/10 rounded-lg text-indigo-400"><Pin className="w-5 h-5" /></div>
        </div>

        <div className="p-4 rounded-xl glass-panel bg-gradient-to-br from-amber-500/5 to-transparent border-l-2 border-l-amber-500 flex items-center justify-between">
          <div>
            <span className="text-[10px] text-zinc-500 font-bold uppercase tracking-wider block">Dynamic (By Plays)</span>
            <span className="text-2xl font-bold text-amber-400 tabular-nums">{loading ? '...' : dynamicCount}</span>
          </div>
          <div className="p-2 bg-amber-500/10 rounded-lg text-amber-400"><Flame className="w-5 h-5" /></div>
        </div>

        <div className="p-4 rounded-xl glass-panel bg-gradient-to-br from-emerald-500/5 to-transparent border-l-2 border-l-emerald-500 flex items-center justify-between">
          <div>
            <span className="text-[10px] text-zinc-500 font-bold uppercase tracking-wider block">Live Streams</span>
            <span className="text-2xl font-bold text-emerald-400 tabular-nums">{loading ? '...' : liveTrending}</span>
          </div>
          <div className="p-2 bg-emerald-500/10 rounded-lg text-emerald-400"><Radio className="w-5 h-5 animate-pulse" /></div>
        </div>
      </div>

      {/* Main Content */}
      {loading ? (
        <div className="h-[400px] rounded-2xl glass-panel flex flex-col items-center justify-center gap-3">
          <Loader2 className="w-8 h-8 text-purple-500 animate-spin" />
          <span className="text-sm text-zinc-400 font-semibold">Calculating dynamic trending leaderboard...</span>
        </div>
      ) : (
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
          {/* Left Column: Homepage Trending Rail (20 Slots) */}
          <div className="lg:col-span-7 space-y-3">
            <div className="flex items-center justify-between px-1">
              <h2 className="text-sm font-bold text-zinc-300 uppercase tracking-wider flex items-center gap-2">
                <Layers className="w-4 h-4 text-purple-400" />
                Homepage 20-Channel Rail Preview
              </h2>
              <span className="text-[10px] text-zinc-500 font-medium">
                {pinnedCount} pinned • {dynamicCount} dynamic
              </span>
            </div>

            {trendingOrder.length === 0 ? (
              <div className="h-[320px] rounded-2xl border border-dashed border-zinc-800 flex flex-col items-center justify-center text-center p-6 bg-zinc-950/20">
                <TrendingUp className="w-8 h-8 text-zinc-600 mb-2" />
                <h3 className="text-sm font-semibold text-zinc-300">No channels trending</h3>
                <p className="text-xs text-zinc-500 max-w-xs mt-1">Pin channels from the pool on the right or wait for playback telemetry to register.</p>
              </div>
            ) : (
              <div className="space-y-2 select-none max-h-[720px] overflow-y-auto pr-1 font-sans">
                {trendingOrder.map((channel, index) => {
                  const isPinned = Boolean(channel.is_pinned || channel.is_trending);
                  return (
                    <div
                      key={channel.id}
                      draggable={isPinned}
                      onDragStart={(e) => handleDragStart(e, index)}
                      onDragEnter={(e) => handleDragEnter(e, index)}
                      onDragOver={handleDragOver}
                      onDrop={handleDrop}
                      onDragEnd={handleDragEnd}
                      className={`flex items-center justify-between p-3 rounded-xl border transition-all duration-200 group ${
                        draggedIndex === index
                          ? 'bg-purple-950/30 border-purple-500/60 opacity-60 scale-[0.99]'
                          : isPinned
                            ? 'glass-panel bg-purple-950/10 border-purple-900/30 hover:bg-purple-950/20 hover:border-purple-700/50'
                            : 'glass-panel hover:bg-zinc-900/60 hover:border-zinc-700/60'
                      }`}
                    >
                      <div className="flex items-center gap-3 min-w-0 flex-1">
                        {isPinned ? (
                          <div
                            className="cursor-grab active:cursor-grabbing p-1 hover:bg-purple-900/30 rounded text-purple-400 hover:text-purple-200 transition-colors"
                            title="Drag to reorder pinned position"
                          >
                            <GripVertical className="w-4 h-4" />
                          </div>
                        ) : (
                          <div className="p-1 text-zinc-600 flex items-center justify-center">
                            <span className="text-[11px] font-mono font-bold w-4 text-center">{index + 1}</span>
                          </div>
                        )}

                        {channel.logo ? (
                          // eslint-disable-next-line @next/next/no-img-element
                          <img
                            src={channel.logo}
                            alt={channel.name}
                            onError={(e) => { (e.target as HTMLElement).style.display = 'none'; }}
                            className="w-9 h-9 rounded-lg object-contain bg-zinc-950/60 border border-zinc-800/80 p-0.5 flex-shrink-0"
                          />
                        ) : (
                          <div className="w-9 h-9 rounded-lg bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-600 flex-shrink-0">
                            <Tv className="w-4 h-4" />
                          </div>
                        )}

                        <div className="min-w-0 leading-tight">
                          <div className="flex items-center gap-1.5 flex-wrap">
                            <span className="font-semibold text-white text-sm truncate max-w-[180px]">{channel.name}</span>
                            {channel.quality && (
                              <span className="text-[9px] px-1 py-0.5 bg-zinc-800 border border-zinc-700 text-zinc-300 rounded font-semibold">{channel.quality}</span>
                            )}
                            {isPinned ? (
                              <span className="flex items-center gap-0.5 text-[9px] px-1.5 py-0.5 bg-purple-500/20 border border-purple-500/30 text-purple-300 rounded-md font-semibold">
                                <Pin className="w-2.5 h-2.5" /> Pinned #{index + 1}
                              </span>
                            ) : (
                              <span className="flex items-center gap-0.5 text-[9px] px-1.5 py-0.5 bg-amber-500/10 border border-amber-500/20 text-amber-300 rounded-md font-semibold">
                                <Flame className="w-2.5 h-2.5 text-amber-400" /> {channel.play_count || 0} plays (48h)
                              </span>
                            )}
                          </div>
                          <div className="flex items-center gap-2 mt-0.5">
                            <span className="text-[10px] text-zinc-500 truncate max-w-[120px]">
                              {categories.find(c => c.id === channel.category)?.name || 'Uncategorized'}
                            </span>
                            <span className="text-[8px] text-zinc-700 font-mono">ID: {channel.id.slice(0, 10)}</span>
                          </div>
                        </div>
                      </div>

                      <div className="flex items-center gap-2.5 flex-shrink-0">
                        {isPinned ? (
                          <>
                            <div className="flex items-center gap-0.5 bg-zinc-950/60 border border-zinc-800 rounded-lg p-0.5">
                              <button
                                onClick={() => moveChannel(index, 'up')}
                                disabled={index === 0 || syncing}
                                className="p-1 rounded text-zinc-400 hover:text-white disabled:opacity-20 disabled:cursor-not-allowed hover:bg-zinc-800 transition-colors cursor-pointer"
                                title="Move Up"
                              >
                                <ChevronUp className="w-3.5 h-3.5" />
                              </button>
                              <button
                                onClick={() => moveChannel(index, 'down')}
                                disabled={index >= pinnedCount - 1 || syncing}
                                className="p-1 rounded text-zinc-400 hover:text-white disabled:opacity-20 disabled:cursor-not-allowed hover:bg-zinc-800 transition-colors cursor-pointer"
                                title="Move Down"
                              >
                                <ChevronDown className="w-3.5 h-3.5" />
                              </button>
                            </div>

                            <button
                              onClick={() => handleUnpinChannel(channel)}
                              disabled={syncing}
                              className="flex items-center gap-1 py-1 px-2 rounded-lg border border-zinc-800 hover:border-red-500/30 bg-zinc-900/60 hover:bg-red-950/20 text-zinc-400 hover:text-red-400 text-[10px] font-semibold transition-all cursor-pointer"
                              title="Unpin (channel will rank dynamically by plays)"
                            >
                              <PinOff className="w-3 h-3" />
                              <span className="hidden sm:inline">Unpin</span>
                            </button>
                          </>
                        ) : (
                          <button
                            onClick={() => handlePinChannel(channel)}
                            disabled={syncing}
                            className="flex items-center gap-1 py-1 px-2.5 rounded-lg border border-purple-500/30 hover:border-purple-500 bg-purple-600/10 hover:bg-purple-600 text-purple-300 hover:text-white text-[10px] font-bold transition-all cursor-pointer"
                            title="Lock this channel in pinned position"
                          >
                            <Pin className="w-3 h-3" />
                            <span>Pin to Top</span>
                          </button>
                        )}

                        <div className="flex items-center gap-1">
                          <span className="relative flex h-1.5 w-1.5">
                            {channel.is_live && <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>}
                            <span className={`relative inline-flex rounded-full h-1.5 w-1.5 ${channel.is_live ? 'bg-emerald-500' : 'bg-red-500'}`}></span>
                          </span>
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </div>

          {/* Right Column: Search & Pin Any Channel */}
          <div className="lg:col-span-5 space-y-3">
            <h2 className="text-sm font-bold text-zinc-300 uppercase tracking-wider flex items-center gap-2 px-1">
              <Plus className="w-4 h-4 text-purple-400" />
              Pin Channels to Trending
            </h2>
            <div className="p-4 rounded-2xl glass-panel space-y-4 bg-zinc-900/40">
              <div className="space-y-2.5">
                <div className="relative">
                  <Search className="absolute left-3 top-2.5 w-4 h-4 text-zinc-500" />
                  <input
                    type="text"
                    placeholder="Search any channel by name or URL..."
                    value={searchTerm}
                    onChange={e => setSearchTerm(e.target.value)}
                    className="w-full pl-9 pr-4 py-2 text-xs rounded-xl glass-input placeholder-zinc-500 focus:outline-none"
                  />
                  {searchTerm && (
                    <button onClick={() => setSearchTerm('')} className="absolute right-3 top-2.5 text-zinc-500 hover:text-white">
                      <X className="w-3.5 h-3.5" />
                    </button>
                  )}
                </div>
                <div className="relative">
                  <select
                    value={selectedCategory}
                    onChange={e => setSelectedCategory(e.target.value)}
                    className="w-full px-3 py-2 text-xs rounded-xl glass-input appearance-none bg-zinc-950/80 cursor-pointer text-zinc-300"
                  >
                    <option value="all">All Categories</option>
                    {categories.map(cat => <option key={cat.id} value={cat.id}>{cat.name}</option>)}
                  </select>
                  <Layers className="absolute right-3 top-2.5 w-3.5 h-3.5 text-zinc-500 pointer-events-none" />
                </div>
              </div>

              <div className="space-y-1.5 max-h-[500px] overflow-y-auto pr-1">
                {availableChannelsFiltered.length === 0 ? (
                  <div className="py-12 text-center text-zinc-500 text-xs">
                    {availableChannels.length === 0 ? 'No channels found in registry.' : 'No matching available channels.'}
                  </div>
                ) : (
                  <>
                    {availableChannelsFiltered.slice(0, limit).map(channel => (
                      <div
                        key={channel.id}
                        className="flex items-center justify-between p-2.5 rounded-xl border border-zinc-800/40 bg-zinc-950/40 hover:bg-zinc-900/40 hover:border-zinc-800 transition-all duration-200"
                      >
                        <div className="flex items-center gap-2 min-w-0">
                          {channel.logo ? (
                            // eslint-disable-next-line @next/next/no-img-element
                            <img
                              src={channel.logo}
                              alt={channel.name}
                              onError={(e) => { (e.target as HTMLElement).style.display = 'none'; }}
                              className="w-7 h-7 rounded-md object-contain bg-zinc-900 border border-zinc-800 p-0.5 flex-shrink-0"
                            />
                          ) : (
                            <div className="w-7 h-7 rounded-md bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-600 flex-shrink-0">
                              <Tv className="w-3.5 h-3.5" />
                            </div>
                          )}
                          <div className="min-w-0 leading-tight">
                            <span className="font-medium text-white text-xs block truncate">{channel.name}</span>
                            <span className="text-[9px] text-zinc-500 block truncate font-semibold">
                              {categories.find(c => c.id === channel.category)?.name || 'Uncategorized'}
                            </span>
                          </div>
                        </div>

                        <button
                          onClick={() => handlePinChannel(channel)}
                          disabled={syncing}
                          className="flex items-center gap-1 py-1 px-2.5 rounded-lg bg-purple-600/10 hover:bg-purple-600 border border-purple-500/20 hover:border-purple-500 text-purple-400 hover:text-white text-[10px] font-bold disabled:opacity-30 disabled:cursor-not-allowed transition-all cursor-pointer"
                        >
                          <Pin className="w-3 h-3" /> Pin
                        </button>
                      </div>
                    ))}
                    {availableChannelsFiltered.length > limit && (
                      <button
                        onClick={() => setLimit(prev => prev + 50)}
                        className="w-full mt-2 py-2 text-center text-[10px] text-zinc-500 hover:text-purple-400 font-bold bg-zinc-950/20 hover:bg-purple-950/5 border border-zinc-800 hover:border-purple-900/30 rounded-xl transition-all cursor-pointer"
                      >
                        Load More Channels (+50)
                      </button>
                    )}
                  </>
                )}
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
