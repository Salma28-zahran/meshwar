import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RideRouteCard extends StatelessWidget {
  const RideRouteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: AppBorders.md,
        border: Border.all(
          color: colors.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          RidePoint(
            color: colors.primary,
            title: 'Pickup',
            value: 'Assiut University',
          ),
          Padding(
            padding: EdgeInsets.only(left: 4.r),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 1.r,
                height: 20.r,
                margin: EdgeInsets.symmetric(
                  vertical: AppSpacing.xs,
                ),
                color: colors.outlineVariant,
              ),
            ),
          ),
          RidePoint(
            color: colors.secondary,
            title: 'Destination',
            value: 'Assiut Railway Station',
          ),
        ],
      ),
    );
  }
}

class RidePoint extends StatelessWidget {
  const RidePoint({
    super.key,
    required this.color,
    required this.title,
    required this.value,
  });

  final Color color;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 9.r,
          height: 9.r,
          margin: EdgeInsets.only(top: 4.r),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: AppSpacing.ms),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colors.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PickupFareCard extends StatelessWidget {
  const PickupFareCard({
    super.key,
    required this.fare,
  });

  final int fare;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: AppBorders.md,
        border: Border.all(
          color: colors.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Info(
              title: 'Pickup',
              value: 'Assiut University',
              color: colors.secondary,
            ),
          ),
          Container(
            width: 1.r,
            height: 42.r,
            color: colors.outlineVariant,
          ),
          SizedBox(width: AppSpacing.md),
          _Info(
            title: 'Fare',
            value: 'EGP $fare',
            color: colors.primary,
            right: true,
          ),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({
    required this.title,
    required this.value,
    required this.color,
    this.right = false,
  });

  final String title;
  final String value;
  final Color color;
  final bool right;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment:
      right ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.bodySmall),
        SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}