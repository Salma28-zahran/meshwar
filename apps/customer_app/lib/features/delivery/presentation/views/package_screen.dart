import 'package:customer_app/config/routing/app_routes.dart';
import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PackageScreen extends StatefulWidget {
  const PackageScreen({super.key});

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  String selectedType = 'Documents';
  String selectedSize = 'Medium';

  int quantity = 1;
  bool isFragile = false;

  final TextEditingController weightController =
  TextEditingController();

  final TextEditingController notesController =
  TextEditingController();

  final List<String> packageTypes = [
    'Documents',
    'Food',
    'Clothes',
    'Electronics',
    'Other',
  ];

  final List<String> sizes = [
    'Small',
    'Medium',
    'Large',
  ];

  @override
  void dispose() {
    weightController.dispose();
    notesController.dispose();
    super.dispose();
  }

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
                  horizontal: 16.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 14.h),

                    const _PackageHeader(),

                    SizedBox(height: 26.h),

                    Text(
                      'What are you sending?',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondaryColor,
                      ),
                    ),

                    SizedBox(height: 17.h),

                    Wrap(
                      spacing: 12.w,
                      runSpacing: 16.h,
                      children: packageTypes.map((type) {
                        return _PackageTypeChip(
                          title: type,
                          isSelected: selectedType == type,
                          onTap: () {
                            setState(() {
                              selectedType = type;
                            });
                          },
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 37.h),

                    Text(
                      'Size Estimate',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryColor,
                      ),
                    ),

                    SizedBox(height: 13.h),

                    Row(
                      children: [
                        Expanded(
                          child: _SizeChip(
                            title: 'Small',
                            isSelected:
                            selectedSize == 'Small',
                            onTap: () {
                              setState(() {
                                selectedSize = 'Small';
                              });
                            },
                          ),
                        ),

                        SizedBox(width: 16.w),

                        Expanded(
                          child: _SizeChip(
                            title: 'Medium',
                            isSelected:
                            selectedSize == 'Medium',
                            onTap: () {
                              setState(() {
                                selectedSize = 'Medium';
                              });
                            },
                          ),
                        ),

                        SizedBox(width: 16.w),

                        Expanded(
                          child: _SizeChip(
                            title: 'Large',
                            isSelected:
                            selectedSize == 'Large',
                            onTap: () {
                              setState(() {
                                selectedSize = 'Large';
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 37.h),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: _WeightField(
                            controller: weightController,
                          ),
                        ),

                        SizedBox(width: 24.w),

                        Expanded(
                          child: _QuantityField(
                            quantity: quantity,
                            onMinus: () {
                              if (quantity <= 1) return;

                              setState(() {
                                quantity--;
                              });
                            },
                            onPlus: () {
                              setState(() {
                                quantity++;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 34.h),

                    _FragileCard(
                      selected: isFragile,
                      onTap: () {
                        setState(() {
                          isFragile = !isFragile;
                        });
                      },
                    ),

                    SizedBox(height: 38.h),

                    Text(
                      'Notes for driver (Optional)',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryColor,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    _NotesField(
                      controller: notesController,
                    ),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                16.w,
                8.h,
                16.w,
                16.h,
              ),
              child: AppButton(
                width: double.infinity,
                label: 'Continue',
                onPressed: () {
                  context.push(
                    AppRoutes.address,
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

// ==========================================================
// HEADER
// ==========================================================

class _PackageHeader extends StatelessWidget {
  const _PackageHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                context.pop();
              },
              borderRadius: BorderRadius.circular(100),
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
            'Package Details',
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

// ==========================================================
// SMALL PACKAGE CHIP
// ==========================================================

class _PackageTypeChip extends StatelessWidget {
  const _PackageTypeChip({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 104.w,
      height: 49.h,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryColor.withValues(
                alpha: 0.08,
              )
                  : AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryColor.withValues(
                  alpha: 0.06,
                )
                    : AppColors.lightBorder,
                width: 1,
              ),
            ),
            child: Text(
              title,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.secondaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// SIZE CHIP
// ==========================================================

class _SizeChip extends StatelessWidget {
  const _SizeChip({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        height: 50.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withValues(
            alpha: 0.08,
          )
              : AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor.withValues(
              alpha: 0.05,
            )
                : AppColors.lightBorder,
          ),
        ),
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
            fontSize: 14.sp,
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.secondaryColor,
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// WEIGHT
// ==========================================================

class _WeightField extends StatelessWidget {
  const _WeightField({
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weight (kg)',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
            fontSize: 12.sp,
            color: AppColors.secondaryColor,
          ),
        ),

        SizedBox(height: 12.h),

        Container(
          height: 58.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.inputBorderGrey,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType:
            const TextInputType.numberWithOptions(
              decimal: true,
            ),
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.secondaryColor,
            ),
            decoration: InputDecoration(
              hintText: '0.0',
              hintStyle: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF8295A9),
              ),
              suffixText: 'Kg',
              suffixStyle: TextStyle(
                fontSize: 11.sp,
                color: const Color(0xFF8295A9),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 18.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================================
// QUANTITY
// ==========================================================

class _QuantityField extends StatelessWidget {
  const _QuantityField({
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
  });

  final int quantity;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
            fontSize: 12.sp,
            color: AppColors.secondaryColor,
          ),
        ),

        SizedBox(height: 12.h),

        Container(
          height: 58.h,
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.inputBorderGrey,
            ),
          ),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: onMinus,
                child: Icon(
                  Icons.remove,
                  size: 21.r,
                  color: const Color(0xFF466482),
                ),
              ),

              Text(
                '$quantity',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF466482),
                ),
              ),

              InkWell(
                onTap: onPlus,
                child: Icon(
                  Icons.add,
                  size: 23.r,
                  color: const Color(0xFF466482),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==========================================================
// FRAGILE
// ==========================================================

class _FragileCard extends StatelessWidget {
  const _FragileCard({
    required this.selected,
    required this.onTap,
  });

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        height: 86.h,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5F4),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFFFFCAC4),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50.r,
              height: 50.r,
              decoration: const BoxDecoration(
                color: Color(0xFFF9DEDE),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.image_outlined,
                size: 23.r,
                color: AppColors.dangerRed,
              ),
            ),

            SizedBox(width: 16.w),

            Expanded(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fragile Items',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      fontSize: 17.sp,
                      fontWeight:
                      FontWeight.w600,
                      color: AppColors
                          .secondaryColor,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  Text(
                    'Handle with extra care',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      fontSize: 12.sp,
                      color: const Color(
                        0xFF60758D,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 25.r,
              height: 25.r,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primaryColor
                    : Colors.transparent,
                borderRadius:
                BorderRadius.circular(4.r),
                border: Border.all(
                  width: 2,
                  color: selected
                      ? AppColors.primaryColor
                      : const Color(
                    0xFF526B86,
                  ),
                ),
              ),
              child: selected
                  ? Icon(
                Icons.check,
                size: 16.r,
                color: Colors.white,
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// NOTES
// ==========================================================

class _NotesField extends StatelessWidget {
  const _NotesField({
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.inputBorderGrey,
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: TextStyle(
          fontSize: 13.sp,
          color: AppColors.secondaryColor,
        ),
        decoration: InputDecoration(
          hintText:
          'Please keep the box upright...',
          hintStyle: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF8295A9),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.fromLTRB(
            18.w,
            20.h,
            18.w,
            16.h,
          ),
        ),
      ),
    );
  }
}