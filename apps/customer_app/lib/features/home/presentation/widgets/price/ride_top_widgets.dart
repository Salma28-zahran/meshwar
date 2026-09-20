import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RideBackButton extends StatelessWidget {
  const RideBackButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      elevation: 2,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox.square(
          dimension: 44.r,
          child: Icon(
            Icons.arrow_back,
            size: 22.r,
            color: colors.primary,
          ),
        ),
      ),
    );
  }
}

class RideLocationCard extends StatelessWidget {
  const RideLocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      constraints: BoxConstraints(
        minHeight: 76.r,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.ms,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppBorders.md,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 10.r,
          ),
        ],
      ),
      child: Row(
        children: [
          _Indicator(
            primary: colors.primary,
            secondary: colors.secondary,
          ),
          SizedBox(width: AppSpacing.ms),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assiut University',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.secondary,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Assiut Railway Station',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RideStatusTopBar extends StatelessWidget {
  const RideStatusTopBar({
    super.key,
    required this.title,
    required this.onBack,
  });

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      height: 48.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            child: RideBackButton(
              onPressed: onBack,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: AppBorders.full,
            ),
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({
    required this.primary,
    required this.secondary,
  });

  final Color primary;
  final Color secondary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 12.r,
      height: 50.r,
      child: Column(
        children: [
          _Dot(color: primary),
          Expanded(
            child: Container(
              width: 1.r,
              color: Theme.of(context)
                  .colorScheme
                  .outlineVariant,
            ),
          ),
          _Dot(color: secondary),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9.r,
      height: 9.r,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}