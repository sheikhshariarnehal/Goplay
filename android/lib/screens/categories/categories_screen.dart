import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme.dart';
import '../../core/typography.dart';
import '../../models/category.dart';
import '../../providers/app_providers.dart';
import '../../providers/playz_providers.dart';
import '../../widgets/app_overflow_menu.dart';
import '../../widgets/cards/channel_card.dart';
import '../../widgets/tv_focus_wrapper.dart';

/// Categories Screen matching the reference UI with GoPlay's dark theme & volt styling.
///
/// Features:
/// - Screen 1: 2-column Category list with circular emblems, bold typography, and volt hover glow.
/// - Screen 2: 4-column Channel grid per category with circular logos, 2-line titles, and star favorites.
/// - In-page search toggle for both Categories and Channels.
/// - Star toggle to filter favorite categories / channels.
/// - Smooth animated transitions between list and grid.
/// - Full D-Pad Android TV support via [TvFocusable].
/// - Handles Android back navigation seamlessly via [PopScope].
class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  // Navigation & selection
  Category? _selectedCategory;
  String? _lastSelectedCategoryId;
  final Map<String, FocusNode> _categoryFocusNodes = {};

  FocusNode _getFocusNodeForCategory(String id) {
    return _categoryFocusNodes.putIfAbsent(id, () => FocusNode(debugLabel: 'Cat_$id'));
  }

  // Search states
  bool _isCategorySearchOpen = false;
  final TextEditingController _categorySearchController = TextEditingController();
  String _categorySearchQuery = '';

  bool _isChannelSearchOpen = false;
  final TextEditingController _channelSearchController = TextEditingController();
  String _channelSearchQuery = '';

  // Favorite filter states
  bool _filterFavoriteCategories = false;
  bool _filterFavoriteChannels = false;

  final ScrollController _categoryScrollController = ScrollController();
  final ScrollController _channelScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _categorySearchController.addListener(() {
      final q = _categorySearchController.text.trim().toLowerCase();
      if (q != _categorySearchQuery) {
        setState(() => _categorySearchQuery = q);
      }
    });

    _channelSearchController.addListener(() {
      final q = _channelSearchController.text.trim().toLowerCase();
      if (q != _channelSearchQuery) {
        setState(() => _channelSearchQuery = q);
      }
    });
  }

  @override
  void dispose() {
    _categorySearchController.dispose();
    _channelSearchController.dispose();
    _categoryScrollController.dispose();
    _channelScrollController.dispose();
    for (final fn in _categoryFocusNodes.values) {
      fn.dispose();
    }
    _categoryFocusNodes.clear();
    super.dispose();
  }

  void _onCategoryTapped(Category category) {
    HapticFeedback.selectionClick();
    _lastSelectedCategoryId = category.id;
    setState(() {
      _selectedCategory = category;
      _isChannelSearchOpen = false;
      _channelSearchController.clear();
      _channelSearchQuery = '';
      _filterFavoriteChannels = false;
    });
    ref.read(playzSelectedCategoryProvider.notifier).select(category);
  }

  void _goBackToCategories() {
    HapticFeedback.lightImpact();
    setState(() {
      if (_isChannelSearchOpen) {
        _isChannelSearchOpen = false;
        _channelSearchController.clear();
        _channelSearchQuery = '';
      }
      _selectedCategory = null;
    });
    ref.read(playzSelectedCategoryProvider.notifier).select(null);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _lastSelectedCategoryId != null) {
        _categoryFocusNodes[_lastSelectedCategoryId]?.requestFocus();
      }
    });
  }

  void _toggleCategorySearch() {
    HapticFeedback.lightImpact();
    setState(() {
      _isCategorySearchOpen = !_isCategorySearchOpen;
      if (!_isCategorySearchOpen) {
        _categorySearchController.clear();
        _categorySearchQuery = '';
      }
    });
  }

  void _toggleChannelSearch() {
    HapticFeedback.lightImpact();
    setState(() {
      _isChannelSearchOpen = !_isChannelSearchOpen;
      if (!_isChannelSearchOpen) {
        _channelSearchController.clear();
        _channelSearchQuery = '';
      }
    });
  }

  void _toggleCategoryFavoritesFilter() {
    HapticFeedback.lightImpact();
    setState(() {
      _filterFavoriteCategories = !_filterFavoriteCategories;
    });
  }

  void _toggleChannelFavoritesFilter() {
    HapticFeedback.lightImpact();
    setState(() {
      _filterFavoriteChannels = !_filterFavoriteChannels;
    });
  }

  int _calculateCategoryColumns(BuildContext context) {
    final configured = ref.watch(uiConfigProvider).categoriesScreen.categoryGridColumns;
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1200) return math.max(4, configured);
    if (width >= 720) return math.max(3, configured);
    return (configured >= 1 && configured <= 4) ? configured : 2;
  }

  double _calculateCategoryAspectRatio(int columns) {
    if (columns >= 4) return 2.85;
    if (columns == 3) return 2.75;
    return 2.65; // Mobile 2-column cards: compact 66dp height
  }

  static const double _kGridSpacing = 8.0;
  static const double _kGridEdgeInset = 12.0;

  SliverGridDelegateWithFixedCrossAxisCount _buildChannelGridDelegate(
    BuildContext context,
    double crossAxisExtent,
  ) {
    final int cols;
    if (crossAxisExtent >= 1180) {
      cols = 6;
    } else if (crossAxisExtent >= 880) {
      cols = 5;
    } else if (crossAxisExtent >= 580) {
      cols = 4;
    } else {
      cols = 3;
    }

    final tileWidth = (crossAxisExtent - _kGridSpacing * (cols - 1)) / cols;
    final tileHeight = math.max(tileWidth, ChannelCard.measureHeight(context));

    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: cols,
      childAspectRatio: tileWidth <= 0 ? 1.0 : tileWidth / tileHeight,
      crossAxisSpacing: _kGridSpacing,
      mainAxisSpacing: _kGridSpacing,
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(playzCategoriesProvider);
    final favoriteIds = ref.watch(favoriteChannelIdsProvider);

    return PopScope(
      canPop: _selectedCategory == null &&
          !_isCategorySearchOpen &&
          !_filterFavoriteCategories,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          if (_isChannelSearchOpen) {
            _toggleChannelSearch();
          } else if (_filterFavoriteChannels) {
            _toggleChannelFavoritesFilter();
          } else if (_selectedCategory != null) {
            _goBackToCategories();
          } else if (_isCategorySearchOpen) {
            _toggleCategorySearch();
          } else if (_filterFavoriteCategories) {
            _toggleCategoryFavoritesFilter();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          bottom: false,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.04, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _selectedCategory == null
                ? _buildCategoriesPage(context, categoriesAsync, favoriteIds)
                : _buildChannelsPage(context, _selectedCategory!, favoriteIds),
          ),
        ),
      ),
    );
  }

  // ==========================================
  //         SCREEN 1: CATEGORIES LIST
  // ==========================================
  Widget _buildCategoriesPage(
    BuildContext context,
    AsyncValue<List<Category>> categoriesAsync,
    Set<String> favoriteIds,
  ) {
    final channelsByCategoryAsync = ref.watch(channelsByCategoryMapProvider);
    final channelsMap = channelsByCategoryAsync.value;

    return Column(
      key: const ValueKey('categories_list_view'),
      children: [
        _buildCategoriesAppBar(context),
        Expanded(
          child: categoriesAsync.when(
            data: (categories) {
              var displayList = categories;

              // Text search filter
              if (_categorySearchQuery.isNotEmpty) {
                displayList = displayList
                    .where((c) => c.name.toLowerCase().contains(_categorySearchQuery))
                    .toList();
              }

              // Favorites category filter
              if (_filterFavoriteCategories) {
                displayList = displayList.where((c) {
                  final channels = channelsMap?[c.id] ??
                      channelsMap?[c.name] ??
                      channelsMap?[c.id.toLowerCase()];
                  return channels != null &&
                      channels.any((ch) => favoriteIds.contains(ch.id));
                }).toList();
              }

              if (displayList.isEmpty) {
                final isFav = _filterFavoriteCategories;
                final isSearch = _categorySearchQuery.isNotEmpty;
                return _buildEmptyState(
                  icon: isFav ? Icons.star_border_rounded : Icons.category_outlined,
                  message: isSearch
                      ? 'No categories match "$_categorySearchQuery"'
                      : isFav
                          ? 'No categories contain favorite channels'
                          : 'No categories available',
                  actionLabel: isSearch
                      ? 'Clear Search'
                      : isFav
                          ? 'Show All Categories'
                          : 'Refresh',
                  onAction: () {
                    if (isSearch) {
                      _categorySearchController.clear();
                    } else if (isFav) {
                      setState(() => _filterFavoriteCategories = false);
                    } else {
                      ref.invalidate(playzCategoriesProvider);
                    }
                  },
                );
              }

              final columns = _calculateCategoryColumns(context);
              return GridView.builder(
                key: const PageStorageKey('categories_grid_page_storage'),
                controller: _categoryScrollController,
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 88),
                cacheExtent: 500.0,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: _calculateCategoryAspectRatio(columns),
                ),
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  final category = displayList[index];
                  final count = channelsMap?[category.id]?.length ??
                      channelsMap?[category.name]?.length ??
                      channelsMap?[category.id.toLowerCase()]?.length;
                  return _CategoryPillCard(
                    category: category,
                    channelCount: count,
                    focusNode: _getFocusNodeForCategory(category.id),
                    onTap: () => _onCategoryTapped(category),
                  );
                },
              );
            },
            loading: () => _buildCategoriesSkeleton(context),
            error: (err, _) => _buildErrorState(
              'Failed to load categories',
              () => ref.invalidate(playzCategoriesProvider),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSkeleton(BuildContext context) {
    final columns = _calculateCategoryColumns(context);
    final cs = Theme.of(context).colorScheme;
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 88),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: _calculateCategoryAspectRatio(columns),
      ),
      itemCount: columns * 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF202226),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 70,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF222428),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 45,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D1F23),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoriesAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return AppBar(
      primary: false,
      automaticallyImplyLeading: false,
      backgroundColor: cs.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: kToolbarHeight,
      titleSpacing: (_filterFavoriteCategories || _isCategorySearchOpen) ? 0 : 16,
      leading: _isCategorySearchOpen
          ? IconButton(
              tooltip: 'Close search',
              icon: Icon(Icons.arrow_back_rounded, color: cs.onSurface, size: 24),
              onPressed: _toggleCategorySearch,
            )
          : _filterFavoriteCategories
              ? IconButton(
                  tooltip: 'Show all categories',
                  icon: Icon(Icons.arrow_back_rounded, color: cs.onSurface, size: 24),
                  onPressed: _toggleCategoryFavoritesFilter,
                )
              : null,
      title: _isCategorySearchOpen
          ? _SearchField(
              controller: _categorySearchController,
              hintText: 'Search categories...',
              onClear: () {
                if (_categorySearchController.text.isEmpty) {
                  _toggleCategorySearch();
                } else {
                  _categorySearchController.clear();
                }
              },
            )
          : Text(
              _filterFavoriteCategories ? 'Favorites' : 'Categories',
              style: theme.appBarTheme.titleTextStyle,
            ),
      actions: _isCategorySearchOpen
          ? null
          : [
              if (ref.watch(uiConfigProvider).categoriesScreen.showCategorySearch)
                IconButton(
                  tooltip: 'Search categories',
                  icon: Icon(Icons.search_rounded, color: cs.onSurface, size: 22),
                  onPressed: _toggleCategorySearch,
                ),
              if (ref.watch(uiConfigProvider).categoriesScreen.showCategoryFavorites)
                IconButton(
                  tooltip: _filterFavoriteCategories ? 'Show all categories' : 'Filter favorites',
                  icon: Icon(
                    _filterFavoriteCategories ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: _filterFavoriteCategories ? cs.primary : cs.onSurface,
                    size: 24,
                  ),
                  onPressed: _toggleCategoryFavoritesFilter,
                ),
              const AppOverflowMenu(iconColor: Colors.white),
              const SizedBox(width: 8),
            ],
    );
  }

  // ==========================================
  //         SCREEN 2: CHANNELS GRID
  // ==========================================
  Widget _buildChannelsPage(
    BuildContext context,
    Category category,
    Set<String> favoriteIds,
  ) {
    final channelsAsync = ref.watch(playzCategoryChannelsProvider(category));

    return Column(
      key: ValueKey('category_channels_${category.id}'),
      children: [
        _buildChannelsAppBar(context, category),
        Expanded(
          child: channelsAsync.when(
            data: (channels) {
              var displayList = channels;

              // Search query filter
              if (_channelSearchQuery.isNotEmpty) {
                displayList = displayList
                    .where((c) => c.name.toLowerCase().contains(_channelSearchQuery))
                    .toList();
              }

              // Star Favorites filter
              if (_filterFavoriteChannels) {
                displayList = displayList
                    .where((c) => favoriteIds.contains(c.id))
                    .toList();
              }

              if (displayList.isEmpty) {
                return _buildEmptyState(
                  icon: _filterFavoriteChannels ? Icons.star_border_rounded : Icons.tv_off_rounded,
                  message: _channelSearchQuery.isNotEmpty
                      ? 'No channels match "$_channelSearchQuery"'
                      : _filterFavoriteChannels
                          ? 'No favorite channels in ${category.name}'
                          : 'No channels available in ${category.name}',
                  actionLabel: _channelSearchQuery.isNotEmpty
                      ? 'Clear Search'
                      : _filterFavoriteChannels
                          ? 'Show All'
                          : 'Retry',
                  onAction: () {
                    if (_channelSearchQuery.isNotEmpty) {
                      _channelSearchController.clear();
                    } else if (_filterFavoriteChannels) {
                      setState(() => _filterFavoriteChannels = false);
                    } else {
                      ref.invalidate(playzCategoryChannelsProvider(category));
                    }
                  },
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth - (_kGridEdgeInset * 2);
                  final gridDelegate = _buildChannelGridDelegate(context, availableWidth);

                  return GridView.builder(
                    key: PageStorageKey('category_channels_${category.id}'),
                    controller: _channelScrollController,
                    padding: const EdgeInsets.fromLTRB(_kGridEdgeInset, 8, _kGridEdgeInset, 88),
                    cacheExtent: 500.0,
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    gridDelegate: gridDelegate,
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      final ch = displayList[index];
                      return RepaintBoundary(
                        child: ChannelCard(
                          key: ValueKey(ch.id),
                          channel: ch,
                          scope: displayList,
                        ),
                      );
                    },
                  );
                },
              );
            },
            loading: () => _buildChannelsSkeleton(context),
            error: (err, _) => _buildErrorState(
              'Failed to load channels for ${category.name}',
              () => ref.invalidate(playzCategoryChannelsProvider(category)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChannelsSkeleton(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth - (_kGridEdgeInset * 2);
        final gridDelegate = _buildChannelGridDelegate(context, availableWidth);

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(_kGridEdgeInset, 8, _kGridEdgeInset, 88),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: gridDelegate,
          itemCount: 12,
          itemBuilder: (context, index) => const _ChannelShimmerCard(),
        );
      },
    );
  }

  Widget _buildChannelsAppBar(BuildContext context, Category category) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return AppBar(
      primary: false,
      automaticallyImplyLeading: false,
      backgroundColor: cs.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: kToolbarHeight,
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: cs.onSurface, size: 24),
        tooltip: _isChannelSearchOpen
            ? 'Close search'
            : _filterFavoriteChannels
                ? 'Show all channels'
                : 'Back to Categories',
        onPressed: () {
          if (_isChannelSearchOpen) {
            _toggleChannelSearch();
          } else if (_filterFavoriteChannels) {
            _toggleChannelFavoritesFilter();
          } else {
            _goBackToCategories();
          }
        },
      ),
      title: _isChannelSearchOpen
          ? _SearchField(
              controller: _channelSearchController,
              hintText: 'Search in ${category.name}...',
              onClear: () {
                if (_channelSearchController.text.isEmpty) {
                  _toggleChannelSearch();
                } else {
                  _channelSearchController.clear();
                }
              },
            )
          : Text(
              _filterFavoriteChannels ? 'Favorites • ${category.name}' : category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.appBarTheme.titleTextStyle,
            ),
      actions: _isChannelSearchOpen
          ? null
          : [
              IconButton(
                tooltip: 'Search channels',
                icon: Icon(Icons.search_rounded, color: cs.onSurface, size: 22),
                onPressed: _toggleChannelSearch,
              ),
              IconButton(
                tooltip: _filterFavoriteChannels ? 'Show all channels' : 'Filter favorites',
                icon: Icon(
                  _filterFavoriteChannels ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: _filterFavoriteChannels ? GoPlayTheme.primary : cs.onSurface,
                  size: 24,
                ),
                onPressed: _toggleChannelFavoritesFilter,
              ),
              const AppOverflowMenu(iconColor: Colors.white),
              const SizedBox(width: 8),
            ],
    );
  }

  // ==========================================
  //             HELPER WIDGETS
  // ==========================================
  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1C),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x1AFFFFFF)),
              ),
              child: Icon(icon, size: 36, color: GoPlayTheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: GoPlayType.family,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xAAFFFFFF),
              ),
            ),
            const SizedBox(height: 14),
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: GoPlayTheme.primary,
                backgroundColor: const Color(0xFF222416),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                actionLabel,
                style: const TextStyle(
                  fontFamily: GoPlayType.family,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 40, color: GoPlayTheme.error),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: GoPlayType.family,
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: GoPlayTheme.primary,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(fontFamily: GoPlayType.family, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
//           SEARCH FIELD COMPONENT
// ==========================================
class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.hintText,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const radius = BorderRadius.all(Radius.circular(100));

    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        autofocus: true,
        textInputAction: TextInputAction.search,
        cursorColor: cs.primary,
        style: GoPlayType.body.copyWith(color: cs.onSurface),
        decoration: InputDecoration(
          filled: true,
          fillColor: cs.surfaceContainerHigh,
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          hintText: hintText,
          hintStyle: GoPlayType.body.copyWith(color: cs.onSurfaceVariant),
          isDense: true,
          border: const OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: radius,
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.search_rounded, color: cs.onSurfaceVariant, size: 20),
          suffixIcon: IconButton(
            tooltip: 'Clear search',
            icon: Icon(Icons.close_rounded, color: cs.onSurfaceVariant, size: 18),
            onPressed: onClear,
          ),
        ),
      ),
    );
  }
}

// ==========================================
//    PILL CATEGORY CARD (2-COLUMN GRID)
// ==========================================
class _CategoryPillCard extends ConsumerWidget {
  final Category category;
  final int? channelCount;
  final VoidCallback onTap;
  final FocusNode? focusNode;

  const _CategoryPillCard({
    required this.category,
    this.channelCount,
    required this.onTap,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catConfig = ref.watch(uiConfigProvider).categoriesScreen;
    final visuals = CategoryVisuals.resolve(category);
    final count = channelCount;
    final countText = (count != null && count > 0)
        ? '$count ${count == 1 ? 'channel' : 'channels'}'
        : null;

    final cs = Theme.of(context).colorScheme;

    return TvFocusable(
      focusNode: focusNode,
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      focusedScale: 1.03,
      semanticLabel: countText != null
          ? '${category.name}, $countText'
          : category.name,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            // Avatar plate (40x40)
            if (catConfig.showCategoryEmblems) ...[
              RepaintBoundary(
                child: _buildAvatar(visuals),
              ),
              const SizedBox(width: 10),
            ],

            // Category Name and Channel Count
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: GoPlayType.family,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFF1F1F1),
                      letterSpacing: -0.2,
                      height: 1.2,
                    ),
                  ),
                  if (catConfig.showCategoryChannelCounts && countText != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      countText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: GoPlayType.family,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0x8AFFFFFF),
                        letterSpacing: -0.1,
                        height: 1.1,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 4),

            // Subtle chevron indicator
            const Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: Color(0x2EFFFFFF),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(CategoryVisuals visuals) {
    final hasIconUrl = category.iconUrl != null && category.iconUrl!.isNotEmpty;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: visuals.gradientColors,
        ),
        border: Border.all(
          color: const Color(0x24FFFFFF),
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x28000000),
            blurRadius: 4,
            offset: Offset(0, 1.5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: hasIconUrl
          ? CachedNetworkImage(
              imageUrl: category.iconUrl!,
              fit: BoxFit.cover,
              memCacheWidth: 80,
              memCacheHeight: 80,
              fadeInDuration: const Duration(milliseconds: 150),
              placeholder: (context, url) => _buildFallbackVisual(visuals),
              errorWidget: (context, url, error) => _buildFallbackVisual(visuals),
            )
          : _buildFallbackVisual(visuals),
    );
  }

  Widget _buildFallbackVisual(CategoryVisuals visuals) {
    if (visuals.isBangladesh) {
      return Center(
        child: Container(
          width: 17,
          height: 17,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFF42A41),
          ),
        ),
      );
    }

    return Center(
      child: Icon(
        visuals.icon,
        size: 19,
        color: visuals.accentColor,
      ),
    );
  }
}

// ==========================================
//    CATEGORY VISUALS RESOLVER
// ==========================================
class CategoryVisuals {
  final IconData icon;
  final List<Color> gradientColors;
  final Color accentColor;
  final bool isBangladesh;

  const CategoryVisuals({
    required this.icon,
    required this.gradientColors,
    required this.accentColor,
    this.isBangladesh = false,
  });

  static CategoryVisuals resolve(Category category) {
    final key = '${category.id} ${category.name}'.toLowerCase();

    if (key.contains('bangla') || key.contains('bangladesh') || key.contains('bd')) {
      return const CategoryVisuals(
        icon: Icons.flag_rounded,
        gradientColors: [Color(0xFF006A4E), Color(0xFF004D38)],
        accentColor: Color(0xFFF42A41),
        isBangladesh: true,
      );
    }
    if (key.contains('kids') || key.contains('cartoon') || key.contains('child') || key.contains('animation')) {
      return const CategoryVisuals(
        icon: Icons.child_care_rounded,
        gradientColors: [Color(0xFFE65100), Color(0xFFFF6D00)],
        accentColor: Color(0xFFFFD54F),
      );
    }
    if (key.contains('kolkata') || key.contains('calcutta')) {
      return const CategoryVisuals(
        icon: Icons.theater_comedy_rounded,
        gradientColors: [Color(0xFFBF360C), Color(0xFFD84315)],
        accentColor: Color(0xFFFF8A65),
      );
    }
    if (key.contains('sports') || key.contains('sport') || key.contains('cricket') || key.contains('football')) {
      return const CategoryVisuals(
        icon: Icons.sports_soccer_rounded,
        gradientColors: [Color(0xFF1B5E20), Color(0xFF00796B)],
        accentColor: GoPlayTheme.primary,
      );
    }
    if (key.contains('hindi') || key.contains('bollywood')) {
      return const CategoryVisuals(
        icon: Icons.movie_filter_rounded,
        gradientColors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
        accentColor: Color(0xFFFFB300),
      );
    }
    if (key.contains('doc') || key.contains('nature') || key.contains('earth') || key.contains('discovery') || key.contains('geo')) {
      return const CategoryVisuals(
        icon: Icons.public_rounded,
        gradientColors: [Color(0xFF004D40), Color(0xFF00838F)],
        accentColor: Color(0xFF4DD0E1),
      );
    }
    if (key.contains('islam') || key.contains('quran') || key.contains('deen') || key.contains('makkah')) {
      return const CategoryVisuals(
        icon: Icons.brightness_3_rounded,
        gradientColors: [Color(0xFF004D40), Color(0xFF00695C)],
        accentColor: Color(0xFFFFD54F),
      );
    }
    if (key.contains('music') || key.contains('song') || key.contains('audio')) {
      return const CategoryVisuals(
        icon: Icons.music_note_rounded,
        gradientColors: [Color(0xFF880E4F), Color(0xFFC2185B)],
        accentColor: Color(0xFFFF4081),
      );
    }
    if (key.contains('news') || key.contains('khobor') || key.contains('headline')) {
      return const CategoryVisuals(
        icon: Icons.newspaper_rounded,
        gradientColors: [Color(0xFF8E0000), Color(0xFFC62828)],
        accentColor: Color(0xFFFF5252),
      );
    }
    if (key.contains('movie') || key.contains('cinema') || key.contains('film')) {
      return const CategoryVisuals(
        icon: Icons.movie_creation_rounded,
        gradientColors: [Color(0xFFBF360C), Color(0xFFE65100)],
        accentColor: Color(0xFFFFB74D),
      );
    }
    if (key.contains('entertainment') || key.contains('natok') || key.contains('drama')) {
      return const CategoryVisuals(
        icon: Icons.auto_awesome_rounded,
        gradientColors: [Color(0xFF311B92), Color(0xFF512DA8)],
        accentColor: Color(0xFFB388FF),
      );
    }
    if (key.contains('info')) {
      return const CategoryVisuals(
        icon: Icons.lightbulb_rounded,
        gradientColors: [Color(0xFF01579B), Color(0xFF0277BD)],
        accentColor: Color(0xFF40C4FF),
      );
    }
    if (key.contains('radio')) {
      return const CategoryVisuals(
        icon: Icons.radio_rounded,
        gradientColors: [Color(0xFFE64A19), Color(0xFFF57C00)],
        accentColor: Color(0xFFFFAB40),
      );
    }
    if (key.contains('indian') || key.contains('india')) {
      return const CategoryVisuals(
        icon: Icons.live_tv_rounded,
        gradientColors: [Color(0xFFE65100), Color(0xFF1B5E20)],
        accentColor: Color(0xFFFF9933),
      );
    }
    if (key.contains('pakistan') || key.contains('pk')) {
      return const CategoryVisuals(
        icon: Icons.star_rounded,
        gradientColors: [Color(0xFF002811), Color(0xFF01411C)],
        accentColor: Colors.white,
      );
    }
    if (key.contains('nepal')) {
      return const CategoryVisuals(
        icon: Icons.landscape_rounded,
        gradientColors: [Color(0xFF003893), Color(0xFFDC143C)],
        accentColor: Colors.white,
      );
    }
    if (key.contains('ayna') || key.contains('ott') || key.contains('tvlink') || key.contains('iptv')) {
      return const CategoryVisuals(
        icon: Icons.stream_rounded,
        gradientColors: [Color(0xFF192227), Color(0xFF263238)],
        accentColor: GoPlayTheme.primary,
      );
    }

    return const CategoryVisuals(
      icon: Icons.category_rounded,
      gradientColors: [Color(0xFF181A1E), Color(0xFF23252B)],
      accentColor: GoPlayTheme.primary,
    );
  }
}

// ==========================================
//    CHANNEL SHIMMER LOADING SKELETON
// ==========================================
class _ChannelShimmerCard extends StatelessWidget {
  const _ChannelShimmerCard();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: SizedBox(
          width: 54,
          height: 54,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: cs.onSurface.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
