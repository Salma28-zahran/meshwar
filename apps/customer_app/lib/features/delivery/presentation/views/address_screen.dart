import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSpacing.md),

                    const _AddressHeader(),

                    SizedBox(height: AppSpacing.xl),

                    const _AddressSection(
                      title: 'Where to pick up',
                      streetHint: '11 orabi street',
                      detailsHint: 'assiut',
                      phoneLabel:
                      'Sender phone number',
                    ),

                    SizedBox(height: AppSpacing.xl),

                    const _AddressSection(
                      title: 'Where to deliver',
                      streetHint: '11 orabi street',
                      detailsHint: 'assiut',
                      phoneLabel:
                      'Recipient phone number',
                    ),

                    SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: AppButton(
                width: double.infinity,
                label: 'Continue',
                onPressed: () {
                  // TODO: next screen
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressHeader extends StatelessWidget {
  const _AddressHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                Navigator.of(context).maybePop();
              },
              borderRadius: AppBorders.full,
              child: SizedBox(
                width: 40.r,
                height: 40.r,
                child: Icon(
                  Icons.arrow_back,
                  size: 21.r,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),

          Text(
            'Order Details',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressSection extends StatelessWidget {
  const _AddressSection({
    required this.title,
    required this.streetHint,
    required this.detailsHint,
    required this.phoneLabel,
  });

  final String title;
  final String streetHint;
  final String detailsHint;
  final String phoneLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.secondaryColor,
          ),
        ),

        SizedBox(height: AppSpacing.lg),

        _AddressField(
          label: 'street building',
          hint: streetHint,
          keyboardType: TextInputType.streetAddress,
        ),

        SizedBox(height: AppSpacing.ml),

        _AddressField(
          label: 'Address details',
          hint: detailsHint,
          keyboardType: TextInputType.streetAddress,
        ),

        SizedBox(height: AppSpacing.ml),

        _AddressField(
          label: phoneLabel,
          hint: '+20 | 10XXXXXXXX',
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }
}

class _AddressField extends StatelessWidget {
  const _AddressField({
    required this.label,
    required this.hint,
    required this.keyboardType,
  });

  final String label;
  final String hint;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryColor,
          ),
        ),

        SizedBox(height: AppSpacing.ms),

        Container(
          height: 57.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppBorders.lg,
            border: Border.all(
              color: AppColors.inputBorderGrey,
              width: 1,
            ),
          ),
          child: TextField(
            keyboardType: keyboardType,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
              fontSize: 13.sp,
              color: AppColors.secondaryColor,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                fontSize: 12.sp,
                color: const Color(
                  0xFF8295A9,
                ),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding:
              EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 18.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}