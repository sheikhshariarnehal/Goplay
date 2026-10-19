'use client';

import React, { useState, useEffect, useMemo, useRef, useCallback } from 'react';
import Link from 'next/link';
import { createAdminSupabaseClient } from '../../utils/supabase';
import {
  Layers, Tv, Plus, Search, Filter, Save, Trash2, Edit2, Copy, Check,
  ExternalLink, Activity, ArrowUpDown, ChevronRight, ChevronLeft,
  CheckSquare, Square, Shield, Lock, Unlock, AlertCircle, RefreshCw,
  Star, Eye, EyeOff, Radio, Play, Upload, GripVertical, Settings2,
  ChevronDown, ChevronUp, CheckCircle2, MoreVertical, X, Sparkles, Zap, Loader2, Workflow
} from 'lucide-react';
import LivePreviewPlayer, { StreamServer } from './LivePreviewPlayer';
import CategoryEditorModal, { CategoryData } from './CategoryEditorModal';
import M3uImportModal from './M3uImportModal';

export interface ChannelData {
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
  drm?: any;
  playz_links?: string | null;
  link_names?: string[];
  server_count?: number;
}

interface LiveTvStudioProps {
  adminToken: string;
  onRefreshStats?: () => void;
}

export default function LiveTvStudio({ adminToken, onRefreshStats }: LiveTvStudioProps) {
  const supabase = useMemo(() => createAdminSupabaseClient(adminToken), [adminToken]);

  // Main data state
  const [categories, setCategories] = useState<CategoryData[]>([]);
  const [channels, setChannels] = useState<ChannelData[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);

  // Active selections
  const [selectedCategoryId, setSelectedCategoryId] = useState<string>('all');
  const [selectedChannelId, setSelectedChannelId] = useState<string | null>(null);

  // Active channel form & servers state (Pane 3)
  const [editingChannel, setEditingChannel] = useState<ChannelData | null>(null);
  const [channelServers, setChannelServers] = useState<StreamServer[]>([]);
  const [activePreviewServerIndex, setActivePreviewServerIndex] = useState(0);
  const [idLocked, setIdLocked] = useState(true);
  const [savingChannel, setSavingChannel] = useState(false);

  // Search & Filter state
  const [searchCategory, setSearchCategory] = useState('');
  const [searchChannel, setSearchChannel] = useState('');
  const [statusFilter, setStatusFilter] = useState<'all' | 'live' | 'offline' | 'trending'>('all');

  // Bulk actions state
  const [isBulkMode, setIsBulkMode] = useState(false);
  const [selectedChannelIds, setSelectedChannelIds] = useState<string[]>([]);
  const [bulkTargetCategory, setBulkTargetCategory] = useState('');

  // Modals state
  const [isCategoryModalOpen, setIsCategoryModalOpen] = useState(false);
  const [editingCategory, setEditingCategory] = useState<CategoryData | null>(null);
  const [isM3uModalOpen, setIsM3uModalOpen] = useState(false);

  // PlayZ Auto-Resolve & Decrypt state
  const [resolvingPlayz, setResolvingPlayz] = useState(false);
  const [batchResolving, setBatchResolving] = useState(false);
  const [batchProgress, setBatchProgress] = useState<{ current: number; total: number } | null>(null);

  // Notification toast
  const [notification, setNotification] = useState<{ type: 'success' | 'error'; message: string } | null>(null);

  // Responsive mobile pane state
  const [mobileView, setMobileView] = useState<'categories' | 'channels' | 'inspector'>('categories');

  const showNotification = (type: 'success' | 'error', message: string) => {
    setNotification({ type, message });
    setTimeout(() => setNotification(null), 3500);
  };

  // Helper: Bump channels_version in app_settings
  const bumpChannelsVersion = async () => {
    try {
      const { data: currentSettings } = await supabase
        .from('app_settings')
        .select('channels_version')
        .limit(1)
        .maybeSingle();

      const nextVersion = (currentSettings?.channels_version || Date.now()) + 1;
      await supabase
        .from('app_settings')
        .update({ channels_version: nextVersion, updated_at: new Date().toISOString() })
        .not('channels_version', 'is', null);
    } catch (err) {
      console.warn('Failed to bump channels_version:', err);
    }
  };

  // Fetch all categories and channels
  const loadData = useCallback(async (isRefresh = false) => {
    try {
      if (isRefresh) setRefreshing(true);
      else setLoading(true);

      // 1. Fetch categories
      const { data: catData, error: catErr } = await supabase
        .from('categories')
        .select('*')
        .order('sort_order', { ascending: true })
        .order('id', { ascending: true });

      if (catErr) throw catErr;

      // 2. Fetch all channels with stable secondary sort
      const BATCH_SIZE = 1000;
      let offset = 0;
      const allChannels: ChannelData[] = [];

      while (true) {
        const { data: chBatch, error: chErr } = await supabase
          .from('channels')
          .select('*')
          .order('sort_order', { ascending: true })
          .order('id', { ascending: true })
          .range(offset, offset + BATCH_SIZE - 1);

        if (chErr) throw chErr;
        const batch = chBatch || [];
        allChannels.push(...batch);
        if (batch.length < BATCH_SIZE) break;
        offset += BATCH_SIZE;
      }

      // 3. Compute channel counts per category
      const countsMap: Record<string, number> = {};
      allChannels.forEach((ch) => {
        if (ch.category) {
          countsMap[ch.category] = (countsMap[ch.category] || 0) + 1;
        }
      });

      const formattedCategories: CategoryData[] = (catData || []).map((cat) => ({
        ...cat,
        channel_count: countsMap[cat.id] || 0,
      }));

      setCategories(formattedCategories);
      setChannels(allChannels);

      // If a channel was selected, re-hydrate it
      if (selectedChannelId) {
        const found = allChannels.find((c) => c.id === selectedChannelId);
        if (found) {
          setEditingChannel(found);
        }
      }
    } catch (err: any) {
      showNotification('error', err.message || 'Failed to load studio data');
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  }, [supabase, selectedChannelId]);

  useEffect(() => {
    loadData();
  }, [loadData]);

  // Load stream servers for the currently selected channel
  const loadChannelServers = useCallback(async (channelId: string, currentStreamUrl: string, currentLinkNames?: string[]) => {
    try {
      const { data, error } = await supabase
        .from('stream_servers')
        .select('*')
        .eq('channel_id', channelId)
        .order('sort_order', { ascending: true })
        .order('created_at', { ascending: true });

      if (error) throw error;

      if (data && data.length > 0) {
        setChannelServers(data);
      } else {
        // Fallback: If no stream_servers rows exist, create a default server based on channels.stream_url
        const initialServer: StreamServer = {
          channel_id: channelId,
          name: (currentLinkNames && currentLinkNames[0]) || 'Server 1 (Auto)',
          stream_url: currentStreamUrl || '',
          scheme: 0,
          sort_order: 0,
          active: true,
          drm: null,
          headers: null,
        };
        setChannelServers([initialServer]);
      }
      setActivePreviewServerIndex(0);
    } catch (err: any) {
      console.warn('Failed to load stream servers:', err);
    }
  }, [supabase]);

  // Handle Channel Selection
  const handleSelectChannel = (channel: ChannelData) => {
    setSelectedChannelId(channel.id);
    setEditingChannel({ ...channel });
    setIdLocked(true);
    loadChannelServers(channel.id, channel.stream_url, channel.link_names);
    setMobileView('inspector');
  };

  // Create New Channel Action
  const handleStartNewChannel = () => {
    const defaultCat = selectedCategoryId !== 'all' ? selectedCategoryId : (categories[0]?.id || 'bangla');
    const newChan: ChannelData = {
      id: '',
      name: '',
      logo: '',
      category: defaultCat,
      quality: 'HD',
      stream_url: '',
      proxy: false,
      is_live: true,
      is_trending: false,
      sort_order: 0,
    };
    setSelectedChannelId(null);
    setEditingChannel(newChan);
    setIdLocked(false);
    setChannelServers([
      {
        name: 'Server 1 (Primary)',
        stream_url: '',
        scheme: 0,
        sort_order: 0,
        active: true,
        drm: null,
        headers: null,
      },
    ]);
    setActivePreviewServerIndex(0);
    setMobileView('inspector');
  };

  // Filtered Categories
  const filteredCategories = useMemo(() => {
    if (!searchCategory.trim()) return categories;
    const term = searchCategory.toLowerCase();
    return categories.filter(
      (c) => c.name.toLowerCase().includes(term) || c.id.toLowerCase().includes(term)
    );
  }, [categories, searchCategory]);

  // Filtered Channels for Middle Pane
  const filteredChannels = useMemo(() => {
    return channels.filter((ch) => {
      // Category filter
      if (selectedCategoryId !== 'all' && ch.category !== selectedCategoryId) {
        return false;
      }
      // Status filter
      if (statusFilter === 'live' && !ch.is_live) return false;
      if (statusFilter === 'offline' && ch.is_live) return false;
      if (statusFilter === 'trending' && !ch.is_trending) return false;

      // Search term
      if (searchChannel.trim()) {
        const term = searchChannel.toLowerCase();
        const matchName = ch.name.toLowerCase().includes(term);
        const matchId = ch.id.toLowerCase().includes(term);
        const matchCat = (ch.category || '').toLowerCase().includes(term);
        if (!matchName && !matchId && !matchCat) return false;
      }

      return true;
    });
  }, [channels, selectedCategoryId, statusFilter, searchChannel]);

  // Save Channel & Stream Servers (Dual-Sync)
  const handleSaveChannel = async () => {
    if (!editingChannel) return;
    const name = editingChannel.name.trim();
    const id = editingChannel.id.trim().toLowerCase();

    if (!name) {
      showNotification('error', 'Channel name is required');
      return;
    }
    if (!id) {
      showNotification('error', 'Channel unique ID is required');
      return;
    }

    try {
      setSavingChannel(true);

      // Primary stream server resolution
      const activeServers = channelServers.filter((s) => s.active);
      const primaryServer = activeServers[0] || channelServers[0];
      const primaryStreamUrl = primaryServer?.stream_url?.trim() || editingChannel.stream_url || '';
      const serverNames = channelServers.map((s) => s.name.trim() || 'Server');

      // 1. Upsert Channel in channels table
      const channelPayload = {
        id,
        name,
        logo: editingChannel.logo?.trim() || null,
        category: editingChannel.category || null,
        quality: editingChannel.quality || 'HD',
        stream_url: primaryStreamUrl,
        proxy: editingChannel.proxy,
        is_live: editingChannel.is_live,
        is_trending: editingChannel.is_trending,
        sort_order: editingChannel.sort_order,
        link_names: serverNames,
        drm: primaryServer?.drm || null,
      };

      const { error: chErr } = await supabase
        .from('channels')
        .upsert(channelPayload, { onConflict: 'id' });

      if (chErr) throw chErr;

      // 2. Synchronize stream_servers table
      // Delete existing stream_servers for this channel_id
      await supabase.from('stream_servers').delete().eq('channel_id', id);

      // Insert updated servers
      if (channelServers.length > 0) {
        const serversPayload = channelServers.map((srv, idx) => ({
          channel_id: id,
          name: srv.name.trim() || `Server ${idx + 1}`,
          stream_url: srv.stream_url.trim(),
          scheme: srv.scheme || 0,
          drm: srv.drm || null,
          headers: srv.headers || null,
          has_header: Boolean(srv.headers && Object.keys(srv.headers).length > 0),
          has_vpn_detection: srv.has_vpn_detection || false,
          sort_order: idx,
          active: srv.active !== false,
        }));

        const { error: srvErr } = await supabase.from('stream_servers').insert(serversPayload);
        if (srvErr) throw srvErr;
      }

      // 3. Bump version in app_settings for real-time mobile app update
      await bumpChannelsVersion();

      showNotification('success', `Channel "${name}" and ${channelServers.length} servers saved successfully!`);
      setSelectedChannelId(id);
      await loadData(true);
      onRefreshStats?.();
    } catch (err: any) {
      showNotification('error', err.message || 'Failed to save channel');
    } finally {
      setSavingChannel(false);
    }
  };

  // Delete Channel Action
  const handleDeleteChannel = async (channelId: string, channelName: string) => {
    if (!confirm(`Are you sure you want to permanently delete "${channelName}"? This will delete all its stream servers.`)) {
      return;
    }

    try {
      const { error } = await supabase.from('channels').delete().eq('id', channelId);
      if (error) throw error;

      await bumpChannelsVersion();
      showNotification('success', `Deleted "${channelName}"`);
      if (selectedChannelId === channelId) {
        setSelectedChannelId(null);
        setEditingChannel(null);
        setChannelServers([]);
        setMobileView('channels');
      }
      await loadData(true);
      onRefreshStats?.();
    } catch (err: any) {
      showNotification('error', err.message || 'Failed to delete channel');
    }
  };

  // Save Category Action
  const handleSaveCategory = async (catData: CategoryData) => {
    try {
      const { error } = await supabase
        .from('categories')
        .upsert(catData, { onConflict: 'id' });

      if (error) throw error;

      await bumpChannelsVersion();
      showNotification('success', `Category "${catData.name}" saved!`);
      await loadData(true);
      onRefreshStats?.();
    } catch (err: any) {
      showNotification('error', err.message || 'Failed to save category');
      throw err;
    }
  };

  // Delete Category Action
  const handleDeleteCategory = async (cat: CategoryData) => {
    if (cat.channel_count && cat.channel_count > 0) {
      if (!confirm(`Category "${cat.name}" has ${cat.channel_count} channels. Deleting this category will leave those channels uncategorized. Continue?`)) {
        return;
      }
    } else {
      if (!confirm(`Delete category "${cat.name}"?`)) return;
    }

    try {
      const { error } = await supabase.from('categories').delete().eq('id', cat.id);
      if (error) throw error;

      await bumpChannelsVersion();
      showNotification('success', `Deleted category "${cat.name}"`);
      if (selectedCategoryId === cat.id) {
        setSelectedCategoryId('all');
      }
      await loadData(true);
      onRefreshStats?.();
    } catch (err: any) {
      showNotification('error', err.message || 'Failed to delete category');
    }
  };

  // Bulk Actions
  const handleSelectAllChannels = () => {
    if (selectedChannelIds.length === filteredChannels.length) {
      setSelectedChannelIds([]);
    } else {
      setSelectedChannelIds(filteredChannels.map((c) => c.id));
    }
  };

  const handleBulkMoveCategory = async () => {
    if (!bulkTargetCategory || selectedChannelIds.length === 0) return;
    try {
      const { error } = await supabase
        .from('channels')
        .update({ category: bulkTargetCategory })
        .in('id', selectedChannelIds);

      if (error) throw error;

      await bumpChannelsVersion();
      showNotification('success', `Moved ${selectedChannelIds.length} channels to "${bulkTargetCategory}"`);
      setSelectedChannelIds([]);
      setIsBulkMode(false);
      await loadData(true);
    } catch (err: any) {
      showNotification('error', err.message || 'Bulk move failed');
    }
  };

  const handleBulkToggleActive = async (targetActive: boolean) => {
    if (selectedChannelIds.length === 0) return;
    try {
      const { error } = await supabase
        .from('channels')
        .update({ is_live: targetActive })
        .in('id', selectedChannelIds);

      if (error) throw error;

      await bumpChannelsVersion();
      showNotification('success', `Updated ${selectedChannelIds.length} channels to ${targetActive ? 'Live' : 'Offline'}`);
      setSelectedChannelIds([]);
      setIsBulkMode(false);
      await loadData(true);
    } catch (err: any) {
      showNotification('error', err.message || 'Bulk update failed');
    }
  };

  const handleBulkDelete = async () => {
    if (selectedChannelIds.length === 0) return;
    if (!confirm(`Permanently delete ${selectedChannelIds.length} selected channels and all their stream servers?`)) {
      return;
    }

    try {
      const { error } = await supabase
        .from('channels')
        .delete()
        .in('id', selectedChannelIds);

      if (error) throw error;

      await bumpChannelsVersion();
      showNotification('success', `Deleted ${selectedChannelIds.length} channels`);
      setSelectedChannelIds([]);
      setIsBulkMode(false);
      if (selectedChannelId && selectedChannelIds.includes(selectedChannelId)) {
        setSelectedChannelId(null);
        setEditingChannel(null);
        setChannelServers([]);
      }
      await loadData(true);
    } catch (err: any) {
      showNotification('error', err.message || 'Bulk delete failed');
    }
  };

  // M3U Batch Import Complete Handler
  const handleM3uImportComplete = async (importedList: Array<{ name: string; logo: string | null; category: string; stream_url: string }>) => {
    try {
      // Chunk insertions in batches of 100
      const CHUNK_SIZE = 100;
      for (let i = 0; i < importedList.length; i += CHUNK_SIZE) {
        const chunk = importedList.slice(i, i + CHUNK_SIZE);

        const channelRows = chunk.map((item, idx) => {
          const slug = (item.name + '-' + Math.random().toString(36).substring(2, 7))
            .toLowerCase()
            .replace(/[^a-z0-9]+/g, '-')
            .replace(/^-+|-+$/g, '');

          return {
            id: slug,
            name: item.name,
            logo: item.logo,
            category: item.category,
            quality: 'HD',
            stream_url: item.stream_url,
            proxy: false,
            is_live: true,
            is_trending: false,
            sort_order: i + idx,
            link_names: ['Server 1 (Primary)'],
          };
        });

        const { error: chErr } = await supabase.from('channels').insert(channelRows);
        if (chErr) throw chErr;

        // Also create stream_servers
        const serverRows = channelRows.map((ch) => ({
          channel_id: ch.id,
          name: 'Server 1 (Primary)',
          stream_url: ch.stream_url,
          scheme: 0,
          sort_order: 0,
          active: true,
        }));

        await supabase.from('stream_servers').insert(serverRows);
      }

      await bumpChannelsVersion();
      showNotification('success', `Successfully imported ${importedList.length} channels!`);
      await loadData(true);
      onRefreshStats?.();
    } catch (err: any) {
      showNotification('error', err.message || 'Import failed');
      throw err;
    }
  };

  // Server management helpers for Pane 3
  const handleAddServer = () => {
    const nextIdx = channelServers.length + 1;
    setChannelServers([
      ...channelServers,
      {
        name: `Server ${nextIdx}`,
        stream_url: '',
        scheme: 0,
        sort_order: channelServers.length,
        active: true,
        drm: null,
        headers: null,
      },
    ]);
  };

  const handleUpdateServer = (idx: number, updates: Partial<StreamServer>) => {
    const next = [...channelServers];
    next[idx] = { ...next[idx], ...updates };
    setChannelServers(next);
  };

  const handleDeleteServer = (idx: number) => {
    if (channelServers.length <= 1) {
      showNotification('error', 'A channel must have at least one stream server entry');
      return;
    }
    const next = channelServers.filter((_, i) => i !== idx);
    setChannelServers(next);
    if (activePreviewServerIndex >= next.length) {
      setActivePreviewServerIndex(Math.max(0, next.length - 1));
    }
  };

  const handleMoveServer = (idx: number, direction: 'up' | 'down') => {
    if ((direction === 'up' && idx === 0) || (direction === 'down' && idx === channelServers.length - 1)) {
      return;
    }
    const targetIdx = direction === 'up' ? idx - 1 : idx + 1;
    const next = [...channelServers];
    const temp = next[idx];
    next[idx] = next[targetIdx];
    next[targetIdx] = temp;
    setChannelServers(next);
    setActivePreviewServerIndex(targetIdx);
  };

  // Resolve individual channel PlayZ encrypted streams
  const handleResolvePlayzStreams = async (autoSave = false) => {
    if (!editingChannel) return;
    const path = editingChannel.playz_links || editingChannel.stream_url;
    if (!path) return;

    try {
      setResolvingPlayz(true);
      const res = await fetch('/api/resolve-playz-stream', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ linksPath: path }),
      });
      const data = await res.json();
      if (!data.ok) throw new Error(data.error || 'Failed to resolve streams');

      if (data.servers && data.servers.length > 0) {
        setChannelServers(data.servers);
        setActivePreviewServerIndex(0);

        if (autoSave && editingChannel.id) {
          // Delete old servers & insert resolved servers
          await supabase.from('stream_servers').delete().eq('channel_id', editingChannel.id);
          const serverRows = data.servers.map((s: any, idx: number) => ({
            channel_id: editingChannel.id,
            name: s.name,
            stream_url: s.stream_url,
            scheme: s.scheme || 0,
            drm: s.drm || null,
            headers: s.headers || null,
            has_header: Boolean(s.headers && Object.keys(s.headers).length > 0),
            sort_order: idx,
            active: true,
          }));
          await supabase.from('stream_servers').insert(serverRows);

          // Update primary stream_url and link_names
          await supabase
            .from('channels')
            .update({
              stream_url: data.servers[0].stream_url,
              link_names: data.servers.map((s: any) => s.name),
              drm: data.servers[0].drm || null,
            })
            .eq('id', editingChannel.id);

          await bumpChannelsVersion();
          await loadData(true);
          showNotification(
            'success',
            `Resolved & saved ${data.servers.length} live streams: ${data.servers.map((s: any) => s.name).join(', ')}`
          );
        } else {
          showNotification(
            'success',
            `Resolved ${data.servers.length} live streams (${data.servers.map((s: any) => s.name).join(', ')}). Click "Save" to commit.`
          );
        }
      } else {
        showNotification('error', 'No stream sources found in manifest');
      }
    } catch (err: any) {
      showNotification('error', err.message || 'Stream resolution failed');
    } finally {
      setResolvingPlayz(false);
    }
  };

  // Batch resolve all PlayZ channels in the current view
  const handleBatchResolveCategoryStreams = async () => {
    const targets = filteredChannels.filter(
      (c) => (c.stream_url?.startsWith('pro/') || c.stream_url?.includes('.txt') || c.playz_links?.startsWith('pro/'))
    );

    if (targets.length === 0) {
      showNotification('error', 'No encrypted PlayZ channels found in this view to resolve.');
      return;
    }

    if (!confirm(`Resolve and extract live FHD/HD streams for ${targets.length} channels in this category? This will update their stream servers in Supabase.`)) {
      return;
    }

    try {
      setBatchResolving(true);
      setBatchProgress({ current: 0, total: targets.length });

      let successCount = 0;
      for (let i = 0; i < targets.length; i++) {
        const ch = targets[i];
        setBatchProgress({ current: i + 1, total: targets.length });

        const path = ch.playz_links || ch.stream_url;
        if (!path) continue;

        try {
          const res = await fetch('/api/resolve-playz-stream', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ linksPath: path }),
          });
          const data = await res.json();

          if (data.ok && data.servers && data.servers.length > 0) {
            // Delete old servers & insert resolved
            await supabase.from('stream_servers').delete().eq('channel_id', ch.id);
            const serverRows = data.servers.map((s: any, idx: number) => ({
              channel_id: ch.id,
              name: s.name,
              stream_url: s.stream_url,
              scheme: s.scheme || 0,
              drm: s.drm || null,
              headers: s.headers || null,
              has_header: Boolean(s.headers && Object.keys(s.headers).length > 0),
              sort_order: idx,
              active: true,
            }));
            await supabase.from('stream_servers').insert(serverRows);

            await supabase
              .from('channels')
              .update({
                stream_url: data.servers[0].stream_url,
                link_names: data.servers.map((s: any) => s.name),
                drm: data.servers[0].drm || null,
              })
              .eq('id', ch.id);

            successCount++;
          }
        } catch (itemErr) {
          console.warn(`Failed to resolve ${ch.name}:`, itemErr);
        }
      }

      await bumpChannelsVersion();
      await loadData(true);
      showNotification('success', `Successfully batch-resolved ${successCount} of ${targets.length} channels!`);
    } catch (err: any) {
      showNotification('error', err.message || 'Batch resolution failed');
    } finally {
      setBatchResolving(false);
      setBatchProgress(null);
    }
  };

  if (loading) {
    return (
      <div className="h-[calc(100vh-80px)] flex flex-col items-center justify-center gap-3 bg-zinc-950 text-zinc-400">
        <div className="w-10 h-10 border-3 border-purple-500 border-t-transparent rounded-full animate-spin" />
        <p className="text-xs font-semibold tracking-wider text-zinc-300">INITIALIZING LIVE TV STUDIO...</p>
      </div>
    );
  }

  return (
    <div className="h-[calc(100vh-64px)] flex flex-col bg-zinc-950 overflow-hidden relative">
      {/* Toast Notification */}
      {notification && (
        <div
          className={`fixed top-4 right-4 z-50 px-4 py-3 rounded-2xl shadow-2xl border text-xs font-bold flex items-center gap-2.5 transition-all duration-300 animate-in fade-in slide-in-from-top-3 ${
            notification.type === 'success'
              ? 'bg-emerald-950/90 border-emerald-500 text-emerald-200 shadow-emerald-900/30'
              : 'bg-rose-950/90 border-rose-500 text-rose-200 shadow-rose-900/30'
          }`}
        >
          {notification.type === 'success' ? (
            <CheckCircle2 className="w-4 h-4 text-emerald-400 flex-shrink-0" />
          ) : (
            <AlertCircle className="w-4 h-4 text-rose-400 flex-shrink-0" />
          )}
          <span>{notification.message}</span>
        </div>
      )}

      {/* Studio Header Bar */}
      <div className="px-5 py-3 bg-zinc-900/80 border-b border-zinc-800 flex items-center justify-between gap-4 flex-shrink-0">
        <div className="flex items-center gap-3">
          <div className="w-8 h-8 rounded-xl bg-gradient-to-tr from-purple-600 to-pink-600 flex items-center justify-center text-white shadow-md shadow-purple-500/20">
            <Radio className="w-4 h-4" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <h2 className="text-sm font-extrabold text-white tracking-wide leading-tight">Live TV Studio</h2>
              <span className="px-2 py-0.5 rounded-full bg-lime-400/10 border border-lime-400/30 text-lime-400 text-[10px] font-bold tracking-wider">
                FLAGSHIP 3.0
              </span>
            </div>
            <p className="text-[11px] text-zinc-400">
              Manage categories, channels, multi-server streams & DRM in one unified studio
            </p>
          </div>
        </div>

        <div className="flex items-center gap-2">
          {/* Quick Stats Pill */}
          <div className="hidden md:flex items-center gap-3 px-3 py-1.5 rounded-xl bg-zinc-950/80 border border-zinc-800 text-xs">
            <span className="text-zinc-400 font-medium">
              Categories: <strong className="text-white">{categories.length}</strong>
            </span>
            <span className="w-1 h-3 bg-zinc-800" />
            <span className="text-zinc-400 font-medium">
              Channels: <strong className="text-white">{channels.length}</strong>
            </span>
          </div>

          <button
            onClick={() => loadData(true)}
            disabled={refreshing}
            title="Refresh database catalog"
            className="p-2 rounded-xl bg-zinc-800 hover:bg-zinc-700 text-zinc-300 hover:text-white transition cursor-pointer disabled:opacity-50"
          >
            <RefreshCw className={`w-4 h-4 ${refreshing ? 'animate-spin text-purple-400' : ''}`} />
          </button>

          <Link
            href="/dashboard/automations"
            className="px-3 py-1.5 rounded-xl bg-purple-950/40 hover:bg-purple-900/50 text-purple-300 text-xs font-semibold transition cursor-pointer flex items-center gap-1.5 border border-purple-800/50 shadow-sm"
            title="Manage Stream Auto-Sync Automations"
          >
            <Workflow className="w-3.5 h-3.5 text-purple-400" />
            <span className="hidden sm:inline">Automations</span>
          </Link>

          <button
            onClick={() => setIsM3uModalOpen(true)}
            className="px-3 py-1.5 rounded-xl bg-zinc-800 hover:bg-zinc-700 text-zinc-200 text-xs font-semibold transition cursor-pointer flex items-center gap-1.5 border border-zinc-700/60"
          >
            <Upload className="w-3.5 h-3.5" />
            <span className="hidden sm:inline">Import M3U</span>
          </button>

          <button
            onClick={handleStartNewChannel}
            className="px-3.5 py-1.5 rounded-xl bg-purple-600 hover:bg-purple-500 text-white text-xs font-bold transition cursor-pointer flex items-center gap-1.5 shadow-md shadow-purple-600/20"
          >
            <Plus className="w-4 h-4" />
            <span>New Channel</span>
          </button>
        </div>
      </div>

      {/* Studio Workspace: 3-Pane Layout */}
      <div className="flex-1 flex overflow-hidden">
        {/* ─── PANE 1: CATEGORIES PANEL (Left) ─── */}
        <aside
          className={`w-full md:w-64 lg:w-72 flex-shrink-0 bg-zinc-900/60 border-r border-zinc-800 flex flex-col ${
            mobileView === 'categories' ? 'flex' : 'hidden md:flex'
          }`}
        >
          {/* Categories Search & Header */}
          <div className="p-3 border-b border-zinc-800 space-y-2.5">
            <div className="flex items-center justify-between">
              <span className="text-xs font-bold text-zinc-300 uppercase tracking-wider flex items-center gap-1.5">
                <Layers className="w-3.5 h-3.5 text-purple-400" /> Categories ({categories.length})
              </span>
              <button
                onClick={() => {
                  setEditingCategory(null);
                  setIsCategoryModalOpen(true);
                }}
                className="p-1 rounded-lg bg-purple-600/20 hover:bg-purple-600 text-purple-300 hover:text-white transition cursor-pointer text-[11px] font-semibold flex items-center gap-1 px-2 border border-purple-500/30"
              >
                <Plus className="w-3 h-3" /> Add
              </button>
            </div>

            <div className="relative">
              <Search className="w-3.5 h-3.5 absolute left-2.5 top-1/2 -translate-y-1/2 text-zinc-500" />
              <input
                type="text"
                value={searchCategory}
                onChange={(e) => setSearchCategory(e.target.value)}
                placeholder="Search categories..."
                className="w-full pl-8 pr-3 py-1.5 bg-zinc-950 border border-zinc-800 rounded-xl text-xs text-white placeholder:text-zinc-600 focus:outline-hidden focus:border-purple-500 transition"
              />
            </div>
          </div>

          {/* Categories Scrollable List */}
          <div className="flex-1 overflow-y-auto p-2 space-y-1">
            {/* All Categories Option */}
            <button
              onClick={() => {
                setSelectedCategoryId('all');
                setMobileView('channels');
              }}
              className={`w-full p-2.5 rounded-xl text-left transition cursor-pointer flex items-center justify-between border ${
                selectedCategoryId === 'all'
                  ? 'bg-purple-600/20 border-purple-500 text-white shadow-sm'
                  : 'bg-zinc-950/60 hover:bg-zinc-800/60 border-zinc-800/80 text-zinc-300'
              }`}
            >
              <div className="flex items-center gap-2.5 min-w-0">
                <div className="w-7 h-7 rounded-lg bg-zinc-800 border border-zinc-700/80 flex items-center justify-center text-xs font-bold text-purple-400 flex-shrink-0">
                  ALL
                </div>
                <div className="min-w-0">
                  <span className="text-xs font-bold block truncate">All Channels</span>
                  <span className="text-[10px] text-zinc-500 font-mono">Entire Catalog</span>
                </div>
              </div>
              <span className="px-2 py-0.5 rounded-full bg-zinc-800 text-[10px] font-bold text-zinc-300">
                {channels.length}
              </span>
            </button>

            {/* Individual Category Cards */}
            {filteredCategories.map((cat) => {
              const isSelected = selectedCategoryId === cat.id;
              return (
                <div
                  key={cat.id}
                  onClick={() => {
                    setSelectedCategoryId(cat.id);
                    setMobileView('channels');
                  }}
                  className={`group relative p-2.5 rounded-xl transition cursor-pointer flex items-center justify-between border ${
                    isSelected
                      ? 'bg-purple-600/20 border-purple-500 text-white shadow-sm'
                      : 'bg-zinc-950/60 hover:bg-zinc-800/60 border-zinc-800/80 text-zinc-300'
                  }`}
                >
                  <div className="flex items-center gap-2.5 min-w-0">
                    {cat.icon_url ? (
                      // eslint-disable-next-line @next/next/no-img-element
                      <img
                        src={cat.icon_url}
                        alt={cat.name}
                        className="w-7 h-7 rounded-lg object-cover bg-zinc-800 border border-zinc-700/80 flex-shrink-0"
                        onError={(e) => {
                          (e.target as HTMLElement).style.display = 'none';
                        }}
                      />
                    ) : (
                      <div className="w-7 h-7 rounded-lg bg-zinc-800 border border-zinc-700/80 flex items-center justify-center text-xs font-bold text-zinc-400 flex-shrink-0">
                        {cat.name[0]}
                      </div>
                    )}

                    <div className="min-w-0">
                      <div className="flex items-center gap-1.5">
                        <span className="text-xs font-bold truncate">{cat.name}</span>
                        {!cat.active && (
                          <span className="w-1.5 h-1.5 rounded-full bg-zinc-600" title="Disabled" />
                        )}
                      </div>
                      <div className="flex items-center gap-1.5 text-[10px] text-zinc-400 font-mono">
                        <span>{cat.id}</span>
                        {cat.type === 'm3u' && (
                          <span className="px-1 py-0.1 bg-sky-950 text-sky-400 rounded text-[9px]">M3U</span>
                        )}
                      </div>
                    </div>
                  </div>

                  {/* Actions & Count */}
                  <div className="flex items-center gap-1">
                    <span className="px-2 py-0.5 rounded-full bg-zinc-800 text-[10px] font-bold text-zinc-300 group-hover:hidden">
                      {cat.channel_count || 0}
                    </span>

                    {/* Quick Edit/Delete on Hover */}
                    <div className="hidden group-hover:flex items-center gap-1">
                      <button
                        type="button"
                        onClick={(e) => {
                          e.stopPropagation();
                          setEditingCategory(cat);
                          setIsCategoryModalOpen(true);
                        }}
                        className="p-1 rounded-md bg-zinc-800 hover:bg-zinc-700 text-zinc-300 hover:text-white transition"
                        title="Edit Category"
                      >
                        <Edit2 className="w-3 h-3" />
                      </button>
                      <button
                        type="button"
                        onClick={(e) => {
                          e.stopPropagation();
                          handleDeleteCategory(cat);
                        }}
                        className="p-1 rounded-md bg-zinc-800 hover:bg-rose-900/60 text-zinc-400 hover:text-rose-300 transition"
                        title="Delete Category"
                      >
                        <Trash2 className="w-3 h-3" />
                      </button>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </aside>

        {/* ─── PANE 2: CHANNELS LIST (Middle) ─── */}
        <section
          className={`w-full md:w-80 lg:w-96 flex-shrink-0 bg-zinc-950 border-r border-zinc-800 flex flex-col ${
            mobileView === 'channels' ? 'flex' : 'hidden md:flex'
          }`}
        >
          {/* Channels Header & Search */}
          <div className="p-3 border-b border-zinc-800 space-y-2.5">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-1.5 min-w-0">
                <button
                  onClick={() => setMobileView('categories')}
                  className="md:hidden p-1 rounded-lg text-zinc-400 hover:text-white mr-1"
                >
                  <ChevronLeft className="w-4 h-4" />
                </button>
                <span className="text-xs font-bold text-white truncate">
                  {selectedCategoryId === 'all'
                    ? 'All Channels'
                    : categories.find((c) => c.id === selectedCategoryId)?.name || selectedCategoryId}
                </span>
                <span className="px-1.5 py-0.5 rounded-full bg-zinc-800 text-[10px] font-bold text-zinc-400">
                  {filteredChannels.length}
                </span>
              </div>

              <div className="flex items-center gap-1.5">
                {/* Batch Resolve Category Button */}
                {filteredChannels.some(
                  (c) => c.stream_url?.startsWith('pro/') || c.stream_url?.includes('.txt') || c.playz_links?.startsWith('pro/')
                ) && (
                  <button
                    onClick={handleBatchResolveCategoryStreams}
                    disabled={batchResolving}
                    className="px-2 py-1 rounded-lg text-[11px] font-bold transition cursor-pointer flex items-center gap-1 border bg-amber-500/10 border-amber-500/30 text-amber-300 hover:bg-amber-500/20 disabled:opacity-50"
                    title="Batch decrypt PlayZ manifests and extract FHD/HD servers for this category"
                  >
                    {batchResolving ? (
                      <>
                        <Loader2 className="w-3 h-3 animate-spin" />
                        <span>{batchProgress ? `${batchProgress.current}/${batchProgress.total}` : 'Resolving...'}</span>
                      </>
                    ) : (
                      <>
                        <Zap className="w-3 h-3 text-amber-400" />
                        <span>Resolve All</span>
                      </>
                    )}
                  </button>
                )}

                {/* Bulk Mode Switcher */}
                <button
                  onClick={() => {
                    setIsBulkMode(!isBulkMode);
                    setSelectedChannelIds([]);
                  }}
                  className={`px-2 py-1 rounded-lg text-[11px] font-semibold transition cursor-pointer flex items-center gap-1 border ${
                    isBulkMode
                      ? 'bg-purple-600 text-white border-purple-400'
                      : 'bg-zinc-900 hover:bg-zinc-800 text-zinc-400 hover:text-zinc-200 border-zinc-800'
                  }`}
                >
                  <CheckSquare className="w-3 h-3" />
                  <span>{isBulkMode ? 'Done' : 'Select'}</span>
                </button>
              </div>
            </div>

            {/* Search Input */}
            <div className="relative">
              <Search className="w-3.5 h-3.5 absolute left-2.5 top-1/2 -translate-y-1/2 text-zinc-500" />
              <input
                type="text"
                value={searchChannel}
                onChange={(e) => setSearchChannel(e.target.value)}
                placeholder="Search channels by name, ID..."
                className="w-full pl-8 pr-3 py-1.5 bg-zinc-900 border border-zinc-800 rounded-xl text-xs text-white placeholder:text-zinc-600 focus:outline-hidden focus:border-purple-500 transition"
              />
            </div>

            {/* Filter Pills */}
            <div className="flex gap-1 overflow-x-auto pb-0.5">
              {(['all', 'live', 'offline', 'trending'] as const).map((st) => (
                <button
                  key={st}
                  onClick={() => setStatusFilter(st)}
                  className={`px-2.5 py-0.8 rounded-lg text-[10px] font-semibold transition cursor-pointer capitalize flex-shrink-0 ${
                    statusFilter === st
                      ? 'bg-zinc-200 text-zinc-950 font-bold'
                      : 'bg-zinc-900 text-zinc-400 hover:text-zinc-200 border border-zinc-800/80'
                  }`}
                >
                  {st}
                </button>
              ))}
            </div>

            {/* Bulk Actions Bar (When Active) */}
            {isBulkMode && (
              <div className="p-2.5 bg-purple-950/40 border border-purple-500/40 rounded-xl space-y-2">
                <div className="flex items-center justify-between text-xs">
                  <span className="font-bold text-purple-200">
                    {selectedChannelIds.length} of {filteredChannels.length} selected
                  </span>
                  <button
                    onClick={handleSelectAllChannels}
                    className="text-[11px] text-purple-400 hover:text-purple-300 font-semibold cursor-pointer"
                  >
                    {selectedChannelIds.length === filteredChannels.length ? 'Deselect All' : 'Select All'}
                  </button>
                </div>

                {selectedChannelIds.length > 0 && (
                  <div className="flex flex-wrap items-center gap-1.5 pt-1">
                    <select
                      value={bulkTargetCategory}
                      onChange={(e) => setBulkTargetCategory(e.target.value)}
                      className="px-2 py-1 bg-zinc-900 border border-zinc-700 rounded-lg text-[11px] text-zinc-200 focus:outline-hidden"
                    >
                      <option value="">Move to Category...</option>
                      {categories.map((c) => (
                        <option key={c.id} value={c.id}>
                          {c.name}
                        </option>
                      ))}
                    </select>

                    <button
                      onClick={handleBulkMoveCategory}
                      disabled={!bulkTargetCategory}
                      className="px-2 py-1 bg-purple-600 hover:bg-purple-500 text-white text-[11px] font-bold rounded-lg transition disabled:opacity-40 cursor-pointer"
                    >
                      Move
                    </button>

                    <button
                      onClick={() => handleBulkToggleActive(true)}
                      className="px-2 py-1 bg-emerald-700/80 hover:bg-emerald-600 text-white text-[11px] font-bold rounded-lg transition cursor-pointer"
                    >
                      Live
                    </button>

                    <button
                      onClick={() => handleBulkToggleActive(false)}
                      className="px-2 py-1 bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-[11px] font-bold rounded-lg transition cursor-pointer"
                    >
                      Offline
                    </button>

                    <button
                      onClick={handleBulkDelete}
                      className="px-2 py-1 bg-rose-700/80 hover:bg-rose-600 text-white text-[11px] font-bold rounded-lg transition cursor-pointer"
                    >
                      Delete
                    </button>
                  </div>
                )}
              </div>
            )}
          </div>

          {/* Channels Scrollable List */}
          <div className="flex-1 overflow-y-auto p-2 space-y-1.5">
            {filteredChannels.length === 0 ? (
              <div className="p-8 text-center text-zinc-500">
                <Tv className="w-8 h-8 mx-auto mb-2 opacity-30" />
                <p className="text-xs font-medium">No channels found</p>
                <p className="text-[10px] text-zinc-600 mt-1">Try another category or add a new channel</p>
              </div>
            ) : (
              filteredChannels.map((ch) => {
                const isSelected = selectedChannelId === ch.id;
                const isChecked = selectedChannelIds.includes(ch.id);

                return (
                  <div
                    key={ch.id}
                    onClick={() => {
                      if (isBulkMode) {
                        setSelectedChannelIds((prev) =>
                          isChecked ? prev.filter((id) => id !== ch.id) : [...prev, ch.id]
                        );
                      } else {
                        handleSelectChannel(ch);
                      }
                    }}
                    className={`p-2.5 rounded-xl border transition cursor-pointer flex items-center justify-between gap-2.5 ${
                      isSelected && !isBulkMode
                        ? 'bg-purple-600/20 border-purple-500 shadow-sm shadow-purple-500/10'
                        : isChecked
                        ? 'bg-purple-950/30 border-purple-500/60'
                        : 'bg-zinc-900/60 hover:bg-zinc-800/60 border-zinc-800/80 text-zinc-300'
                    }`}
                  >
                    <div className="flex items-center gap-2.5 min-w-0">
                      {isBulkMode && (
                        <div className="flex-shrink-0">
                          {isChecked ? (
                            <CheckSquare className="w-4 h-4 text-purple-400" />
                          ) : (
                            <Square className="w-4 h-4 text-zinc-600" />
                          )}
                        </div>
                      )}

                      {/* Channel Logo */}
                      {ch.logo ? (
                        // eslint-disable-next-line @next/next/no-img-element
                        <img
                          src={ch.logo}
                          alt={ch.name}
                          className="w-8 h-8 rounded-full object-cover bg-zinc-800 border border-zinc-700/80 flex-shrink-0"
                          onError={(e) => {
                            (e.target as HTMLElement).style.display = 'none';
                          }}
                        />
                      ) : (
                        <div className="w-8 h-8 rounded-full bg-zinc-800 border border-zinc-700/80 flex items-center justify-center text-xs font-bold text-zinc-400 flex-shrink-0">
                          {ch.name[0] || 'T'}
                        </div>
                      )}

                      {/* Channel Metadata */}
                      <div className="min-w-0">
                        <div className="flex items-center gap-1.5">
                          <span className="text-xs font-bold text-white truncate">{ch.name}</span>
                          {ch.is_trending && <Star className="w-3 h-3 text-amber-400 fill-amber-400 flex-shrink-0" />}
                        </div>
                        <div className="flex items-center gap-1.5 text-[10px] text-zinc-400 font-mono">
                          <span
                            className={`w-1.5 h-1.5 rounded-full ${
                              ch.is_live ? 'bg-emerald-400' : 'bg-zinc-600'
                            }`}
                          />
                          <span className="truncate max-w-[100px]">{ch.id}</span>
                          <span className="px-1 py-0.1 bg-zinc-800 rounded text-zinc-400 text-[9px]">
                            {ch.quality || 'HD'}
                          </span>
                        </div>
                      </div>
                    </div>

                    {/* Server count & chevron */}
                    <div className="flex items-center gap-1.5 flex-shrink-0">
                      {ch.link_names && ch.link_names.length > 1 && (
                        <span className="px-1.5 py-0.5 rounded-full bg-purple-950/80 border border-purple-500/30 text-[9px] font-bold text-purple-300">
                          {ch.link_names.length} Srv
                        </span>
                      )}
                      <ChevronRight className="w-3.5 h-3.5 text-zinc-600" />
                    </div>
                  </div>
                );
              })
            )}
          </div>
        </section>

        {/* ─── PANE 3: INSPECTOR & MULTI-SERVER MANAGER (Right) ─── */}
        <main
          className={`flex-1 bg-zinc-950 overflow-y-auto p-4 lg:p-6 flex flex-col ${
            mobileView === 'inspector' ? 'flex' : 'hidden md:flex'
          }`}
        >
          {editingChannel ? (
            <div className="max-w-4xl w-full mx-auto space-y-6">
              {/* Back to Channels button for mobile */}
              <div className="md:hidden flex items-center gap-2 pb-2">
                <button
                  onClick={() => setMobileView('channels')}
                  className="p-1.5 rounded-lg bg-zinc-900 border border-zinc-800 text-zinc-300 flex items-center gap-1 text-xs"
                >
                  <ChevronLeft className="w-3.5 h-3.5" /> Back to Channels
                </button>
              </div>

              {/* Inspector Header & Actions */}
              <div className="bg-zinc-900/90 border border-zinc-800 rounded-2xl p-4 sm:p-5 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 shadow-xl">
                <div className="flex items-center gap-3.5 min-w-0">
                  {editingChannel.logo ? (
                    // eslint-disable-next-line @next/next/no-img-element
                    <img
                      src={editingChannel.logo}
                      alt={editingChannel.name}
                      className="w-12 h-12 rounded-2xl object-cover bg-zinc-800 border border-zinc-700/80 shadow-md flex-shrink-0"
                      onError={(e) => {
                        (e.target as HTMLElement).style.display = 'none';
                      }}
                    />
                  ) : (
                    <div className="w-12 h-12 rounded-2xl bg-purple-500/20 border border-purple-500/40 text-purple-300 font-extrabold text-lg flex items-center justify-center flex-shrink-0 shadow-md">
                      {editingChannel.name ? editingChannel.name[0] : 'TV'}
                    </div>
                  )}

                  <div className="min-w-0">
                    <div className="flex items-center gap-2">
                      <h3 className="text-base font-extrabold text-white truncate">
                        {editingChannel.name || 'New Channel'}
                      </h3>
                      <span className="px-2 py-0.5 rounded-full bg-zinc-800 text-[10px] font-mono text-zinc-300">
                        {editingChannel.id || 'slug-pending'}
                      </span>
                    </div>
                    <p className="text-xs text-zinc-400">
                      Category: <strong className="text-zinc-200">{editingChannel.category || 'Unassigned'}</strong> •{' '}
                      {channelServers.length} Stream Server{channelServers.length === 1 ? '' : 's'} Configured
                    </p>
                  </div>
                </div>

                <div className="flex items-center gap-2 w-full sm:w-auto justify-end">
                  {selectedChannelId && (
                    <button
                      type="button"
                      onClick={() => handleDeleteChannel(editingChannel.id, editingChannel.name)}
                      className="px-3 py-2 rounded-xl bg-zinc-800 hover:bg-rose-950/60 text-zinc-400 hover:text-rose-300 border border-zinc-700 text-xs font-semibold transition cursor-pointer flex items-center gap-1.5"
                    >
                      <Trash2 className="w-3.5 h-3.5" />
                      <span className="hidden sm:inline">Delete</span>
                    </button>
                  )}

                  <button
                    type="button"
                    onClick={handleSaveChannel}
                    disabled={savingChannel}
                    className="px-4 py-2 rounded-xl bg-purple-600 hover:bg-purple-500 text-white text-xs font-bold transition flex items-center gap-2 cursor-pointer disabled:opacity-50 shadow-md shadow-purple-600/30"
                  >
                    {savingChannel ? (
                      <>
                        <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                        <span>Saving...</span>
                      </>
                    ) : (
                      <>
                        <Save className="w-4 h-4" />
                        <span>Save Channel & Servers</span>
                      </>
                    )}
                  </button>
                </div>
              </div>

              {/* Live Preview Player Section */}
              <LivePreviewPlayer
                servers={channelServers}
                activeServerIndex={activePreviewServerIndex}
                onSelectServer={(idx) => setActivePreviewServerIndex(idx)}
                channelName={editingChannel.name}
                channelLogo={editingChannel.logo}
              />

              {/* Channel Basic Details Form */}
              <div className="bg-zinc-900 border border-zinc-800 rounded-2xl p-5 space-y-4 shadow-xl">
                <div className="flex items-center justify-between border-b border-zinc-800 pb-3">
                  <span className="text-xs font-bold text-white uppercase tracking-wider flex items-center gap-1.5">
                    <Settings2 className="w-4 h-4 text-purple-400" /> Channel Metadata
                  </span>
                  <span className="text-[11px] text-zinc-500 font-mono">Syncs to public.channels</span>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  {/* Name */}
                  <div>
                    <label className="block text-xs font-medium text-zinc-300 mb-1">
                      Channel Name <span className="text-purple-400">*</span>
                    </label>
                    <input
                      type="text"
                      value={editingChannel.name}
                      onChange={(e) => {
                        const name = e.target.value;
                        if (!selectedChannelId && !idLocked) {
                          const autoId = name
                            .toLowerCase()
                            .replace(/[^a-z0-9]+/g, '-')
                            .replace(/^-+|-+$/g, '');
                          setEditingChannel({ ...editingChannel, name, id: autoId });
                        } else {
                          setEditingChannel({ ...editingChannel, name });
                        }
                      }}
                      placeholder="e.g. Sony Ten 1 HD"
                      className="w-full px-3 py-2 bg-zinc-950 border border-zinc-800 rounded-xl text-white text-xs focus:outline-hidden focus:border-purple-500 transition"
                    />
                  </div>

                  {/* ID */}
                  <div>
                    <div className="flex items-center justify-between mb-1">
                      <label className="block text-xs font-medium text-zinc-300">
                        Unique Channel ID <span className="text-purple-400">*</span>
                      </label>
                      <button
                        type="button"
                        onClick={() => setIdLocked(!idLocked)}
                        className="text-[10px] text-zinc-400 hover:text-purple-400 flex items-center gap-1 cursor-pointer"
                      >
                        {idLocked ? <Lock className="w-2.5 h-2.5" /> : <Unlock className="w-2.5 h-2.5" />}
                        {idLocked ? 'Unlock' : 'Lock'}
                      </button>
                    </div>
                    <input
                      type="text"
                      value={editingChannel.id}
                      onChange={(e) => setEditingChannel({ ...editingChannel, id: e.target.value })}
                      disabled={idLocked}
                      placeholder="e.g. sony-ten-1-hd"
                      className="w-full px-3 py-2 bg-zinc-950 border border-zinc-800 rounded-xl text-white text-xs font-mono focus:outline-hidden focus:border-purple-500 transition disabled:opacity-50"
                    />
                  </div>

                  {/* Category Selector */}
                  <div>
                    <label className="block text-xs font-medium text-zinc-300 mb-1">
                      Assigned Category
                    </label>
                    <select
                      value={editingChannel.category || ''}
                      onChange={(e) => setEditingChannel({ ...editingChannel, category: e.target.value })}
                      className="w-full px-3 py-2 bg-zinc-950 border border-zinc-800 rounded-xl text-white text-xs focus:outline-hidden focus:border-purple-500 transition cursor-pointer"
                    >
                      {categories.map((c) => (
                        <option key={c.id} value={c.id}>
                          {c.name} ({c.id})
                        </option>
                      ))}
                    </select>
                  </div>

                  {/* Logo URL */}
                  <div>
                    <label className="block text-xs font-medium text-zinc-300 mb-1">
                      Channel Logo URL
                    </label>
                    <input
                      type="url"
                      value={editingChannel.logo || ''}
                      onChange={(e) => setEditingChannel({ ...editingChannel, logo: e.target.value })}
                      placeholder="https://assets-playztv.pages.dev/logo.png"
                      className="w-full px-3 py-2 bg-zinc-950 border border-zinc-800 rounded-xl text-white text-xs font-mono focus:outline-hidden focus:border-purple-500 transition"
                    />
                  </div>

                  {/* Quality & Sort Order */}
                  <div>
                    <label className="block text-xs font-medium text-zinc-300 mb-1">
                      Quality Resolution Tag
                    </label>
                    <select
                      value={editingChannel.quality || 'HD'}
                      onChange={(e) => setEditingChannel({ ...editingChannel, quality: e.target.value })}
                      className="w-full px-3 py-2 bg-zinc-950 border border-zinc-800 rounded-xl text-white text-xs focus:outline-hidden focus:border-purple-500 transition cursor-pointer"
                    >
                      <option value="4K">4K Ultra HD</option>
                      <option value="FHD">1080p Full HD</option>
                      <option value="HD">720p HD</option>
                      <option value="SD">480p SD</option>
                    </select>
                  </div>

                  <div>
                    <label className="block text-xs font-medium text-zinc-300 mb-1">
                      Sort Order Weight
                    </label>
                    <input
                      type="number"
                      value={editingChannel.sort_order}
                      onChange={(e) => setEditingChannel({ ...editingChannel, sort_order: parseInt(e.target.value) || 0 })}
                      className="w-full px-3 py-2 bg-zinc-950 border border-zinc-800 rounded-xl text-white text-xs font-mono focus:outline-hidden focus:border-purple-500 transition"
                    />
                  </div>
                </div>

                {/* Status Toggles */}
                <div className="pt-2 flex flex-wrap items-center gap-6 border-t border-zinc-800">
                  <label className="inline-flex items-center gap-2 cursor-pointer">
                    <input
                      type="checkbox"
                      checked={editingChannel.is_live}
                      onChange={(e) => setEditingChannel({ ...editingChannel, is_live: e.target.checked })}
                      className="sr-only peer"
                    />
                    <div className="w-9 h-5 bg-zinc-800 peer-focus:outline-hidden rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-emerald-500 relative"></div>
                    <span className="text-xs text-zinc-300 font-medium">Channel Active / Live</span>
                  </label>

                  <label className="inline-flex items-center gap-2 cursor-pointer">
                    <input
                      type="checkbox"
                      checked={editingChannel.is_trending}
                      onChange={(e) => setEditingChannel({ ...editingChannel, is_trending: e.target.checked })}
                      className="sr-only peer"
                    />
                    <div className="w-9 h-5 bg-zinc-800 peer-focus:outline-hidden rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-amber-500 relative"></div>
                    <span className="text-xs text-zinc-300 font-medium">Featured in Trending</span>
                  </label>

                  <label className="inline-flex items-center gap-2 cursor-pointer">
                    <input
                      type="checkbox"
                      checked={editingChannel.proxy}
                      onChange={(e) => setEditingChannel({ ...editingChannel, proxy: e.target.checked })}
                      className="sr-only peer"
                    />
                    <div className="w-9 h-5 bg-zinc-800 peer-focus:outline-hidden rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-purple-600 relative"></div>
                    <span className="text-xs text-zinc-300 font-medium">Proxy Stream via Cloudflare</span>
                  </label>
                </div>
              </div>

              {/* ─── Stream Servers Cluster Section ─── */}
              <div className="bg-zinc-900 border border-zinc-800 rounded-2xl p-5 space-y-4 shadow-xl">
                <div className="flex items-center justify-between border-b border-zinc-800 pb-3">
                  <div>
                    <span className="text-xs font-bold text-white uppercase tracking-wider flex items-center gap-1.5">
                      <Radio className="w-4 h-4 text-purple-400" /> Stream Servers Cluster ({channelServers.length})
                    </span>
                    <p className="text-[11px] text-zinc-500">
                      Top server acts as primary fallback for legacy clients
                    </p>
                  </div>

                  <div className="flex items-center gap-2">
                    {(editingChannel.playz_links?.startsWith('pro/') ||
                      editingChannel.stream_url?.startsWith('pro/') ||
                      editingChannel.stream_url?.includes('.txt') ||
                      channelServers.some((s) => s.stream_url?.startsWith('pro/'))) && (
                      <button
                        type="button"
                        onClick={() => handleResolvePlayzStreams(false)}
                        disabled={resolvingPlayz}
                        className="px-3 py-1.5 rounded-xl bg-gradient-to-r from-amber-500 to-yellow-400 hover:from-amber-400 hover:to-yellow-300 text-zinc-950 text-xs font-extrabold transition flex items-center gap-1.5 cursor-pointer shadow-md shadow-amber-500/20 disabled:opacity-50"
                        title="Decrypt pro/*.txt manifest and populate live FHD/HD streams"
                      >
                        {resolvingPlayz ? (
                          <>
                            <Loader2 className="w-3.5 h-3.5 animate-spin" />
                            <span>Resolving...</span>
                          </>
                        ) : (
                          <>
                            <Sparkles className="w-3.5 h-3.5 fill-zinc-950" />
                            <span>Auto-Resolve FHD/HD Streams</span>
                          </>
                        )}
                      </button>
                    )}

                    <button
                      type="button"
                      onClick={handleAddServer}
                      className="px-3 py-1.5 rounded-xl bg-purple-600 hover:bg-purple-500 text-white text-xs font-bold transition flex items-center gap-1.5 cursor-pointer shadow-md shadow-purple-600/20"
                    >
                      <Plus className="w-3.5 h-3.5" /> Add Stream Server
                    </button>
                  </div>
                </div>

                {/* Server Cards List */}
                <div className="space-y-3">
                  {channelServers.map((srv, idx) => {
                    const isPreviewActive = idx === activePreviewServerIndex;
                    return (
                      <div
                        key={idx}
                        className={`p-4 rounded-xl border transition ${
                          isPreviewActive
                            ? 'bg-zinc-950/90 border-purple-500/80 shadow-md shadow-purple-500/5'
                            : 'bg-zinc-950/60 border-zinc-800/80 hover:border-zinc-700/80'
                        }`}
                      >
                        {/* Server Card Header */}
                        <div className="flex items-center justify-between gap-2 mb-3">
                          <div className="flex items-center gap-2 min-w-0">
                            <span className="px-2 py-0.5 rounded bg-zinc-800 text-[10px] font-mono font-bold text-zinc-300">
                              #{idx + 1} {idx === 0 && 'PRIMARY'}
                            </span>
                            <span className="text-xs font-bold text-white truncate">
                              {srv.name || `Server ${idx + 1}`}
                            </span>
                          </div>

                          <div className="flex items-center gap-1">
                            {/* Move Up/Down */}
                            <button
                              type="button"
                              onClick={() => handleMoveServer(idx, 'up')}
                              disabled={idx === 0}
                              className="p-1 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-400 hover:text-white transition disabled:opacity-30 cursor-pointer"
                              title="Move Server Up"
                            >
                              <ChevronUp className="w-3 h-3" />
                            </button>
                            <button
                              type="button"
                              onClick={() => handleMoveServer(idx, 'down')}
                              disabled={idx === channelServers.length - 1}
                              className="p-1 rounded bg-zinc-800 hover:bg-zinc-700 text-zinc-400 hover:text-white transition disabled:opacity-30 cursor-pointer"
                              title="Move Server Down"
                            >
                              <ChevronDown className="w-3 h-3" />
                            </button>

                            {/* Active Toggle */}
                            <label className="inline-flex items-center cursor-pointer ml-1">
                              <input
                                type="checkbox"
                                checked={srv.active}
                                onChange={(e) => handleUpdateServer(idx, { active: e.target.checked })}
                                className="sr-only peer"
                              />
                              <div className="w-8 h-4.5 bg-zinc-800 peer-focus:outline-hidden rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-3.5 after:w-3.5 after:transition-all peer-checked:bg-emerald-500 relative"></div>
                            </label>

                            {/* Delete */}
                            <button
                              type="button"
                              onClick={() => handleDeleteServer(idx)}
                              className="p-1 rounded bg-zinc-800 hover:bg-rose-900/60 text-zinc-400 hover:text-rose-300 transition cursor-pointer ml-1"
                              title="Delete Server"
                            >
                              <Trash2 className="w-3 h-3" />
                            </button>
                          </div>
                        </div>

                        {/* Server Inputs */}
                        <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                          <div>
                            <label className="block text-[11px] font-medium text-zinc-400 mb-1">
                              Server Label Name
                            </label>
                            <input
                              type="text"
                              value={srv.name}
                              onChange={(e) => handleUpdateServer(idx, { name: e.target.value })}
                              placeholder="e.g. Server 1 (FHD), Hindi"
                              className="w-full px-3 py-1.5 bg-zinc-900 border border-zinc-800 rounded-lg text-white text-xs focus:outline-hidden focus:border-purple-500 transition"
                            />
                          </div>

                          <div className="sm:col-span-2">
                            <label className="block text-[11px] font-medium text-zinc-400 mb-1">
                              Live Stream URL (.m3u8, .mpd, HTTP)
                            </label>
                            <input
                              type="url"
                              value={srv.stream_url}
                              onChange={(e) => handleUpdateServer(idx, { stream_url: e.target.value })}
                              placeholder="https://stream.example.com/live/stream.m3u8"
                              className="w-full px-3 py-1.5 bg-zinc-900 border border-zinc-800 rounded-lg text-white text-xs font-mono focus:outline-hidden focus:border-purple-500 transition"
                            />
                          </div>
                        </div>

                        {/* DRM & Custom Headers Expandable Drawer */}
                        <div className="mt-3 pt-3 border-t border-zinc-800/60">
                          <details className="group/details">
                            <summary className="text-[11px] font-semibold text-purple-400 hover:text-purple-300 cursor-pointer flex items-center gap-1 select-none">
                              <Shield className="w-3 h-3" />
                              <span>DRM Encryption & Custom HTTP Headers</span>
                              <ChevronDown className="w-3 h-3 group-open/details:rotate-180 transition-transform" />
                            </summary>

                            <div className="mt-3 p-3 bg-zinc-900/80 border border-zinc-800 rounded-xl space-y-3">
                              {/* DRM Type */}
                              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                                <div>
                                  <label className="block text-[10px] font-medium text-zinc-400 mb-1">
                                    DRM System
                                  </label>
                                  <select
                                    value={srv.drm?.type || 'none'}
                                    onChange={(e) => {
                                      const val = e.target.value;
                                      if (val === 'none') {
                                        handleUpdateServer(idx, { drm: null });
                                      } else {
                                        handleUpdateServer(idx, {
                                          drm: {
                                            type: val as any,
                                            kid: srv.drm?.kid || '',
                                            key: srv.drm?.key || '',
                                            licenseUrl: srv.drm?.licenseUrl || '',
                                          },
                                        });
                                      }
                                    }}
                                    className="w-full px-2.5 py-1.5 bg-zinc-950 border border-zinc-800 rounded-lg text-xs text-white focus:outline-hidden"
                                  >
                                    <option value="none">None (Clear Stream)</option>
                                    <option value="clearkey">ClearKey (KID / KEY)</option>
                                    <option value="widevine">Widevine Modular</option>
                                    <option value="playready">PlayReady</option>
                                  </select>
                                </div>

                                {srv.drm?.type === 'clearkey' && (
                                  <>
                                    <div>
                                      <label className="block text-[10px] font-medium text-zinc-400 mb-1">
                                        ClearKey Key ID (KID Hex)
                                      </label>
                                      <input
                                        type="text"
                                        value={srv.drm.kid || ''}
                                        onChange={(e) =>
                                          handleUpdateServer(idx, {
                                            drm: { ...srv.drm!, kid: e.target.value },
                                          })
                                        }
                                        placeholder="e.g. 1a2b3c4d5e6f..."
                                        className="w-full px-2.5 py-1.5 bg-zinc-950 border border-zinc-800 rounded-lg text-xs font-mono text-white focus:outline-hidden"
                                      />
                                    </div>
                                    <div>
                                      <label className="block text-[10px] font-medium text-zinc-400 mb-1">
                                        ClearKey Key (KEY Hex)
                                      </label>
                                      <input
                                        type="text"
                                        value={srv.drm.key || ''}
                                        onChange={(e) =>
                                          handleUpdateServer(idx, {
                                            drm: { ...srv.drm!, key: e.target.value },
                                          })
                                        }
                                        placeholder="e.g. 9z8y7x6w5v4u..."
                                        className="w-full px-2.5 py-1.5 bg-zinc-950 border border-zinc-800 rounded-lg text-xs font-mono text-white focus:outline-hidden"
                                      />
                                    </div>
                                  </>
                                )}

                                {(srv.drm?.type === 'widevine' || srv.drm?.type === 'playready') && (
                                  <div className="sm:col-span-2">
                                    <label className="block text-[10px] font-medium text-zinc-400 mb-1">
                                      DRM License Server URL
                                    </label>
                                    <input
                                      type="url"
                                      value={srv.drm?.licenseUrl || ''}
                                      onChange={(e) =>
                                        handleUpdateServer(idx, {
                                          drm: { ...srv.drm!, licenseUrl: e.target.value },
                                        })
                                      }
                                      placeholder="https://license.server.com/acquire"
                                      className="w-full px-2.5 py-1.5 bg-zinc-950 border border-zinc-800 rounded-lg text-xs font-mono text-white focus:outline-hidden"
                                    />
                                  </div>
                                )}
                              </div>

                              {/* Custom Headers */}
                              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-1">
                                <div>
                                  <label className="block text-[10px] font-medium text-zinc-400 mb-1">
                                    Custom User-Agent Header
                                  </label>
                                  <input
                                    type="text"
                                    value={srv.headers?.['User-Agent'] || ''}
                                    onChange={(e) =>
                                      handleUpdateServer(idx, {
                                        headers: { ...srv.headers, 'User-Agent': e.target.value },
                                      })
                                    }
                                    placeholder="Mozilla/5.0 (Linux; Android 10)..."
                                    className="w-full px-2.5 py-1.5 bg-zinc-950 border border-zinc-800 rounded-lg text-xs font-mono text-white focus:outline-hidden"
                                  />
                                </div>

                                <div>
                                  <label className="block text-[10px] font-medium text-zinc-400 mb-1">
                                    Custom Referer Header
                                  </label>
                                  <input
                                    type="text"
                                    value={srv.headers?.['Referer'] || ''}
                                    onChange={(e) =>
                                      handleUpdateServer(idx, {
                                        headers: { ...srv.headers, Referer: e.target.value },
                                      })
                                    }
                                    placeholder="https://streaming.domain.com/"
                                    className="w-full px-2.5 py-1.5 bg-zinc-950 border border-zinc-800 rounded-lg text-xs font-mono text-white focus:outline-hidden"
                                  />
                                </div>
                              </div>
                            </div>
                          </details>
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>
            </div>
          ) : (
            <div className="h-full flex flex-col items-center justify-center text-center p-8 max-w-sm mx-auto text-zinc-500">
              <div className="w-16 h-16 rounded-3xl bg-zinc-900 border border-zinc-800 flex items-center justify-center mb-4 text-purple-400 shadow-xl">
                <Tv className="w-8 h-8" />
              </div>
              <h3 className="text-sm font-bold text-white mb-1">Select a Channel to Inspect</h3>
              <p className="text-xs text-zinc-400 mb-4">
                Choose any channel from the list on the left to edit its details, preview video, and manage stream servers.
              </p>
              <button
                type="button"
                onClick={handleStartNewChannel}
                className="px-4 py-2 bg-purple-600 hover:bg-purple-500 text-white text-xs font-bold rounded-xl transition cursor-pointer flex items-center gap-2 shadow-md shadow-purple-600/20"
              >
                <Plus className="w-4 h-4" /> Create New Channel
              </button>
            </div>
          )}
        </main>
      </div>

      {/* Modals */}
      <CategoryEditorModal
        isOpen={isCategoryModalOpen}
        onClose={() => setIsCategoryModalOpen(false)}
        onSave={handleSaveCategory}
        initialData={editingCategory}
        existingIds={categories.map((c) => c.id)}
      />

      <M3uImportModal
        isOpen={isM3uModalOpen}
        onClose={() => setIsM3uModalOpen(false)}
        categories={categories}
        defaultCategoryId={selectedCategoryId !== 'all' ? selectedCategoryId : categories[0]?.id}
        onImportComplete={handleM3uImportComplete}
      />
    </div>
  );
}
