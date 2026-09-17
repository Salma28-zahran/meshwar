import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/features/home/data/ride_models.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_common_widgets.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_driver_widgets.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_route_widgets.dart';
import 'package:flutter/material.dart';

class DriverOnWaySheet extends StatelessWidget {
  const DriverOnWaySheet({
    super.key,
    required this.driver,
    required this.onCancel,
  });

  final DriverInfo driver;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const RideStatusPill(
          text: 'Your driver is on the way',
        ),
        SizedBox(height: AppSpacing.ms),
        Text(
          'Will arrive in 1 minute',
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        DriverContactCard(driver: driver),
        SizedBox(height: AppSpacing.md),
        const RideRouteCard(),
        SizedBox(height: AppSpacing.md),
        CancelRideButton(onPressed: onCancel),
        SizedBox(height: AppSpacing.sm),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Need help with this trip? Contact Support',
          ),
        ),
      ],
    );
  }
}

class DriverArrivedSheet extends StatelessWidget {
  const DriverArrivedSheet({
    super.key,
    required this.driver,
    required this.fare,
    required this.onCancel,
  });

  final DriverInfo driver;
  final int fare;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const RideStatusPill(
          text: 'Your driver has arrived',
          icon: Icons.check_circle,
        ),
        SizedBox(height: AppSpacing.ms),
        Text(
          'Please meet your driver at the pickup point.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(height: AppSpacing.md),
        DriverContactCard(driver: driver),
        SizedBox(height: AppSpacing.md),
        PickupFareCard(fare: fare),
        SizedBox(height: AppSpacing.md),
        CancelRideButton(onPressed: onCancel),
      ],
    );
  }
}