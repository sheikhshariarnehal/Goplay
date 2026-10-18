import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../providers/app_providers.dart';
import 'tv_focus_wrapper.dart';

/// Industry-grade 3-dot action menu with sleek bottom sheet design matching bottom nav bar.
class AppOverflowMenu extends ConsumerWidget {
  final Color? iconColor;

  const AppOverflowMenu({super.key, this.iconColor});

  void _showActionSheet(BuildContext context, WidgetRef ref) {
    HapticFeedback.lightImpact();

    final favoriteCount = ref.read(favoriteChannelIdsProvider).length;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _OverflowActionSheet(
        favoriteCount: favoriteCount,
        onFavoritesSelected: () {
          Navigator.of(ctx).pop();
          ref.read(selectedCategoryProvider.notifier).select('favorite');
          context.go('/channels');
        },
        onSettingsSelected: () {
          Navigator.of(ctx).pop();
          context.push('/settings');
        },
        onAboutSelected: () {
          Navigator.of(ctx).pop();
          showAboutDialog(
            context: context,
            applicationName: 'GoPlay Stream',
            applicationVersion: 'v2.1.0 (Build 210)',
            applicationLegalese: '© 2026 GoPlay Streaming Platform. All rights reserved.',
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final color = iconColor ?? cs.onSurface.withValues(alpha: 0.85);

    return TvFocusable(
      onTap: () => _showActionSheet(context, ref),
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

class _OverflowActionSheet extends StatelessWidget {
  final int favoriteCount;
  final VoidCallback onFavoritesSelected;
  final VoidCallback onSettingsSelected;
  final VoidCallback onAboutSelected;

  const _OverflowActionSheet({
    required this.favoriteCount,
    required this.onFavoritesSelected,
    required this.onSettingsSelected,
    required this.onAboutSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F0F), // Exactly matches bottom nav bar background
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Drag Handle Indicator
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: const Color(0x40FFFFFF),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header Branding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF7A85), Color(0xFFFF5263)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'GP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GoPlay Menu',
                            style: TextStyle(
                              color: GoPlayTheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            'Live IPTV & Sports Stream',
                            style: TextStyle(
                              color: GoPlayTheme.onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0x14FFFFFF), width: 0.6),
                      ),
                      child: const Text(
                        'v2.1.0',
                        style: TextStyle(
                          color: GoPlayTheme.onSurfaceVariant,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              const Divider(color: Color(0x14FFFFFF), height: 1),
              const SizedBox(height: 10),

              // Action Tile 1: Favorites
              _buildMenuItem(
                icon: Icons.bookmark_rounded,
                iconColor: GoPlayTheme.primary,
                title: 'Favorite Channels',
                subtitle: 'Quick access to your pinned channels',
                badgeText: favoriteCount > 0 ? '$favoriteCount' : null,
                onTap: onFavoritesSelected,
              ),

              const SizedBox(height: 8),

              // Action Tile 2: Settings
              _buildMenuItem(
                icon: Icons.settings_rounded,
                iconColor: const Color(0xFF60A5FA),
                title: 'App Settings',
                subtitle: 'Playback engine, sync schedule & updates',
                onTap: onSettingsSelected,
              ),

              const SizedBox(height: 8),

              // Action Tile 3: About
              _buildMenuItem(
                icon: Icons.info_outline_rounded,
                iconColor: const Color(0xFFA78BFA),
                title: 'About GoPlay',
                subtitle: 'Version info, open source licenses & legal',
                onTap: onAboutSelected,
              ),

              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? badgeText,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0x14FFFFFF),
          width: 0.6,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: GoPlayTheme.onSurface,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: GoPlayTheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (badgeText != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: GoPlayTheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badgeText,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                const Icon(
                  Icons.chevron_right_rounded,
                  color: GoPlayTheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
