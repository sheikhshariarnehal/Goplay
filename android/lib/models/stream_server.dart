import 'drm_config.dart';
import 'channel.dart';

/// Data model for a stream server belonging to a channel.
class StreamServer {
  final String id;
  final String channelId;
  final String name;
  final String streamUrl;
  final int scheme;
  final DrmConfig? drm;
  final Map<String, dynamic> headers;
  final bool hasHeader;
  final bool hasVpnDetection;
  final int sortOrder;
  final bool active;
  final String? healthStatus;
  final int? latencyMs;
  final DateTime? lastCheckedAt;

  const StreamServer({
    required this.id,
    required this.channelId,
    required this.name,
    required this.streamUrl,
    this.scheme = 0,
    this.drm,
    this.headers = const {},
    this.hasHeader = false,
    this.hasVpnDetection = false,
    this.sortOrder = 0,
    this.active = true,
    this.healthStatus,
    this.latencyMs,
    this.lastCheckedAt,
  });

  factory StreamServer.fromJson(Map<String, dynamic> json) {
    DrmConfig? drmConfig;
    if (json['drm'] != null && json['drm'] is Map) {
      drmConfig = DrmConfig.fromJson(Map<String, dynamic>.from(json['drm'] as Map));
    }

    final headersMap = json['headers'] is Map
        ? Map<String, dynamic>.from(json['headers'] as Map)
        : <String, dynamic>{};

    return StreamServer(
      id: json['id'] as String? ?? '',
      channelId: json['channel_id'] as String? ?? '',
      name: json['name'] as String? ?? 'Server',
      streamUrl: json['stream_url'] as String? ?? json['link'] as String? ?? '',
      scheme: (json['scheme'] as num?)?.toInt() ?? 0,
      drm: drmConfig,
      headers: headersMap,
      hasHeader: json['has_header'] as bool? ?? false,
      hasVpnDetection: json['has_vpn_detection'] as bool? ?? false,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      active: json['active'] as bool? ?? true,
      healthStatus: json['health_status'] as String?,
      latencyMs: (json['latency_ms'] as num?)?.toInt(),
      lastCheckedAt: json['last_checked_at'] != null
          ? DateTime.tryParse(json['last_checked_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel_id': channelId,
      'name': name,
      'stream_url': streamUrl,
      'scheme': scheme,
      'drm': drm?.toJson(),
      'headers': headers,
      'has_header': hasHeader,
      'has_vpn_detection': hasVpnDetection,
      'sort_order': sortOrder,
      'active': active,
      'health_status': healthStatus,
      'latency_ms': latencyMs,
      'last_checked_at': lastCheckedAt?.toIso8601String(),
    };
  }

  Channel toPlayableChannel({
    required String parentChannelId,
    required String parentName,
    String? logo,
    String? category,
  }) {
    return Channel(
      id: '${parentChannelId}_srv_$id',
      name: name,
      logo: logo,
      category: category,
      streamUrl: streamUrl,
      headers: headers,
      drm: drm,
      isLive: true,
      quality: 'HD',
      sortOrder: sortOrder,
    );
  }
}
