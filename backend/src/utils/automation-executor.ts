import { createClient } from '@supabase/supabase-js';
import { parseM3uContent, ParsedM3uEntry } from './m3u-parser';

export interface AutomationMappingRule {
  source_name: string;
  source_logo?: string;
  source_group?: string;
  source_tvg_id?: string;
  action: 'link_server' | 'update_primary' | 'create_channel' | 'skip';
  target_channel_id?: string;
  target_category_id?: string;
  server_name?: string;
  custom_headers?: Record<string, string>;
}

export interface SyncAutomationRecord {
  id: string;
  name: string;
  description?: string;
  type: 'category_sync' | 'channel_sync';
  source_url: string;
  target_category_id?: string;
  default_server_name?: string;
  auto_create_channels?: boolean;
  mapping_rules: AutomationMappingRule[];
  sync_interval_mins?: number;
  last_synced_at?: string;
  last_status?: string;
  last_error?: string | null;
  channels_count?: number;
  active?: boolean;
}

export interface ExecutionResult {
  success: boolean;
  automationId: string;
  automationName: string;
  channelsUpdated: number;
  serversUpdated: number;
  durationMs: number;
  errorMessage?: string;
}

function getAdminClient() {
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || '';
  const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '';
  const adminToken = process.env.ADMIN_SECRET_TOKEN || 'GoLiveAdminSecret2026';

  return createClient(supabaseUrl, supabaseAnonKey, {
    global: {
      headers: {
        'x-admin-token': adminToken,
      },
    },
  });
}

function slugify(text: string): string {
  return text
    .toLowerCase()
    .replace(/[^\w\s-]/g, '')
    .trim()
    .replace(/\s+/g, '_');
}

/**
 * Executes a single sync automation record
 */
export async function executeAutomation(
  automation: SyncAutomationRecord
): Promise<ExecutionResult> {
  const startTime = Date.now();
  const supabase = getAdminClient();

  let channelsUpdated = 0;
  let serversUpdated = 0;

  try {
    if (!automation.source_url) {
      throw new Error('Automation has no source_url configured');
    }

    // 1. Fetch remote M3U playlist
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 20000); // 20s timeout

    const res = await fetch(automation.source_url.trim(), {
      signal: controller.signal,
      headers: {
        'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
        Accept: '*/*',
      },
    });
    clearTimeout(timeout);

    if (!res.ok) {
      throw new Error(`Failed to fetch M3U playlist: HTTP ${res.status} ${res.statusText}`);
    }

    const m3uText = await res.text();
    const parsedEntries = parseM3uContent(m3uText);

    if (parsedEntries.length === 0) {
      throw new Error('No valid streams found in remote M3U playlist');
    }

    // 2. Build quick lookup index of M3U entries
    const byTvgId = new Map<string, ParsedM3uEntry>();
    const byName = new Map<string, ParsedM3uEntry>();

    for (const entry of parsedEntries) {
      if (entry.tvgId) byTvgId.set(entry.tvgId.toLowerCase().trim(), entry);
      if (entry.tvgName) byName.set(entry.tvgName.toLowerCase().trim(), entry);
      if (entry.name) byName.set(entry.name.toLowerCase().trim(), entry);
    }

    const rules = Array.isArray(automation.mapping_rules) ? automation.mapping_rules : [];

    // 3. Process mapping rules
    for (const rule of rules) {
      if (rule.action === 'skip') continue;

      // Find matching entry from M3U
      let match: ParsedM3uEntry | undefined;
      if (rule.source_tvg_id && byTvgId.has(rule.source_tvg_id.toLowerCase().trim())) {
        match = byTvgId.get(rule.source_tvg_id.toLowerCase().trim());
      } else if (rule.source_name && byName.has(rule.source_name.toLowerCase().trim())) {
        match = byName.get(rule.source_name.toLowerCase().trim());
      }

      // Safe non-destructive sync: if missing from M3U, retain existing DB state and skip
      if (!match) continue;

      const finalHeaders = { ...(match.headers || {}), ...(rule.custom_headers || {}) };
      const hasHeader = Object.keys(finalHeaders).length > 0;
      const scheme = match.streamUrl.includes('.mpd') ? 1 : 0;
      const serverLabel = rule.server_name || automation.default_server_name || 'Server 2';

      if (rule.action === 'create_channel') {
        const chanId = rule.target_channel_id || slugify(rule.source_name || match.name);
        const targetCategory = rule.target_category_id || automation.target_category_id || 'general';

        // Check if channel already exists
        const { data: existingChan } = await supabase
          .from('channels')
          .select('id')
          .eq('id', chanId)
          .maybeSingle();

        if (!existingChan) {
          const { error: chErr } = await supabase.from('channels').insert({
            id: chanId,
            name: rule.source_name || match.name,
            logo: rule.source_logo || match.logo || null,
            category: targetCategory,
            stream_url: match.streamUrl,
            quality: 'HD',
            is_live: true,
          });
          if (chErr) {
            console.error(`Failed to insert channel ${chanId}:`, chErr);
          } else {
            channelsUpdated++;
          }
        }

        // Upsert stream server for this channel
        const { data: existingServer } = await supabase
          .from('stream_servers')
          .select('id')
          .eq('channel_id', chanId)
          .eq('name', serverLabel)
          .maybeSingle();

        if (existingServer) {
          const { error: upSrvErr } = await supabase
            .from('stream_servers')
            .update({
              stream_url: match.streamUrl,
              headers: finalHeaders,
              has_header: hasHeader,
              scheme,
              active: true,
            })
            .eq('id', existingServer.id);
          if (upSrvErr) {
            console.error(`Failed to update stream_server ${existingServer.id}:`, upSrvErr);
          } else {
            serversUpdated++;
          }
        } else {
          const { error: insSrvErr } = await supabase.from('stream_servers').insert({
            channel_id: chanId,
            name: serverLabel,
            stream_url: match.streamUrl,
            headers: finalHeaders,
            has_header: hasHeader,
            scheme,
            sort_order: 1,
            active: true,
          });
          if (insSrvErr) {
            console.error(`Failed to insert stream_server for ${chanId}:`, insSrvErr);
          } else {
            serversUpdated++;
          }
        }
      } else if (rule.action === 'update_primary' && rule.target_channel_id) {
        // Update channels.stream_url
        const { error: chErr } = await supabase
          .from('channels')
          .update({
            stream_url: match.streamUrl,
          })
          .eq('id', rule.target_channel_id);

        if (!chErr) {
          channelsUpdated++;

          // Also update or insert primary server in stream_servers (sort_order = 0)
          const { data: primaryServer } = await supabase
            .from('stream_servers')
            .select('id')
            .eq('channel_id', rule.target_channel_id)
            .eq('sort_order', 0)
            .maybeSingle();

          if (primaryServer) {
            await supabase
              .from('stream_servers')
              .update({
                stream_url: match.streamUrl,
                headers: finalHeaders,
                has_header: hasHeader,
                scheme,
                active: true,
              })
              .eq('id', primaryServer.id);
            serversUpdated++;
          }
        }
      } else if (rule.action === 'link_server' && rule.target_channel_id) {
        // Find or create named stream_server
        const { data: existingServer } = await supabase
          .from('stream_servers')
          .select('id')
          .eq('channel_id', rule.target_channel_id)
          .eq('name', serverLabel)
          .maybeSingle();

        if (existingServer) {
          const { error: upErr } = await supabase
            .from('stream_servers')
            .update({
              stream_url: match.streamUrl,
              headers: finalHeaders,
              has_header: hasHeader,
              scheme,
              active: true,
            })
            .eq('id', existingServer.id);

          if (!upErr) serversUpdated++;
        } else {
          const { error: insErr } = await supabase.from('stream_servers').insert({
            channel_id: rule.target_channel_id,
            name: serverLabel,
            stream_url: match.streamUrl,
            headers: finalHeaders,
            has_header: hasHeader,
            scheme,
            sort_order: 2,
            active: true,
          });

          if (!insErr) serversUpdated++;
        }
        channelsUpdated++;
      }
    }

    const durationMs = Date.now() - startTime;

    // 4. Update sync_automations table
    await supabase
      .from('sync_automations')
      .update({
        last_synced_at: new Date().toISOString(),
        last_status: 'success',
        last_error: null,
        channels_count: channelsUpdated,
        updated_at: new Date().toISOString(),
      })
      .eq('id', automation.id);

    // 5. Insert execution log
    await supabase.from('automation_logs').insert({
      automation_id: automation.id,
      automation_name: automation.name,
      status: 'success',
      channels_updated: channelsUpdated,
      servers_updated: serversUpdated,
      duration_ms: durationMs,
    });

    // 6. Increment channels_version in app_settings if changes were made
    if (channelsUpdated > 0 || serversUpdated > 0) {
      const { data: appSettings } = await supabase
        .from('app_settings')
        .select('channels_version')
        .eq('id', 1)
        .maybeSingle();

      const currentVer = appSettings?.channels_version || 1000;
      await supabase
        .from('app_settings')
        .update({
          channels_version: currentVer + 1,
          updated_at: new Date().toISOString(),
        })
        .eq('id', 1);
    }

    return {
      success: true,
      automationId: automation.id,
      automationName: automation.name,
      channelsUpdated,
      serversUpdated,
      durationMs,
    };
  } catch (err: any) {
    const durationMs = Date.now() - startTime;
    const errorMsg = err.message || 'Unknown automation execution failure';

    // Record error in sync_automations
    await supabase
      .from('sync_automations')
      .update({
        last_status: 'failed',
        last_error: errorMsg,
        updated_at: new Date().toISOString(),
      })
      .eq('id', automation.id);

    // Record log
    await supabase.from('automation_logs').insert({
      automation_id: automation.id,
      automation_name: automation.name,
      status: 'failed',
      channels_updated: 0,
      servers_updated: 0,
      duration_ms: durationMs,
      error_message: errorMsg,
    });

    return {
      success: false,
      automationId: automation.id,
      automationName: automation.name,
      channelsUpdated: 0,
      serversUpdated: 0,
      durationMs,
      errorMessage: errorMsg,
    };
  }
}
