import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme.dart';
import '../../core/typography.dart';
import '../../providers/app_providers.dart';
import '../../models/event.dart';
import '../../models/channel.dart';
import '../../models/announcement.dart';
import '../../models/hero_banner_item.dart';

import '../../widgets/cards/playz_event_card.dart';
import '../../services/event_stream_launcher.dart';
import '../../widgets/section_header.dart';
import '../../widgets/channel_avatar.dart';
import '../../widgets/tv_focus_wrapper.dart';
import '../../widgets/app_overflow_menu.dart';

// ─── Static const text styles ────────────────────────────────────────────
// Inter comes from the ambient theme (bundled, see pubspec.yaml). Sizes are
// steps on the GoPlayType scale — nothing here is hand-picked.
//
// The hero styles below keep literal `Colors.white*` rather than the
// GoPlayTheme text tokens on purpose: they render on top of a cover photo
// under a scrim, not on a known theme surface, so the three-tier surface
// ladder does not apply and pure white is the safer contrast choice.
const _kInterLeagueBadge = TextStyle(
  fontFamily: GoPlayType.family,
  color: Colors.white,
  fontSize: GoPlayType.xs,
  fontWeight: FontWeight.w600,
  height: GoPlayType.leadingFlat,
  letterSpacing: GoPlayType.trackingMeta,
);


const _kInterSearchHint = TextStyle(
  fontFamily: GoPlayType.family,
  color: GoPlayTheme.onSurfaceMuted,
  fontSize: GoPlayType.base,
  height: GoPlayType.leadingSnug,
);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the appSyncProvider to check initialization state
    final syncState = ref.watch(appSyncProvider);
    final cache = ref.watch(cacheServiceProvider);
    final localChannels = cache.getLocalChannels();

    final cs = Theme.of(context).colorScheme;

    // If local cache is empty, we must show loading/error states for the initial sync.
    if (localChannels.isEmpty) {
      return syncState.when(
        data: (_) => _buildMainContent(context, ref),
        loading: () => Material(
          color: cs.surface,
          child: const Center(
            child: CircularProgressIndicator(
              color: GoPlayTheme.primary,
            ),
          ),
        ),
        error: (error, stack) => Material(
          color: cs.surface,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cloud_off_rounded,
                    size: 64,
                    color: GoPlayTheme.error,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'CONNECTION ERROR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: GoPlayType.family,
                      fontSize: GoPlayType.lg,
                      fontWeight: FontWeight.w800,
                      color: GoPlayTheme.onSurface,
                      height: GoPlayType.leadingTitle,
                      letterSpacing: GoPlayType.trackingWide,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    error.toString().replaceAll('Exception: ', ''),
                    textAlign: TextAlign.center,
                    style: GoPlayType.body.copyWith(
                      color: GoPlayTheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Refresh the sync provider to trigger a reload
                      ref.invalidate(appSyncProvider);
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    label: const Text('RETRY CONNECTION'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GoPlayTheme.primary,
                      foregroundColor: const Color(0xFF003300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return _buildMainContent(context, ref);
  }

  Widget _buildMainContent(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surface,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        cacheExtent: 600.0,
        slivers: [
          // Collapsing Dark-Themed App Bar
          SliverAppBar(
            expandedHeight: 108.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final double appBarHeight = constraints.biggest.height;
                final double statusBarHeight = MediaQuery.paddingOf(
                  context,
                ).top;
                const double expandedHeight = 108.0;
                final double minHeight = kToolbarHeight + statusBarHeight;
                final double maxHeight = expandedHeight + statusBarHeight;

                final double collapseRatio =
                    ((maxHeight - appBarHeight) / (maxHeight - minHeight))
                        .clamp(0.0, 1.0);

                final Color themeSurface = Theme.of(context).colorScheme.surface;
                final Color headerBgColor = themeSurface;

                final Widget headerContent = Container(
                  color: headerBgColor,
                  child: Padding(
                    padding: EdgeInsets.only(top: statusBarHeight),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 16,
                          top: 0,
                          height: kToolbarHeight,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              ref.watch(uiConfigProvider).navigationBranding.brandWordmark,
                              style: GoPlayType.wordmark.copyWith(
                                color: GoPlayTheme.onSurface,
                                // Lerps between two on-scale steps so the
                                // wordmark shrinks smoothly instead of
                                // snapping at the halfway point.
                                fontSize: GoPlayType.xl -
                                    ((GoPlayType.xl - GoPlayType.lg) *
                                        collapseRatio),
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),

                        if (collapseRatio >= 0.5)
                          Positioned(
                            right: 48,
                            top: 0,
                            height: kToolbarHeight,
                            child: Center(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.search_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: () => context.push('/search'),
                              ),
                            ),
                          ),

                        const Positioned(
                          right: 8,
                          top: 0,
                          height: kToolbarHeight,
                          child: Center(
                            child: AppOverflowMenu(iconColor: Colors.white),
                          ),
                        ),

                        if (collapseRatio < 0.67)
                          Positioned(
                            left: 16,
                            right: 16,
                            bottom: 4 * (1.0 - collapseRatio),
                            // The hit zone is 48dp; the pill it paints is 40dp.
                            // The field used to be a 44dp box that was both
                            // heavier than it needed to look and below the
                            // Android touch-target minimum. Splitting the two
                            // lets the pill get lighter while the target gets
                            // bigger. 56 (toolbar) + 48 + 4 = the 108 expanded
                            // height, so the geometry above is unchanged.
                            height: 48,
                            child: TvFocusable(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () => context.push('/search'),
                              child: Center(
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: GoPlayTheme.surfaceContainerHigh,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.search_rounded,
                                        color: GoPlayTheme.onSurfaceMuted,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Search channels, events...',
                                        style: _kInterSearchHint,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );

                return headerContent;
              },
            ),
          ),

          ..._buildModularSections(context, ref),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  List<Widget> _buildModularSections(BuildContext context, WidgetRef ref) {
    final uiConfig = ref.watch(uiConfigProvider);
    final homeConfig = uiConfig.homeScreen;
    final order = homeConfig.sectionOrder;

    final widgets = <Widget>[];

    for (final sectionKey in order) {
      if (sectionKey == 'hero' && homeConfig.showHeroBanner) {
        widgets.add(const SliverToBoxAdapter(
          child: RepaintBoundary(child: _HeroBanner()),
        ));
      } else if (sectionKey == 'trending' && homeConfig.showTrendingSection) {
        widgets.addAll([
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Trending Channels',
              actionLabel: 'See all',
              onAction: () {
                final isTrendingEnabled = ref.read(showTrendingTabProvider);
                ref.read(selectedCategoryProvider.notifier).select(
                  isTrendingEnabled ? 'trending' : 'all',
                );
                context.go('/channels');
              },
            ),
          ),
          const SliverToBoxAdapter(
            child: RepaintBoundary(child: _TrendingChannels()),
          ),
        ]);
      } else if (sectionKey == 'matches' && homeConfig.showTodaysMatches) {
        widgets.addAll([
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: "Today's Matches",
              actionLabel: 'See all',
              onAction: () => context.go('/upcoming'),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: RepaintBoundary(child: _SportCategoryFilterChips()),
            ),
          ),
          const _TodaySchedule(),
        ]);
      } else if (sectionKey == 'recent' && homeConfig.showRecentlyWatched) {
        widgets.add(const SliverToBoxAdapter(
          child: RepaintBoundary(child: _RecentlyWatched()),
        ));
      } else if (sectionKey == 'announcements' && homeConfig.showAnnouncements) {
        widgets.add(const SliverToBoxAdapter(
          child: RepaintBoundary(child: _AnnouncementsSection()),
        ));
      }
    }

    // Safety fallback: if all sections turned off, show at least trending channels
    if (widgets.isEmpty) {
      widgets.addAll([
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: SectionHeader(
            title: 'Trending Channels',
            actionLabel: 'See all',
            onAction: () {
              final isTrendingEnabled = ref.read(showTrendingTabProvider);
              ref.read(selectedCategoryProvider.notifier).select(
                isTrendingEnabled ? 'trending' : 'all',
              );
              context.go('/channels');
            },
          ),
        ),
        const SliverToBoxAdapter(
          child: RepaintBoundary(child: _TrendingChannels()),
        ),
      ]);
    }

    return widgets;
  }
}

// ─── Hero Banner ──────────────────────────────────────────────────────────────
class _HeroBanner extends ConsumerStatefulWidget {
  const _HeroBanner();

  @override
  ConsumerState<_HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends ConsumerState<_HeroBanner> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
  Timer? _autoScrollTimer;
  int _bannerCount = 0;

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  void _startAutoScroll(int count) {
    _autoScrollTimer?.cancel();
    _bannerCount = count;
    if (count <= 1) return;

    final speed = ref.read(uiConfigProvider).homeScreen.heroBannerAutoplaySpeed;
    final interval = Duration(seconds: speed > 0 ? speed : 5);

    _autoScrollTimer = Timer.periodic(interval, (timer) {
      if (!_pageController.hasClients) return;
      final nextPage = (_currentPage.value + 1) % _bannerCount;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _pauseAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  void _resumeAutoScroll() {
    _startAutoScroll(_bannerCount);
  }

  @override
  Widget build(BuildContext context) {
    final bannersAsync = ref.watch(heroBannersProvider);

    return bannersAsync.when(
      data: (banners) {
        if (banners.isEmpty) return const SizedBox.shrink();

        if (_bannerCount != banners.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _startAutoScroll(banners.length);
          });
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  _currentPage.value = index;
                },
                itemCount: banners.length,
                itemBuilder: (context, index) {
                  final banner = banners[index];
                  return _HeroBannerCard(
                    banner: banner,
                    autoFocus: index == 0,
                    onInteractionStart: _pauseAutoScroll,
                    onInteractionEnd: _resumeAutoScroll,
                  );
                },
              ),
            ),
            if (banners.length > 1) ...[
              const SizedBox(height: 8),
              ValueListenableBuilder<int>(
                valueListenable: _currentPage,
                builder: (context, currentPage, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(banners.length, (index) {
                      final bool active = currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: active ? 18 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(3),
                          ),
                          color: active
                              ? GoPlayTheme.primary
                              : const Color(0x50C8FF00),
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ],
        );
      },
      loading: () => const _HeroBannerSkeleton(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}

/// Individual hero banner card for ads and promotional images
class _HeroBannerCard extends ConsumerWidget {
  final HeroBannerItem banner;
  final bool autoFocus;
  final VoidCallback? onInteractionStart;
  final VoidCallback? onInteractionEnd;

  const _HeroBannerCard({
    required this.banner,
    this.autoFocus = false,
    this.onInteractionStart,
    this.onInteractionEnd,
  });

  static const _cardRadius = BorderRadius.all(Radius.circular(20));
  static const _cardDecoration = BoxDecoration(
    borderRadius: _cardRadius,
    border: Border.fromBorderSide(
      BorderSide(color: GoPlayTheme.cardBorder, width: 0.8),
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x26000000),
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  );

  Future<void> _handleTap(BuildContext context, WidgetRef ref) async {
    if (banner.isExternalUrl) {
      final uri = Uri.tryParse(banner.actionValue!);
      if (uri != null) {
        try {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (e) {
          debugPrint('Error launching banner URL: $e');
        }
      }
    } else if (banner.isChannelAction) {
      if (context.mounted) {
        context.push('/player/${banner.actionValue}');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TvFocusable(
      autoFocus: autoFocus,
      borderRadius: BorderRadius.circular(20),
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          onInteractionStart?.call();
        } else {
          onInteractionEnd?.call();
        }
      },
      onTap: () => _handleTap(context, ref),
      child: GestureDetector(
        onTapDown: (_) => onInteractionStart?.call(),
        onTapUp: (_) => onInteractionEnd?.call(),
        onTapCancel: () => onInteractionEnd?.call(),
        onTap: () => _handleTap(context, ref),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
          child: DecoratedBox(
            decoration: _cardDecoration,
            child: ClipRRect(
              borderRadius: _cardRadius,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Artwork Image
                  if (banner.imageUrl.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: banner.imageUrl,
                      fit: BoxFit.cover,
                      memCacheWidth: 600,
                      fadeInDuration: const Duration(milliseconds: 200),
                      placeholder: (context, url) => const ColoredBox(
                        color: GoPlayTheme.surfaceContainerHigh,
                      ),
                      errorWidget: (context, url, error) => const ColoredBox(
                        color: GoPlayTheme.surfaceContainerHigh,
                      ),
                    )
                  else
                    const ColoredBox(
                      color: GoPlayTheme.surfaceContainerHigh,
                    ),

                  // Top & bottom gradient overlays for contrast (only when text/badge overlays are active)
                  if (banner.hasOverlay)
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x60000000),
                            Colors.transparent,
                            Color(0x85000000),
                          ],
                          stops: [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),

                  // Top badge
                  if (banner.showBadge && banner.badgeText != null && banner.badgeText!.isNotEmpty)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0x30FFFFFF), width: 0.5),
                        ),
                        child: Text(
                          banner.badgeText!.toUpperCase(),
                          style: _kInterLeagueBadge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                  // Bottom Title Overlay
                  if (banner.showTitle && banner.title != null && banner.title!.isNotEmpty)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.85),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
                        child: Text(
                          banner.title!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Minimal Sport Category Filter Chips ─────────────────────────────────────────
class _SportCategoryFilterChips extends ConsumerWidget {
  const _SportCategoryFilterChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sportsAsync = ref.watch(sortedSportCategoriesProvider);
    final selectedSport = ref.watch(selectedSportFilterProvider);
    final uiConfig = ref.watch(uiConfigProvider);

    final activeBg = GoPlayTheme.parseHex(uiConfig.resolveCategoryChipActiveBg(isHome: true));
    final inactiveBg = GoPlayTheme.parseHex(uiConfig.resolveCategoryChipInactiveBg(isHome: true));
    final activeTextColor = GoPlayTheme.parseHex(uiConfig.resolveCategoryChipActiveTextColor(isHome: true));
    final inactiveTextColor = GoPlayTheme.parseHex(uiConfig.resolveCategoryChipInactiveTextColor(isHome: true));
    final chipRadius = uiConfig.resolveCategoryChipRadius(isHome: true);

    return sportsAsync.when(
      data: (sportsList) {
        return SizedBox(
          height: 32,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            addRepaintBoundaries: false,
            addAutomaticKeepAlives: false,
            itemCount: sportsList.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final sport = sportsList[index];
              final isSelected = selectedSport.toLowerCase() == sport.toLowerCase();

              return TvFocusable(
                borderRadius: BorderRadius.circular(chipRadius),
                onTap: () {
                  ref.read(selectedSportFilterProvider.notifier).select(sport);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? activeBg : inactiveBg,
                    borderRadius: BorderRadius.circular(chipRadius),
                  ),
                  child: Center(
                    child: Text(
                      sport,
                      style: TextStyle(
                        fontFamily: GoPlayType.family,
                        fontSize: GoPlayType.sm,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? activeTextColor : inactiveTextColor,
                        height: GoPlayType.leadingSnug,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const _ChipsSkeleton(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}

class _TodaySchedule extends ConsumerWidget {
  const _TodaySchedule();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSport = ref.watch(selectedSportFilterProvider);
    final eventsAsync = ref.watch(filteredLiveEventsProvider(selectedSport));

    return eventsAsync.when(
      data: (liveEvents) {
        if (liveEvents.isEmpty) {
          final emptyText = selectedSport.toLowerCase() == 'all'
              ? 'No live events streaming right now'
              : 'No live $selectedSport matches right now';
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                emptyText,
                style: const TextStyle(color: GoPlayTheme.onSurfaceVariant),
              ),
            ),
          );
        }

        final isDesktopOrTv = MediaQuery.of(context).size.width >= 800;

        Future<void> handleTap(SportEvent event) async {
          await EventStreamLauncher.launch(context, event);
        }

        if (isDesktopOrTv) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: PlayZEventCard.tileExtent(context),
                crossAxisSpacing: 8,
                mainAxisSpacing: 0,
              ),
              itemCount: liveEvents.length,
              itemBuilder: (context, index) {
                final event = liveEvents[index];
                return PlayZEventCard(
                  key: ValueKey(event.id),
                  event: event,
                  onTap: () => handleTap(event),
                );
              },
            ),
          );
        }

        return SliverFixedExtentList.builder(
          itemExtent: PlayZEventCard.tileExtent(context),
          itemCount: liveEvents.length,
          itemBuilder: (context, index) {
            final event = liveEvents[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PlayZEventCard(
                key: ValueKey(event.id),
                event: event,
                onTap: () => handleTap(event),
              ),
            );
          },
        );
      },
      loading: () => const _ScheduleSkeleton(),
      error: (err, stack) => const SliverToBoxAdapter(child: SizedBox.shrink()),
    );
  }
}

// â”€â”€â”€ Trending Channels â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _TrendingChannels extends ConsumerWidget {
  const _TrendingChannels();

  static const _nameStyle = TextStyle(
    fontFamily: GoPlayType.family,
    color: GoPlayTheme.onSurface,
    fontSize: GoPlayType.xs,
    fontWeight: FontWeight.w500,
    height: GoPlayType.leadingSnug,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingAsync = ref.watch(trendingChannelsProvider);

    return trendingAsync.when(
      data: (channels) {
        if (channels.isEmpty) return const SizedBox.shrink();

        // Scope the player's channel switcher to this rail. Without it the
        // player falls back to "every channel in the same category", so
        // tapping a trending channel showed the whole category instead of
        // the trending set the user was looking at.
        final railIds = channels.map((c) => c.id).toList(growable: false);

        return SizedBox(
          height: 88,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: channels.length,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            itemBuilder: (context, index) {
              final ch = channels[index];
              return _ChannelItem(
                channel: ch,
                nameStyle: _nameStyle,
                showBorder: true,
                onTap: () => context.push(
                  '/player/${ch.id}',
                  extra: {'eventChannels': railIds},
                ),
              );
            },
          ),
        );
      },
      loading: () => const _TrendingChannelsSkeleton(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}

// ─── Recently Watched ────────────────────────────────────────────────────────
class _RecentlyWatched extends ConsumerWidget {
  const _RecentlyWatched();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(watchHistoryProvider);

    if (history.isEmpty) return const SizedBox.shrink();

    // Same scoping as the trending rail: switching channels inside the player
    // walks the history you opened it from, not the whole category.
    final railIds = history.map((c) => c.id).toList(growable: false);

    return Column(
      children: [
        const SizedBox(height: 24),
        const SectionHeader(title: 'Recently Watched'),
        SizedBox(
          height: 88,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: history.length,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            itemBuilder: (context, index) {
              final ch = history[index];
              return _ChannelItem(
                channel: ch,
                nameStyle: _historyNameStyle,
                showBorder: false,
                onTap: () => context.push(
                  '/player/${ch.id}',
                  extra: {'eventChannels': railIds},
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── Announcements ────────────────────────────────────────────────────────────
class _AnnouncementsSection extends ConsumerWidget {
  const _AnnouncementsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsync = ref.watch(announcementsProvider);

    return announcementsAsync.when(
      data: (announcements) {
        if (announcements.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
            const SizedBox(height: 24),
            const SectionHeader(title: 'Announcements'),
            for (final a in announcements) _AnnouncementTile(announcement: a),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}



// â”€â”€â”€ Cached style â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
const TextStyle _historyNameStyle = TextStyle(
  fontFamily: GoPlayType.family,
  color: GoPlayTheme.onSurface,
  fontSize: GoPlayType.xs,
  height: GoPlayType.leadingSnug,
);

// â”€â”€â”€ _HeroBannerSkeleton â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _HeroBannerSkeleton extends StatelessWidget {
  const _HeroBannerSkeleton();

  static const _decoration = BoxDecoration(
    color: GoPlayTheme.surfaceContainer,
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SizedBox(
        height: 200,
        child: DecoratedBox(
          decoration: _decoration,
          child: Center(
            child: CircularProgressIndicator(color: GoPlayTheme.primary),
          ),
        ),
      ),
    );
  }
}


// â”€â”€â”€ _ChannelItem â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _ChannelItem extends StatelessWidget {
  final Channel channel;
  final TextStyle nameStyle;
  final bool showBorder;
  final VoidCallback onTap;

  const _ChannelItem({
    required this.channel,
    required this.nameStyle,
    required this.showBorder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: TvFocusable(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: SizedBox(
            width: 72,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ChannelAvatar(channel: channel, showBorder: showBorder),
                const SizedBox(height: 4),
                Text(
                  channel.displayName,
                  style: nameStyle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€ _AnnouncementTile â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _AnnouncementTile extends StatelessWidget {
  final Announcement announcement;

  const _AnnouncementTile({required this.announcement});

  static const _cardDecoration = BoxDecoration(
    color: Color(0xFF272727),
    borderRadius: BorderRadius.all(Radius.circular(12)),
    boxShadow: [
      BoxShadow(color: Color(0x14000000), blurRadius: 4, offset: Offset(0, 1)),
    ],
  );

  static const _titleStyle = TextStyle(
    fontFamily: GoPlayType.family,
    color: GoPlayTheme.onSurface,
    fontSize: GoPlayType.sm,
    fontWeight: FontWeight.w600,
    height: GoPlayType.leadingSnug,
  );

  static const _bodyStyle = TextStyle(
    fontFamily: GoPlayType.family,
    color: GoPlayTheme.onSurfaceVariant,
    fontSize: GoPlayType.xs,
    height: GoPlayType.leadingBody,
  );

  @override
  Widget build(BuildContext context) {
    final bool isWarning = announcement.type == 'warning';
    final iconColor = isWarning ? const Color(0xFFFFB020) : GoPlayTheme.primary;
    final iconBgColor = isWarning
        ? const Color(0xFFFFB020).withValues(alpha: 0.12)
        : GoPlayTheme.primary.withValues(alpha: 0.12);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DecoratedBox(
        decoration: _cardDecoration,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isWarning
                      ? Icons.warning_amber_rounded
                      : Icons.info_outline_rounded,
                  color: iconColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(announcement.title, style: _titleStyle),
                    const SizedBox(height: 3),
                    Text(announcement.body, style: _bodyStyle),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Skeleton Loaders ─────────────────────────────────────────────────────────

/// Placeholder row of 5 grey circles matching real channel avatar size.
class _TrendingChannelsSkeleton extends StatelessWidget {
  const _TrendingChannelsSkeleton();

  static const _circleDecoration = BoxDecoration(
    color: GoPlayTheme.surfaceContainerHigh,
    shape: BoxShape.circle,
  );

  static const _barDecoration = BoxDecoration(
    color: GoPlayTheme.surfaceContainerHigh,
    borderRadius: BorderRadius.all(Radius.circular(4)),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Padding(
              padding: EdgeInsets.all(4),
              child: SizedBox(
                width: 72,
                child: Column(
                  children: [
                    SizedBox(
                      width: 52,
                      height: 52,
                      child: DecoratedBox(decoration: _circleDecoration),
                    ),
                    SizedBox(height: 6),
                    SizedBox(
                      width: 48,
                      height: 10,
                      child: DecoratedBox(decoration: _barDecoration),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Placeholder row of 4 grey pill-shaped chips.
class _ChipsSkeleton extends StatelessWidget {
  const _ChipsSkeleton();

  static const _chipDecoration = BoxDecoration(
    color: GoPlayTheme.surfaceContainerHigh,
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          const SizedBox(width: 16),
          for (int i = 0; i < 4; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            SizedBox(
              width: i == 0 ? 42 : 70,
              height: 32,
              child: const DecoratedBox(decoration: _chipDecoration),
            ),
          ],
        ],
      ),
    );
  }
}

/// 3 grey placeholder cards matching the measured event card extent.
class _ScheduleSkeleton extends StatelessWidget {
  const _ScheduleSkeleton();

  static const _cardDecoration = BoxDecoration(
    color: GoPlayTheme.surfaceContainerHigh,
    borderRadius: BorderRadius.all(Radius.circular(12)),
  );

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList.builder(
      itemExtent: PlayZEventCard.tileExtent(context),
      itemCount: 3,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: DecoratedBox(decoration: _cardDecoration),
          ),
        );
      },
    );
  }
}
