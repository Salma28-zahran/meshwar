import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:customer_app/features/home/data/ride_models.dart';
import 'package:customer_app/features/home/presentation/widgets/success/success_common_widgets.dart';
import 'package:customer_app/features/home/presentation/widgets/success/success_driver_widgets.dart';
import 'package:customer_app/features/home/presentation/widgets/success/success_rating_widgets.dart';
import 'package:flutter/material.dart';

class SuccessRateView extends StatelessWidget {
  const SuccessRateView({
    super.key,
    required this.driver,
    required this.rating,
    required this.options,
    required this.selectedOptions,
    required this.onBack,
    required this.onRatingChanged,
    required this.onOptionTap,
    required this.onContinue,
  });

  final DriverInfo driver;
  final int rating;
  final List<String> options;
  final Set<String> selectedOptions;

  final VoidCallback onBack;
  final ValueChanged<int> onRatingChanged;
  final ValueChanged<String> onOptionTap;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SuccessPageLayout(
      content: Column(
        children: [
          SuccessHeader(
            title: 'Rate Your Driver',
            onBack: onBack,
          ),

          SizedBox(height: AppSpacing.lg),

          SuccessDriverProfile(
            driver: driver,
          ),

          SizedBox(height: AppSpacing.lg),

          SuccessSurfaceCard(
            child: Column(
              children: [
                Text(
                  'Rate Your Driver',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colors.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: AppSpacing.sm),

                DriverStarRating(
                  rating: rating,
                  onChanged: onRatingChanged,
                ),
              ],
            ),
          ),

          if (rating > 0) ...[
            SizedBox(height: AppSpacing.lg),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Quick feedback (optional)',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(height: AppSpacing.sm),

            Align(
              alignment: Alignment.centerLeft,
              child: QuickFeedbackChips(
                options: options,
                selected: selectedOptions,
                onTap: onOptionTap,
              ),
            ),
          ],
        ],
      ),

      bottom: AppButton(
        label: 'Continue',
        onPressed: rating == 0 ? null : onContinue,
      ),
    );
  }
}