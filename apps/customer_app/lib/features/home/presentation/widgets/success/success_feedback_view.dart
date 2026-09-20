import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:customer_app/features/home/presentation/widgets/success/success_common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessFeedbackView extends StatelessWidget {
  const SuccessFeedbackView({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onSubmit,
    required this.onSkip,
  });

  final TextEditingController controller;
  final VoidCallback onBack;
  final VoidCallback onSubmit;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SuccessPageLayout(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SuccessHeader(
            title: 'Trip Feedback',
            onBack: onBack,
          ),

          SizedBox(height: AppSpacing.lg),

          Text(
            'Tell us about your experience.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.secondary,
            ),
          ),

          SizedBox(height: AppSpacing.ms),

          Container(
            height: 220.r,
            decoration: BoxDecoration(
              borderRadius: AppBorders.md,
              border: Border.all(
                color: colors.outlineVariant,
              ),
            ),
            child: TextField(
              controller: controller,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText:
                'Write your feedback here (optional)...',
                hintStyle: theme.textTheme.bodySmall,
                border: InputBorder.none,
                contentPadding:
                EdgeInsets.all(AppSpacing.md),
              ),
            ),
          ),
        ],
      ),

      bottom: Column(
        children: [
          AppButton(
            label: 'Submit Feedback',
            onPressed: onSubmit,
          ),

          SizedBox(height: AppSpacing.sm),

          TextButton(
            onPressed: onSkip,
            child: Text(
              'Skip',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colors.secondary.withValues(alpha: .6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}