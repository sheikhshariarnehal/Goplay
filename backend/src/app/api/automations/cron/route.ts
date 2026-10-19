import { NextResponse } from 'next/server';
import { createClient } from '@supabase/supabase-js';
import { executeAutomation, SyncAutomationRecord } from '../../../../utils/automation-executor';

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

export async function POST(request: Request) {
  return handleCron(request);
}

export async function GET(request: Request) {
  return handleCron(request);
}

async function handleCron(request: Request) {
  const startTime = Date.now();

  try {
    // 1. Authenticate cron trigger
    const authHeader = request.headers.get('authorization') || request.headers.get('x-admin-token');
    const bearerToken = authHeader?.replace('Bearer ', '').trim();

    const { searchParams } = new URL(request.url);
    const querySecret = searchParams.get('secret');

    const expectedCronSecret = process.env.CRON_SECRET || 'GoPlayCronSecret2026';
    const expectedAdminSecret = process.env.ADMIN_SECRET_TOKEN || 'GoLiveAdminSecret2026';

    const tokenToCheck = bearerToken || querySecret;

    const isAuthorized =
      tokenToCheck &&
      (tokenToCheck === expectedCronSecret || tokenToCheck === expectedAdminSecret);

    if (!isAuthorized) {
      return NextResponse.json(
        { success: false, error: 'Unauthorized: Invalid Cron Secret or Admin Token' },
        { status: 401 }
      );
    }

    const supabase = getAdminClient();

    // 2. Fetch all active automations
    const { data: automations, error: fetchErr } = await supabase
      .from('sync_automations')
      .select('*')
      .eq('active', true)
      .order('created_at', { ascending: true });

    if (fetchErr) {
      throw new Error(`Failed to query automations: ${fetchErr.message}`);
    }

    if (!automations || automations.length === 0) {
      return NextResponse.json({
        success: true,
        message: 'No active automations found to run.',
        automationsProcessed: 0,
        totalChannelsUpdated: 0,
        totalServersUpdated: 0,
        durationMs: Date.now() - startTime,
      });
    }

    // 3. Process each automation sequentially
    const results = [];
    let totalChannels = 0;
    let totalServers = 0;

    for (const auto of automations) {
      try {
        const res = await executeAutomation(auto as SyncAutomationRecord);
        results.push(res);
        totalChannels += res.channelsUpdated;
        totalServers += res.serversUpdated;
      } catch (err: any) {
        results.push({
          success: false,
          automationId: auto.id,
          automationName: auto.name,
          channelsUpdated: 0,
          serversUpdated: 0,
          durationMs: 0,
          errorMessage: err.message,
        });
      }
    }

    return NextResponse.json({
      success: true,
      timestamp: new Date().toISOString(),
      automationsProcessed: automations.length,
      totalChannelsUpdated: totalChannels,
      totalServersUpdated: totalServers,
      durationMs: Date.now() - startTime,
      results,
    });
  } catch (error: any) {
    return NextResponse.json(
      {
        success: false,
        error: error.message || 'Error executing scheduled automations',
        durationMs: Date.now() - startTime,
      },
      { status: 500 }
    );
  }
}
