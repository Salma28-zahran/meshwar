import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:customer_app/features/home/data/ride_models.dart';
import 'package:customer_app/features/home/presentation/widgets/success/success_common_widgets.dart';
import 'package:customer_app/features/home/presentation/widgets/success/success_driver_widgets.dart';
import 'package:flutter/material.dart';

class SuccessCompleteView extends StatelessWidget {
  const SuccessCompleteView({
    super.key,
    required this.driver,
    required this.totalFare,
    required this.onRateDriver,
    required this.onInvoice,
  });

  final DriverInfo driver;
  final int totalFare;
  final VoidCallback onRateDriver;
  final VoidCallback onInvoice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SuccessPageLayout(
      content: Column(
        children: [
          SizedBox(height: AppSpacing.xxl),

          const SuccessCheckIcon(),

          SizedBox(height: AppSpacing.xl),

          Text(
            "You've arrived!",
            style: theme.textTheme.titleLarge?.copyWith(
              color: colors.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: AppSpacing.sm),

          Text(
            'Your ride has been completed successfully.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),

          SizedBox(height: AppSpacing.lg),

          SuccessSurfaceCard(
            child: SuccessDriverCard(
              driver: driver,
            ),
          ),

          SizedBox(height: AppSpacing.lg),

          SuccessSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total Fare',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      'EGP $totalFare',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.ms),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: .08),
                    borderRadius: AppBorders.full,
                  ),
                  child: Text(
                    'Paid via Cash',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      bottom: Column(
        children: [
          AppButton(
            label: 'Rate Driver',
            onPressed: onRateDriver,
          ),

          SizedBox(height: AppSpacing.sm),

          AppButton(
            label: 'View Fare Invoice',
            type: AppButtonType.outline,
            onPressed: onInvoice,
          ),

          SizedBox(height: AppSpacing.sm),

          TextButton(
            onPressed: () {},
            child: const Text(
              'Need help with this trip? Contact Support',
            ),
          ),
        ],
      ),
    );
  }
}