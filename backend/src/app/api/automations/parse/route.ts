import { NextResponse } from 'next/server';
import { parseM3uContent } from '../../../../utils/m3u-parser';

export async function POST(request: Request) {
  try {
    const authHeader = request.headers.get('authorization') || request.headers.get('x-admin-token');
    const token = authHeader?.replace('Bearer ', '').trim();
    const correctToken = process.env.ADMIN_SECRET_TOKEN || 'GoLiveAdminSecret2026';

    if (!token || token !== correctToken) {
      return NextResponse.json({ error: 'Unauthorized Access Secret Required' }, { status: 401 });
    }

    const { url, content } = await request.json();

    let rawText = '';

    if (content && typeof content === 'string' && content.trim()) {
      rawText = content;
    } else if (url && typeof url === 'string' && url.trim()) {
      const controller = new AbortController();
      const timeout = setTimeout(() => controller.abort(), 15000);

      const res = await fetch(url.trim(), {
        signal: controller.signal,
        headers: {
          'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
          Accept: '*/*',
        },
      });
      clearTimeout(timeout);

      if (!res.ok) {
        return NextResponse.json(
          { success: false, error: `Failed to fetch remote M3U URL: HTTP ${res.status} ${res.statusText}` },
          { status: 400 }
        );
      }
      rawText = await res.text();
    } else {
      return NextResponse.json(
        { success: false, error: 'Please provide either a valid M3U URL or raw M3U text content' },
        { status: 400 }
      );
    }

    const parsed = parseM3uContent(rawText);

    return NextResponse.json({
      success: true,
      count: parsed.length,
      channels: parsed,
    });
  } catch (error: any) {
    return NextResponse.json(
      { success: false, error: error.message || 'Failed to parse M3U source' },
      { status: 500 }
    );
  }
}
