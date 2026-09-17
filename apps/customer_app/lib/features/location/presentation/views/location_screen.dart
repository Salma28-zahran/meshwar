import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:customer_app/src/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routing/app_routes.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 74.h),

                        // ─────────────────────────────────────────
                        // Location Illustration
                        // ─────────────────────────────────────────
                        Image.asset(
                          ImageAssets.location,
                          width: 300.w,
                          height: 260.h,
                          fit: BoxFit.contain,
                        ),

                        SizedBox(height: 10.h),

                        // ─────────────────────────────────────────
                        // Main title
                        // ─────────────────────────────────────────
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                          ),
                          child: Text(
                            'Go Where You Need, When\nYou Need.',
                            textAlign: TextAlign.center,
                            style: textTheme.headlineMedium?.copyWith(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              height: 1.55,
                              letterSpacing: -0.4,
                              color: AppColors.isDark
                                  ? AppColors.appBlack
                                  : AppColors.secondaryColor,
                            ),
                          ),
                        ),

                        SizedBox(height: 8.h),

                        // ─────────────────────────────────────────
                        // Subtitle
                        // ─────────────────────────────────────────
                        Text(
                          'Rides, deliveries & intercity trips —all in one place.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyLarge?.copyWith(
                            fontSize: 14.5.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            letterSpacing: 0,
                            color: AppColors.textGreyAndWhite,
                          ),
                        ),

                        const Spacer(),

                        // ─────────────────────────────────────────
                        // Use Current Location
                        // ─────────────────────────────────────────
                        AppButton(
                          label: 'Use Current Location',
                          type: AppButtonType.primary,
                          onPressed: () {
                            _useCurrentLocation(context);
                          },
                        ),

                        SizedBox(height: AppSpacing.md),

                        // ─────────────────────────────────────────
                        // Set Location Manually
                        // ─────────────────────────────────────────
                        AppButton(
                          label: 'Set Location Manually',
                          type: AppButtonType.outline,
                          onPressed: () {
                            _setLocationManually(context);
                          },
                        ),

                        SizedBox(height: 38.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Current location
  // ─────────────────────────────────────────────────────────────
  void _useCurrentLocation(BuildContext context) {
    // TODO:
    // 1. Request location permission.
    // 2. Get current location.
    // 3. Save selected location.
    // 4. Navigate to next screen.
    context.push(AppRoutes.home);
  }

  // ─────────────────────────────────────────────────────────────
  // Manual location
  // ─────────────────────────────────────────────────────────────
  void _setLocationManually(BuildContext context) {
    // TODO:
    // Navigator.pushNamed(context, Routes.manualLocation);
    context.push(AppRoutes.whereto);
  }
}