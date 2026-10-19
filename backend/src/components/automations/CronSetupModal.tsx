'use client';

import React, { useState } from 'react';
import { X, Copy, Check, Terminal, ExternalLink, Shield, Clock, Cpu } from 'lucide-react';

interface CronSetupModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export default function CronSetupModal({ isOpen, onClose }: CronSetupModalProps) {
  const [copiedKey, setCopiedKey] = useState<string | null>(null);

  if (!isOpen) return null;

  const origin = typeof window !== 'undefined' ? window.location.origin : 'https://your-domain.vercel.app';
  const cronUrl = `${origin}/api/automations/cron`;
  const cronUrlWithSecret = `${origin}/api/automations/cron?secret=GoPlayCronSecret2026`;

  const githubWorkflowContent = `name: GoPlay Auto-Sync Streams

on:
  schedule:
    # Runs every 45 minutes to refresh expiring tokens
    - cron: '*/45 * * * *'
  workflow_dispatch:

jobs:
  sync:
    name: Refresh Live Stream Tokens
    runs-on: ubuntu-latest
    steps:
      - name: Ping GoPlay Backend Cron
        run: |
          RESPONSE=$(curl -s -w "\\n%{http_code}" -X POST "${cronUrl}" \\
            -H "Authorization: Bearer \${{ secrets.CRON_SECRET || 'GoPlayCronSecret2026' }}")
          HTTP_BODY=$(echo "$RESPONSE" | sed '$d')
          HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
          echo "Status Code: $HTTP_CODE"
          echo "Response Body: $HTTP_BODY"
          if [ "$HTTP_CODE" -ne 200 ]; then
            echo "Cron sync failed"
            exit 1
          fi
`;

  const supabaseSqlContent = `-- Run directly inside Supabase SQL Editor to schedule hourly automated syncs
create extension if not exists pg_cron;
create extension if not exists pg_net;

select cron.schedule(
  'goplay-refresh-streams',
  '*/45 * * * *',
  $$
    select net.http_post(
      url := '${cronUrl}',
      headers := jsonb_build_object(
        'Content-Type', 'application/json',
        'Authorization', 'Bearer GoPlayCronSecret2026'
      )
    );
  $$
);
`;

  const handleCopy = (text: string, key: string) => {
    navigator.clipboard.writeText(text);
    setCopiedKey(key);
    setTimeout(() => setCopiedKey(null), 2500);
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm animate-in fade-in duration-200">
      <div className="bg-zinc-900 border border-zinc-800 rounded-2xl w-full max-w-3xl max-h-[90vh] flex flex-col shadow-2xl overflow-hidden">
        {/* Modal Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-zinc-800 bg-zinc-900/80">
          <div className="flex items-center gap-3">
            <div className="w-9 h-9 rounded-xl bg-purple-500/10 border border-purple-500/20 flex items-center justify-center text-purple-400">
              <Clock className="w-5 h-5" />
            </div>
            <div>
              <h2 className="text-base font-bold text-white">Automated Schedule & Cron Trigger</h2>
              <p className="text-xs text-zinc-400">
                Keep ephemeral tokens (like Toffee M3U) refreshed 24/7 without manual intervention
              </p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="p-1.5 rounded-lg hover:bg-zinc-800 text-zinc-400 hover:text-white transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Modal Body */}
        <div className="p-6 overflow-y-auto space-y-6 text-sm">
          {/* Endpoint Info */}
          <div className="p-4 rounded-xl bg-zinc-950 border border-zinc-800 space-y-3">
            <div className="flex items-center justify-between">
              <span className="text-xs font-semibold text-zinc-300 uppercase tracking-wider flex items-center gap-1.5">
                <Shield className="w-3.5 h-3.5 text-purple-400" />
                Backend Webhook Endpoint
              </span>
              <button
                onClick={() => handleCopy(cronUrl, 'url')}
                className="flex items-center gap-1 text-xs text-purple-400 hover:text-purple-300 transition-colors"
              >
                {copiedKey === 'url' ? <Check className="w-3.5 h-3.5" /> : <Copy className="w-3.5 h-3.5" />}
                {copiedKey === 'url' ? 'Copied' : 'Copy URL'}
              </button>
            </div>
            <div className="p-2.5 bg-zinc-900 rounded-lg font-mono text-xs text-zinc-300 break-all select-all border border-zinc-800">
              {cronUrl}
            </div>
            <p className="text-[11px] text-zinc-500">
              Trigger via <span className="text-zinc-300 font-mono">POST</span> or <span className="text-zinc-300 font-mono">GET</span> with header <span className="text-zinc-300 font-mono">Authorization: Bearer CRON_SECRET</span> or append <span className="text-zinc-300 font-mono">?secret=...</span>
            </p>
          </div>

          {/* Option 1: GitHub Actions (Recommended) */}
          <div className="space-y-3">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <span className="w-5 h-5 rounded-full bg-emerald-500/20 text-emerald-400 text-xs font-bold flex items-center justify-center">
                  1
                </span>
                <h3 className="font-semibold text-white">Recommended: GitHub Actions (100% Free & Unlimited)</h3>
              </div>
              <button
                onClick={() => handleCopy(githubWorkflowContent, 'gh')}
                className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-purple-600 hover:bg-purple-500 text-white text-xs font-medium transition-colors"
              >
                {copiedKey === 'gh' ? <Check className="w-3.5 h-3.5" /> : <Copy className="w-3.5 h-3.5" />}
                {copiedKey === 'gh' ? 'Copied Workflow YAML' : 'Copy Workflow'}
              </button>
            </div>
            <p className="text-xs text-zinc-400">
              Save this file as <code className="text-purple-300 font-mono bg-zinc-800 px-1.5 py-0.5 rounded">.github/workflows/auto_sync.yml</code> in your repository. GitHub will automatically trigger your backend every 45 minutes to refresh all active automations!
            </p>
            <div className="relative">
              <pre className="p-3 bg-zinc-950 border border-zinc-800 rounded-xl font-mono text-[11px] text-zinc-300 overflow-x-auto max-h-48">
                {githubWorkflowContent}
              </pre>
            </div>
          </div>

          {/* Option 2: Supabase pg_cron */}
          <div className="space-y-3">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <span className="w-5 h-5 rounded-full bg-sky-500/20 text-sky-400 text-xs font-bold flex items-center justify-center">
                  2
                </span>
                <h3 className="font-semibold text-white">Alternative: Supabase Cloud Native pg_cron</h3>
              </div>
              <button
                onClick={() => handleCopy(supabaseSqlContent, 'sql')}
                className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-zinc-800 hover:bg-zinc-700 text-zinc-200 text-xs font-medium transition-colors"
              >
                {copiedKey === 'sql' ? <Check className="w-3.5 h-3.5" /> : <Copy className="w-3.5 h-3.5" />}
                {copiedKey === 'sql' ? 'Copied SQL' : 'Copy SQL Snippet'}
              </button>
            </div>
            <p className="text-xs text-zinc-400">
              Paste and run this directly in your Supabase SQL Editor. The Postgres engine itself will schedule and execute the HTTP POST request.
            </p>
            <div className="relative">
              <pre className="p-3 bg-zinc-950 border border-zinc-800 rounded-xl font-mono text-[11px] text-zinc-300 overflow-x-auto max-h-36">
                {supabaseSqlContent}
              </pre>
            </div>
          </div>
        </div>

        {/* Modal Footer */}
        <div className="flex items-center justify-end px-6 py-4 border-t border-zinc-800 bg-zinc-900/80">
          <button
            onClick={onClose}
            className="px-4 py-2 bg-zinc-800 hover:bg-zinc-700 text-white rounded-xl text-xs font-medium transition-colors cursor-pointer"
          >
            Done
          </button>
        </div>
      </div>
    </div>
  );
}
