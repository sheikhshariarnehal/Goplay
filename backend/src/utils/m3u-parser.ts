/**
 * GoPlay M3U & Header Parser Utility
 * Extracts #EXTINF attributes, #KODIPROP headers, and tokenized stream URLs.
 */

export interface ParsedM3uEntry {
  id: string; // derived unique key for row tracking
  name: string;
  tvgName: string;
  tvgId: string;
  logo: string;
  groupTitle: string;
  streamUrl: string;
  headers: Record<string, string>;
  hasHeaders: boolean;
  rawKodiProps?: Record<string, string>;
}

/**
 * Standardize HTTP header casing (e.g. user-agent -> User-Agent)
 */
function normalizeHeaderKey(key: string): string {
  const lower = key.trim().toLowerCase();
  switch (lower) {
    case 'user-agent':
    case 'useragent':
      return 'User-Agent';
    case 'host':
      return 'Host';
    case 'cookie':
      return 'Cookie';
    case 'referer':
    case 'referrer':
      return 'Referer';
    case 'origin':
      return 'Origin';
    case 'accept':
      return 'Accept';
    case 'accept-encoding':
      return 'Accept-Encoding';
    case 'client-api-header':
      return 'Client-Api-Header';
    case 'x-forwarded-for':
      return 'X-Forwarded-For';
    default:
      return key
        .split('-')
        .map((p) => p.charAt(0).toUpperCase() + p.slice(1).toLowerCase())
        .join('-');
  }
}

/**
 * Parse Kodi stream headers string (e.g. "Host=foo.com&user-agent=okhttp/5.1.0&cookie=")
 */
export function parseKodiStreamHeaders(rawHeaderString: string): Record<string, string> {
  const headers: Record<string, string> = {};
  if (!rawHeaderString) return headers;

  const pairs = rawHeaderString.split('&');
  for (const pair of pairs) {
    const eqIdx = pair.indexOf('=');
    if (eqIdx !== -1) {
      const rawKey = pair.substring(0, eqIdx).trim();
      const rawVal = pair.substring(eqIdx + 1).trim();

      // Only include non-empty, non-null values
      if (rawKey && rawVal && rawVal !== 'null' && rawVal !== 'undefined') {
        const standardKey = normalizeHeaderKey(decodeURIComponent(rawKey));
        headers[standardKey] = decodeURIComponent(rawVal);
      }
    }
  }

  return headers;
}

/**
 * Parse full M3U content with support for #EXTINF and #KODIPROP directives
 */
export function parseM3uContent(content: string): ParsedM3uEntry[] {
  if (!content) return [];

  const lines = content.split(/\r?\n/);
  const results: ParsedM3uEntry[] = [];

  let currentName = '';
  let currentTvgName = '';
  let currentTvgId = '';
  let currentLogo = '';
  let currentGroup = '';
  let currentHeaders: Record<string, string> = {};
  let currentKodiProps: Record<string, string> = {};

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i].trim();
    if (!line) continue;

    if (line.startsWith('#EXTINF:')) {
      // Extract tvg-logo
      const logoMatch = line.match(/tvg-logo="([^"]*)"/i);
      currentLogo = logoMatch ? logoMatch[1].trim() : '';

      // Extract tvg-name
      const nameMatch = line.match(/tvg-name="([^"]*)"/i);
      currentTvgName = nameMatch ? nameMatch[1].trim() : '';

      // Extract tvg-id
      const idMatch = line.match(/tvg-id="([^"]*)"/i);
      currentTvgId = idMatch ? idMatch[1].trim() : '';

      // Extract group-title
      const groupMatch = line.match(/group-title="([^"]*)"/i);
      currentGroup = groupMatch ? groupMatch[1].trim() : '';

      // Name after the last comma
      const commaIdx = line.lastIndexOf(',');
      if (commaIdx !== -1) {
        currentName = line.substring(commaIdx + 1).trim();
      } else if (currentTvgName) {
        currentName = currentTvgName;
      } else {
        currentName = `Channel ${results.length + 1}`;
      }
    } else if (line.startsWith('#KODIPROP:')) {
      const propContent = line.substring('#KODIPROP:'.length).trim();
      const eqIdx = propContent.indexOf('=');
      if (eqIdx !== -1) {
        const propKey = propContent.substring(0, eqIdx).trim();
        const propVal = propContent.substring(eqIdx + 1).trim();
        currentKodiProps[propKey] = propVal;

        if (propKey === 'inputstream.adaptive.stream_headers') {
          const parsedHeaders = parseKodiStreamHeaders(propVal);
          currentHeaders = { ...currentHeaders, ...parsedHeaders };
        }
      }
    } else if (line.startsWith('#EXTVLCOPT:http-user-agent=')) {
      const ua = line.substring('#EXTVLCOPT:http-user-agent='.length).trim();
      if (ua) currentHeaders['User-Agent'] = ua;
    } else if (line.startsWith('#EXTVLCOPT:http-referrer=')) {
      const ref = line.substring('#EXTVLCOPT:http-referrer='.length).trim();
      if (ref) currentHeaders['Referer'] = ref;
    } else if (!line.startsWith('#')) {
      // This is the stream URL
      if (currentName || line.startsWith('http')) {
        const hasHeaders = Object.keys(currentHeaders).length > 0;
        const entryId = `${currentTvgId || currentTvgName || currentName || 'stream'}-${results.length}`
          .toLowerCase()
          .replace(/[^a-z0-9_-]/g, '_');

        results.push({
          id: entryId,
          name: currentName || currentTvgName || `Channel ${results.length + 1}`,
          tvgName: currentTvgName,
          tvgId: currentTvgId,
          logo: currentLogo,
          groupTitle: currentGroup,
          streamUrl: line,
          headers: { ...currentHeaders },
          hasHeaders,
          rawKodiProps: { ...currentKodiProps },
        });

        // Reset temporary states for next channel entry
        currentName = '';
        currentTvgName = '';
        currentTvgId = '';
        currentLogo = '';
        currentGroup = '';
        currentHeaders = {};
        currentKodiProps = {};
      }
    }
  }

  return results;
}

/**
 * Normalizes a channel name string for fuzzy matching
 */
function cleanChannelName(raw: string): string {
  return raw
    .toLowerCase()
    .replace(/\b(hd|fhd|4k|sd|tv|live|bd|in|bangla|india|stream)\b/g, '')
    .replace(/[^a-z0-9]/g, '')
    .trim();
}

/**
 * Fuzzy matches an M3U entry name against a list of existing channels in the DB
 */
export function findBestChannelMatch(
  sourceName: string,
  sourceTvgId: string | undefined,
  candidates: Array<{ id: string; name: string }>
): { channel: { id: string; name: string } | null; confidence: number } {
  if (!candidates || candidates.length === 0) {
    return { channel: null, confidence: 0 };
  }

  const cleanSource = cleanChannelName(sourceName);
  const cleanId = sourceTvgId ? cleanChannelName(sourceTvgId) : '';

  let bestMatch: { id: string; name: string } | null = null;
  let highestScore = 0;

  for (const candidate of candidates) {
    const cleanCandName = cleanChannelName(candidate.name);
    const cleanCandId = cleanChannelName(candidate.id);

    // Exact matches
    if (candidate.name.toLowerCase() === sourceName.toLowerCase()) {
      return { channel: candidate, confidence: 1.0 };
    }
    if (cleanCandName === cleanSource && cleanSource.length > 0) {
      return { channel: candidate, confidence: 0.95 };
    }
    if (cleanId && (cleanCandId === cleanId || cleanCandName === cleanId)) {
      return { channel: candidate, confidence: 0.9 };
    }

    // Substring contains check
    if (cleanSource.length >= 3 && cleanCandName.length >= 3) {
      if (cleanSource.includes(cleanCandName) || cleanCandName.includes(cleanSource)) {
        const score = Math.min(cleanSource.length, cleanCandName.length) / Math.max(cleanSource.length, cleanCandName.length);
        if (score > highestScore && score >= 0.6) {
          highestScore = score;
          bestMatch = candidate;
        }
      }
    }
  }

  if (highestScore >= 0.6 && bestMatch) {
    return { channel: bestMatch, confidence: highestScore };
  }

  return { channel: null, confidence: 0 };
}
