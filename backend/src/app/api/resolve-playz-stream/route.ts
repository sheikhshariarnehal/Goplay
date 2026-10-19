import { NextRequest, NextResponse } from 'next/server';
import crypto from 'crypto';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

const BASE_PRO_URL = 'https://pabbdyzone.shop/';

// Tier-1 PlayZ TV AES Keys
const KEY_PX = Buffer.from('cz14RStkN01PVE5w', 'utf8'); // 16 bytes
const IV_PX = Buffer.from('WTlEvckd2UR41sdk', 'utf8');  // 16 bytes

// PlayZ TV substitution cipher alphabet
const PLAIN_ALPHA = 'aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ';
const CIPHER_ALPHA = 'fFgGjJkKaApPbBmMzZeEnNcCdDrRqQtTvVuUxXhHiIwWyYlLsS';

const decryptMap = new Map<string, string>();
for (let i = 0; i < PLAIN_ALPHA.length; i++) {
  decryptMap.set(CIPHER_ALPHA[i], PLAIN_ALPHA[i]);
}

/**
 * Decrypts Tier-1 AES-128-CBC cipher:
 * 1. Base64 decode
 * 2. Swap adjacent bytes [i] <-> [i+1]
 * 3. Reverse entire byte array
 * 4. Base64 decode second layer
 * 5. AES-128-CBC Decrypt + PKCS7 unpad
 */
function decryptPx(rawB64Str: string): string {
  const clean = rawB64Str.replace(/\r?\n/g, '').trim();
  if (clean.startsWith('[') || clean.startsWith('{')) {
    return clean;
  }

  // 1. Base64 decode
  const step1 = Buffer.from(clean, 'base64');

  // 2. Swap adjacent bytes
  const swapped = Buffer.from(step1);
  for (let i = 0; i < swapped.length - 1; i += 2) {
    const tmp = swapped[i];
    swapped[i] = swapped[i + 1];
    swapped[i + 1] = tmp;
  }

  // 3. Reverse entire byte array
  swapped.reverse();

  // 4. Base64 decode second layer
  const step4 = Buffer.from(swapped.toString('utf8'), 'base64');

  // 5. AES-128-CBC Decrypt
  const decipher = crypto.createDecipheriv('aes-128-cbc', KEY_PX, IV_PX);
  decipher.setAutoPadding(true);
  const decrypted = Buffer.concat([decipher.update(step4), decipher.final()]);
  return decrypted.toString('utf8');
}

/**
 * Decrypts substitution-cipher ciphertext string into plain JSON string.
 */
function decryptSubstitution(encryptedContent: string): string {
  const trimmed = encryptedContent.trim();
  if (trimmed.startsWith('[') || trimmed.startsWith('{')) {
    return trimmed;
  }

  let substituted = '';
  for (let i = 0; i < trimmed.length; i++) {
    const char = trimmed[i];
    substituted += decryptMap.get(char) || char;
  }

  try {
    return Buffer.from(substituted, 'base64').toString('utf8');
  } catch {
    return substituted;
  }
}

function decryptAuto(raw: string): string {
  try {
    return decryptPx(raw);
  } catch {
    return decryptSubstitution(raw);
  }
}

/**
 * Parses stream URLs with pipe-separated custom headers.
 * e.g.: "https://example.com/live.m3u8|User-Agent=CustomAgent&Referer=https://ref.com"
 */
function parseStreamUrl(rawUrl: string): { url: string; headers: Record<string, string> } {
  if (!rawUrl.includes('|')) {
    return { url: rawUrl.trim(), headers: {} };
  }

  const parts = rawUrl.split('|');
  const streamUrl = parts[0].trim();
  const headersPart = parts.slice(1).join('|').trim();
  const headers: Record<string, string> = {};

  headersPart.split('&').forEach((pair) => {
    const eqIdx = pair.indexOf('=');
    if (eqIdx !== -1) {
      const key = decodeURIComponent(pair.substring(0, eqIdx).trim());
      const val = decodeURIComponent(pair.substring(eqIdx + 1).trim());
      headers[key] = val;
    }
  });

  return { url: streamUrl, headers };
}

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const { linksPath } = body as { linksPath?: string };

    if (!linksPath || typeof linksPath !== 'string') {
      return NextResponse.json({ ok: false, error: 'linksPath is required' }, { status: 400 });
    }

    const cleanPath = linksPath.trim();
    const fullUrl = cleanPath.startsWith('http')
      ? cleanPath
      : `${BASE_PRO_URL.replace(/\/+$/, '')}/${cleanPath.replace(/^\/+/, '')}`;

    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 10000);

    const res = await fetch(fullUrl, {
      method: 'GET',
      headers: {
        'User-Agent':
          'Mozilla/5.0 (Linux; Android 10; Pixel 3 XL) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36',
      },
      signal: controller.signal,
    });
    clearTimeout(timeoutId);

    if (!res.ok) {
      return NextResponse.json(
        { ok: false, error: `Upstream HTTP error: ${res.status} ${res.statusText}` },
        { status: res.status }
      );
    }

    const raw = await res.text();
    if (!raw.trim()) {
      return NextResponse.json({ ok: false, error: 'Empty upstream manifest' }, { status: 502 });
    }

    const decrypted = decryptAuto(raw);
    let items: any[];
    try {
      items = JSON.parse(decrypted);
    } catch {
      return NextResponse.json({ ok: false, error: 'Failed to parse decrypted manifest JSON' }, { status: 502 });
    }

    if (!Array.isArray(items)) {
      return NextResponse.json({ ok: false, error: 'Manifest is not an array' }, { status: 502 });
    }

    const servers = items
      .map((item: any, idx: number) => {
        if (!item || typeof item !== 'object') return null;
        const rawLink = item.link || '';
        if (!rawLink) return null;

        const parsed = parseStreamUrl(rawLink);
        const name = (item.name && typeof item.name === 'string' ? item.name.trim() : `Server ${idx + 1}`) || `Server ${idx + 1}`;
        const apiKey = item.api || '';

        let drm: any = null;
        if (apiKey && typeof apiKey === 'string' && apiKey.includes(':')) {
          const tokens = apiKey.split(':');
          if (tokens.length >= 2) {
            drm = {
              type: 'clearkey',
              kid: tokens[0].trim(),
              key: tokens[1].trim(),
            };
          }
        }

        return {
          name,
          stream_url: parsed.url,
          scheme: 0,
          drm,
          headers: parsed.headers,
          has_header: Object.keys(parsed.headers).length > 0,
          sort_order: idx,
          active: true,
        };
      })
      .filter(Boolean);

    return NextResponse.json({
      ok: true,
      servers,
      count: servers.length,
    });
  } catch (err: any) {
    return NextResponse.json(
      { ok: false, error: err.message || 'Internal server error while resolving streams' },
      { status: 500 }
    );
  }
}
