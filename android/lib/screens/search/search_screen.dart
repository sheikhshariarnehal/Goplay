import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme.dart';
import '../../core/typography.dart';
import '../../providers/app_providers.dart';
import '../../models/channel.dart';
import '../../models/event.dart';
import '../../services/event_stream_launcher.dart';
import '../../widgets/cards/playz_event_card.dart';

/// Opens [ch] in the player scoped to [scope] — the list the user tapped it in.
void _openPlayer(BuildContext context, Channel ch, List<Channel> scope) {
  if (scope.length < 2) {
    context.push('/player/${ch.id}');
    return;
  }
  context.push(
    '/player/${ch.id}',
    extra: {'eventChannels': scope.map((c) => c.id).toList(growable: false)},
  );
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
  bool _showCloseButton = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    final showClose = _controller.text.isNotEmpty;
    if (showClose != _showCloseButton) {
      setState(() {
        _showCloseButton = showClose;
      });
    }
  }

  void _setQuery(String queryText) {
    _debounce?.cancel();
    setState(() {
      _query = queryText;
      _controller.text = queryText;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: queryText.length),
      );
    });
  }

  void _clearSearch() {
    _controller.clear();
    _debounce?.cancel();
    setState(() {
      _query = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final channelsAsync = ref.watch(channelsProvider);

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            // YouTube-style sleek search bar
            Container(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 12),
              decoration: BoxDecoration(
                color: cs.surface,
                border: const Border(
                  bottom: BorderSide(
                    color: Color(0x1AFFFFFF),
                    width: 0.8,
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: GoPlayTheme.onSurface,
                      size: 24,
                    ),
                    tooltip: 'Back',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: GoPlayTheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        cursorColor: GoPlayTheme.primary,
                        style: GoPlayType.body.copyWith(
                          color: GoPlayTheme.onSurface,
                          fontSize: 15,
                        ),
                        onChanged: (value) {
                          if (_debounce?.isActive ?? false) _debounce!.cancel();
                          _debounce = Timer(const Duration(milliseconds: 200), () {
                            setState(() {
                              _query = value.trim();
                            });
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search channels, matches, sports...',
                          hintStyle: GoPlayType.body.copyWith(
                            color: GoPlayTheme.onSurfaceVariant,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 11,
                            horizontal: 16,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: GoPlayTheme.onSurfaceVariant,
                            size: 20,
                          ),
                          suffixIcon: _showCloseButton
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: GoPlayTheme.onSurfaceVariant,
                                    size: 20,
                                  ),
                                  onPressed: _clearSearch,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content: Empty State (Discovery) or Live Search Results
            Expanded(
              child: _query.isEmpty
                  ? _EmptySearchState(
                      channelsAsync: channelsAsync,
                      onTagSelect: _setQuery,
                    )
                  : _SearchResults(
                      query: _query,
                      onClear: _clearSearch,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Discovery State (Empty Query) ───────────────────────────
class _EmptySearchState extends ConsumerWidget {
  final AsyncValue<List<Channel>> channelsAsync;
  final ValueChanged<String> onTagSelect;

  const _EmptySearchState({
    required this.channelsAsync,
    required this.onTagSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiConfig = ref.watch(uiConfigProvider);
    final popularTags = uiConfig.searchConfig.popularTags;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      physics: const BouncingScrollPhysics(),
      children: [
        if (popularTags.isNotEmpty) ...[
          // Section 1: Popular Searches
          Text(
            'Popular Searches',
            style: GoPlayType.sectionTitle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: GoPlayTheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: popularTags.map((tag) {
              return InkWell(
                onTap: () => onTagSelect(tag.query),
                borderRadius: BorderRadius.circular(8),
                child: Ink(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: GoPlayTheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0x14FFFFFF),
                      width: 0.6,
                    ),
                  ),
                  child: Text(
                    tag.label,
                    style: GoPlayType.label.copyWith(
                      color: GoPlayTheme.onSurface,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
        ],

        // Section 2: Recommended Channels
        Text(
          'Recommended Channels',
          style: GoPlayType.sectionTitle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: GoPlayTheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 14),
        channelsAsync.when(
          data: (channels) {
            final liveList = channels.where((ch) => ch.isLive).take(6).toList();
            final displayList = liveList.isNotEmpty ? liveList : channels.take(6).toList();

            if (displayList.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'No channels available right now.',
                  style: GoPlayType.body.copyWith(
                    color: GoPlayTheme.onSurfaceVariant,
                  ),
                ),
              );
            }

            return Column(
              children: displayList
                  .map((ch) => _buildChannelTile(context, ch, scope: displayList))
                  .toList(),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(
                color: GoPlayTheme.primary,
                strokeWidth: 2.5,
              ),
            ),
          ),
          error: (err, stack) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildChannelTile(
    BuildContext context,
    Channel ch, {
    required List<Channel> scope,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: GoPlayTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0x14FFFFFF),
          width: 0.6,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openPlayer(context, ch, scope),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _ChannelAvatar(ch: ch),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ch.displayName,
                        style: GoPlayType.label.copyWith(
                          color: GoPlayTheme.onSurface,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${ch.category ?? 'General'} • ${ch.country ?? 'Global'}',
                        style: GoPlayType.bodySmall.copyWith(
                          color: GoPlayTheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (ch.isLive) const _LiveBadge(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Search Results Page ──────────────────────────────────────
const int _kPageSize = 40;

class _SearchResults extends ConsumerStatefulWidget {
  final String query;
  final VoidCallback onClear;

  const _SearchResults({
    required this.query,
    required this.onClear,
  });

  @override
  ConsumerState<_SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends ConsumerState<_SearchResults> {
  int _channelLimit = _kPageSize;
  int _eventLimit = _kPageSize;

  @override
  void didUpdateWidget(_SearchResults old) {
    super.didUpdateWidget(old);
    if (old.query != widget.query) {
      _channelLimit = _kPageSize;
      _eventLimit = _kPageSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    final channelsAsync = ref.watch(filteredChannelsProvider(widget.query));
    final eventsAsync = ref.watch(filteredEventsProvider(widget.query));

    if (channelsAsync.isLoading || eventsAsync.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: GoPlayTheme.primary,
          strokeWidth: 2.5,
        ),
      );
    }

    if (channelsAsync.hasError || eventsAsync.hasError) {
      return Center(
        child: Text(
          'An error occurred while searching.',
          textAlign: TextAlign.center,
          style: GoPlayType.body.copyWith(color: GoPlayTheme.error),
        ),
      );
    }

    final allChannels = channelsAsync.value ?? const [];
    final allEvents = eventsAsync.value ?? const [];

    final showChannels = allChannels.isNotEmpty;
    final showEvents = allEvents.isNotEmpty;
    final showNoResults = !showChannels && !showEvents;

    if (showNoResults) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: GoPlayTheme.surfaceContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.search_off_rounded,
                    size: 36,
                    color: GoPlayTheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'No results for "${widget.query}"',
                textAlign: TextAlign.center,
                style: GoPlayType.subtitle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: GoPlayTheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'Try checking for spelling errors or searching another keyword.',
                textAlign: TextAlign.center,
                style: GoPlayType.body.copyWith(
                  color: GoPlayTheme.onSurfaceVariant,
                  fontSize: GoPlayType.sm,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: GoPlayTheme.surfaceContainerHigh,
                  foregroundColor: GoPlayTheme.onSurface,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onPressed: widget.onClear,
                child: Text('Clear search', style: GoPlayType.label),
              ),
            ],
          ),
        ),
      );
    }

    final visibleChannels = allChannels.take(_channelLimit).toList();
    final visibleEvents = allEvents.take(_eventLimit).toList();
    final hasMoreChannels = allChannels.length > _channelLimit;
    final hasMoreEvents = allEvents.length > _eventLimit;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ─── Matches / Events Section ─────────────────────────────
        if (showEvents) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
              child: Row(
                children: [
                  Text(
                    'Matches',
                    style: GoPlayType.sectionTitle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: GoPlayTheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: GoPlayTheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      '${allEvents.length}',
                      style: GoPlayType.inter(
                        color: GoPlayTheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildEventCard(context, visibleEvents[index]),
                childCount: visibleEvents.length,
              ),
            ),
          ),
          if (hasMoreEvents)
            SliverToBoxAdapter(
              child: _LoadMoreButton(
                remaining: allEvents.length - _eventLimit,
                onTap: () => setState(() => _eventLimit += _kPageSize),
              ),
            ),
        ],

        if (showChannels && showEvents)
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // ─── Channels Section ─────────────────────────────────────
        if (showChannels) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
              child: Row(
                children: [
                  Text(
                    'Channels',
                    style: GoPlayType.sectionTitle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: GoPlayTheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: GoPlayTheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      '${allChannels.length}',
                      style: GoPlayType.inter(
                        color: GoPlayTheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildChannelCard(
                  context,
                  visibleChannels[index],
                  scope: visibleChannels,
                ),
                childCount: visibleChannels.length,
              ),
            ),
          ),
          if (hasMoreChannels)
            SliverToBoxAdapter(
              child: _LoadMoreButton(
                remaining: allChannels.length - _channelLimit,
                onTap: () => setState(() => _channelLimit += _kPageSize),
              ),
            ),
        ],

        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  Widget _buildChannelCard(
    BuildContext context,
    Channel ch, {
    required List<Channel> scope,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: GoPlayTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0x14FFFFFF),
          width: 0.6,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openPlayer(context, ch, scope),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _ChannelAvatar(ch: ch),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ch.displayName,
                        style: GoPlayType.label.copyWith(
                          color: GoPlayTheme.onSurface,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${ch.category ?? 'General'} • ${ch.country ?? 'Global'}',
                        style: GoPlayType.bodySmall.copyWith(
                          color: GoPlayTheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (ch.isLive) const _LiveBadge(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, SportEvent event) {
    return PlayZEventCard(
      event: event,
      onTap: () => EventStreamLauncher.launch(context, event),
    );
  }
}

// ─── Shared Micro-Widgets ─────────────────────────────────────

/// Circular channel logo with initials fallback.
class _ChannelAvatar extends StatelessWidget {
  final Channel ch;
  const _ChannelAvatar({required this.ch});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: GoPlayTheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: ch.logo != null && ch.logo!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: ch.logo!,
                fit: BoxFit.cover,
                memCacheWidth: 88,
                memCacheHeight: 88,
                placeholder: (context, url) => Center(
                  child: Text(
                    ch.initials,
                    style: GoPlayType.labelSmall.copyWith(
                      color: GoPlayTheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Text(
                    ch.initials,
                    style: GoPlayType.labelSmall.copyWith(
                      color: GoPlayTheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
            : Center(
                child: Text(
                  ch.initials,
                  style: GoPlayType.labelSmall.copyWith(
                    color: GoPlayTheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
      ),
    );
  }
}

/// Compact minimal LIVE badge.
class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: GoPlayTheme.liveBadge,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'LIVE',
        style: GoPlayType.meta.copyWith(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
        maxLines: 1,
      ),
    );
  }
}

/// "Load X more" button for capped sections.
class _LoadMoreButton extends StatelessWidget {
  final int remaining;
  final VoidCallback onTap;

  const _LoadMoreButton({required this.remaining, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final label = remaining > _kPageSize
        ? 'Show $_kPageSize more  ($remaining remaining)'
        : 'Show all $remaining remaining';

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: GoPlayTheme.surfaceContainer,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0x14FFFFFF),
              width: 0.6,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.expand_more_rounded,
                color: GoPlayTheme.primary,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoPlayType.label.copyWith(
                  color: GoPlayTheme.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
