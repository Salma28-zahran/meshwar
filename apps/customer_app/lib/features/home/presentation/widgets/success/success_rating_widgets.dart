import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DriverStarRating extends StatelessWidget {
  const DriverStarRating({
    super.key,
    required this.rating,
    required this.onChanged,
  });

  final int rating;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
            (index) {
          final value = index + 1;
          final selected = value <= rating;

          return IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
            ),
            onPressed: () => onChanged(value),
            icon: Icon(
              Icons.star_rounded,
              size: 39.r,
              color: selected
                  ? colors.tertiary
                  : colors.surfaceContainerHighest,
            ),
          );
        },
      ),
    );
  }
}

class QuickFeedbackChips extends StatelessWidget {
  const QuickFeedbackChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onTap,
  });

  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: options.map((option) {
        return _FeedbackChip(
          text: option,
          selected: selected.contains(option),
          onTap: () => onTap(option),
        );
      }).toList(),
    );
  }
}

class _FeedbackChip extends StatelessWidget {
  const _FeedbackChip({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: AppBorders.full,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.ms,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected
              ? colors.primary.withValues(alpha: .10)
              : colors.surface,
          borderRadius: AppBorders.full,
          border: Border.all(
            color: selected
                ? colors.primary
                : colors.outlineVariant,
          ),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: selected
                ? colors.primary
                : colors.secondary,
          ),
        ),
      ),
    );
  }
}