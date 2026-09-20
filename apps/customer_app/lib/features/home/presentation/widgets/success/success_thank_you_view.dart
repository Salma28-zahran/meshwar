import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:customer_app/features/home/presentation/widgets/success/success_common_widgets.dart';
import 'package:flutter/material.dart';

class SuccessThankYouView extends StatelessWidget {
  const SuccessThankYouView({
    super.key,
    required this.onHome,
  });

  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SuccessPageLayout(
      content: Column(
        children: [
          SizedBox(height: AppSpacing.xxxl),

          const SuccessCheckIcon(),

          SizedBox(height: AppSpacing.xl),

          Text(
            'Thank You!',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colors.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: AppSpacing.ms),

          Text(
            'Your feedback helps us improve\nMeshwar.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.secondary.withValues(alpha: .7),
            ),
          ),
        ],
      ),

      bottom: AppButton(
        label: 'Back To Home',
        onPressed: onHome,
      ),
    );
  }
}