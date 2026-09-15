import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:customer_app/src/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class Completeprofile extends StatelessWidget {
  const Completeprofile({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePadding,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    children: [
                      SizedBox(height: 8.h),

                      /// Back Button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: context.pop,
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          icon: Icon(
                            Icons.arrow_back,
                            size: 24.r,
                            color: const Color(0xFF02A47D),
                          ),
                        ),
                      ),

                      SizedBox(height: 28.h),

                      /// Logo
                      Image.asset(
                        ImageAssets.logo2,
                        width: 145.w,
                        height: 145.h,
                        fit: BoxFit.contain,
                      ),

                      SizedBox(height: AppSpacing.lg),

                      /// Title
                      Text(
                        'Complete your profile',
                        textAlign: TextAlign.center,
                        style: textTheme.titleLarge?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondaryColor,
                        ),
                      ),

                      SizedBox(height: AppSpacing.ms),

                      /// Subtitle
                      Text(
                        'Add your details to personalize your Meshwar experience.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          fontSize: 13.sp,
                          color: const Color(0xFF6E6E6E),
                        ),
                      ),

                      SizedBox(height: 30.h),

                      /// Full Name
                      _ProfileField(
                        label: 'Full Name',
                        hint: 'Mohamed Fathy',
                        keyboardType: TextInputType.name,
                      ),

                      SizedBox(height: AppSpacing.ml),

                      /// Email
                      _ProfileField(
                        label: 'Email Address',
                        hint: 'mohamedfathy@gamil.com',
                        keyboardType: TextInputType.emailAddress,
                      ),

                      SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),

              /// Continue Button
              AppButton(
                label: 'Continue',
                onPressed: () {

                },
              ),

              SizedBox(height: AppSpacing.ml),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.hint,
    required this.keyboardType,
  });

  final String label;
  final String hint;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            fontSize: 13.sp,
            color: const Color(0xFF0B3155),
          ),
        ),

        SizedBox(height: AppSpacing.sm),

        SizedBox(
          height: 56.h,
          child: TextFormField(
            keyboardType: keyboardType,
            textInputAction: keyboardType == TextInputType.emailAddress
                ? TextInputAction.done
                : TextInputAction.next,
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              color: const Color(0xFF0B3155),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp,
                color: const Color(0xFF8294A8),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              enabledBorder: _border(
                const Color(0xFFC6D1DB),
              ),
              focusedBorder: _border(
                const Color(0xFF02BE8C),
              ),
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide(
        color: color,
        width: 1.2,
      ),
    );
  }
}