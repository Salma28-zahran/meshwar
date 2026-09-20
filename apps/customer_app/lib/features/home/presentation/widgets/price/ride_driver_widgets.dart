import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:customer_app/features/home/data/ride_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DriverCard extends StatelessWidget {
  const DriverCard({
    super.key,
    required this.driver,
    required this.onTap,
  });

  final DriverInfo driver;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: AppBorders.md,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.ms),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppBorders.md,
          border: Border.all(
            color: colors.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            _DriverAvatar(driver: driver),
            SizedBox(width: AppSpacing.ms),
            Expanded(
              child: _DriverInfo(driver: driver),
            ),
            SizedBox(width: AppSpacing.sm),
            Container(
              padding: EdgeInsets.all(AppSpacing.ms),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: .08),
                borderRadius: AppBorders.md,
              ),
              child: Text(
                'EGP ${driver.price}',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DriverContactCard extends StatelessWidget {
  const DriverContactCard({
    super.key,
    required this.driver,
  });

  final DriverInfo driver;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(AppSpacing.ms),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppBorders.md,
        border: Border.all(
          color: colors.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          _DriverAvatar(driver: driver),
          SizedBox(width: AppSpacing.ms),
          Expanded(
            child: _DriverInfo(driver: driver),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.chat_bubble_outline,
              color: colors.secondary,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.phone_outlined,
              color: colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class MapCarMarker extends StatelessWidget {
  const MapCarMarker({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppBorders.lg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .18),
            blurRadius: 5.r,
          ),
        ],
      ),
      child: Icon(
        Icons.directions_car_filled,
        size: 27.r,
        color: colors.secondary,
      ),
    );
  }
}

class MapPickupMarker extends StatelessWidget {
  const MapPickupMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.location_on,
      size: 38.r,
      color: Theme.of(context).colorScheme.error,
    );
  }
}

class _DriverAvatar extends StatelessWidget {
  const _DriverAvatar({
    required this.driver,
  });

  final DriverInfo driver;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return CircleAvatar(
      radius: 21.r,
      backgroundColor:
      colors.primary.withValues(alpha: .10),
      child: Icon(
        Icons.person,
        color: colors.primary,
      ),
    );
  }
}

class _DriverInfo extends StatelessWidget {
  const _DriverInfo({
    required this.driver,
  });

  final DriverInfo driver;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
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
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}