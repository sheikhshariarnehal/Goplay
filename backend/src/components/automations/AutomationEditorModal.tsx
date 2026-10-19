'use client';

import React, { useState, useEffect, useMemo } from 'react';
import {
  X, ArrowRight, ArrowLeft, Check, Sparkles, Link as LinkIcon, Tv, Server,
  Globe, Search, AlertCircle, RefreshCw, Layers, Shield, Plus, CheckCircle2, ChevronDown
} from 'lucide-react';
import { createAdminSupabaseClient } from '../../utils/supabase';
import { ParsedM3uEntry, findBestChannelMatch } from '../../utils/m3u-parser';

export interface AutomationMappingItem {
  id: string; // unique key in table
  source_name: string;
  source_logo?: string;
  source_group?: string;
  source_tvg_id?: string;
  source_stream_url: string;
  source_headers: Record<string, string>;
  action: 'link_server' | 'update_primary' | 'create_channel' | 'skip';
  target_channel_id: string;
  target_channel_name: string;
  target_category_id: string;
  server_name: string;
  confidence: number;
}

interface DBChannel {
  id: string;
  name: string;
  category: string;
  logo: string | null;
}

interface DBCategory {
  id: string;
  name: string;
}

interface AutomationEditorModalProps {
  isOpen: boolean;
  onClose: () => void;
  adminToken: string;
  editingAutomation?: any | null;
  onSaved: (automationId: string, runNow: boolean) => Promise<void>;
}

export default function AutomationEditorModal({
  isOpen,
  onClose,
  adminToken,
  editingAutomation,
  onSaved,
}: AutomationEditorModalProps) {
  const [step, setStep] = useState<1 | 2 | 3>(1);

  // Form Basic Info (Step 1)
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [type, setType] = useState<'category_sync' | 'channel_sync'>('category_sync');
  const [sourceUrl, setSourceUrl] = useState('');
  const [targetCategoryId, setTargetCategoryId] = useState('');
  const [defaultServerName, setDefaultServerName] = useState('Server 2');
  const [autoCreateChannels, setAutoCreateChannels] = useState(true);

  // Data fetching states
  const [categories, setCategories] = useState<DBCategory[]>([]);
  const [channels, setChannels] = useState<DBChannel[]>([]);
  const [loadingData, setLoadingData] = useState(false);
  const [parsingUrl, setParsingUrl] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Step 2: Mapping Matrix
  const [mappings, setMappings] = useState<AutomationMappingItem[]>([]);
  const [matrixSearch, setMatrixSearch] = useState('');
  const [filterAction, setFilterAction] = useState<string>('all');

  // Load existing categories and channels from Supabase
  useEffect(() => {
    if (!isOpen) return;

    const loadDbData = async () => {
      try {
        setLoadingData(true);
        const supabase = createAdminSupabaseClient(adminToken);

        const [catRes, chanRes] = await Promise.all([
          supabase.from('categories').select('id, name').order('sort_order', { ascending: true }),
          supabase.from('channels').select('id, name, category, logo').order('name', { ascending: true }),
        ]);

        if (catRes.data) setCategories(catRes.data);
        if (chanRes.data) setChannels(chanRes.data);

        if (!targetCategoryId && catRes.data && catRes.data.length > 0) {
          setTargetCategoryId(catRes.data[0].id);
        }
      } catch (err: any) {
        console.error('Error fetching DB data:', err);
      } finally {
        setLoadingData(false);
      }
    };

    loadDbData();
  }, [isOpen, adminToken]);

  // Populate form if editing
  useEffect(() => {
    if (editingAutomation) {
      setName(editingAutomation.name || '');
      setDescription(editingAutomation.description || '');
      setType(editingAutomation.type || 'category_sync');
      setSourceUrl(editingAutomation.source_url || '');
      setTargetCategoryId(editingAutomation.target_category_id || '');
      setDefaultServerName(editingAutomation.default_server_name || 'Server 2');
      setAutoCreateChannels(editingAutomation.auto_create_channels ?? true);

      if (Array.isArray(editingAutomation.mapping_rules) && editingAutomation.mapping_rules.length > 0) {
        const converted = editingAutomation.mapping_rules.map((r: any, idx: number) => ({
          id: `rule-${idx}`,
          source_name: r.source_name || '',
          source_logo: r.source_logo || '',
          source_group: r.source_group || '',
          source_tvg_id: r.source_tvg_id || '',
          source_stream_url: r.source_stream_url || '',
          source_headers: r.custom_headers || {},
          action: r.action || 'link_server',
          target_channel_id: r.target_channel_id || '',
          target_channel_name: r.target_channel_id || '',
          target_category_id: r.target_category_id || editingAutomation.target_category_id || '',
          server_name: r.server_name || editingAutomation.default_server_name || 'Server 2',
          confidence: 1.0,
        }));
        setMappings(converted);
      }
    } else {
      // Defaults for new automation
      setName('');
      setDescription('');
      setType('category_sync');
      setSourceUrl('');
      setDefaultServerName('Server 2');
      setAutoCreateChannels(true);
      setMappings([]);
      setStep(1);
    }
  }, [editingAutomation, isOpen]);

  // Step 1: Parse Source URL and proceed to Step 2
  const handleInspectAndProceed = async () => {
    setError(null);
    if (!name.trim()) {
      setError('Please provide an Automation Name');
      return;
    }
    if (!sourceUrl.trim()) {
      setError('Please provide a valid M3U Source URL');
      return;
    }

    try {
      setParsingUrl(true);
      const res = await fetch('/api/automations/parse', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'x-admin-token': adminToken,
        },
        body: JSON.stringify({ url: sourceUrl.trim() }),
      });

      const data = await res.json();
      if (!res.ok || !data.success) {
        throw new Error(data.error || 'Failed to parse M3U playlist from source URL');
      }

      const parsed: ParsedM3uEntry[] = data.channels || [];
      if (parsed.length === 0) {
        throw new Error('No valid channels found in the provided M3U');
      }

      // Build mappings matrix using smart auto-matching
      const newMappings: AutomationMappingItem[] = parsed.map((entry, idx) => {
        // Auto-match against DB channels
        const matchResult = findBestChannelMatch(entry.name, entry.tvgId, channels);
        const hasMatch = matchResult.channel !== null;

        let initialAction: 'link_server' | 'update_primary' | 'create_channel' | 'skip' = 'link_server';
        if (hasMatch) {
          initialAction = 'link_server';
        } else if (autoCreateChannels) {
          initialAction = 'create_channel';
        } else {
          initialAction = 'skip';
        }

        return {
          id: `item-${idx}`,
          source_name: entry.name,
          source_logo: entry.logo,
          source_group: entry.groupTitle,
          source_tvg_id: entry.tvgId,
          source_stream_url: entry.streamUrl,
          source_headers: entry.headers || {},
          action: initialAction,
          target_channel_id: matchResult.channel ? matchResult.channel.id : '',
          target_channel_name: matchResult.channel ? matchResult.channel.name : entry.name,
          target_category_id: targetCategoryId,
          server_name: defaultServerName || 'Server 2',
          confidence: matchResult.confidence,
        };
      });

      setMappings(newMappings);
      setStep(2);
    } catch (err: any) {
      setError(err.message || 'Error parsing M3U');
    } finally {
      setParsingUrl(false);
    }
  };

  // Batch actions on matrix
  const handleBatchAutoMatch = () => {
    setMappings((prev) =>
      prev.map((item) => {
        const matchResult = findBestChannelMatch(item.source_name, item.source_tvg_id, channels);
        if (matchResult.channel) {
          return {
            ...item,
            action: 'link_server',
            target_channel_id: matchResult.channel.id,
            target_channel_name: matchResult.channel.name,
            confidence: matchResult.confidence,
          };
        }
        return item;
      })
    );
  };

  const handleBatchSetAction = (action: 'link_server' | 'update_primary' | 'create_channel' | 'skip') => {
    setMappings((prev) =>
      prev.map((item) => ({
        ...item,
        action,
      }))
    );
  };

  const handleBatchSetServerName = (label: string) => {
    if (!label.trim()) return;
    setMappings((prev) =>
      prev.map((item) => ({
        ...item,
        server_name: label.trim(),
      }))
    );
  };

  // Update single row
  const handleUpdateRow = (id: string, updates: Partial<AutomationMappingItem>) => {
    setMappings((prev) => prev.map((item) => (item.id === id ? { ...item, ...updates } : item)));
  };

  // Filtered matrix rows
  const filteredMappings = useMemo(() => {
    return mappings.filter((item) => {
      if (filterAction !== 'all' && item.action !== filterAction) return false;
      if (!matrixSearch.trim()) return true;
      const q = matrixSearch.toLowerCase();
      return (
        item.source_name.toLowerCase().includes(q) ||
        (item.source_group && item.source_group.toLowerCase().includes(q)) ||
        item.target_channel_name.toLowerCase().includes(q)
      );
    });
  }, [mappings, matrixSearch, filterAction]);

  // Metrics summary
  const summary = useMemo(() => {
    let linkCount = 0;
    let createCount = 0;
    let primaryCount = 0;
    let skipCount = 0;
    let headersCount = 0;

    for (const m of mappings) {
      if (m.action === 'link_server') linkCount++;
      else if (m.action === 'create_channel') createCount++;
      else if (m.action === 'update_primary') primaryCount++;
      else if (m.action === 'skip') skipCount++;

      if (Object.keys(m.source_headers).length > 0) headersCount++;
    }

    return {
      total: mappings.length,
      linkCount,
      createCount,
      primaryCount,
      skipCount,
      headersCount,
    };
  }, [mappings]);

  // Step 3: Save Automation to Supabase
  const handleSaveAutomation = async (runNow: boolean) => {
    try {
      setSaving(true);
      setError(null);
      const supabase = createAdminSupabaseClient(adminToken);

      const rulesPayload = mappings.map((m) => ({
        source_name: m.source_name,
        source_logo: m.source_logo || null,
        source_group: m.source_group || null,
        source_tvg_id: m.source_tvg_id || null,
        source_stream_url: m.source_stream_url,
        action: m.action,
        target_channel_id: m.action === 'create_channel' ? (m.target_channel_id || null) : m.target_channel_id,
        target_category_id: m.target_category_id || targetCategoryId,
        server_name: m.server_name || defaultServerName,
        custom_headers: m.source_headers,
      }));

      const payload = {
        name: name.trim(),
        description: description.trim() || null,
        type,
        source_url: sourceUrl.trim(),
        target_category_id: targetCategoryId || null,
        default_server_name: defaultServerName.trim() || 'Server 2',
        auto_create_channels: autoCreateChannels,
        mapping_rules: rulesPayload,
        active: true,
        updated_at: new Date().toISOString(),
      };

      let autoId = editingAutomation?.id;

      if (editingAutomation) {
        const { error: upErr } = await supabase
          .from('sync_automations')
          .update(payload)
          .eq('id', editingAutomation.id);
        if (upErr) throw upErr;
      } else {
        const { data: newRow, error: insErr } = await supabase
          .from('sync_automations')
          .insert(payload)
          .select('id')
          .single();
        if (insErr) throw insErr;
        autoId = newRow.id;
      }

      await onSaved(autoId, runNow);
      onClose();
    } catch (err: any) {
      setError(err.message || 'Failed to save automation');
    } finally {
      setSaving(false);
    }
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/85 backdrop-blur-md animate-in fade-in duration-200">
      <div className="bg-zinc-900 border border-zinc-800 rounded-2xl w-full max-w-5xl max-h-[92vh] flex flex-col shadow-2xl overflow-hidden">
        {/* Modal Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-zinc-800 bg-zinc-900/90">
          <div className="flex items-center gap-3">
            <div className="w-9 h-9 rounded-xl bg-purple-500/10 border border-purple-500/20 flex items-center justify-center text-purple-400">
              <Sparkles className="w-5 h-5" />
            </div>
            <div>
              <h2 className="text-base font-bold text-white">
                {editingAutomation ? 'Edit Stream Sync Automation' : 'New Stream Auto-Sync Automation'}
              </h2>
              <p className="text-xs text-zinc-400">
                Step {step} of 3: {step === 1 ? 'Source & Type' : step === 2 ? 'Visual Connection Matrix' : 'Review & Schedule'}
              </p>
            </div>
          </div>

          {/* Stepper Dots */}
          <div className="flex items-center gap-2">
            {[1, 2, 3].map((s) => (
              <div
                key={s}
                className={`h-2 rounded-full transition-all duration-300 ${
                  s === step ? 'w-6 bg-purple-500' : s < step ? 'w-2 bg-purple-800' : 'w-2 bg-zinc-800'
                }`}
              />
            ))}
          </div>

          <button
            onClick={onClose}
            className="p-1.5 rounded-lg hover:bg-zinc-800 text-zinc-400 hover:text-white transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Modal Body */}
        <div className="flex-1 overflow-y-auto p-6 space-y-6">
          {error && (
            <div className="p-3 bg-red-950/40 border border-red-800/60 rounded-xl text-xs text-red-300 flex items-center gap-2">
              <AlertCircle className="w-4 h-4 text-red-400 flex-shrink-0" />
              <span>{error}</span>
            </div>
          )}

          {/* ──────────────── STEP 1: SOURCE & TYPE ──────────────── */}
          {step === 1 && (
            <div className="space-y-6 max-w-2xl mx-auto py-2">
              <div className="space-y-4">
                {/* Name */}
                <div>
                  <label className="block text-xs font-semibold text-zinc-300 mb-1.5">
                    Automation Name <span className="text-purple-400">*</span>
                  </label>
                  <input
                    type="text"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    placeholder="e.g. Toffee Live TV & Sports Sync"
                    className="w-full px-3.5 py-2.5 bg-zinc-950 border border-zinc-800 rounded-xl text-sm text-white placeholder-zinc-500 focus:outline-none focus:border-purple-500 transition-colors"
                  />
                </div>

                {/* Automation Type */}
                <div>
                  <label className="block text-xs font-semibold text-zinc-300 mb-2">Automation Strategy</label>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <button
                      type="button"
                      onClick={() => setType('category_sync')}
                      className={`p-3.5 rounded-xl border text-left transition-all cursor-pointer ${
                        type === 'category_sync'
                          ? 'bg-purple-950/30 border-purple-500 text-white shadow-sm shadow-purple-500/10'
                          : 'bg-zinc-950 border-zinc-800 text-zinc-400 hover:border-zinc-700'
                      }`}
                    >
                      <div className="flex items-center gap-2 mb-1">
                        <Layers className={`w-4 h-4 ${type === 'category_sync' ? 'text-purple-400' : 'text-zinc-500'}`} />
                        <span className="text-xs font-bold text-white">Category Push / Bulk Sync</span>
                      </div>
                      <p className="text-[11px] text-zinc-400 leading-relaxed">
                        Maps M3U playlist entries into a designated category, with options to auto-create missing channels or link existing ones.
                      </p>
                    </button>

                    <button
                      type="button"
                      onClick={() => setType('channel_sync')}
                      className={`p-3.5 rounded-xl border text-left transition-all cursor-pointer ${
                        type === 'channel_sync'
                          ? 'bg-purple-950/30 border-purple-500 text-white shadow-sm shadow-purple-500/10'
                          : 'bg-zinc-950 border-zinc-800 text-zinc-400 hover:border-zinc-700'
                      }`}
                    >
                      <div className="flex items-center gap-2 mb-1">
                        <Tv className={`w-4 h-4 ${type === 'channel_sync' ? 'text-purple-400' : 'text-zinc-500'}`} />
                        <span className="text-xs font-bold text-white">Channel Selective Sync</span>
                      </div>
                      <p className="text-[11px] text-zinc-400 leading-relaxed">
                        Refreshes streams for specific selected channels across categories without creating new channels.
                      </p>
                    </button>
                  </div>
                </div>

                {/* Source M3U URL */}
                <div>
                  <label className="block text-xs font-semibold text-zinc-300 mb-1.5">
                    Source M3U Playlist URL <span className="text-purple-400">*</span>
                  </label>
                  <div className="relative">
                    <Globe className="w-4 h-4 text-zinc-500 absolute left-3.5 top-3" />
                    <input
                      type="url"
                      value={sourceUrl}
                      onChange={(e) => setSourceUrl(e.target.value)}
                      placeholder="https://raw.githubusercontent.com/.../Toffee.m3u"
                      className="w-full pl-10 pr-4 py-2.5 bg-zinc-950 border border-zinc-800 rounded-xl text-sm text-white font-mono placeholder-zinc-500 focus:outline-none focus:border-purple-500 transition-colors"
                    />
                  </div>
                  <p className="text-[11px] text-zinc-500 mt-1">
                    Direct raw M3U / M3U8 link containing <code className="text-zinc-400">#EXTINF</code> entries and tokenized streams.
                  </p>
                </div>

                {/* Target Category & Defaults (for category_sync) */}
                {type === 'category_sync' && (
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-1">
                    <div>
                      <label className="block text-xs font-semibold text-zinc-300 mb-1.5">
                        Target Category <span className="text-purple-400">*</span>
                      </label>
                      <select
                        value={targetCategoryId}
                        onChange={(e) => setTargetCategoryId(e.target.value)}
                        className="w-full px-3 py-2.5 bg-zinc-950 border border-zinc-800 rounded-xl text-sm text-white focus:outline-none focus:border-purple-500 transition-colors"
                      >
                        {categories.map((cat) => (
                          <option key={cat.id} value={cat.id}>
                            {cat.name} ({cat.id})
                          </option>
                        ))}
                      </select>
                    </div>

                    <div>
                      <label className="block text-xs font-semibold text-zinc-300 mb-1.5">
                        Default Stream Server Label
                      </label>
                      <input
                        type="text"
                        value={defaultServerName}
                        onChange={(e) => setDefaultServerName(e.target.value)}
                        placeholder="e.g. Server 2 or Toffee HLS"
                        className="w-full px-3.5 py-2.5 bg-zinc-950 border border-zinc-800 rounded-xl text-sm text-white focus:outline-none focus:border-purple-500 transition-colors"
                      />
                    </div>
                  </div>
                )}

                {/* Auto-create missing channels toggle */}
                <div className="p-3.5 rounded-xl bg-zinc-950 border border-zinc-800 flex items-center justify-between">
                  <div>
                    <span className="text-xs font-semibold text-zinc-200 block">Auto-Create Missing Channels</span>
                    <span className="text-[11px] text-zinc-500">
                      If an M3U stream does not match an existing channel, auto-create it under the category.
                    </span>
                  </div>
                  <label className="relative inline-flex items-center cursor-pointer">
                    <input
                      type="checkbox"
                      checked={autoCreateChannels}
                      onChange={(e) => setAutoCreateChannels(e.target.checked)}
                      className="sr-only peer"
                    />
                    <div className="w-9 h-5 bg-zinc-800 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-purple-600"></div>
                  </label>
                </div>
              </div>
            </div>
          )}

          {/* ──────────────── STEP 2: VISUAL CONNECTION MATRIX ──────────────── */}
          {step === 2 && (
            <div className="space-y-4">
              {/* Matrix Toolbar */}
              <div className="flex flex-col md:flex-row items-stretch md:items-center justify-between gap-3 p-3.5 bg-zinc-950 rounded-xl border border-zinc-800">
                {/* Search & Filter */}
                <div className="flex items-center gap-2 flex-1 max-w-md">
                  <div className="relative flex-1">
                    <Search className="w-3.5 h-3.5 text-zinc-500 absolute left-3 top-2.5" />
                    <input
                      type="text"
                      value={matrixSearch}
                      onChange={(e) => setMatrixSearch(e.target.value)}
                      placeholder="Filter parsed channels..."
                      className="w-full pl-9 pr-3 py-1.5 bg-zinc-900 border border-zinc-800 rounded-lg text-xs text-white placeholder-zinc-500 focus:outline-none focus:border-purple-500"
                    />
                  </div>
                  <select
                    value={filterAction}
                    onChange={(e) => setFilterAction(e.target.value)}
                    className="px-2.5 py-1.5 bg-zinc-900 border border-zinc-800 rounded-lg text-xs text-zinc-300 focus:outline-none"
                  >
                    <option value="all">All Actions ({mappings.length})</option>
                    <option value="link_server">Link Server ({summary.linkCount})</option>
                    <option value="create_channel">Create New ({summary.createCount})</option>
                    <option value="update_primary">Update Primary ({summary.primaryCount})</option>
                    <option value="skip">Skip ({summary.skipCount})</option>
                  </select>
                </div>

                {/* Batch Action Buttons */}
                <div className="flex items-center gap-2 flex-wrap text-xs">
                  <button
                    type="button"
                    onClick={handleBatchAutoMatch}
                    className="px-2.5 py-1.5 rounded-lg bg-purple-600/20 text-purple-300 border border-purple-500/30 hover:bg-purple-600/30 transition-colors flex items-center gap-1.5 font-medium cursor-pointer"
                  >
                    <Sparkles className="w-3 h-3 text-purple-400" />
                    Auto-Match DB
                  </button>
                  <button
                    type="button"
                    onClick={() => handleBatchSetAction('link_server')}
                    className="px-2.5 py-1.5 rounded-lg bg-zinc-800 hover:bg-zinc-700 text-zinc-300 transition-colors cursor-pointer"
                  >
                    All to Server
                  </button>
                  <button
                    type="button"
                    onClick={() => handleBatchSetAction('create_channel')}
                    className="px-2.5 py-1.5 rounded-lg bg-zinc-800 hover:bg-zinc-700 text-zinc-300 transition-colors cursor-pointer"
                  >
                    All Create New
                  </button>
                </div>
              </div>

              {/* Status Header Bar */}
              <div className="flex items-center justify-between text-xs text-zinc-400 px-1">
                <span>
                  Showing <strong className="text-white">{filteredMappings.length}</strong> of {mappings.length} streams
                </span>
                <div className="flex items-center gap-3">
                  <span className="flex items-center gap-1">
                    <span className="w-2 h-2 rounded-full bg-purple-400"></span>
                    Link: {summary.linkCount}
                  </span>
                  <span className="flex items-center gap-1">
                    <span className="w-2 h-2 rounded-full bg-emerald-400"></span>
                    Create: {summary.createCount}
                  </span>
                  <span className="flex items-center gap-1">
                    <span className="w-2 h-2 rounded-full bg-sky-400"></span>
                    Headers: {summary.headersCount}
                  </span>
                </div>
              </div>

              {/* Matrix Table */}
              <div className="border border-zinc-800 rounded-xl overflow-hidden bg-zinc-950/70">
                <div className="max-h-[460px] overflow-y-auto">
                  <table className="w-full text-left text-xs">
                    <thead className="sticky top-0 bg-zinc-900 border-b border-zinc-800 text-[11px] font-semibold text-zinc-400 uppercase tracking-wider z-10">
                      <tr>
                        <th className="py-2.5 px-3">Source M3U Stream</th>
                        <th className="py-2.5 px-3">Target Action</th>
                        <th className="py-2.5 px-3">Connect to DB Channel</th>
                        <th className="py-2.5 px-3">Server Label</th>
                        <th className="py-2.5 px-3">Headers</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-zinc-800/60">
                      {filteredMappings.map((row) => {
                        const headerKeys = Object.keys(row.source_headers);
                        const hasHeaders = headerKeys.length > 0;

                        return (
                          <tr key={row.id} className="hover:bg-zinc-900/50 transition-colors">
                            {/* Source M3U info */}
                            <td className="py-2.5 px-3">
                              <div className="flex items-center gap-2.5">
                                {row.source_logo ? (
                                  <img
                                    src={row.source_logo}
                                    alt=""
                                    className="w-7 h-7 rounded object-contain bg-zinc-900 border border-zinc-800 flex-shrink-0"
                                    onError={(e: any) => (e.target.style.display = 'none')}
                                  />
                                ) : (
                                  <div className="w-7 h-7 rounded bg-zinc-900 border border-zinc-800 flex items-center justify-center text-zinc-600 flex-shrink-0">
                                    <Tv className="w-3.5 h-3.5" />
                                  </div>
                                )}
                                <div className="min-w-0">
                                  <span className="font-semibold text-white truncate block">{row.source_name}</span>
                                  {row.source_group && (
                                    <span className="text-[10px] text-zinc-500 font-mono">{row.source_group}</span>
                                  )}
                                </div>
                              </div>
                            </td>

                            {/* Action selector */}
                            <td className="py-2.5 px-3">
                              <select
                                value={row.action}
                                onChange={(e: any) => handleUpdateRow(row.id, { action: e.target.value })}
                                className="px-2 py-1.5 bg-zinc-900 border border-zinc-800 rounded-lg text-xs text-zinc-200 focus:outline-none focus:border-purple-500 cursor-pointer"
                              >
                                <option value="link_server">Link to Stream Server</option>
                                <option value="create_channel">Create New Channel</option>
                                <option value="update_primary">Update Primary Stream</option>
                                <option value="skip">Skip / Ignore</option>
                              </select>
                            </td>

                            {/* DB Channel connector */}
                            <td className="py-2.5 px-3">
                              {row.action === 'skip' ? (
                                <span className="text-[11px] text-zinc-600 italic">Excluded from sync</span>
                              ) : row.action === 'create_channel' ? (
                                <div className="flex items-center gap-1.5 text-emerald-400 font-medium">
                                  <Plus className="w-3.5 h-3.5" />
                                  <span>Will create as new channel</span>
                                </div>
                              ) : (
                                <div className="min-w-[180px]">
                                  <select
                                    value={row.target_channel_id}
                                    onChange={(e) => {
                                      const found = channels.find((c) => c.id === e.target.value);
                                      handleUpdateRow(row.id, {
                                        target_channel_id: e.target.value,
                                        target_channel_name: found?.name || e.target.value,
                                      });
                                    }}
                                    className="w-full px-2 py-1.5 bg-zinc-900 border border-zinc-800 rounded-lg text-xs text-white focus:outline-none focus:border-purple-500 cursor-pointer"
                                  >
                                    <option value="">-- Select Channel --</option>
                                    {channels.map((chan) => (
                                      <option key={chan.id} value={chan.id}>
                                        {chan.name} ({chan.category || 'general'})
                                      </option>
                                    ))}
                                  </select>
                                </div>
                              )}
                            </td>

                            {/* Server Label */}
                            <td className="py-2.5 px-3">
                              {row.action === 'skip' || row.action === 'update_primary' ? (
                                <span className="text-[11px] text-zinc-500 font-mono">Primary Stream</span>
                              ) : (
                                <input
                                  type="text"
                                  value={row.server_name}
                                  onChange={(e) => handleUpdateRow(row.id, { server_name: e.target.value })}
                                  className="w-28 px-2 py-1 bg-zinc-900 border border-zinc-800 rounded-lg text-xs text-zinc-200 font-mono focus:outline-none focus:border-purple-500"
                                />
                              )}
                            </td>

                            {/* Headers Badge */}
                            <td className="py-2.5 px-3">
                              {hasHeaders ? (
                                <div className="flex items-center gap-1 flex-wrap" title={JSON.stringify(row.source_headers, null, 2)}>
                                  {headerKeys.slice(0, 2).map((k) => (
                                    <span
                                      key={k}
                                      className="px-1.5 py-0.5 rounded bg-sky-950/80 text-sky-400 border border-sky-800/60 text-[9px] font-mono"
                                    >
                                      {k}
                                    </span>
                                  ))}
                                  {headerKeys.length > 2 && (
                                    <span className="text-[9px] text-zinc-500">+{headerKeys.length - 2}</span>
                                  )}
                                </div>
                              ) : (
                                <span className="text-[10px] text-zinc-600 font-mono">None</span>
                              )}
                            </td>
                          </tr>
                        );
                      })}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          )}

          {/* ──────────────── STEP 3: REVIEW & SCHEDULE ──────────────── */}
          {step === 3 && (
            <div className="space-y-6 max-w-2xl mx-auto py-2">
              <div className="p-4 rounded-xl bg-purple-950/20 border border-purple-900/40 space-y-3">
                <div className="flex items-center gap-2">
                  <Sparkles className="w-4 h-4 text-purple-400" />
                  <h3 className="text-sm font-bold text-white">Automation Configuration Ready</h3>
                </div>
                <p className="text-xs text-zinc-300 leading-relaxed">
                  GoPlay will connect <strong className="text-white">{summary.total}</strong> streams from{' '}
                  <code className="text-purple-300 font-mono">{sourceUrl}</code> into your unified database structure.
                </p>
              </div>

              {/* Summary Metrics Grid */}
              <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
                <div className="p-3 bg-zinc-950 border border-zinc-800 rounded-xl text-center">
                  <span className="text-lg font-bold text-white block">{summary.linkCount}</span>
                  <span className="text-[10px] text-zinc-500 uppercase tracking-wider font-semibold">
                    Server Links
                  </span>
                </div>
                <div className="p-3 bg-zinc-950 border border-zinc-800 rounded-xl text-center">
                  <span className="text-lg font-bold text-emerald-400 block">{summary.createCount}</span>
                  <span className="text-[10px] text-zinc-500 uppercase tracking-wider font-semibold">
                    New Channels
                  </span>
                </div>
                <div className="p-3 bg-zinc-950 border border-zinc-800 rounded-xl text-center">
                  <span className="text-lg font-bold text-sky-400 block">{summary.headersCount}</span>
                  <span className="text-[10px] text-zinc-500 uppercase tracking-wider font-semibold">
                    With Headers
                  </span>
                </div>
                <div className="p-3 bg-zinc-950 border border-zinc-800 rounded-xl text-center">
                  <span className="text-lg font-bold text-zinc-400 block">{summary.skipCount}</span>
                  <span className="text-[10px] text-zinc-500 uppercase tracking-wider font-semibold">Skipped</span>
                </div>
              </div>

              {/* Execution Details */}
              <div className="p-4 rounded-xl bg-zinc-950 border border-zinc-800 space-y-3 text-xs">
                <div className="flex items-center justify-between py-1 border-b border-zinc-900">
                  <span className="text-zinc-400">Target Category</span>
                  <span className="font-semibold text-white">{targetCategoryId || 'Cross-category'}</span>
                </div>
                <div className="flex items-center justify-between py-1 border-b border-zinc-900">
                  <span className="text-zinc-400">Default Server Label</span>
                  <span className="font-mono text-purple-300">{defaultServerName}</span>
                </div>
                <div className="flex items-center justify-between py-1 border-b border-zinc-900">
                  <span className="text-zinc-400">Background Schedule Interval</span>
                  <span className="text-emerald-400 font-medium">Every 45 minutes (via GitHub Action)</span>
                </div>
                <div className="flex items-center justify-between py-1">
                  <span className="text-zinc-400">Auto Version Bump</span>
                  <span className="text-zinc-200">Automatically increments channels_version on changes</span>
                </div>
              </div>
            </div>
          )}
        </div>

        {/* Modal Footer Controls */}
        <div className="flex items-center justify-between px-6 py-4 border-t border-zinc-800 bg-zinc-900/90">
          <div>
            {step > 1 && (
              <button
                type="button"
                onClick={() => setStep((s) => (s - 1) as any)}
                className="px-4 py-2 rounded-xl bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-xs font-medium transition-colors flex items-center gap-1.5 cursor-pointer"
              >
                <ArrowLeft className="w-3.5 h-3.5" /> Back
              </button>
            )}
          </div>

          <div className="flex items-center gap-3">
            <button
              type="button"
              onClick={onClose}
              className="px-4 py-2 rounded-xl border border-zinc-800 hover:bg-zinc-800 text-zinc-400 hover:text-white text-xs font-medium transition-colors cursor-pointer"
            >
              Cancel
            </button>

            {step === 1 && (
              <button
                type="button"
                onClick={handleInspectAndProceed}
                disabled={parsingUrl || !name.trim() || !sourceUrl.trim()}
                className="px-5 py-2 rounded-xl bg-purple-600 hover:bg-purple-500 disabled:opacity-50 text-white text-xs font-semibold shadow-md shadow-purple-500/20 transition-all flex items-center gap-2 cursor-pointer"
              >
                {parsingUrl ? (
                  <>
                    <RefreshCw className="w-3.5 h-3.5 animate-spin" />
                    Fetching & Parsing M3U...
                  </>
                ) : (
                  <>
                    Inspect Streams & Open Matrix <ArrowRight className="w-3.5 h-3.5" />
                  </>
                )}
              </button>
            )}

            {step === 2 && (
              <button
                type="button"
                onClick={() => setStep(3)}
                className="px-5 py-2 rounded-xl bg-purple-600 hover:bg-purple-500 text-white text-xs font-semibold shadow-md shadow-purple-500/20 transition-all flex items-center gap-2 cursor-pointer"
              >
                Review & Finalize <ArrowRight className="w-3.5 h-3.5" />
              </button>
            )}

            {step === 3 && (
              <>
                <button
                  type="button"
                  onClick={() => handleSaveAutomation(false)}
                  disabled={saving}
                  className="px-4 py-2 rounded-xl bg-zinc-800 hover:bg-zinc-700 text-white text-xs font-semibold transition-colors cursor-pointer"
                >
                  Save Automation
                </button>
                <button
                  type="button"
                  onClick={() => handleSaveAutomation(true)}
                  disabled={saving}
                  className="px-5 py-2 rounded-xl bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-500 hover:to-pink-500 text-white text-xs font-bold shadow-md shadow-purple-500/20 transition-all flex items-center gap-2 cursor-pointer"
                >
                  {saving ? (
                    <>
                      <RefreshCw className="w-3.5 h-3.5 animate-spin" /> Saving & Running...
                    </>
                  ) : (
                    <>
                      <Check className="w-4 h-4" /> Save & Run Sync Now
                    </>
                  )}
                </button>
              </>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
