'use client';

import React, { useState, useEffect } from 'react';
import { X, RefreshCw, CheckCircle2, AlertCircle, Clock, Server, Tv, Activity } from 'lucide-react';
import { createAdminSupabaseClient } from '../../utils/supabase';

interface AutomationLog {
  id: string;
  automation_id: string;
  automation_name: string;
  status: 'success' | 'failed';
  channels_updated: number;
  servers_updated: number;
  duration_ms: number;
  error_message?: string | null;
  created_at: string;
}

interface AutomationLogsModalProps {
  isOpen: boolean;
  onClose: () => void;
  adminToken: string;
  selectedAutomationId?: string | null;
  selectedAutomationName?: string | null;
}

export default function AutomationLogsModal({
  isOpen,
  onClose,
  adminToken,
  selectedAutomationId,
  selectedAutomationName,
}: AutomationLogsModalProps) {
  const [logs, setLogs] = useState<AutomationLog[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchLogs = async () => {
    try {
      setLoading(true);
      setError(null);
      const supabase = createAdminSupabaseClient(adminToken);

      let query = supabase
        .from('automation_logs')
        .select('*')
        .order('created_at', { ascending: false })
        .limit(60);

      if (selectedAutomationId) {
        query = query.eq('automation_id', selectedAutomationId);
      }

      const { data, error: fetchErr } = await query;
      if (fetchErr) throw fetchErr;

      setLogs(data || []);
    } catch (err: any) {
      setError(err.message || 'Failed to fetch automation logs');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (isOpen) {
      fetchLogs();
    }
  }, [isOpen, selectedAutomationId]);

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm animate-in fade-in duration-200">
      <div className="bg-zinc-900 border border-zinc-800 rounded-2xl w-full max-w-4xl max-h-[90vh] flex flex-col shadow-2xl overflow-hidden">
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-zinc-800 bg-zinc-900/80">
          <div className="flex items-center gap-3">
            <div className="w-9 h-9 rounded-xl bg-purple-500/10 border border-purple-500/20 flex items-center justify-center text-purple-400">
              <Activity className="w-5 h-5" />
            </div>
            <div>
              <h2 className="text-base font-bold text-white">
                {selectedAutomationName ? `Audit Logs: ${selectedAutomationName}` : 'All Sync Automation Logs'}
              </h2>
              <p className="text-xs text-zinc-400">
                Detailed execution history, updated stream counts, durations, and errors
              </p>
            </div>
          </div>
          <div className="flex items-center gap-2">
            <button
              onClick={fetchLogs}
              disabled={loading}
              className="p-1.5 rounded-lg bg-zinc-800 hover:bg-zinc-700 text-zinc-300 transition-colors disabled:opacity-50"
              title="Refresh logs"
            >
              <RefreshCw className={`w-4 h-4 ${loading ? 'animate-spin' : ''}`} />
            </button>
            <button
              onClick={onClose}
              className="p-1.5 rounded-lg hover:bg-zinc-800 text-zinc-400 hover:text-white transition-colors"
            >
              <X className="w-5 h-5" />
            </button>
          </div>
        </div>

        {/* Content */}
        <div className="flex-1 overflow-y-auto p-6 space-y-4">
          {error && (
            <div className="p-3 bg-red-950/40 border border-red-800/60 rounded-xl text-xs text-red-300 flex items-center gap-2">
              <AlertCircle className="w-4 h-4 text-red-400 flex-shrink-0" />
              <span>{error}</span>
            </div>
          )}

          {loading && logs.length === 0 ? (
            <div className="py-20 flex flex-col items-center justify-center text-center">
              <RefreshCw className="w-8 h-8 text-purple-400 animate-spin mb-3" />
              <p className="text-sm text-zinc-400">Loading audit history...</p>
            </div>
          ) : logs.length === 0 ? (
            <div className="py-20 flex flex-col items-center justify-center text-center text-zinc-500">
              <Clock className="w-10 h-10 mb-2 stroke-1" />
              <p className="text-sm font-medium">No execution logs found</p>
              <p className="text-xs text-zinc-600 mt-1">
                Logs will appear automatically when automations run on schedule or manually
              </p>
            </div>
          ) : (
            <div className="space-y-2.5">
              {logs.map((log) => {
                const isSuccess = log.status === 'success';
                const date = new Date(log.created_at);
                const formattedDate = date.toLocaleDateString('en-US', {
                  month: 'short',
                  day: 'numeric',
                  year: 'numeric',
                });
                const formattedTime = date.toLocaleTimeString('en-US', {
                  hour: '2-digit',
                  minute: '2-digit',
                  second: '2-digit',
                });

                return (
                  <div
                    key={log.id}
                    className={`p-3.5 rounded-xl border transition-all ${
                      isSuccess
                        ? 'bg-zinc-950/60 border-zinc-800/80 hover:border-zinc-700'
                        : 'bg-rose-950/15 border-rose-900/40 hover:border-rose-800'
                    }`}
                  >
                    <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2">
                      <div className="flex items-center gap-2.5">
                        {isSuccess ? (
                          <div className="w-6 h-6 rounded-full bg-emerald-500/10 border border-emerald-500/20 flex items-center justify-center text-emerald-400 flex-shrink-0">
                            <CheckCircle2 className="w-3.5 h-3.5" />
                          </div>
                        ) : (
                          <div className="w-6 h-6 rounded-full bg-rose-500/10 border border-rose-500/20 flex items-center justify-center text-rose-400 flex-shrink-0">
                            <AlertCircle className="w-3.5 h-3.5" />
                          </div>
                        )}
                        <div>
                          <div className="flex items-center gap-2">
                            <span className="text-xs font-semibold text-white">
                              {log.automation_name || 'Stream Sync'}
                            </span>
                            <span
                              className={`px-1.5 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider ${
                                isSuccess
                                  ? 'bg-emerald-500/15 text-emerald-400 border border-emerald-500/30'
                                  : 'bg-rose-500/15 text-rose-400 border border-rose-500/30'
                              }`}
                            >
                              {log.status}
                            </span>
                          </div>
                          <span className="text-[11px] text-zinc-500">
                            {formattedDate} at {formattedTime}
                          </span>
                        </div>
                      </div>

                      {/* Metrics Badges */}
                      <div className="flex items-center gap-3 text-xs">
                        <div className="flex items-center gap-1.5 text-zinc-400 bg-zinc-900 px-2.5 py-1 rounded-lg border border-zinc-800/80">
                          <Tv className="w-3.5 h-3.5 text-purple-400" />
                          <span>{log.channels_updated} channels</span>
                        </div>
                        <div className="flex items-center gap-1.5 text-zinc-400 bg-zinc-900 px-2.5 py-1 rounded-lg border border-zinc-800/80">
                          <Server className="w-3.5 h-3.5 text-sky-400" />
                          <span>{log.servers_updated} servers</span>
                        </div>
                        <div className="flex items-center gap-1 text-zinc-500 text-[11px] font-mono">
                          <Clock className="w-3 h-3" />
                          <span>{log.duration_ms}ms</span>
                        </div>
                      </div>
                    </div>

                    {log.error_message && (
                      <div className="mt-2.5 p-2 bg-rose-950/30 border border-rose-900/30 rounded-lg text-xs font-mono text-rose-300 break-all">
                        {log.error_message}
                      </div>
                    )}
                  </div>
                );
              })}
            </div>
          )}
        </div>

        {/* Footer */}
        <div className="flex items-center justify-between px-6 py-3 border-t border-zinc-800 bg-zinc-900/80 text-xs text-zinc-500">
          <span>Showing latest {logs.length} execution logs</span>
          <button
            onClick={onClose}
            className="px-3.5 py-1.5 bg-zinc-800 hover:bg-zinc-700 text-white rounded-lg transition-colors cursor-pointer"
          >
            Close
          </button>
        </div>
      </div>
    </div>
  );
}
