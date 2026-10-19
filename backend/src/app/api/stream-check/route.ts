import { NextRequest, NextResponse } from 'next/server';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const { url, headers } = body as {
      url?: string;
      headers?: Record<string, string>;
    };

    if (!url || typeof url !== 'string') {
      return NextResponse.json({ ok: false, error: 'A valid stream URL is required' }, { status: 400 });
    }

    // Validate URL syntax
    let parsedUrl: URL;
    try {
      parsedUrl = new URL(url);
    } catch {
      return NextResponse.json({ ok: false, error: 'Invalid URL format' }, { status: 400 });
    }

    if (!['http:', 'https:'].includes(parsedUrl.protocol)) {
      return NextResponse.json({ ok: false, error: 'Only HTTP/HTTPS protocols are supported' }, { status: 400 });
    }

    const requestHeaders: Record<string, string> = {
      'User-Agent':
        headers?.['User-Agent'] ||
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
      Accept: '*/*',
    };

    if (headers?.['Referer']) requestHeaders['Referer'] = headers['Referer'];
    if (headers?.['Origin']) requestHeaders['Origin'] = headers['Origin'];
    if (headers) {
      Object.entries(headers).forEach(([k, v]) => {
        if (!['User-Agent', 'Referer', 'Origin'].includes(k) && v) {
          requestHeaders[k] = v;
        }
      });
    }

    const startTime = Date.now();
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 6000);

    let res: Response;
    try {
      // First attempt a fast HEAD probe
      res = await fetch(url, {
        method: 'HEAD',
        headers: requestHeaders,
        signal: controller.signal,
        redirect: 'follow',
      });

      // If HEAD is disallowed by upstream (e.g. 405 Method Not Allowed), retry with a ranged GET
      if (res.status === 405 || res.status === 501) {
        res = await fetch(url, {
          method: 'GET',
          headers: { ...requestHeaders, Range: 'bytes=0-1024' },
          signal: controller.signal,
          redirect: 'follow',
        });
      }
    } catch (fetchErr: any) {
      clearTimeout(timeoutId);
      const latencyMs = Date.now() - startTime;
      const isTimeout = fetchErr.name === 'AbortError';
      return NextResponse.json({
        ok: false,
        status: isTimeout ? 504 : 0,
        statusText: isTimeout ? 'Gateway Timeout' : 'Network Connection Error',
        latencyMs,
        contentType: '',
        error: isTimeout ? 'Stream server timed out after 6 seconds' : fetchErr.message || 'Failed to reach stream server',
      });
    }

    clearTimeout(timeoutId);
    const latencyMs = Date.now() - startTime;
    const contentType = res.headers.get('content-type') || '';
    const isStreamContent =
      contentType.includes('application/vnd.apple.mpegurl') ||
      contentType.includes('application/x-mpegurl') ||
      contentType.includes('video/') ||
      contentType.includes('application/dash+xml') ||
      contentType.includes('octet-stream') ||
      url.includes('.m3u8') ||
      url.includes('.mpd');

    return NextResponse.json({
      ok: res.ok,
      status: res.status,
      statusText: res.statusText,
      latencyMs,
      contentType,
      isStreamContent,
      finalUrl: res.url,
      headers: {
        'content-type': contentType,
        'content-length': res.headers.get('content-length') || '',
        server: res.headers.get('server') || '',
      },
    });
  } catch (err: any) {
    return NextResponse.json(
      { ok: false, error: err.message || 'Internal server error while probing stream' },
      { status: 500 }
    );
  }
}
