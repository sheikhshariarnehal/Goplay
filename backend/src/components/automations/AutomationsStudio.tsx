'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import {
  Workflow, Plus, RefreshCw, Clock, CheckCircle2, AlertCircle, Play,
  Settings2, Trash2, Globe, Layers, Tv, Activity, Sparkles, ExternalLink,
  Shield, Server, Radio, Power
} from 'lucide-react';
import { createAdminSupabaseClient } from '../../utils/supabase';
import AutomationEditorModal from './AutomationEditorModal';
import AutomationLogsModal from './AutomationLogsModal';
import CronSetupModal from './CronSetupModal';

interface AutomationItem {
  id: string;
  name: string;
  description?: string;
  type: 'category_sync' | 'channel_sync';
  source_url: string;
  target_category_id?: string;
  default_server_name?: string;
  auto_create_channels?: boolean;
  mapping_rules?: any[];
  sync_interval_mins?: number;
  last_synced_at?: string;
  last_status?: string;
  last_error?: string | null;
  channels_count?: number;
  active: boolean;
  created_at: string;
}

interface AutomationsStudioProps {
  adminToken: string;
}

export default function AutomationsStudio({ adminToken }: AutomationsStudioProps) {
  const [automations, setAutomations] = useState<AutomationItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [runningId, setRunningId] = useState<string | null>(null);
  const [runningAll, setRunningAll] = useState(false);
  const [feedback, setFeedback] = useState<{ type: 'success' | 'error'; message: string } | null>(null);

  // Modals state
  const [isEditorOpen, setIsEditorOpen] = useState(false);
  const [editingItem, setEditingItem] = useState<AutomationItem | null>(null);
  const [isLogsOpen, setIsLogsOpen] = useState(false);
  const [logFilterId, setLogFilterId] = useState<string | null>(null);
  const [logFilterName, setLogFilterName] = useState<string | null>(null);
  const [isCronSetupOpen, setIsCronSetupOpen] = useState(false);

  const fetchAutomations = async () => {
    try {
      setLoading(true);
      const supabase = createAdminSupabaseClient(adminToken);
      const { data, error } = await supabase
        .from('sync_automations')
        .select('*')
        .order('created_at', { ascending: false });

      if (error) throw error;
      setAutomations(data || []);
    } catch (err: any) {
      setFeedback({ type: 'error', message: err.message || 'Failed to load automations' });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchAutomations();
  }, [adminToken]);

  // Run single automation
  const handleRunAutomation = async (id: string, name: string) => {
    try {
      setRunningId(id);
      setFeedback(null);

      const res = await fetch('/api/automations/run', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'x-admin-token': adminToken,
        },
        body: JSON.stringify({ automationId: id }),
      });

      const data = await res.json();
      if (!res.ok || !data.success) {
        throw new Error(data.error || 'Failed to execute sync automation');
      }

      setFeedback({
        type: 'success',
        message: `Synced ${name}: ${data.channelsUpdated} channels & ${data.serversUpdated} servers updated (${data.durationMs}ms)`,
      });

      await fetchAutomations();
    } catch (err: any) {
      setFeedback({ type: 'error', message: err.message || 'Sync failed' });
    } finally {
      setRunningId(null);
    }
  };

  // Run all active automations
  const handleRunAll = async () => {
    try {
      setRunningAll(true);
      setFeedback(null);

      const res = await fetch('/api/automations/cron', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'x-admin-token': adminToken,
        },
      });

      const data = await res.json();
      if (!res.ok || !data.success) {
        throw new Error(data.error || 'Failed to execute all automations');
      }

      setFeedback({
        type: 'success',
        message: `Global Sync Complete: ${data.totalChannelsUpdated} channels & ${data.totalServersUpdated} servers updated across ${data.automationsProcessed} automations (${data.durationMs}ms)`,
      });

      await fetchAutomations();
    } catch (err: any) {
      setFeedback({ type: 'error', message: err.message || 'Global sync failed' });
    } finally {
      setRunningAll(false);
    }
  };

  // Toggle active status
  const handleToggleActive = async (auto: AutomationItem) => {
    try {
      const supabase = createAdminSupabaseClient(adminToken);
      const newStatus = !auto.active;

      const { error } = await supabase
        .from('sync_automations')
        .update({ active: newStatus, updated_at: new Date().toISOString() })
        .eq('id', auto.id);

      if (error) throw error;

      setAutomations((prev) =>
        prev.map((item) => (item.id === auto.id ? { ...item, active: newStatus } : item))
      );
    } catch (err: any) {
      setFeedback({ type: 'error', message: err.message || 'Failed to toggle status' });
    }
  };

  // Delete automation
  const handleDelete = async (id: string, name: string) => {
    if (!confirm(`Are you sure you want to delete the automation "${name}"? This will not delete previously created channels.`)) {
      return;
    }

    try {
      const supabase = createAdminSupabaseClient(adminToken);
      const { error } = await supabase.from('sync_automations').delete().eq('id', id);
      if (error) throw error;

      setAutomations((prev) => prev.filter((item) => item.id !== id));
      setFeedback({ type: 'success', message: `Deleted automation: ${name}` });
    } catch (err: any) {
      setFeedback({ type: 'error', message: err.message || 'Failed to delete automation' });
    }
  };

  // Stats calculation
  const totalChannelsMapped = automations.reduce((acc, curr) => acc + (curr.channels_count || 0), 0);
  const activeCount = automations.filter((a) => a.active).length;

  return (
    <div className="flex-1 flex flex-col min-w-0 h-full overflow-y-auto bg-zinc-950 p-4 sm:p-6 lg:p-8 space-y-6">
      {/* Studio Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <div className="flex items-center gap-2.5">
            <div className="w-9 h-9 rounded-xl bg-gradient-to-tr from-purple-600 to-pink-600 flex items-center justify-center text-white shadow-md shadow-purple-500/10">
              <Workflow className="w-5 h-5" />
            </div>
            <div>
              <h1 className="text-xl font-extrabold text-white tracking-tight flex items-center gap-2">
                Automations & Stream Sync
                <span className="px-2 py-0.5 rounded-full bg-purple-500/15 text-purple-400 border border-purple-500/30 text-[10px] font-mono tracking-wider">
                  REALTIME
                </span>
              </h1>
              <p className="text-xs text-zinc-400">
                Auto-sync remote M3U playlists, refresh expiring stream tokens, and manage multi-server links
              </p>
            </div>
          </div>
        </div>

        {/* Action Controls */}
        <div className="flex items-center gap-2.5 flex-wrap">
          <button
            onClick={() => setIsCronSetupOpen(true)}
            className="px-3 py-2 rounded-xl bg-zinc-900 border border-zinc-800 hover:border-zinc-700 text-zinc-300 hover:text-white text-xs font-semibold transition-all flex items-center gap-2 cursor-pointer"
          >
            <Clock className="w-3.5 h-3.5 text-purple-400" />
            Schedule & Cron Setup
          </button>

          <button
            onClick={() => {
              setLogFilterId(null);
              setLogFilterName(null);
              setIsLogsOpen(true);
            }}
            className="px-3 py-2 rounded-xl bg-zinc-900 border border-zinc-800 hover:border-zinc-700 text-zinc-300 hover:text-white text-xs font-semibold transition-all flex items-center gap-2 cursor-pointer"
          >
            <Activity className="w-3.5 h-3.5 text-sky-400" />
            Audit Logs
          </button>

          <button
            onClick={handleRunAll}
            disabled={runningAll || activeCount === 0}
            className="px-3.5 py-2 rounded-xl bg-zinc-800 hover:bg-zinc-700 disabled:opacity-50 text-white text-xs font-semibold transition-all flex items-center gap-2 cursor-pointer"
          >
            <RefreshCw className={`w-3.5 h-3.5 ${runningAll ? 'animate-spin text-purple-400' : ''}`} />
            {runningAll ? 'Syncing All...' : 'Run All Syncs'}
          </button>

          <button
            onClick={() => {
              setEditingItem(null);
              setIsEditorOpen(true);
            }}
            className="px-4 py-2 rounded-xl bg-purple-600 hover:bg-purple-500 text-white text-xs font-bold shadow-md shadow-purple-500/20 transition-all flex items-center gap-2 cursor-pointer"
          >
            <Plus className="w-4 h-4" />
            New Automation
          </button>
        </div>
      </div>

      {/* Feedback Alert Toast */}
      {feedback && (
        <div
          className={`p-3.5 rounded-xl border flex items-center justify-between gap-3 text-xs animate-in fade-in ${
            feedback.type === 'success'
              ? 'bg-emerald-950/30 border-emerald-800/50 text-emerald-300'
              : 'bg-rose-950/30 border-rose-800/50 text-rose-300'
          }`}
        >
          <div className="flex items-center gap-2">
            {feedback.type === 'success' ? (
              <CheckCircle2 className="w-4 h-4 text-emerald-400 flex-shrink-0" />
            ) : (
              <AlertCircle className="w-4 h-4 text-rose-400 flex-shrink-0" />
            )}
            <span>{feedback.message}</span>
          </div>
          <button
            onClick={() => setFeedback(null)}
            className="p-1 text-zinc-400 hover:text-white rounded hover:bg-zinc-800/50"
          >
            ✕
          </button>
        </div>
      )}

      {/* Overview Stat Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="p-4 rounded-2xl bg-zinc-900/60 border border-zinc-800/80 flex items-center justify-between">
          <div>
            <span className="text-[11px] font-semibold text-zinc-500 uppercase tracking-wider block">
              Active Automations
            </span>
            <span className="text-2xl font-black text-white mt-0.5 block">{activeCount}</span>
            <span className="text-[11px] text-zinc-400">of {automations.length} total defined</span>
          </div>
          <div className="w-10 h-10 rounded-xl bg-purple-500/10 border border-purple-500/20 flex items-center justify-center text-purple-400">
            <Workflow className="w-5 h-5" />
          </div>
        </div>

        <div className="p-4 rounded-2xl bg-zinc-900/60 border border-zinc-800/80 flex items-center justify-between">
          <div>
            <span className="text-[11px] font-semibold text-zinc-500 uppercase tracking-wider block">
              Managed Streams
            </span>
            <span className="text-2xl font-black text-white mt-0.5 block">{totalChannelsMapped}</span>
            <span className="text-[11px] text-zinc-400">live stream servers synced</span>
          </div>
          <div className="w-10 h-10 rounded-xl bg-sky-500/10 border border-sky-500/20 flex items-center justify-center text-sky-400">
            <Server className="w-5 h-5" />
          </div>
        </div>

        <div className="p-4 rounded-2xl bg-zinc-900/60 border border-zinc-800/80 flex items-center justify-between">
          <div>
            <span className="text-[11px] font-semibold text-zinc-500 uppercase tracking-wider block">
              Schedule Interval
            </span>
            <span className="text-xl font-bold text-emerald-400 mt-1 block">45 Minutes</span>
            <span className="text-[11px] text-zinc-500 font-mono">GitHub Action Runner</span>
          </div>
          <div className="w-10 h-10 rounded-xl bg-emerald-500/10 border border-emerald-500/20 flex items-center justify-center text-emerald-400">
            <Clock className="w-5 h-5" />
          </div>
        </div>

        <div className="p-4 rounded-2xl bg-zinc-900/60 border border-zinc-800/80 flex items-center justify-between">
          <div>
            <span className="text-[11px] font-semibold text-zinc-500 uppercase tracking-wider block">
              Live TV Studio
            </span>
            <Link
              href="/dashboard/livetv"
              className="text-xs font-bold text-purple-400 hover:text-purple-300 mt-1 inline-flex items-center gap-1.5 transition-colors"
            >
              Open Studio <ExternalLink className="w-3.5 h-3.5" />
            </Link>
            <span className="text-[11px] text-zinc-500 block">Preview streams & player</span>
          </div>
          <div className="w-10 h-10 rounded-xl bg-purple-500/10 border border-purple-500/20 flex items-center justify-center text-purple-400">
            <Radio className="w-5 h-5" />
          </div>
        </div>
      </div>

      {/* Main List Section */}
      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="text-sm font-bold text-zinc-300 uppercase tracking-wider">Configured Automations</h2>
          <button
            onClick={fetchAutomations}
            disabled={loading}
            className="p-1.5 rounded-lg bg-zinc-900 border border-zinc-800 text-zinc-400 hover:text-white transition-colors"
            title="Refresh automations list"
          >
            <RefreshCw className={`w-3.5 h-3.5 ${loading ? 'animate-spin' : ''}`} />
          </button>
        </div>

        {loading && automations.length === 0 ? (
          <div className="py-24 rounded-2xl border border-zinc-800/80 bg-zinc-900/40 flex flex-col items-center justify-center text-center">
            <RefreshCw className="w-8 h-8 text-purple-400 animate-spin mb-3" />
            <p className="text-sm text-zinc-400">Loading sync automations...</p>
          </div>
        ) : automations.length === 0 ? (
          <div className="py-20 px-6 rounded-2xl border border-zinc-800/80 bg-zinc-900/30 flex flex-col items-center justify-center text-center space-y-4">
            <div className="w-12 h-12 rounded-2xl bg-purple-500/10 border border-purple-500/20 flex items-center justify-center text-purple-400">
              <Workflow className="w-6 h-6" />
            </div>
            <div>
              <h3 className="text-base font-bold text-white">No Automations Created Yet</h3>
              <p className="text-xs text-zinc-400 max-w-md mt-1">
                Create an automation to auto-sync your M3U playlist (e.g. Toffee M3U), map streams to channels and stream servers, and keep tokens refreshed automatically.
              </p>
            </div>
            <button
              onClick={() => {
                setEditingItem(null);
                setIsEditorOpen(true);
              }}
              className="px-4 py-2 rounded-xl bg-purple-600 hover:bg-purple-500 text-white text-xs font-semibold shadow-md shadow-purple-500/20 transition-all flex items-center gap-2 cursor-pointer"
            >
              <Plus className="w-4 h-4" /> Create Your First Automation
            </button>
          </div>
        ) : (
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
            {automations.map((auto) => {
              const isRunning = runningId === auto.id;
              const ruleCount = Array.isArray(auto.mapping_rules) ? auto.mapping_rules.length : 0;
              const lastSync = auto.last_synced_at ? new Date(auto.last_synced_at) : null;

              return (
                <div
                  key={auto.id}
                  className={`p-5 rounded-2xl border transition-all ${
                    auto.active
                      ? 'bg-zinc-900/70 border-zinc-800 hover:border-zinc-700'
                      : 'bg-zinc-950/60 border-zinc-800/50 opacity-70'
                  }`}
                >
                  <div className="flex items-start justify-between gap-3">
                    <div className="space-y-1 min-w-0">
                      <div className="flex items-center gap-2 flex-wrap">
                        <span className="font-bold text-white text-sm truncate">{auto.name}</span>
                        <span
                          className={`px-2 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider ${
                            auto.active
                              ? 'bg-emerald-500/15 text-emerald-400 border border-emerald-500/30'
                              : 'bg-zinc-800 text-zinc-500'
                          }`}
                        >
                          {auto.active ? 'Active' : 'Paused'}
                        </span>
                        <span className="px-2 py-0.5 rounded-full bg-purple-950/60 text-purple-400 border border-purple-800/40 text-[10px] font-medium">
                          {auto.type === 'category_sync' ? 'Category Push' : 'Selective Sync'}
                        </span>
                      </div>

                      {auto.description && <p className="text-xs text-zinc-400 line-clamp-1">{auto.description}</p>}
                    </div>

                    {/* Status Dot */}
                    <div className="flex items-center gap-1.5 flex-shrink-0">
                      {auto.last_status === 'success' ? (
                        <span className="flex items-center gap-1 text-[11px] text-emerald-400 font-medium">
                          <CheckCircle2 className="w-3.5 h-3.5" /> Synced
                        </span>
                      ) : auto.last_status === 'failed' ? (
                        <span className="flex items-center gap-1 text-[11px] text-rose-400 font-medium">
                          <AlertCircle className="w-3.5 h-3.5" /> Failed
                        </span>
                      ) : (
                        <span className="flex items-center gap-1 text-[11px] text-zinc-500">
                          <Clock className="w-3.5 h-3.5" /> Ready
                        </span>
                      )}
                    </div>
                  </div>

                  {/* Details & Source */}
                  <div className="my-3.5 p-3 rounded-xl bg-zinc-950/80 border border-zinc-800/80 space-y-2 text-xs">
                    <div className="flex items-center justify-between">
                      <span className="text-zinc-500 flex items-center gap-1.5">
                        <Globe className="w-3.5 h-3.5 text-zinc-400" /> Source URL:
                      </span>
                      <span className="font-mono text-zinc-300 truncate max-w-[260px]" title={auto.source_url}>
                        {auto.source_url}
                      </span>
                    </div>

                    <div className="flex items-center justify-between pt-1 border-t border-zinc-900">
                      <span className="text-zinc-500 flex items-center gap-1.5">
                        <Layers className="w-3.5 h-3.5 text-zinc-400" /> Target Category:
                      </span>
                      <span className="font-semibold text-zinc-200">
                        {auto.target_category_id || 'Cross-category'}
                      </span>
                    </div>

                    <div className="flex items-center justify-between pt-1 border-t border-zinc-900">
                      <span className="text-zinc-500 flex items-center gap-1.5">
                        <Server className="w-3.5 h-3.5 text-zinc-400" /> Default Server:
                      </span>
                      <span className="font-mono text-purple-300">
                        {auto.default_server_name || 'Server 2'}
                      </span>
                    </div>
                  </div>

                  {/* Metrics & Last Synced */}
                  <div className="flex items-center justify-between text-xs text-zinc-500 py-1">
                    <span>
                      Rules: <strong className="text-white">{ruleCount}</strong> mapped (
                      <span className="text-emerald-400">{auto.channels_count || 0} active</span>)
                    </span>
                    <span>
                      {lastSync ? (
                        <>
                          Last sync:{' '}
                          <strong className="text-zinc-300">
                            {lastSync.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                          </strong>
                        </>
                      ) : (
                        'Never synced'
                      )}
                    </span>
                  </div>

                  {/* Card Actions */}
                  <div className="mt-4 pt-3 border-t border-zinc-800 flex items-center justify-between gap-2">
                    <div className="flex items-center gap-2">
                      <button
                        onClick={() => handleRunAutomation(auto.id, auto.name)}
                        disabled={isRunning}
                        className="px-3 py-1.5 rounded-lg bg-purple-600 hover:bg-purple-500 disabled:opacity-50 text-white text-xs font-semibold shadow-sm transition-all flex items-center gap-1.5 cursor-pointer"
                      >
                        <RefreshCw className={`w-3.5 h-3.5 ${isRunning ? 'animate-spin' : ''}`} />
                        {isRunning ? 'Syncing...' : 'Sync Now'}
                      </button>

                      <button
                        onClick={() => {
                          setEditingItem(auto);
                          setIsEditorOpen(true);
                        }}
                        className="px-2.5 py-1.5 rounded-lg bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-xs font-medium transition-colors flex items-center gap-1 cursor-pointer"
                      >
                        <Settings2 className="w-3.5 h-3.5" /> Edit
                      </button>

                      <button
                        onClick={() => {
                          setLogFilterId(auto.id);
                          setLogFilterName(auto.name);
                          setIsLogsOpen(true);
                        }}
                        className="px-2.5 py-1.5 rounded-lg bg-zinc-800 hover:bg-zinc-700 text-zinc-300 text-xs font-medium transition-colors cursor-pointer"
                      >
                        Logs
                      </button>
                    </div>

                    <div className="flex items-center gap-2">
                      <button
                        onClick={() => handleToggleActive(auto)}
                        className={`p-1.5 rounded-lg border transition-colors cursor-pointer ${
                          auto.active
                            ? 'bg-zinc-900 border-zinc-800 text-zinc-400 hover:text-zinc-200'
                            : 'bg-emerald-950/40 border-emerald-800 text-emerald-400'
                        }`}
                        title={auto.active ? 'Pause automation' : 'Activate automation'}
                      >
                        <Power className="w-3.5 h-3.5" />
                      </button>

                      <button
                        onClick={() => handleDelete(auto.id, auto.name)}
                        className="p-1.5 rounded-lg bg-zinc-900 border border-zinc-800 hover:border-rose-900 text-zinc-500 hover:text-rose-400 transition-colors cursor-pointer"
                        title="Delete automation"
                      >
                        <Trash2 className="w-3.5 h-3.5" />
                      </button>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

      {/* Modals */}
      <AutomationEditorModal
        isOpen={isEditorOpen}
        onClose={() => setIsEditorOpen(false)}
        adminToken={adminToken}
        editingAutomation={editingItem}
        onSaved={async (id, runNow) => {
          await fetchAutomations();
          if (runNow) {
            const found = automations.find((a) => a.id === id);
            await handleRunAutomation(id, found?.name || 'Automation');
          }
        }}
      />

      <AutomationLogsModal
        isOpen={isLogsOpen}
        onClose={() => setIsLogsOpen(false)}
        adminToken={adminToken}
        selectedAutomationId={logFilterId}
        selectedAutomationName={logFilterName}
      />

      <CronSetupModal isOpen={isCronSetupOpen} onClose={() => setIsCronSetupOpen(false)} />
    </div>
  );
}
