import 'package:customer_app/config/routing/app_routes.dart';
import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:customer_app/features/ride_type/ride_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({
    super.key,
    required this.fromTitle,
    required this.toTitle,
  });

  final String fromTitle;
  final String toTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: AppSpacing.md,
                    ),

                    const _AddressHeader(),

                    SizedBox(
                      height: AppSpacing.xl,
                    ),

                    const _AddressSection(
                      title: 'Where to pick up',
                      streetHint: '11 orabi street',
                      detailsHint: 'assiut',
                      phoneLabel:
                      'Sender phone number',
                    ),

                    SizedBox(
                      height: AppSpacing.xl,
                    ),

                    const _AddressSection(
                      title: 'Where to deliver',
                      streetHint: '11 orabi street',
                      detailsHint: 'assiut',
                      phoneLabel:
                      'Recipient phone number',
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(
                AppSpacing.md,
              ),
              child: AppButton(
                width: double.infinity,
                label: 'Continue',
                onPressed: () {
                  context.push(
                    AppRoutes.whento,
                    extra: {
                      'fromTitle': fromTitle,
                      'toTitle': toTitle,
                      'rideType': RideType.delivery,
                    },
                  );
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
                context.pop();
              },
              borderRadius: AppBorders.full,
              child: Icon(
                Icons.arrow_back,
                size: 22.r,
                color: AppColors.primaryColor,
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

        _Field(
          label: 'street building',
          hint: streetHint,
          type: TextInputType.streetAddress,
        ),

        SizedBox(height: AppSpacing.ml),

        _Field(
          label: 'Address details',
          hint: detailsHint,
          type: TextInputType.streetAddress,
        ),

        SizedBox(height: AppSpacing.ml),

        _Field(
          label: phoneLabel,
          hint: '+20 | 10XXXXXXXX',
          type: TextInputType.phone,
        ),
      ],
    );
  }
}


class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.hint,
    required this.type,
  });

  final String label;
  final String hint;
  final TextInputType type;

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
            ),
          ),
          child: TextField(
            keyboardType: type,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
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