import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:customer_app/features/home/data/ride_models.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_driver_widgets.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_route_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RideInProgressSheet extends StatelessWidget {
  const RideInProgressSheet({
    super.key,
    required this.driver,
    required this.fare,
    required this.onShare,
  });

  final DriverInfo driver;
  final int fare;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DriverContactCard(
          driver: driver,
        ),

        SizedBox(height: AppSpacing.md),

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: _ArrivalInfo(
                expectedTime: '6:45 PM',
              ),
            ),

            SizedBox(width: AppSpacing.md),

            _FareInfo(
              fare: fare,
            ),
          ],
        ),

        SizedBox(height: AppSpacing.md),

        const RideRouteCard(),

        SizedBox(height: AppSpacing.md),

        AppButton(
          label: 'Share Trip',
          type: AppButtonType.outline,
          prefixIcon: Icon(
            Icons.share_outlined,
            size: 20.r,
            color: colors.secondary,
          ),
          onPressed: onShare,
        ),
      ],
    );
  }
}

class _ArrivalInfo extends StatelessWidget {
  const _ArrivalInfo({
    required this.expectedTime,
  });

  final String expectedTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estimated Arrival',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colors.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: AppSpacing.xs),

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '12',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colors.secondary,
                fontWeight: FontWeight.w700,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                bottom: 3.r,
                left: AppSpacing.xs,
              ),
              child: Text(
                'm',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.secondary,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: AppSpacing.xs),

        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 16.r,
              color: colors.secondary,
            ),

            SizedBox(width: AppSpacing.xs),

            Flexible(
              child: Text(
                'Expected $expectedTime',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.secondary.withValues(alpha: .7),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FareInfo extends StatelessWidget {
  const _FareInfo({
    required this.fare,
  });

  final int fare;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'AGREED FARE',
          style: theme.textTheme.labelSmall?.copyWith(
            color: colors.secondary.withValues(alpha: .65),
          ),
        ),

        SizedBox(height: AppSpacing.sm),

        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'EGP $fare',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}