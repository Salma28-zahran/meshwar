import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CancelRideDialog extends StatelessWidget {
  const CancelRideDialog({
    super.key,
    required this.onKeepRide,
    required this.onCancelRide,
  });

  final VoidCallback onKeepRide;
  final VoidCallback onCancelRide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final error = colors.error;

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: colors.surface,
        insetPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorders.xl,
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52.r,
                height: 52.r,
                decoration: BoxDecoration(
                  color: error.withValues(alpha: .06),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 25.r,
                  color: error,
                ),
              ),

              SizedBox(height: AppSpacing.lg),

              Text(
                'Cancel this ride?',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colors.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: AppSpacing.ms),

              Text(
                'Are you sure you want to cancel your\nride?',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.secondary.withValues(alpha: .7),
                  height: 1.6,
                ),
              ),

              SizedBox(height: AppSpacing.lg),

              AppButton(
                label: 'Keep Ride',
                onPressed: onKeepRide,
              ),

              SizedBox(height: AppSpacing.ms),

              CancelRideButton(
                onPressed: onCancelRide,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RideCanceledScreen extends StatelessWidget {
  const RideCanceledScreen({
    super.key,
    required this.onBackHome,
  });

  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Column(
            children: [
              const Spacer(flex: 2),

              Container(
                width: 96.r,
                height: 96.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colors.primary.withValues(alpha: .75),
                      colors.primary,
                    ],
                  ),
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 58.r,
                  color: colors.onPrimary,
                ),
              ),

              SizedBox(height: AppSpacing.xl),

              Text(
                'Ride Canceled',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colors.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: AppSpacing.ms),

              Text(
                'Your ride has been canceled\nsuccessfully.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colors.secondary.withValues(alpha: .7),
                  height: 1.6,
                ),
              ),

              const Spacer(flex: 4),

              AppButton(
                label: 'Back To Home',
                onPressed: onBackHome,
              ),
            ],
          ),
        ),
      ),
    );
  }
}