import { createClient } from '@supabase/supabase-js';
import fs from 'fs';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || 'https://hqmhuvsjlykrdusfkmeg.supabase.co';
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '';

if (!supabaseKey) {
  console.error('Please set NEXT_PUBLIC_SUPABASE_ANON_KEY or SUPABASE_SERVICE_ROLE_KEY environment variable.');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey, {
  global: {
    headers: {
      'x-admin-token': process.env.ADMIN_API_SECRET || 'GoLiveAdminSecret2026',
    },
  },
});

async function main() {
  console.log('Reading seed SQL...');
  const sqlContent = fs.readFileSync('d:/Poject/GoPlay/backend/migrations/seed_playz_channels.sql', 'utf-8');

  // Extract channels
  const channelMatches = [...sqlContent.matchAll(/INSERT INTO public\.channels \([^\)]+\)\s+VALUES \('([^']+)', '([^']*)', '([^']*)', '([^']+)', '([^']+)', '([^']*)', (true|false), (\d+)\)/g)];
  console.log(`Found ${channelMatches.length} raw channel records in SQL.`);

  // Deduplicate by channel ID
  const channelMap = new Map();
  for (const m of channelMatches) {
    channelMap.set(m[1], {
      id: m[1],
      name: m[2],
      logo: m[3] || null,
      category: m[4],
      stream_url: m[5],
      playz_links: m[6] || null,
      is_live: true,
      sort_order: parseInt(m[8], 10),
    });
  }
  const uniqueChannels = Array.from(channelMap.values());
  console.log(`Deduplicated to ${uniqueChannels.length} unique channels.`);

  // Batch upsert channels (50 at a time)
  console.log('Upserting unique channels into Supabase...');
  for (let i = 0; i < uniqueChannels.length; i += 50) {
    const chunk = uniqueChannels.slice(i, i + 50);
    const { error } = await supabase.from('channels').upsert(chunk, { onConflict: 'id' });
    if (error) {
      console.error(`Error upserting channels chunk ${i}-${i + chunk.length}:`, error);
    } else {
      console.log(`  Upserted channels ${i + 1} to ${i + chunk.length}`);
    }
  }

  // Create stream_servers matching unique channels
  const servers = uniqueChannels.map((ch, idx) => ({
    channel_id: ch.id,
    name: 'Server 1',
    stream_url: ch.stream_url,
    active: true,
    sort_order: 1,
  }));

  console.log('Inserting stream_servers into Supabase...');
  for (let i = 0; i < servers.length; i += 50) {
    const chunk = servers.slice(i, i + 50);
    const { error } = await supabase.from('stream_servers').upsert(chunk, { onConflict: 'channel_id,name', ignoreDuplicates: true });
    if (error) {
      // Fallback: insert directly
      const { error: insErr } = await supabase.from('stream_servers').insert(chunk);
      if (insErr) {
        console.warn(`  Chunk ${i + 1}-${i + chunk.length} note:`, insErr.message);
      } else {
        console.log(`  Inserted stream_servers ${i + 1} to ${i + chunk.length}`);
      }
    } else {
      console.log(`  Upserted stream_servers ${i + 1} to ${i + chunk.length}`);
    }
  }

  // Bump channels_version in sync_versions
  console.log('Incrementing channels_version in sync_versions...');
  const { data: currentSync } = await supabase.from('sync_versions').select('*').limit(1).single();
  if (currentSync) {
    const newVer = (currentSync.channels_version || 1) + 1;
    const { error: syncErr } = await supabase
      .from('sync_versions')
      .update({ channels_version: newVer, updated_at: new Date().toISOString() })
      .eq('id', currentSync.id);
    if (syncErr) {
      console.error('Failed to update sync_versions:', syncErr);
    } else {
      console.log(`Successfully updated sync_versions channels_version to ${newVer}`);
    }
  }

  console.log('MIGRATION COMPLETE!');
}

main().catch(console.error);
