/// Data model for channel category
class Category {
  final String id;
  final String name;
  final String? icon;
  final String? iconUrl;
  final String type; // 'custom' or 'm3u'
  final String? playzEndpoint;
  final String? m3uUrl;
  final String xorKey;
  final bool hasHeader;
  final bool hasVpnDetection;
  final int sortOrder;
  final bool active;

  const Category({
    required this.id,
    required this.name,
    this.icon,
    this.iconUrl,
    this.type = 'custom',
    this.playzEndpoint,
    this.m3uUrl,
    this.xorKey = '',
    this.hasHeader = false,
    this.hasVpnDetection = false,
    this.sortOrder = 0,
    this.active = true,
  });

  bool get isM3u => type == 'm3u';
  bool get isCustom => type == 'custom';
  bool get isPlayzDirect =>
      (playzEndpoint != null && playzEndpoint!.isNotEmpty) ||
      (m3uUrl != null && m3uUrl!.isNotEmpty);

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String? ?? (json['name'] as String? ?? '').toLowerCase(),
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String?,
      iconUrl: json['icon_url'] as String? ?? json['logo_url'] as String? ?? json['logo'] as String?,
      type: json['type'] as String? ?? 'custom',
      playzEndpoint: json['playz_endpoint'] as String? ?? json['api'] as String?,
      m3uUrl: json['m3u_url'] as String?,
      xorKey: json['xor_key'] as String? ?? json['xorKey'] as String? ?? '',
      hasHeader: json['has_header'] as bool? ?? json['hasHeader'] as bool? ?? false,
      hasVpnDetection: json['has_vpn_detection'] as bool? ?? json['hasVpnDetection'] as bool? ?? false,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      active: json['active'] as bool? ?? (json['visible'] as bool? ?? true),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'icon_url': iconUrl,
        'type': type,
        'playz_endpoint': playzEndpoint,
        'm3u_url': m3uUrl,
        'xor_key': xorKey,
        'has_header': hasHeader,
        'has_vpn_detection': hasVpnDetection,
        'sort_order': sortOrder,
        'active': active,
      };

  Category copyWith({
    String? id,
    String? name,
    String? icon,
    String? iconUrl,
    String? type,
    String? playzEndpoint,
    String? m3uUrl,
    String? xorKey,
    bool? hasHeader,
    bool? hasVpnDetection,
    int? sortOrder,
    bool? active,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      iconUrl: iconUrl ?? this.iconUrl,
      type: type ?? this.type,
      playzEndpoint: playzEndpoint ?? this.playzEndpoint,
      m3uUrl: m3uUrl ?? this.m3uUrl,
      xorKey: xorKey ?? this.xorKey,
      hasHeader: hasHeader ?? this.hasHeader,
      hasVpnDetection: hasVpnDetection ?? this.hasVpnDetection,
      sortOrder: sortOrder ?? this.sortOrder,
      active: active ?? this.active,
    );
  }
}
