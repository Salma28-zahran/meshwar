import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessPageLayout extends StatelessWidget {
  const SuccessPageLayout({
    super.key,
    required this.content,
    required this.bottom,
  });

  final Widget content;
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.lg,
            ),
            child: content,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: bottom,
        ),
      ],
    );
  }
}

class SuccessHeader extends StatelessWidget {
  const SuccessHeader({
    super.key,
    required this.title,
    required this.onBack,
  });

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 48.r,
      child: Row(
        children: [
          SizedBox(
            width: 48.r,
            child: IconButton(
              onPressed: onBack,
              icon: Icon(
                Icons.arrow_back,
                size: 21.r,
                color: colors.primary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 48.r),
        ],
      ),
    );
  }
}

class SuccessCheckIcon extends StatelessWidget {
  const SuccessCheckIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 64.r,
      height: 64.r,
      decoration: BoxDecoration(
        color: colors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check_rounded,
        size: 42.r,
        color: colors.onPrimary,
      ),
    );
  }
}

class SuccessSurfaceCard extends StatelessWidget {
  const SuccessSurfaceCard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppBorders.md,
        border: Border.all(
          color: colors.outlineVariant,
        ),
      ),
      child: child,
    );
  }
}