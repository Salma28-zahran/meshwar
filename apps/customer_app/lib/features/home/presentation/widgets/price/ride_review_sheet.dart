import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:customer_app/features/home/data/ride_models.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_driver_widgets.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_route_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewRideSheet extends StatelessWidget {
  const ReviewRideSheet({
    super.key,
    required this.driver,
    required this.offer,
    required this.onConfirm,
  });

  final DriverInfo driver;
  final int offer;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DriverContactCard(driver: driver),
        SizedBox(height: AppSpacing.ms),
        const _RideDetailsCard(),
        SizedBox(height: AppSpacing.ms),
        _PaymentCard(offer: offer),
        SizedBox(height: AppSpacing.md),
        AppButton(
          label: 'Confirm Ride',
          onPressed: onConfirm,
        ),
      ],
    );
  }
}

class _RideDetailsCard extends StatelessWidget {
  const _RideDetailsCard();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: AppBorders.md,
        border: Border.all(
          color: colors.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          const RideRouteCard(),
          SizedBox(height: AppSpacing.md),
          Divider(
            color: colors.outlineVariant,
          ),
          Row(
            children: [
              const Expanded(
                child: _Meta(
                  title: 'DISTANCE',
                  value: '5.2 km',
                ),
              ),
              Container(
                width: 1.r,
                height: 40.r,
                color: colors.outlineVariant,
              ),
              const Expanded(
                child: _Meta(
                  title: 'EST. TIME',
                  value: '12 min',
                  right: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({
    required this.offer,
  });

  final int offer;

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
            child: _PaymentText(
              title: 'Payment method',
              value: 'Cash',
              color: colors.secondary,
            ),
          ),
          Text(
            'Change',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colors.primary,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          _PaymentText(
            title: 'Total',
            value: 'EGP $offer',
            color: colors.primary,
            right: true,
          ),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({
    required this.title,
    required this.value,
    this.right = false,
  });

  final String title;
  final String value;
  final bool right;

  @override
  Widget build(BuildContext context) {
    return _PaymentText(
      title: title,
      value: value,
      color: Theme.of(context).colorScheme.secondary,
      right: right,
    );
  }
}

class _PaymentText extends StatelessWidget {
  const _PaymentText({
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
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment:
      right ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(title, style: text.bodySmall),
        SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: text.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}