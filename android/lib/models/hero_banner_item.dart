/// Data model for Hero Banner ads and promotional spotlight items
class HeroBannerItem {
  final String id;
  final String? title;
  final String imageUrl;
  final String? badgeText;
  final bool showTitle;
  final bool showBadge;
  final String actionType; // 'none', 'url', 'channel'
  final String? actionValue; // Target URL or Channel ID
  final bool active;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const HeroBannerItem({
    required this.id,
    this.title,
    required this.imageUrl,
    this.badgeText,
    this.showTitle = true,
    this.showBadge = true,
    this.actionType = 'none',
    this.actionValue,
    this.active = true,
    this.sortOrder = 0,
    this.createdAt,
    this.updatedAt,
  });

  bool get hasAction => actionType != 'none' && actionValue != null && actionValue!.isNotEmpty;
  bool get isExternalUrl => actionType == 'url' && actionValue != null && actionValue!.isNotEmpty;
  bool get isChannelAction => actionType == 'channel' && actionValue != null && actionValue!.isNotEmpty;
  bool get hasOverlay => (showBadge && badgeText != null && badgeText!.isNotEmpty) || (showTitle && title != null && title!.isNotEmpty);

  factory HeroBannerItem.fromJson(Map<String, dynamic> json) {
    return HeroBannerItem(
      id: json['id'] as String,
      title: json['title'] as String?,
      imageUrl: json['image_url'] as String? ?? '',
      badgeText: json['badge_text'] as String?,
      showTitle: json['show_title'] as bool? ?? true,
      showBadge: json['show_badge'] as bool? ?? true,
      actionType: json['action_type'] as String? ?? 'none',
      actionValue: json['action_value'] as String?,
      active: json['active'] as bool? ?? true,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_url': imageUrl,
      'badge_text': badgeText,
      'show_title': showTitle,
      'show_badge': showBadge,
      'action_type': actionType,
      'action_value': actionValue,
      'active': active,
      'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
