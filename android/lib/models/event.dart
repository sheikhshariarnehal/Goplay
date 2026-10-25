import 'package:flutter/foundation.dart';

/// Supported event lifecycle states (Section 3.1 & 5.2)
enum EventLifecycleStatus {
  live,
  todays,
  tomorrow,
  upcoming,
  ended,
}

/// Team data within an event
class Team {
  final String name;
  final String? flag;

  const Team({required this.name, this.flag});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      name: json['name'] as String? ?? 'TBD',
      flag: json['flag'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'flag': flag};
}

/// Data model for a sporting event
///
/// Implements UTC/GMT evaluation and lifecycle states matching the Live Events
/// architecture specification (`live_events_architecture_context.md`).
class SportEvent {
  final String id;
  final String sport;
  final String league;
  final Team homeTeam;
  final Team awayTeam;
  final DateTime startTime;
  final DateTime? endTime;
  final String status; // 'live', 'upcoming', 'finished', 'ended'
  final List<String> channels;
  final List<String> linkNames;
  final String? links; // Encrypted path e.g. "pro/xxx.txt"
  final String? banner;
  final String? categoryLogo;
  final String? strokeColor;
  final bool isFeatured;
  final int sortOrder;

  const SportEvent({
    required this.id,
    required this.sport,
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
    required this.startTime,
    this.endTime,
    this.status = 'upcoming',
    this.channels = const [],
    this.linkNames = const [],
    this.links,
    this.banner,
    this.categoryLogo,
    this.strokeColor,
    this.isFeatured = false,
    this.sortOrder = 0,
  });

  /// Evaluates whether the event has concluded according to UTC/GMT time.
  /// Matches PlayZ TV wc.d.q logic: only marked ended if an end timestamp has passed
  /// or backend explicitly marks status as finished/completed/ended.
  bool get isEnded {
    final s = status.trim().toLowerCase();
    if (s == 'finished' || s == 'completed' || s == 'ended') {
      return true;
    }
    if (endTime != null) {
      return DateTime.now().toUtc().isAfter(endTime!.toUtc());
    }
    // PlayZ TV wc.d.q: if (endDateStr.isNullOrEmpty() || endTimeStr.isNullOrEmpty()) return false;
    return false;
  }


  /// Evaluates whether the event is currently active and live in UTC/GMT.
  bool get isLive {
    if (isEnded) return false;
    final s = status.trim().toLowerCase();
    if (s == 'live') return true;

    final nowUtc = DateTime.now().toUtc();
    final startUtc = startTime.toUtc();
    return !nowUtc.isBefore(startUtc);
  }

  /// Evaluates whether the event is upcoming in the future.
  bool get isUpcoming {
    if (isEnded || isLive) return false;
    final nowUtc = DateTime.now().toUtc();
    final startUtc = startTime.toUtc();
    return nowUtc.isBefore(startUtc);
  }

  /// Legacy alias for isEnded
  bool get isFinished => isEnded;

  /// Runtime computed lifecycle status bucket (Section 5.2)
  EventLifecycleStatus get lifecycleStatus {
    if (isEnded) return EventLifecycleStatus.ended;
    if (isLive) return EventLifecycleStatus.live;

    final nowUtc = DateTime.now().toUtc();
    final startUtc = startTime.toUtc();
    final todayUtc = DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day);
    final tomorrowUtc = todayUtc.add(const Duration(days: 1));
    final startDayUtc = DateTime.utc(startUtc.year, startUtc.month, startUtc.day);

    if (startDayUtc == todayUtc) return EventLifecycleStatus.todays;
    if (startDayUtc == tomorrowUtc) return EventLifecycleStatus.tomorrow;
    return EventLifecycleStatus.upcoming;
  }

  Duration get timeUntilStart => startTime.toUtc().difference(DateTime.now().toUtc());
  Duration get elapsedTime => DateTime.now().toUtc().difference(startTime.toUtc());

  static DateTime? _parseDateSafe(dynamic val) {
    if (val == null) return null;
    if (val is DateTime) return val;
    try {
      return DateTime.parse(val.toString());
    } catch (_) {
      return null;
    }
  }

  factory SportEvent.fromJson(Map<String, dynamic> json) {
    DateTime start = _parseDateSafe(json['start_time']) ?? DateTime.now();
    DateTime? end = _parseDateSafe(json['end_time']);

    // If start_time was in dd/MM/yyyy format (from direct API)
    if (json.containsKey('date') && json.containsKey('time')) {
      try {
        final dateParts = (json['date'] as String).split('/');
        final timeParts = (json['time'] as String).split(':');
        if (dateParts.length == 3 && timeParts.length >= 2) {
          start = DateTime.utc(
            int.parse(dateParts[2]),
            int.parse(dateParts[1]),
            int.parse(dateParts[0]),
            int.parse(timeParts[0]),
            int.parse(timeParts[1]),
            timeParts.length > 2 ? int.parse(timeParts[2]) : 0,
          );
        }
      } catch (_) {}
    }

    if (json.containsKey('end_date') && json.containsKey('end_time')) {
      try {
        final dateParts = (json['end_date'] as String).split('/');
        final timeParts = (json['end_time'] as String).split(':');
        if (dateParts.length == 3 && timeParts.length >= 2) {
          end = DateTime.utc(
            int.parse(dateParts[2]),
            int.parse(dateParts[1]),
            int.parse(dateParts[0]),
            int.parse(timeParts[0]),
            int.parse(timeParts[1]),
            timeParts.length > 2 ? int.parse(timeParts[2]) : 0,
          );
        }
      } catch (_) {}
    }

    final rawSport = json['sport'] as String? ?? json['category'] as String? ?? 'Sports';
    final rawLeague = json['league'] as String? ?? json['eventName'] as String? ?? '';
    final rawStatus = json['status'] as String? ?? 'upcoming';

    return SportEvent(
      id: (json['id'] ?? (json['links'] != null ? (json['links'] as String).replaceAll('/', '_') : null) ?? UniqueKey().toString()).toString().replaceAll('/', '_'),
      sport: rawSport.trim().isEmpty ? 'Sports' : rawSport.trim(),
      league: rawLeague.trim(),
      homeTeam: json['home_team'] is Map
          ? Team.fromJson(Map<String, dynamic>.from(json['home_team'] as Map))
          : Team(
              name: (json['teamAName'] as String? ?? 'Team A').trim(),
              flag: json['teamAFlag'] as String?,
            ),
      awayTeam: json['away_team'] is Map
          ? Team.fromJson(Map<String, dynamic>.from(json['away_team'] as Map))
          : Team(
              name: (json['teamBName'] as String? ?? 'Team B').trim(),
              flag: json['teamBFlag'] as String?,
            ),
      startTime: start,
      endTime: end,
      status: rawStatus.trim(),
      channels: json['channels'] is List
          ? (json['channels'] as List).map((e) => e.toString()).toList()
          : [],
      linkNames: json['link_names'] is List
          ? (json['link_names'] as List).map((e) => e.toString()).toList()
          : [],
      links: json['links'] as String?,
      banner: json['banner'] as String? ?? json['eventLogo'] as String?,
      categoryLogo: json['categoryLogo'] as String?,
      strokeColor: json['strokeColor'] as String?,
      isFeatured: json['is_featured'] as bool? ?? json['isHot'] as bool? ?? false,
      sortOrder: json['sort_order'] as int? ?? json['priority'] as int? ?? 0,
    );
  }

  SportEvent copyWith({
    String? id,
    String? sport,
    String? league,
    Team? homeTeam,
    Team? awayTeam,
    DateTime? startTime,
    DateTime? endTime,
    String? status,
    List<String>? channels,
    List<String>? linkNames,
    String? links,
    String? banner,
    String? categoryLogo,
    String? strokeColor,
    bool? isFeatured,
    int? sortOrder,
  }) {
    return SportEvent(
      id: id ?? this.id,
      sport: sport ?? this.sport,
      league: league ?? this.league,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      channels: channels ?? this.channels,
      linkNames: linkNames ?? this.linkNames,
      links: links ?? this.links,
      banner: banner ?? this.banner,
      categoryLogo: categoryLogo ?? this.categoryLogo,
      strokeColor: strokeColor ?? this.strokeColor,
      isFeatured: isFeatured ?? this.isFeatured,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sport': sport,
        'league': league,
        'home_team': homeTeam.toJson(),
        'away_team': awayTeam.toJson(),
        'start_time': startTime.toIso8601String(),
        if (endTime != null) 'end_time': endTime!.toIso8601String(),
        'status': status,
        'channels': channels,
        'link_names': linkNames,
        if (links != null) 'links': links,
        'banner': banner,
        if (categoryLogo != null) 'categoryLogo': categoryLogo,
        if (strokeColor != null) 'strokeColor': strokeColor,
        'is_featured': isFeatured,
        'sort_order': sortOrder,
      };
}
