import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:customer_app/features/home/data/ride_models.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_common_widgets.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_driver_widgets.dart';
import 'package:flutter/material.dart';

class PriceOfferSheet extends StatelessWidget {
  const PriceOfferSheet({
    super.key,
    required this.offer,
    required this.onIncrease,
    required this.onDecrease,
    required this.onFindDriver,
  });

  final int offer;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onFindDriver;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: .08),
            borderRadius: AppBorders.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estimated fare: EGP 240',
                style: theme.textTheme.bodySmall,
              ),
              SizedBox(height: AppSpacing.ms),
              Text(
                'Your Offer',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _PriceButton(
                    icon: Icons.remove,
                    onTap: onDecrease,
                  ),
                  Text(
                    'EGP $offer',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  _PriceButton(
                    icon: Icons.add,
                    onTap: onIncrease,
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.ms),
              Center(
                child: Text(
                  'Set the price you’re willing to pay.',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        AppButton(
          label: 'Find a driver',
          onPressed: onFindDriver,
        ),
      ],
    );
  }
}

class FindingDriverSheet extends StatelessWidget {
  const FindingDriverSheet({
    super.key,
    required this.offer,
    required this.onCancel,
  });

  final int offer;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          children: [
            CircularProgressIndicator(
              color: colors.primary,
            ),
            SizedBox(width: AppSpacing.ms),
            Text(
              'Finding a Driver',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        SizedBox(height: AppSpacing.lg),
        RideValueRow(
          title: 'Estimated Fare',
          value: 'EGP $offer',
        ),
        SizedBox(height: AppSpacing.lg),
        CancelRideButton(onPressed: onCancel),
      ],
    );
  }
}

class SelectDriverSheet extends StatelessWidget {
  const SelectDriverSheet({
    super.key,
    required this.offer,
    required this.drivers,
    required this.onDriverSelected,
    required this.onChangeOffer,
    required this.onCancel,
  });

  final int offer;
  final List<DriverInfo> drivers;
  final ValueChanged<DriverInfo> onDriverSelected;
  final VoidCallback onChangeOffer;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Drivers Available',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          'Choose the driver that works best for you.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(height: AppSpacing.md),
        RideValueRow(
          title: 'Your offer',
          value: 'EGP $offer',
        ),
        SizedBox(height: AppSpacing.md),
        ...drivers.map(
              (driver) => Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.ms),
            child: DriverCard(
              driver: driver,
              onTap: () => onDriverSelected(driver),
            ),
          ),
        ),
        AppButton(
          label: 'Change Offer',
          onPressed: onChangeOffer,
        ),
        SizedBox(height: AppSpacing.ms),
        CancelRideButton(onPressed: onCancel),
      ],
    );
  }
}

class _PriceButton extends StatelessWidget {
  const _PriceButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return IconButton.filled(
      onPressed: onTap,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
    );
  }
}