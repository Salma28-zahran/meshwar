import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/features/home/data/ride_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessDriverCard extends StatelessWidget {
  const SuccessDriverCard({
    super.key,
    required this.driver,
  });

  final DriverInfo driver;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        _DriverAvatar(
          driver: driver,
          radius: 21.r,
        ),
        SizedBox(width: AppSpacing.ms),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                driver.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                '${driver.car} • ${driver.plate}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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

class SuccessDriverProfile extends StatelessWidget {
  const SuccessDriverProfile({
    super.key,
    required this.driver,
  });

  final DriverInfo driver;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        _DriverAvatar(
          driver: driver,
          radius: 30.r,
        ),
        SizedBox(height: AppSpacing.md),
        Text(
          driver.name,
          style: theme.textTheme.titleSmall?.copyWith(
            color: colors.secondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          driver.car,
          style: theme.textTheme.bodySmall,
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          driver.plate,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _DriverAvatar extends StatelessWidget {
  const _DriverAvatar({
    required this.driver,
    required this.radius,
  });

  final DriverInfo driver;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor:
          colors.primary.withValues(alpha: .10),
          child: Icon(
            Icons.person,
            size: radius,
            color: colors.primary,
          ),
        ),
        Positioned(
          bottom: -6.r,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: 2.r,
            ),
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  size: 10.r,
                  color: colors.onPrimary,
                ),
                SizedBox(width: 2.r),
                Text(
                  '${driver.rating}',
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: colors.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}