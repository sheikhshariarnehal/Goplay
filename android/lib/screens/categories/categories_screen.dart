import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme.dart';
import '../../core/typography.dart';
import '../../models/category.dart';
import '../../models/channel.dart';
import '../../providers/app_providers.dart';
import '../../providers/playz_providers.dart';
import '../../services/channel_stream_launcher.dart';
import '../../widgets/app_overflow_menu.dart';
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
    super.dispose();
  }

  void _onCategoryTapped(Category category) {
    HapticFeedback.selectionClick();
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
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1200) return 4;
    if (width >= 720) return 3;
    return 2; // 2-columns on standard mobile
  }

  int _calculateChannelColumns(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1200) return 7;
    if (width >= 900) return 6;
    if (width >= 600) return 5;
    return 4; // 4-columns on standard mobile
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(playzCategoriesProvider);
    final favoriteIds = ref.watch(favoriteChannelIdsProvider);

    return PopScope(
      canPop: _selectedCategory == null && !_isCategorySearchOpen,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          if (_isChannelSearchOpen) {
            setState(() {
              _isChannelSearchOpen = false;
              _channelSearchController.clear();
              _channelSearchQuery = '';
            });
          } else if (_selectedCategory != null) {
            _goBackToCategories();
          } else if (_isCategorySearchOpen) {
            setState(() {
              _isCategorySearchOpen = false;
              _categorySearchController.clear();
              _categorySearchQuery = '';
            });
          }
        }
      },
      child: Scaffold(
        backgroundColor: GoPlayTheme.darkSurface,
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

              if (displayList.isEmpty) {
                return _buildEmptyState(
                  icon: Icons.category_outlined,
                  message: _categorySearchQuery.isNotEmpty
                      ? 'No categories match "$_categorySearchQuery"'
                      : 'No categories available',
                  actionLabel: _categorySearchQuery.isNotEmpty ? 'Clear Search' : 'Refresh',
                  onAction: () {
                    if (_categorySearchQuery.isNotEmpty) {
                      _categorySearchController.clear();
                    } else {
                      ref.invalidate(playzCategoriesProvider);
                    }
                  },
                );
              }

              return GridView.builder(
                controller: _categoryScrollController,
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 80),
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _calculateCategoryColumns(context),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.35,
                ),
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  final category = displayList[index];
                  return _CategoryPillCard(
                    category: category,
                    onTap: () => _onCategoryTapped(category),
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(GoPlayTheme.primary),
              ),
            ),
            error: (err, _) => _buildErrorState(
              'Failed to load categories',
              () => ref.invalidate(playzCategoriesProvider),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: const BoxDecoration(
        color: GoPlayTheme.darkSurface,
        border: Border(
          bottom: BorderSide(color: Color(0x14FFFFFF), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Left Icon / Indicator
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF18181A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0x1AFFFFFF)),
            ),
            child: const Icon(
              Icons.category_rounded,
              color: GoPlayTheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Title or In-Page Search Field
          Expanded(
            child: _isCategorySearchOpen
                ? TextField(
                    controller: _categorySearchController,
                    autofocus: true,
                    style: const TextStyle(
                      fontFamily: GoPlayType.family,
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    cursorColor: GoPlayTheme.primary,
                    decoration: InputDecoration(
                      hintText: 'Search categories...',
                      hintStyle: const TextStyle(
                        fontFamily: GoPlayType.family,
                        fontSize: 14,
                        color: Color(0x75FFFFFF),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      suffixIcon: _categorySearchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18, color: Colors.white70),
                              onPressed: () => _categorySearchController.clear(),
                            )
                          : null,
                    ),
                  )
                : const Text(
                    'Categories',
                    style: TextStyle(
                      fontFamily: GoPlayType.family,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.4,
                    ),
                  ),
          ),

          // Search Toggle Button
          IconButton(
            icon: Icon(
              _isCategorySearchOpen ? Icons.close_rounded : Icons.search_rounded,
              color: _isCategorySearchOpen ? GoPlayTheme.primary : Colors.white,
              size: 22,
            ),
            tooltip: _isCategorySearchOpen ? 'Close search' : 'Search categories',
            onPressed: _toggleCategorySearch,
          ),

          // Favorites Filter Toggle
          IconButton(
            icon: Icon(
              _filterFavoriteCategories ? Icons.star_rounded : Icons.star_outline_rounded,
              color: _filterFavoriteCategories ? GoPlayTheme.primary : Colors.white,
              size: 24,
            ),
            tooltip: _filterFavoriteCategories ? 'Show all categories' : 'Filter favorites',
            onPressed: _toggleCategoryFavoritesFilter,
          ),

          // 3-Dots Action Sheet
          const AppOverflowMenu(iconColor: Colors.white),
        ],
      ),
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

              return GridView.builder(
                controller: _channelScrollController,
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 80),
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _calculateChannelColumns(context),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.82,
                ),
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  final ch = displayList[index];
                  final isFav = favoriteIds.contains(ch.id);
                  return _ChannelGridCard(
                    channel: ch,
                    isFavorite: isFav,
                    scope: displayList,
                    onToggleFavorite: () {
                      HapticFeedback.selectionClick();
                      ref.read(favoriteChannelIdsProvider.notifier).toggle(ch.id);
                    },
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(GoPlayTheme.primary),
              ),
            ),
            error: (err, _) => _buildErrorState(
              'Failed to load channels for ${category.name}',
              () => ref.invalidate(playzCategoryChannelsProvider(category)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChannelsAppBar(BuildContext context, Category category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        color: GoPlayTheme.darkSurface,
        border: Border(
          bottom: BorderSide(color: Color(0x14FFFFFF), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
            tooltip: 'Back to Categories',
            onPressed: _goBackToCategories,
          ),

          // Title or In-Page Search Field
          Expanded(
            child: _isChannelSearchOpen
                ? TextField(
                    controller: _channelSearchController,
                    autofocus: true,
                    style: const TextStyle(
                      fontFamily: GoPlayType.family,
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    cursorColor: GoPlayTheme.primary,
                    decoration: InputDecoration(
                      hintText: 'Search in ${category.name}...',
                      hintStyle: const TextStyle(
                        fontFamily: GoPlayType.family,
                        fontSize: 14,
                        color: Color(0x75FFFFFF),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      suffixIcon: _channelSearchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18, color: Colors.white70),
                              onPressed: () => _channelSearchController.clear(),
                            )
                          : null,
                    ),
                  )
                : Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: GoPlayType.family,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.4,
                    ),
                  ),
          ),

          // Search Toggle Button
          IconButton(
            icon: Icon(
              _isChannelSearchOpen ? Icons.close_rounded : Icons.search_rounded,
              color: _isChannelSearchOpen ? GoPlayTheme.primary : Colors.white,
              size: 22,
            ),
            tooltip: _isChannelSearchOpen ? 'Close search' : 'Search channels',
            onPressed: _toggleChannelSearch,
          ),

          // Star Favorites Filter Toggle
          IconButton(
            icon: Icon(
              _filterFavoriteChannels ? Icons.star_rounded : Icons.star_outline_rounded,
              color: _filterFavoriteChannels ? GoPlayTheme.primary : Colors.white,
              size: 24,
            ),
            tooltip: _filterFavoriteChannels ? 'Show all channels' : 'Show favorites only',
            onPressed: _toggleChannelFavoritesFilter,
          ),

          // 3-Dots Action Sheet
          const AppOverflowMenu(iconColor: Colors.white),
        ],
      ),
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
//    PILL CATEGORY CARD (2-COLUMN GRID)
// ==========================================
class _CategoryPillCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const _CategoryPillCard({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TvFocusable(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      focusedScale: 1.03,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF16171A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0x1EFFFFFF),
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            // Circular Emblem Avatar on left
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF222428),
                border: Border.all(
                  color: const Color(0x28FFFFFF),
                  width: 1.2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: category.iconUrl != null && category.iconUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: category.iconUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => _buildFallbackIcon(),
                    )
                  : _buildFallbackIcon(),
            ),
            const SizedBox(width: 10),

            // Category Title on right
            Expanded(
              child: Text(
                category.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: GoPlayType.family,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return const Center(
      child: Icon(
        Icons.tv_rounded,
        size: 20,
        color: Color(0x88FFFFFF),
      ),
    );
  }
}

// ==========================================
//    4-COLUMN CHANNEL CARD (CHANNELS GRID)
// ==========================================
class _ChannelGridCard extends StatelessWidget {
  final Channel channel;
  final bool isFavorite;
  final List<Channel> scope;
  final VoidCallback onToggleFavorite;

  const _ChannelGridCard({
    required this.channel,
    required this.isFavorite,
    required this.scope,
    required this.onToggleFavorite,
  });

  void _open(BuildContext context) {
    HapticFeedback.selectionClick();
    ChannelStreamLauncher.launch(context, channel, scope: scope);
  }

  @override
  Widget build(BuildContext context) {
    return TvFocusable(
      onTap: () => _open(context),
      onLongPress: onToggleFavorite,
      borderRadius: BorderRadius.circular(12),
      focusedScale: 1.05,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF16171A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0x1CFFFFFF),
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Channel content: Logo plate + Name
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Circular Logo Plate
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF222428),
                    border: Border.all(
                      color: const Color(0x28FFFFFF),
                      width: 1.2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: channel.logo != null && channel.logo!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: channel.logo!,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => _buildFallbackLogo(),
                        )
                      : _buildFallbackLogo(),
                ),
                const SizedBox(height: 7),

                // Channel Name (max 2 lines, centered)
                Text(
                  channel.displayName,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: GoPlayType.family,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEDEDED),
                    height: 1.15,
                  ),
                ),
              ],
            ),

            // Star indicator for favorites (top right)
            if (isFavorite)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Color(0x33C8FF00),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    size: 13,
                    color: GoPlayTheme.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackLogo() {
    return Center(
      child: Text(
        channel.initials,
        style: const TextStyle(
          fontFamily: GoPlayType.family,
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Color(0xAAFFFFFF),
        ),
      ),
    );
  }
}
