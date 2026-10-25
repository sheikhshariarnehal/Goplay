import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/typography.dart';
import '../providers/app_providers.dart';
import 'tv_focus_wrapper.dart';

/// Telegram-style sleek top-right popup dropdown menu.
class AppOverflowMenu extends ConsumerWidget {
  final Color? iconColor;

  const AppOverflowMenu({super.key, this.iconColor});

  void _showDropdown(BuildContext context, WidgetRef ref) {
    HapticFeedback.lightImpact();

    // Resolve target button's global position on screen
    final renderBox = context.findRenderObject() as RenderBox?;
    final buttonRect = renderBox != null
        ? renderBox.localToGlobal(Offset.zero) & renderBox.size
        : Rect.fromLTWH(MediaQuery.of(context).size.width - 48, 48, 38, 38);

    Navigator.of(context).push(
      _TelegramMenuRoute(
        targetRect: buttonRect,
        child: _TelegramDropdownCard(
          onFavoritesSelected: () {
            ref.read(selectedCategoryProvider.notifier).select('favorite');
            context.go('/channels');
          },
          onSettingsSelected: () {
            context.push('/settings');
          },
          onAboutSelected: () {
            showAboutDialog(
              context: context,
              applicationName: 'GoPlay Stream',
              applicationVersion: 'v2.1.0 (Build 210)',
              applicationLegalese: '© 2026 GoPlay Streaming Platform. All rights reserved.',
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final color = iconColor ?? cs.onSurface.withValues(alpha: 0.85);

    return TvFocusable(
      onTap: () => _showDropdown(context, ref),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        child: Icon(
          Icons.more_vert_rounded,
          color: color,
          size: 22,
        ),
      ),
    );
  }
}

/// Custom PopupRoute for Telegram-style scale/fade animation and clear backdrop.
class _TelegramMenuRoute extends PopupRoute<void> {
  final Rect targetRect;
  final Widget child;

  _TelegramMenuRoute({
    required this.targetRect,
    required this.child,
  });

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Dismiss Menu';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 160);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return CustomSingleChildLayout(
      delegate: _DropdownPositionDelegate(targetRect: targetRect),
      child: child,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return ScaleTransition(
      alignment: Alignment.topRight,
      scale: Tween<double>(begin: 0.82, end: 1.0).animate(curvedAnimation),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
        child: child,
      ),
    );
  }
}

/// Position delegate anchoring the dropdown directly below the 3-dot icon.
class _DropdownPositionDelegate extends SingleChildLayoutDelegate {
  final Rect targetRect;

  _DropdownPositionDelegate({required this.targetRect});

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints.loosen();
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    const double rightMargin = 12.0;
    const double verticalGap = 6.0;

    // Align dropdown right edge with the button, bounded by right screen margin
    double x = targetRect.right - childSize.width + 4;
    if (x + childSize.width > size.width - rightMargin) {
      x = size.width - childSize.width - rightMargin;
    }
    if (x < 12.0) {
      x = 12.0;
    }

    // Place directly beneath button; if it exceeds bottom of screen, flip above
    double y = targetRect.bottom + verticalGap;
    if (y + childSize.height > size.height - 20) {
      y = targetRect.top - childSize.height - verticalGap;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_DropdownPositionDelegate oldDelegate) {
    return targetRect != oldDelegate.targetRect;
  }
}

/// Floating dark dropdown card matching Telegram's sleek popup aesthetics.
class _TelegramDropdownCard extends StatelessWidget {
  final VoidCallback onFavoritesSelected;
  final VoidCallback onSettingsSelected;
  final VoidCallback onAboutSelected;

  const _TelegramDropdownCard({
    required this.onFavoritesSelected,
    required this.onSettingsSelected,
    required this.onAboutSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 215,
        decoration: BoxDecoration(
          color: const Color(0xFF222222), // Telegram-style deep slate dark surface
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 0.7,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.55),
              blurRadius: 28,
              spreadRadius: 2,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: FocusScope(
              autofocus: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _MenuItemTile(
                    icon: Icons.bookmark_border_rounded,
                    title: 'Favorite Channels',
                    onTap: () {
                      Navigator.of(context).pop();
                      onFavoritesSelected();
                    },
                  ),
                  _MenuItemTile(
                    icon: Icons.settings_outlined,
                    title: 'App Settings',
                    onTap: () {
                      Navigator.of(context).pop();
                      onSettingsSelected();
                    },
                  ),
                  _MenuItemTile(
                    icon: Icons.info_outline_rounded,
                    title: 'About GoPlay',
                    onTap: () {
                      Navigator.of(context).pop();
                      onAboutSelected();
                    },
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

/// Compact single-line row tile with Telegram touch feedback and Android TV D-Pad focus.
class _MenuItemTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItemTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  State<_MenuItemTile> createState() => _MenuItemTileState();
}

class _MenuItemTileState extends State<_MenuItemTile> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onShowFocusHighlight: (focused) => setState(() => _isFocused = focused),
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            HapticFeedback.lightImpact();
            widget.onTap();
            return null;
          },
        ),
      },
      child: Material(
        color: _isFocused
            ? Colors.white.withValues(alpha: 0.12)
            : Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onTap();
          },
          splashColor: Colors.white.withValues(alpha: 0.08),
          highlightColor: Colors.white.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  size: 20,
                  color: _isFocused
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.85),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: GoPlayType.family,
                      color: _isFocused
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.92),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.1,
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
