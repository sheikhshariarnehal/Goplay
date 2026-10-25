import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show compute;
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart' as enc;
import '../models/channel.dart';
import '../models/category.dart';
import '../models/drm_config.dart';
import '../models/event.dart';

/// Stream Decryptor & Parser for Live Events
///
/// Implements reverse-engineered algorithms from PlayZ TV:
/// - Tier-1 AES-128-CBC Decryption (`decryptPx` with byte swapping & reversal)
/// - Section 4: `sc.a.b` Custom Alphabet Substitution Cipher + Base64
/// - Section 7.1: URL-encoded Pipe Header Parser (`parseStreamUrl`)
/// - Section 7.3: ClearKey DRM Hex-to-JWK format converter (`convertHexToClearKeyJson`)
class StreamDecryptor {
  StreamDecryptor._();

  static const String _plain =
      'aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ';
  static const String _cipher =
      'fFgGjJkKaApPbBmMoOzZeEnNcCdDrRqQtTvVuUxXhHiIwWyYlLsS';


  static final List<int> _decryptMap = List<int>.generate(128, (i) => i);
  static bool _initialized = false;

  // Tier-1 PlayZ TV AES Keys
  static final enc.Key _keyPx =
      enc.Key(Uint8List.fromList(utf8.encode('cz14RStkN01PVE5w')));
  static final enc.IV _ivPx =
      enc.IV(Uint8List.fromList(utf8.encode('WTlEvckd2UR41sdk')));

  static const String baseProUrl = 'https://pabbdyzone.shop/';

  static void _init() {
    if (_initialized) return;
    for (int i = 0; i < _plain.length; i++) {
      final cipherCode = _cipher.codeUnitAt(i);
      if (cipherCode < 128) {
        _decryptMap[cipherCode] = _plain.codeUnitAt(i);
      }
    }
    _initialized = true;
  }

  /// Decrypts Tier-1 AES-128-CBC cipher:
  /// 1. Base64 decode
  /// 2. Swap adjacent bytes [i] <-> [i+1]
  /// 3. Reverse entire bytearray
  /// 4. Base64 decode second layer
  /// 5. AES-128-CBC Decrypt + PKCS7 unpad
  static String decryptPx(String rawB64Str) {
    final clean = rawB64Str.replaceAll('\n', '').replaceAll('\r', '').trim();
    if (clean.startsWith('[') || clean.startsWith('{')) {
      return clean;
    }

    final step1 = Uint8List.fromList(base64.decode(base64.normalize(clean)));
    for (int i = 0; i < step1.length - 1; i += 2) {
      final tmp = step1[i];
      step1[i] = step1[i + 1];
      step1[i + 1] = tmp;
    }
    // In-place byte reversal on Uint8List: 0 heap allocations
    for (int left = 0, right = step1.length - 1; left < right; left++, right--) {
      final tmp = step1[left];
      step1[left] = step1[right];
      step1[right] = tmp;
    }
    final step4 = base64.decode(base64.normalize(utf8.decode(step1)));

    final encrypter = enc.Encrypter(enc.AES(_keyPx, mode: enc.AESMode.cbc));
    return encrypter.decrypt(
      enc.Encrypted(Uint8List.fromList(step4)),
      iv: _ivPx,
    );
  }

  /// Decrypts substitution-cipher ciphertext string into plain JSON string.
  /// Matches PlayZ TV `sc.a.b.java`.
  static String decryptSubstitution(String encryptedContent) {
    _init();
    final trimmed = encryptedContent.trim();
    if (trimmed.startsWith('[') || trimmed.startsWith('{')) {
      return trimmed; // Already plain JSON
    }

    final codeUnits = List<int>.filled(trimmed.length, 0);
    for (int i = 0; i < trimmed.length; i++) {
      final code = trimmed.codeUnitAt(i);
      codeUnits[i] = code < 128 ? _decryptMap[code] : code;
    }

    final substituted = String.fromCharCodes(codeUnits);
    try {
      final decodedBytes = base64.decode(base64.normalize(substituted));
      return utf8.decode(decodedBytes);
    } catch (_) {
      return substituted;
    }
  }

  /// Automatically attempts Tier-1 AES decryption first, then substitution cipher.
  static String decryptAuto(String rawPayload) {
    final trimmed = rawPayload.trim();
    if (trimmed.startsWith('[') || trimmed.startsWith('{')) {
      return trimmed;
    }

    try {
      return decryptPx(trimmed);
    } catch (_) {
      try {
        return decryptSubstitution(trimmed);
      } catch (_) {
        return trimmed;
      }
    }
  }

  /// Parses stream URL and pipe-separated headers.
  /// Example: `https://domain.com/live.m3u8|User-Agent=Mozilla...&Referer=https://...`
  /// Matches Section 7.1 specification.
  static ({String url, Map<String, String> headers}) parseStreamUrl(
      String rawUrl) {
    try {
      final decoded = Uri.decodeFull(rawUrl);
      if (!decoded.contains('|')) {
        return (url: decoded.trim(), headers: const <String, String>{});
      }

      final parts = decoded.split('|');
      final streamUrl = parts[0].trim();
      final headers = <String, String>{};

      if (parts.length > 1) {
        final queryParams = parts[1].split('&');
        for (final param in queryParams) {
          final kv = param.split('=');
          if (kv.length >= 2) {
            headers[kv[0].trim()] = kv.sublist(1).join('=').trim();
          }
        }
      }

      return (url: streamUrl, headers: headers);
    } catch (_) {
      return (url: rawUrl, headers: const <String, String>{});
    }
  }

  /// Converts hex "kid:key" to W3C ClearKey JSON Web Key (JWK) format.
  /// Matches Section 7.3 (`wc.d.s` and `wc.d.n`).
  static String convertHexToClearKeyJson(String hexPair) {
    final trimmed = hexPair.trim();
    if (trimmed.startsWith('{')) return trimmed; // Already JSON

    final tokens = trimmed.split(':');
    final keys = <String>[];

    for (int i = 0; i < tokens.length - 1; i += 2) {
      final hexKid = tokens[i].trim();
      final hexKey = tokens[i + 1].trim();

      final base64Kid = _hexToBase64(hexKid).replaceAll('=', '');
      final base64Key = _hexToBase64(hexKey).replaceAll('=', '');

      keys.add('{"kty":"oct","k":"$base64Key","kid":"$base64Kid"}');
    }

    return '{"keys":[${keys.join(',')}],"type":"temporary"}';
  }

  static String _hexToBase64(String hex) {
    final len = hex.length;
    final bytes = List<int>.filled(len ~/ 2, 0);
    for (int i = 0; i < len; i += 2) {
      final byteVal = int.parse(hex.substring(i, i + 2), radix: 16);
      bytes[i ~/ 2] = byteVal;
    }
    return base64.encode(bytes);
  }

  // ── In-Memory Caches for Instant (0ms) Response ───────────────────
  static final Map<String, ({DateTime cachedAt, List<Channel> channels})> _streamCache = {};
  static String _lastRawEventsData = '';
  static List<SportEvent> _cachedLiveEvents = [];

  /// Returns cached streams for this event if available and fresh (< 3 mins).
  static List<Channel>? getCachedStreams(String linksPath, String eventId) {
    final cacheKey = '$linksPath::$eventId';
    final cached = _streamCache[cacheKey];
    if (cached != null && DateTime.now().difference(cached.cachedAt).inSeconds < 180) {
      return cached.channels;
    }
    return null;
  }

  /// Fetches the raw encrypted file from `pabbdyzone.shop/{linksPath}`,
  /// decrypts it on the fly, and returns parsed [Channel] objects.
  /// Includes an in-memory 3-minute TTL cache for 0ms instant stream launching.
  static Future<List<Channel>> fetchAndDecryptStreams({
    required String linksPath,
    required String eventId,
    String? eventTitle,
    String? logo,
  }) async {
    if (linksPath.isEmpty) return const [];

    final cacheKey = '$linksPath::$eventId';
    final cached = _streamCache[cacheKey];
    if (cached != null && DateTime.now().difference(cached.cachedAt).inSeconds < 180) {
      return cached.channels;
    }

    final fullUrl = linksPath.startsWith('http')
        ? linksPath
        : '${baseProUrl.replaceAll(RegExp(r'/+$'), '')}/${linksPath.replaceAll(RegExp(r'^/+'), '')}';

    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'User-Agent': 'Dalvik/2.1.0'},
      ));

      final response = await dio.get<String>(fullUrl);
      final raw = response.data?.trim() ?? '';
      if (raw.isEmpty) return const [];

      final decrypted = decryptAuto(raw);
      final dynamic decoded = json.decode(decrypted);

      if (decoded is! List) return const [];

      final channels = <Channel>[];
      for (int i = 0; i < decoded.length; i++) {
        final item = decoded[i];
        if (item is! Map) continue;

        final map = Map<String, dynamic>.from(item);
        final rawLink = map['link'] as String? ?? '';
        if (rawLink.isEmpty) continue;

        final parsed = parseStreamUrl(rawLink);
        final streamName = map['name'] as String? ?? 'Stream ${i + 1}';
        final apiKey = map['api'] as String?;

        Map<String, dynamic>? drmMap;
        if (apiKey != null && apiKey.contains(':')) {
          final tokens = apiKey.split(':');
          if (tokens.length >= 2) {
            drmMap = {
              'type': 'clearkey',
              'kid': tokens[0].trim(),
              'key': tokens[1].trim(),
            };
          }
        }

        final safeEventId = eventId.replaceAll('/', '_');
        channels.add(Channel(
          id: 'live_${safeEventId}_$i',
          name: streamName,
          logo: logo,
          category: 'events',
          streamUrl: parsed.url,
          headers: parsed.headers,
          drm: DrmConfig.fromJson(drmMap),
          isLive: true,
          quality: 'HD',
        ));
      }

      if (channels.isNotEmpty) {
        _streamCache[cacheKey] = (cachedAt: DateTime.now(), channels: channels);
      }
      return channels;
    } catch (_) {
      return cached?.channels ?? const [];
    }
  }

  /// Parses and decrypts event payload. Designed to run inside a background isolate.
  static List<SportEvent> parseEventsFromRaw(String raw) {
    try {
      final decrypted = decryptAuto(raw);
      final dynamic decoded = json.decode(decrypted);

      if (decoded is! List) return const [];

      final events = <SportEvent>[];
      for (final item in decoded) {
        if (item is! Map) continue;
        final map = Map<String, dynamic>.from(item);

        // API wraps each item as {"event": "{\"visible\":true,...}"}
        if (map.containsKey('event')) {
          final dynamic inner = map['event'];
          if (inner is String) {
            try {
              final parsedInner = json.decode(inner);
              if (parsedInner is Map) {
                final eventMap = Map<String, dynamic>.from(parsedInner);
                if (eventMap['visible'] == false) continue;
                events.add(SportEvent.fromJson(eventMap));
              }
            } catch (_) {}
          } else if (inner is Map) {
            final eventMap = Map<String, dynamic>.from(inner);
            if (eventMap['visible'] == false) continue;
            events.add(SportEvent.fromJson(eventMap));
          }
        } else {
          if (map['visible'] == false) continue;
          events.add(SportEvent.fromJson(map));
        }
      }

      return events;
    } catch (_) {
      return const [];
    }
  }

  /// Fetches raw encrypted `events.txt` directly from `https://pabbdyzone.shop/events.txt`,
  /// decrypts it using Tier-1 AES-128-CBC / substitution cipher, and maps to [SportEvent] objects.
  ///
  /// Performance Optimizations:
  /// - Runs decryption and 200+ JSON decodes in a background isolate (`compute`), ensuring 0 UI jank.
  /// - Compares raw payload before decryption: identical data returns cached events in 0ms.
  static Future<List<SportEvent>> fetchLiveEvents({
    String? customBaseUrl,
    bool forceRefresh = false,
  }) async {
    final baseUrl = customBaseUrl ?? baseProUrl;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final url = '${baseUrl.replaceAll(RegExp(r'/+$'), '')}/events.txt?_t=$timestamp';

    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 12),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Linux; Android 10; Pixel 3 XL) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36',
          'Cache-Control': 'no-cache, no-store, must-revalidate',
          'Pragma': 'no-cache',
        },
      ));

      final response = await dio.get<String>(url);
      final raw = response.data?.trim() ?? '';
      if (raw.isEmpty) return List<SportEvent>.from(_cachedLiveEvents);

      // 1. Fast zero-cost return if backend payload hasn't changed (saves CPU on unchanged polls)
      // Returns a fresh list shallow-copy so Riverpod detects state update when invalidated
      if (!forceRefresh && raw == _lastRawEventsData && _cachedLiveEvents.isNotEmpty) {
        return List<SportEvent>.from(_cachedLiveEvents);
      }

      // 2. Offload heavy crypto + JSON decodes to background worker isolate
      final parsedEvents = await compute(StreamDecryptor.parseEventsFromRaw, raw);
      if (parsedEvents.isNotEmpty) {
        _lastRawEventsData = raw;
        _cachedLiveEvents = parsedEvents;
      }

      return parsedEvents.isNotEmpty
          ? List<SportEvent>.from(parsedEvents)
          : List<SportEvent>.from(_cachedLiveEvents);
    } catch (e) {
      return List<SportEvent>.from(_cachedLiveEvents);
    }
  }


  /// Fetches event category logos from `https://pabbdyzone.shop/event_cats.txt`.
  /// Returns a map of Category/Sport Name -> Logo URL.
  static Future<Map<String, String>> fetchEventCategories({
    String? customBaseUrl,
  }) async {
    final baseUrl = customBaseUrl ?? baseProUrl;
    final url = '${baseUrl.replaceAll(RegExp(r'/+$'), '')}/event_cats.txt';

    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Linux; Android 10; Pixel 3 XL) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36',
        },
      ));

      final response = await dio.get<String>(url);
      final raw = response.data?.trim() ?? '';
      if (raw.isEmpty) return const {};

      final decrypted = decryptAuto(raw);
      final dynamic decoded = json.decode(decrypted);

      final result = <String, String>{};
      if (decoded is Map) {
        for (final entry in decoded.entries) {
          result[entry.key.toString()] = entry.value.toString();
        }
      } else if (decoded is List) {
        for (final item in decoded) {
          if (item is Map && item.containsKey('cat')) {
            final dynamic catData = item['cat'];
            if (catData is String) {
              try {
                final catMap = json.decode(catData);
                if (catMap is Map && catMap['name'] != null && catMap['logo'] != null) {
                  result[catMap['name'].toString()] = catMap['logo'].toString();
                }
              } catch (_) {}
            }
          }
        }
      }
      return result;
    } catch (_) {
      return const {};
    }
  }

  /// Fetches and decrypts a category's channel list from `https://pabbdyzone.shop/{endpoint}`
  /// (e.g. `channels/Qk4xNzY3MDIzMTU1NzMy.txt` for Bangla, `channels/SW5kaWExNzY3MDA3MjE1ODgz.txt` for India).
  static Future<List<Channel>> fetchCategoryChannels({
    required String endpoint,
    required String categoryId,
    String? customBaseUrl,
  }) async {
    final baseUrl = customBaseUrl ?? baseProUrl;
    final url = endpoint.startsWith('http')
        ? endpoint
        : '${baseUrl.replaceAll(RegExp(r'/+$'), '')}/${endpoint.replaceAll(RegExp(r'^/+'), '')}';

    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 12),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Linux; Android 10; Pixel 3 XL) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36',
        },
      ));

      final response = await dio.get<String>(url);
      final raw = response.data?.trim() ?? '';
      if (raw.isEmpty) return const [];

      final decrypted = decryptAuto(raw);
      final dynamic decoded = json.decode(decrypted);
      if (decoded is! List) return const [];

      final channels = <Channel>[];
      for (int i = 0; i < decoded.length; i++) {
        final item = decoded[i];
        if (item is! Map) continue;

        Map<String, dynamic>? channelMap;
        if (item.containsKey('channel')) {
          final dynamic inner = item['channel'];
          if (inner is String) {
            try {
              final parsedInner = json.decode(inner);
              if (parsedInner is Map) {
                channelMap = Map<String, dynamic>.from(parsedInner);
              }
            } catch (_) {}
          } else if (inner is Map) {
            channelMap = Map<String, dynamic>.from(inner);
          }
        } else {
          channelMap = Map<String, dynamic>.from(item);
        }

        if (channelMap == null) continue;
        if (channelMap['visible'] == false) continue;

        final rawName = channelMap['name'] as String? ?? 'Channel ${i + 1}';
        final logo = channelMap['logo'] as String?;
        final links = channelMap['links'] as String? ?? '';
        if (links.isEmpty) continue;

        final safeSuffix = rawName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_').replaceAll(RegExp(r'^_+|_+$'), '');
        final safeId = 'playz_${categoryId}_${safeSuffix.isEmpty ? i : safeSuffix}';

        channels.add(Channel(
          id: safeId,
          name: rawName,
          logo: logo,
          category: categoryId,
          streamUrl: links,
          isLive: true,
          quality: 'HD',
          sortOrder: i,
        ));
      }

      return channels;
    } catch (_) {
      return const [];
    }
  }

  /// Fetches and decrypts dynamic stream servers from a channel's manifest (`pro/*.txt`).
  /// Each server is mapped to an playable [Channel] object with parsed headers and DRM.
  static Future<List<Channel>> fetchChannelStreams({
    required String linksPath,
    required String channelId,
    required String channelName,
    String? category,
    String? logo,
    String? customBaseUrl,
  }) async {
    if (linksPath.isEmpty) return const [];

    final baseUrl = customBaseUrl ?? baseProUrl;
    final fullUrl = linksPath.startsWith('http')
        ? linksPath
        : '${baseUrl.replaceAll(RegExp(r'/+$'), '')}/${linksPath.replaceAll(RegExp(r'^/+'), '')}';

    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Linux; Android 10; Pixel 3 XL) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36',
        },
      ));

      final response = await dio.get<String>(fullUrl);
      final raw = response.data?.trim() ?? '';
      if (raw.isEmpty) return const [];

      final decrypted = decryptAuto(raw);
      final dynamic decoded = json.decode(decrypted);

      if (decoded is! List) return const [];

      final streams = <Channel>[];
      for (int i = 0; i < decoded.length; i++) {
        final item = decoded[i];
        if (item is! Map) continue;

        final map = Map<String, dynamic>.from(item);
        final rawLink = map['link'] as String? ?? '';
        if (rawLink.isEmpty) continue;

        final parsed = parseStreamUrl(rawLink);
        final streamServerName = map['name'] as String? ?? 'Server ${i + 1}';
        final apiKey = map['api'] as String?;

        Map<String, dynamic>? drmMap;
        if (apiKey != null && apiKey.contains(':')) {
          final tokens = apiKey.split(':');
          if (tokens.length >= 2) {
            drmMap = {
              'type': 'clearkey',
              'kid': tokens[0].trim(),
              'key': tokens[1].trim(),
            };
          }
        }

        final safeChannelId = channelId.replaceAll('/', '_');
        streams.add(Channel(
          id: '${safeChannelId}_server_$i',
          name: streamServerName,
          logo: logo,
          category: category ?? 'direct',
          streamUrl: parsed.url,
          headers: parsed.headers,
          drm: DrmConfig.fromJson(drmMap),
          isLive: true,
          quality: 'HD',
        ));
      }

      return streams;
    } catch (_) {
      return const [];
    }
  }

  /// Fetches and decrypts the master categories directory from PlayZ (`categories.txt`).
  static Future<List<Category>> fetchPlayzRemoteCategories({String? customBaseUrl}) async {
    final baseUrl = customBaseUrl ?? baseProUrl;
    final fullUrl = '${baseUrl.replaceAll(RegExp(r'/+$'), '')}/categories.txt';

    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Linux; Android 10; Pixel 3 XL) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36',
        },
      ));

      final response = await dio.get<String>(fullUrl);
      final raw = response.data?.trim() ?? '';
      if (raw.isEmpty) return const [];

      final decrypted = decryptAuto(raw);
      final dynamic decoded = json.decode(decrypted);
      if (decoded is! List) return const [];

      final categories = <Category>[];
      for (int i = 0; i < decoded.length; i++) {
        final item = decoded[i];
        if (item is! Map) continue;

        Map<String, dynamic>? catMap;
        if (item.containsKey('cat')) {
          final dynamic inner = item['cat'];
          if (inner is String) {
            try {
              final parsedInner = json.decode(inner);
              if (parsedInner is Map) {
                catMap = Map<String, dynamic>.from(parsedInner);
              }
            } catch (_) {}
          } else if (inner is Map) {
            catMap = Map<String, dynamic>.from(inner);
          }
        } else {
          catMap = Map<String, dynamic>.from(item);
        }

        if (catMap == null) continue;
        if (catMap['visible'] == false) continue;

        final name = (catMap['name'] as String? ?? '').trim();
        if (name.isEmpty) continue;

        final type = catMap['type'] as String? ?? 'custom';
        final api = catMap['api'] as String?;
        final logo = catMap['logo'] as String?;
        final xorKey = catMap['xorKey'] as String? ?? '';
        final hasHeader = catMap['hasHeader'] as bool? ?? false;
        final hasVpnDetection = catMap['hasVpnDetection'] as bool? ?? false;

        final slug = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_').replaceAll(RegExp(r'^_+|_+$'), '');
        final id = slug.isEmpty ? 'cat_$i' : slug;

        categories.add(Category(
          id: id,
          name: name,
          iconUrl: logo,
          type: type,
          playzEndpoint: type == 'custom' ? api : null,
          m3uUrl: type == 'm3u' ? api : null,
          xorKey: xorKey,
          hasHeader: hasHeader,
          hasVpnDetection: hasVpnDetection,
          sortOrder: i + 1,
          active: true,
        ));
      }

      return categories;
    } catch (_) {
      return const [];
    }
  }

  /// Parses an M3U / M3U8 text playlist into a list of playable Channels.
  static Future<List<Channel>> fetchM3uChannels({
    required String m3uUrl,
    required String categoryId,
  }) async {
    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 12),
      ));

      final response = await dio.get<String>(m3uUrl);
      final raw = response.data ?? '';
      if (raw.isEmpty) return const [];

      final lines = raw.split(RegExp(r'\r?\n'));
      final channels = <Channel>[];
      String? currentName;
      String? currentLogo;

      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        if (line.startsWith('#EXTINF:')) {
          final logoMatch = RegExp(r'tvg-logo="([^"]+)"', caseSensitive: false).firstMatch(line);
          currentLogo = logoMatch?.group(1);

          final commaIdx = line.indexOf(',');
          if (commaIdx != -1 && commaIdx < line.length - 1) {
            currentName = line.substring(commaIdx + 1).trim();
          } else {
            currentName = 'Channel ${channels.length + 1}';
          }
        } else if (!line.startsWith('#') && (line.startsWith('http://') || line.startsWith('https://'))) {
          final streamUrl = line;
          final name = currentName ?? 'Channel ${channels.length + 1}';
          final safeId = 'm3u_${categoryId}_${channels.length}';

          final parsed = parseStreamUrl(streamUrl);

          channels.add(Channel(
            id: safeId,
            name: name,
            logo: currentLogo,
            category: categoryId,
            streamUrl: parsed.url,
            headers: parsed.headers,
            isLive: true,
            quality: 'HD',
            sortOrder: channels.length,
          ));

          currentName = null;
          currentLogo = null;
        }
      }

      return channels;
    } catch (_) {
      return const [];
    }
  }
}
