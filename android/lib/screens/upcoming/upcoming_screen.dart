import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme.dart';
import '../../core/typography.dart';
import '../../providers/app_providers.dart';
import '../../models/event.dart';
import '../../services/stream_decryptor.dart';
import '../../widgets/cards/playz_event_card.dart';
import '../../widgets/app_overflow_menu.dart';
import '../../widgets/tv_focus_wrapper.dart';

/// Live Events Hub for GoPlay
///
/// Implements the complete Live Events Client Architecture:
/// - Section 2.1: Sport Category Filter Chips (All, Cricket, Football, etc.)
/// - Section 5.2: 5 Pinned Status Tabs (Live, Today, Tomorrow, Upcoming, Ended)
/// - Section 6: Smart JIT on-demand stream resolution & decryption with instant playback
/// - Section 5.1: Strict UTC/GMT lifecycle evaluation
class UpcomingScreen extends ConsumerStatefulWidget {
  const UpcomingScreen({super.key});

  @override
  ConsumerState<UpcomingScreen> createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends ConsumerState<UpcomingScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabs = [
    'Live',
    'Today',
    'Tomorrow',
    'Upcoming',
    'Ended',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    try {
      await ref.read(syncServiceProvider).sync();
    } catch (_) {}
  }

  Future<void> _handleEventTap(SportEvent event) async {
    // 1. If pre-cached channels exist, auto-play stream 0 immediately
    if (event.channels.isNotEmpty) {
      if (!mounted) return;
      context.push(
        '/player/${event.channels.first}',
        extra: {
          'eventChannels': event.channels,
          'forceFullscreen': true,
        },
      );
      return;
    }

    // 2. If channels are missing but event has encrypted links, run Smart JIT fetch
    final linksPath = event.links;
    if (linksPath != null && linksPath.isNotEmpty) {
      _showJitLoadingDialog();

      try {
        final streams = await StreamDecryptor.fetchAndDecryptStreams(
          linksPath: linksPath,
          eventId: event.id,
          eventTitle: '${event.homeTeam.name} vs ${event.awayTeam.name}',
          logo: event.banner,
        );

        if (!mounted) return;
        Navigator.of(context, rootNavigator: true).pop(); // Dismiss HUD

        if (streams.isNotEmpty) {
          context.push(
            '/player/${streams.first.id}',
            extra: {
              'eventChannels': streams.map((c) => c.id).toList(),
              'dynamicChannels': streams,
              'forceFullscreen': true,
            },
          );
          return;
        }
      } catch (_) {
        if (!mounted) return;
        Navigator.of(context, rootNavigator: true).pop(); // Dismiss HUD
      }
    }

    // 3. Fallback notice if no active streams resolved
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No active streams available yet. Check back closer to kickoff.'),
        backgroundColor: GoPlayTheme.error,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showJitLoadingDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (ctx) => Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x28FFFFFF)),
            boxShadow: const [
              BoxShadow(color: Color(0xDD000000), blurRadius: 20, spreadRadius: 4),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(GoPlayTheme.primary),
                ),
              ),
              SizedBox(width: 16),
              Text(
                'Connecting to live feed...',
                style: TextStyle(
                  fontFamily: GoPlayType.family,
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final sportsAsync = ref.watch(sortedSportCategoriesProvider);
    final selectedSport = ref.watch(selectedSportFilterProvider);
    final liveEventsCount = ref.watch(liveEventsProvider).value?.length ?? 0;

    return Material(
      color: cs.surface,
      child: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // Pinned Main App Bar
            SliverAppBar(
              floating: false,
              pinned: true,
              backgroundColor: cs.surface,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 16,
              toolbarHeight: kToolbarHeight,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
              ),
              title: const Text(
                'Live Events',
                style: TextStyle(
                  fontFamily: GoPlayType.family,
                  color: GoPlayTheme.onSurface,
                  fontSize: GoPlayType.xl,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
              actions: const [
                AppOverflowMenu(iconColor: Colors.white),
                SizedBox(width: 8),
              ],
            ),

            // Horizontal Sport Category Filter Chips
            SliverToBoxAdapter(
              child: sportsAsync.when(
                data: (sports) => SizedBox(
                  height: 44,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    scrollDirection: Axis.horizontal,
                    itemCount: sports.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final sport = sports[index];
                      final isSelected = sport.toLowerCase() == selectedSport.toLowerCase();
                      return TvFocusable(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          ref.read(selectedSportFilterProvider.notifier).select(sport);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? GoPlayTheme.primary
                                : const Color(0xFF272727),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            sport,
                            style: TextStyle(
                              fontFamily: GoPlayType.family,
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? const Color(0xFF0F0F0F) : Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                loading: () => const SizedBox(height: 44),
                error: (err, stack) => const SizedBox.shrink(),
              ),
            ),

            // Pinned 5 Status Tabs
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  physics: const BouncingScrollPhysics(),
                  tabAlignment: TabAlignment.start,
                  padding: const EdgeInsets.only(left: 4),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(color: GoPlayTheme.primary, width: 3.0),
                    borderRadius: BorderRadius.all(Radius.circular(1.5)),
                  ),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorPadding: const EdgeInsets.only(bottom: 2),
                  dividerColor: Colors.transparent,
                  dividerHeight: 0,
                  labelColor: GoPlayTheme.primary,
                  unselectedLabelColor: GoPlayTheme.onSurfaceVariant,
                  labelStyle: GoPlayType.label.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: GoPlayType.label.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(
                      text: 'Live${liveEventsCount > 0 ? ' ($liveEventsCount)' : ''}',
                    ),
                    const Tab(text: 'Today'),
                    const Tab(text: 'Tomorrow'),
                    const Tab(text: 'Upcoming'),
                    const Tab(text: 'Ended'),
                  ],
                ),
                backgroundColor: cs.surface,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Tab 0: Live Events
            _EventsListView(
              eventsAsync: ref.watch(filteredLiveEventsProvider(selectedSport)),
              onRefresh: _handleRefresh,
              onEventTap: _handleEventTap,
              emptyMessage: 'No live matches right now.',
            ),

            // Tab 1: Today Events
            _EventsListView(
              eventsAsync: ref.watch(filteredTodayEventsProvider(selectedSport)),
              onRefresh: _handleRefresh,
              onEventTap: _handleEventTap,
              emptyMessage: 'No matches scheduled for today.',
            ),

            // Tab 2: Tomorrow Events
            _EventsListView(
              eventsAsync: ref.watch(filteredTomorrowEventsProvider),
              onRefresh: _handleRefresh,
              onEventTap: _handleEventTap,
              emptyMessage: 'No matches scheduled for tomorrow.',
            ),

            // Tab 3: Upcoming Events (Grouped by date)
            _GroupedUpcomingListView(
              eventsAsync: ref.watch(filteredUpcomingEventsProvider),
              onRefresh: _handleRefresh,
              onEventTap: _handleEventTap,
            ),

            // Tab 4: Ended Events
            _EventsListView(
              eventsAsync: ref.watch(filteredEndedEventsProvider),
              onRefresh: _handleRefresh,
              onEventTap: _handleEventTap,
              emptyMessage: 'No completed matches recorded.',
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Single List Tab View ───────────────────────────────────────────────────
class _EventsListView extends StatelessWidget {
  final AsyncValue<List<SportEvent>> eventsAsync;
  final Future<void> Function() onRefresh;
  final void Function(SportEvent) onEventTap;
  final String emptyMessage;

  const _EventsListView({
    required this.eventsAsync,
    required this.onRefresh,
    required this.onEventTap,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktopOrTv = MediaQuery.of(context).size.width >= 800;

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: GoPlayTheme.primary,
      backgroundColor: const Color(0xFF272727),
      child: eventsAsync.when(
        data: (events) {
          if (events.isEmpty) {
            return _EmptyTabState(message: emptyMessage);
          }

          if (isDesktopOrTv) {
            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: PlayZEventCard.tileExtent(context),
                crossAxisSpacing: 8,
                mainAxisSpacing: 0,
              ),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return PlayZEventCard(
                  key: ValueKey(event.id),
                  event: event,
                  onTap: () => onEventTap(event),
                );
              },
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            itemExtent: PlayZEventCard.tileExtent(context),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return PlayZEventCard(
                key: ValueKey(event.id),
                event: event,
                onTap: () => onEventTap(event),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: GoPlayTheme.primary),
        ),
        error: (err, _) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: GoPlayTheme.error),
          ),
        ),
      ),
    );
  }
}

// ─── Grouped Upcoming Tab View ──────────────────────────────────────────────
class _GroupedUpcomingListView extends StatelessWidget {
  final AsyncValue<List<SportEvent>> eventsAsync;
  final Future<void> Function() onRefresh;
  final void Function(SportEvent) onEventTap;

  const _GroupedUpcomingListView({
    required this.eventsAsync,
    required this.onRefresh,
    required this.onEventTap,
  });

  static Map<String, List<SportEvent>> _groupByDate(List<SportEvent> events) {
    final Map<String, List<SportEvent>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final nextWeek = today.add(const Duration(days: 7));

    for (final event in events) {
      final localStart = event.startTime.toLocal();
      final eventDate = DateTime(
        localStart.year,
        localStart.month,
        localStart.day,
      );

      final String label;
      if (eventDate == today) {
        label = 'Today';
      } else if (eventDate == tomorrow) {
        label = 'Tomorrow';
      } else if (eventDate.isBefore(nextWeek)) {
        label = DateFormat('EEEE, MMM d').format(localStart);
      } else {
        label = DateFormat('MMM d, yyyy').format(localStart);
      }

      grouped.putIfAbsent(label, () => []).add(event);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktopOrTv = MediaQuery.of(context).size.width >= 800;

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: GoPlayTheme.primary,
      backgroundColor: const Color(0xFF272727),
      child: eventsAsync.when(
        data: (events) {
          final grouped = _groupByDate(events);
          if (grouped.isEmpty) {
            return const _EmptyTabState(message: 'No upcoming fixtures scheduled.');
          }

          final keys = grouped.keys.toList(growable: false);

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: keys.length,
            itemBuilder: (context, index) {
              final key = keys[index];
              final dayEvents = grouped[key]!;

              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 15,
                          color: GoPlayTheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          key,
                          style: GoPlayType.label.copyWith(
                            color: GoPlayTheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (isDesktopOrTv)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisExtent: PlayZEventCard.tileExtent(context),
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 0,
                        ),
                        itemCount: dayEvents.length,
                        itemBuilder: (context, idx) {
                          final event = dayEvents[idx];
                          return PlayZEventCard(
                            key: ValueKey(event.id),
                            event: event,
                            onTap: () => onEventTap(event),
                          );
                        },
                      )
                    else
                      ...dayEvents.map(
                        (event) => PlayZEventCard(
                          key: ValueKey(event.id),
                          event: event,
                          onTap: () => onEventTap(event),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: GoPlayTheme.primary),
        ),
        error: (err, _) => Center(
          child: Text('Error: $err', style: const TextStyle(color: GoPlayTheme.error)),
        ),
      ),
    );
  }
}

// ─── Empty State ─────────────────────────────────────────────────────────────
class _EmptyTabState extends StatelessWidget {
  final String message;

  const _EmptyTabState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_rounded,
              size: 48,
              color: GoPlayTheme.onSurfaceMuted.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoPlayType.body.copyWith(
                color: GoPlayTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Pinned TabBar Delegate ─────────────────────────────────────────────────
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;

  _SliverTabBarDelegate(this.tabBar, {required this.backgroundColor});

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: backgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
