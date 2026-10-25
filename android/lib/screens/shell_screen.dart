import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../core/theme.dart';
import '../core/typography.dart';
import '../widgets/tv_focus_wrapper.dart';

/// Main shell screen with bottom navigation bar.
///
/// Performance notes:
/// - MediaQuery accessed once, results passed down (avoids multiple rebuild subscriptions).
/// - Bottom nav wrapped in RepaintBoundary (isolated from page scroll repaints).
/// - Mobile nav items use lightweight InkWell with splash + haptic (no TvFocusable overhead).
/// - TV rail items keep TvFocusable for D-Pad focus visuals.
class ShellScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;
  const ShellScreen({super.key, required this.navigationShell});

  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<ShellScreen> {
  late final List<FocusNode> _navFocusNodes;
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    _navFocusNodes = List.generate(
      4,
      (i) => FocusNode(debugLabel: 'NavMenu_$i'),
    );
  }

  @override
  void dispose() {
    for (final node in _navFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final index = widget.navigationShell.currentIndex;

    // Scoped MediaQuery reads. `MediaQuery.of(context)` subscribes to every
    // field — including `viewInsets` — so it rebuilt the whole shell (and every
    // nav item) each time the keyboard opened.
    final size = MediaQuery.sizeOf(context);
    // TV & Landscape detection: TV devices, TV boxes, tablets, or any landscape screen (width > height)
    // use the Left Side Navigation Rail.
    // Mobile phones in portrait mode (width <= height) use the Bottom Navigation Bar.
    final isLandscape = size.width > size.height;
    final isTv = MediaQuery.navigationModeOf(context) == NavigationMode.directional ||
        FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
    final isDesktop = isLandscape || isTv;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    Widget content;

    if (isDesktop) {
      content = Scaffold(
        backgroundColor: cs.surface,
        body: Row(
          children: [
            // Side Navigation Rail — D-Pad friendly
            RepaintBoundary(
              child: Container(
                width: 72,
                decoration: BoxDecoration(
                  color: cs.surface,
                  border: Border(
                    right: BorderSide(
                      color: cs.outline.withValues(alpha: 0.15),
                      width: 0.8,
                    ),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _RailNavItem(
                        focusNode: _navFocusNodes[0],
                        icon: Icons.home_outlined,
                        selectedIcon: Icons.home_rounded,
                        label: 'Home',
                        isSelected: index == 0,
                        onTap: () => _goBranch(0),
                      ),
                      if (ref.watch(uiConfigProvider).navigationBranding.enabledTabs.contains('categories')) ...[
                        const SizedBox(height: 8),
                        _RailNavItem(
                          focusNode: _navFocusNodes[1],
                          icon: Icons.dashboard_customize_outlined,
                          selectedIcon: Icons.dashboard_customize_rounded,
                          label: 'Categories',
                          isSelected: index == 1,
                          onTap: () => _goBranch(1),
                        ),
                      ],
                      if (ref.watch(uiConfigProvider).navigationBranding.enabledTabs.contains('channels')) ...[
                        const SizedBox(height: 8),
                        _RailNavItem(
                          focusNode: _navFocusNodes[2],
                          icon: Icons.smart_display_outlined,
                          selectedIcon: Icons.smart_display_rounded,
                          label: 'Channels',
                          isSelected: index == 2,
                          onTap: () => _goBranch(2),
                        ),
                      ],
                      if (ref.watch(uiConfigProvider).navigationBranding.enabledTabs.contains('upcoming') ||
                          ref.watch(uiConfigProvider).navigationBranding.enabledTabs.contains('events')) ...[
                        const SizedBox(height: 8),
                        _RailNavItem(
                          focusNode: _navFocusNodes[3],
                          icon: Icons.sports_soccer_outlined,
                          selectedIcon: Icons.sports_soccer_rounded,
                          label: 'Events',
                          isSelected: index == 3,
                          onTap: () => _goBranch(3),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Main Content Area
            Expanded(child: widget.navigationShell),
          ],
        ),
      );
    } else {
      content = Scaffold(
        backgroundColor: cs.surface,
        extendBody: false,
        body: widget.navigationShell,
        bottomNavigationBar: RepaintBoundary(
          child: Container(
            height: 64 + bottomPadding,
            decoration: BoxDecoration(
              color: cs.surface,
              border: Border(
                top: BorderSide(
                  color: cs.outline.withValues(alpha: 0.15),
                  width: 0.8,
                ),
              ),
            ),
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: Row(
              children: [
                _NavItem(
                  focusNode: _navFocusNodes[0],
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home_rounded,
                  label: 'Home',
                  isSelected: index == 0,
                  onTap: () => _goBranch(0),
                ),
                if (ref.watch(uiConfigProvider).navigationBranding.enabledTabs.contains('categories'))
                  _NavItem(
                    focusNode: _navFocusNodes[1],
                    icon: Icons.dashboard_customize_outlined,
                    selectedIcon: Icons.dashboard_customize_rounded,
                    label: 'Categories',
                    isSelected: index == 1,
                    onTap: () => _goBranch(1),
                  ),
                if (ref.watch(uiConfigProvider).navigationBranding.enabledTabs.contains('channels'))
                  _NavItem(
                    focusNode: _navFocusNodes[2],
                    icon: Icons.smart_display_outlined,
                    selectedIcon: Icons.smart_display_rounded,
                    label: 'Channels',
                    isSelected: index == 2,
                    onTap: () => _goBranch(2),
                  ),
                if (ref.watch(uiConfigProvider).navigationBranding.enabledTabs.contains('upcoming') ||
                    ref.watch(uiConfigProvider).navigationBranding.enabledTabs.contains('events'))
                  _NavItem(
                    focusNode: _navFocusNodes[3],
                    icon: Icons.sports_soccer_outlined,
                    selectedIcon: Icons.sports_soccer_rounded,
                    label: 'Events',
                    isSelected: index == 3,
                    onTap: () => _goBranch(3),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (index != 0) {
          // Any non-home tab (Categories, Channels, Upcoming) smoothly backs to Home tab
          _goBranch(0);
        } else {
          // Home tab requires double-back to exit within 2 seconds
          final now = DateTime.now();
          if (_lastBackPressTime == null ||
              now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
            _lastBackPressTime = now;
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.exit_to_app_rounded,
                      color: GoPlayTheme.primary,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Press back again to exit',
                      style: TextStyle(
                        fontFamily: GoPlayType.family,
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                width: 240,
                backgroundColor: const Color(0xFF1E2024),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  side: BorderSide(
                    color: Color(0x33C8FF00),
                    width: 0.8,
                  ),
                ),
              ),
            );
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: Focus(
        canRequestFocus: false,
        onKeyEvent: (node, event) {
        if (event is KeyDownEvent || event is KeyRepeatEvent) {
          final key = event.logicalKey;
          if (key == LogicalKeyboardKey.digit1 ||
              key == LogicalKeyboardKey.numpad1) {
            _goBranch(0);
            return KeyEventResult.handled;
          } else if (key == LogicalKeyboardKey.digit2 ||
                     key == LogicalKeyboardKey.numpad2) {
            _goBranch(1);
            return KeyEventResult.handled;
          } else if (key == LogicalKeyboardKey.digit3 ||
                     key == LogicalKeyboardKey.numpad3) {
            _goBranch(2);
            return KeyEventResult.handled;
          } else if (key == LogicalKeyboardKey.digit4 ||
                     key == LogicalKeyboardKey.numpad4) {
            _goBranch(3);
            return KeyEventResult.handled;
          }

          // TV Remote D-Pad LEFT: Move left on page first.
          // ONLY jump to Navigation Menu when at the left-most edge of the page!
          if (key == LogicalKeyboardKey.arrowLeft) {
            final primary = FocusManager.instance.primaryFocus;
            if (primary != null && !_navFocusNodes.contains(primary)) {
              if (primary.context != null) {
                final moved = FocusTraversalGroup.of(primary.context!).inDirection(
                  primary,
                  TraversalDirection.left,
                );
                if (moved) {
                  return KeyEventResult.handled;
                }
              }
              _navFocusNodes[widget.navigationShell.currentIndex].requestFocus();
              return KeyEventResult.handled;
            }
          }
        }
        return KeyEventResult.ignored;
      },
        child: content,
      ),
    );
  }
}

// ─── Mobile Bottom Nav Item ──────────────────────────────────────
// Lightweight: InkWell with splash + haptic feedback.
// No TvFocusable overhead (Focus/Stack/AnimatedScale) on mobile.

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final FocusNode? focusNode;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.focusNode,
  });

  static final _borderRadius = BorderRadius.circular(10);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.onSurfaceVariant;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: TvFocusable(
          focusNode: focusNode,
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          borderRadius: _borderRadius,
          child: Container(
            // 8dp of vertical air instead of 6, with a 22dp glyph instead of
            // 24: the bar keeps its 64dp height but the icon/label pair stops
            // filling it edge to edge.
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSelected ? selectedIcon : icon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 22,
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: GoPlayType.inter(
                        color: isSelected ? activeColor : inactiveColor,
                        fontSize: GoPlayType.xs,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        height: GoPlayType.leadingFlat,
                        letterSpacing: 0.2,
                      ),
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
}

// ─── TV Side Rail Nav Item ────────────────────────────────────────
// Keeps TvFocusable for D-Pad focus ring on TV/desktop.

class _RailNavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final FocusNode? focusNode;

  const _RailNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.focusNode,
  });

  static final _borderRadius = BorderRadius.circular(12);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.onSurfaceVariant;

    return TvFocusable(
      focusNode: focusNode,
      onTap: onTap,
      borderRadius: _borderRadius,
      child: Container(
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: _borderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: GoPlayType.inter(
                  color: isSelected ? activeColor : inactiveColor,
                  fontSize: GoPlayType.xs,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  height: GoPlayType.leadingFlat,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
