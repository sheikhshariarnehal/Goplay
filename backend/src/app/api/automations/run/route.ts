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
  try {
    const authHeader = request.headers.get('authorization') || request.headers.get('x-admin-token');
    const token = authHeader?.replace('Bearer ', '').trim();
    const correctToken = process.env.ADMIN_SECRET_TOKEN || 'GoLiveAdminSecret2026';

    if (!token || token !== correctToken) {
      return NextResponse.json({ error: 'Unauthorized Access Secret Required' }, { status: 401 });
    }

    const { automationId } = await request.json();

    if (!automationId) {
      return NextResponse.json({ success: false, error: 'automationId is required' }, { status: 400 });
    }

    const supabase = getAdminClient();
    const { data: automation, error: fetchErr } = await supabase
      .from('sync_automations')
      .select('*')
      .eq('id', automationId)
      .maybeSingle();

    if (fetchErr || !automation) {
      return NextResponse.json(
        { success: false, error: fetchErr?.message || 'Automation not found' },
        { status: 404 }
      );
    }

    const result = await executeAutomation(automation as SyncAutomationRecord);

    return NextResponse.json({
      success: result.success,
      channelsUpdated: result.channelsUpdated,
      serversUpdated: result.serversUpdated,
      durationMs: result.durationMs,
      error: result.errorMessage,
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, error: error.message || 'Server error running automation' },
      { status: 500 }
    );
  }
}
