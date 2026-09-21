import 'package:customer_app/config/routing/app_routes.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class Drawer extends StatefulWidget {
  const Drawer({super.key, this.userImage});

  final ImageProvider? userImage;

  @override
  State<Drawer> createState() => _DrawerState();
}

class _DrawerState extends State<Drawer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
      reverseDuration: const Duration(milliseconds: 250),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _closeDrawer() async {
    await _controller.reverse();

    if (!mounted) return;

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final colors = Theme.of(context).colorScheme;

    final double drawerWidth = size.width < 600 ? size.width * .74 : 330.r;

    return SizedBox(
      width: drawerWidth,
      height: size.height,
      child: Material(
        color: colors.surface,
        child: Padding(
          padding: EdgeInsets.only(
            top: mediaQuery.padding.top,
            bottom: mediaQuery.padding.bottom,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------------------------------------------------------------
                // USER
                // -------------------------------------------------------------
                _AnimatedDrawerItem(
                  controller: _controller,
                  start: 0.00,
                  end: 0.30,
                  scale: true,
                  slideAmount: 36,
                  child: _UserHeader(userImage: widget.userImage),
                ),

                SizedBox(height: AppSpacing.md),

                _AnimatedDrawerItem(
                  controller: _controller,
                  start: 0.08,
                  end: 0.34,
                  slideAmount: 20,
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: colors.outlineVariant.withValues(alpha: .85),
                  ),
                ),

                SizedBox(height: AppSpacing.lg),

                // -------------------------------------------------------------
                // TRIPS
                // -------------------------------------------------------------
                _AnimatedDrawerItem(
                  controller: _controller,
                  start: 0.12,
                  end: 0.38,
                  child: const _SectionTitle(title: 'TRIPS'),
                ),

                _AnimatedDrawerItem(
                  controller: _controller,
                  start: 0.18,
                  end: 0.46,
                  child: _DrawerItem(
                    icon: Icons.access_time_rounded,
                    title: 'Trip History',
                    onTap: () async {
                      await _controller.reverse();

                      if (!context.mounted) return;

                      Navigator.of(context).pop();

                      Future.delayed(const Duration(milliseconds: 150), () {
                        if (context.mounted) {
                          context.push(AppRoutes.history);
                        }
                      });
                    },
                  ),
                ),

                _AnimatedDrawerItem(
                  controller: _controller,
                  start: 0.24,
                  end: 0.52,
                  child: _DrawerItem(
                    icon: Icons.calendar_month_outlined,
                    title: 'Scheduled Trips',
                    onTap: _closeDrawer,
                  ),
                ),

                _AnimatedDrawerItem(
                  controller: _controller,
                  start: 0.30,
                  end: 0.58,
                  child: _DrawerItem(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Meshwar Wallet',
                    onTap: _closeDrawer,
                  ),
                ),

                SizedBox(height: AppSpacing.md),

                // -------------------------------------------------------------
                // COMMUNICATION
                // -------------------------------------------------------------
                _AnimatedDrawerItem(
                  controller: _controller,
                  start: 0.36,
                  end: 0.64,
                  child: const _SectionTitle(title: 'COMMUNICATION'),
                ),

                _AnimatedDrawerItem(
                  controller: _controller,
                  start: 0.42,
                  end: 0.70,
                  child: _DrawerItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'Messages',
                    onTap: () async {
                      await _controller.reverse();

                      if (!context.mounted) return;

                      Navigator.of(context).pop();

                      Future.delayed(const Duration(milliseconds: 150), () {
                        if (context.mounted) {
                          context.push(AppRoutes.chat);
                        }
                      });
                    },
                  ),
                ),
                _AnimatedDrawerItem(
                  controller: _controller,
                  start: 0.48,
                  end: 0.76,
                  child: _DrawerItem(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    onTap: _closeDrawer,
                  ),
                ),

                SizedBox(height: AppSpacing.md),

                // -------------------------------------------------------------
                // SUPPORT
                // -------------------------------------------------------------
                _AnimatedDrawerItem(
                  controller: _controller,
                  start: 0.54,
                  end: 0.82,
                  child: const _SectionTitle(title: 'SUPPORT'),
                ),

                _AnimatedDrawerItem(
                  controller: _controller,
                  start: 0.60,
                  end: 0.88,
                  child: _DrawerItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Help & Support',
                    onTap: () async {
                      await _controller.reverse();

                      if (!context.mounted) return;

                      Navigator.of(context).pop();

                      Future.delayed(const Duration(milliseconds: 150), () {
                        if (context.mounted) {
                          context.push(AppRoutes.support);
                        }
                      });
                    },
                  ),
                ),

                SizedBox(height: AppSpacing.md),

                // -------------------------------------------------------------
                // SETTINGS
                // -------------------------------------------------------------
                _AnimatedDrawerItem(
                  controller: _controller,
                  start: 0.66,
                  end: 0.94,
                  child: const _SectionTitle(title: 'SETTINGS'),
                ),

                _AnimatedDrawerItem(
                  controller: _controller,
                  start: 0.72,
                  end: 1.00,
                  child: _DrawerItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: _closeDrawer,
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

// =============================================================================
// USER HEADER
// =============================================================================

class _UserHeader extends StatelessWidget {
  const _UserHeader({required this.userImage});

  final ImageProvider? userImage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      height: 70.r,
      child: Row(
        children: [
          Container(
            width: 58.r,
            height: 58.r,
            padding: EdgeInsets.all(2.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colors.primary, width: 2.r),
            ),
            child: CircleAvatar(
              backgroundColor: colors.primary.withValues(alpha: .08),
              backgroundImage: userImage,
              child: userImage == null
                  ? Icon(
                      Icons.person_rounded,
                      size: 32.r,
                      color: colors.primary,
                    )
                  : null,
            ),
          ),

          SizedBox(width: AppSpacing.ms),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Name',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: AppSpacing.sm),

                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 17.r,
                      color: const Color(0xFFFFA000),
                    ),

                    SizedBox(width: AppSpacing.xs),

                    Text(
                      '4.8',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colors.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SECTION TITLE
// =============================================================================

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colors.secondary,
          fontWeight: FontWeight.w800,
          letterSpacing: .55,
        ),
      ),
    );
  }
}

// =============================================================================
// DRAWER ITEM
// =============================================================================

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppBorders.md,
        splashColor: colors.primary.withValues(alpha: .08),
        highlightColor: colors.primary.withValues(alpha: .04),
        child: SizedBox(
          height: 48.r,
          child: Row(
            children: [
              SizedBox(
                width: 36.r,
                child: Center(
                  child: Icon(icon, size: 20.r, color: colors.secondary),
                ),
              ),

              SizedBox(width: AppSpacing.xs),

              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.secondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              Icon(
                Icons.chevron_right_rounded,
                size: 21.r,
                color: colors.secondary.withValues(alpha: .70),
              ),

              SizedBox(width: AppSpacing.xs),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// ANIMATION
// =============================================================================

class _AnimatedDrawerItem extends StatelessWidget {
  const _AnimatedDrawerItem({
    required this.controller,
    required this.start,
    required this.end,
    required this.child,
    this.scale = false,
    this.slideAmount = 48,
  });

  final AnimationController controller;
  final double start;
  final double end;
  final Widget child;

  final bool scale;
  final double slideAmount;

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final value = animation.value;

        final double translateX = -slideAmount.r * (1 - value);

        final double scaleValue = scale ? .78 + (.22 * value) : 1;

        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(translateX, 0),
            child: Transform.scale(
              scale: scaleValue,
              alignment: Alignment.centerLeft,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
