import 'package:customer_app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WhereCityHeader extends StatelessWidget {
  const WhereCityHeader({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onBack,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                Icons.arrow_back_rounded,
                size: 25.sp,
                color: context.primaryColor,
              ),
            ),
          ),

          Text(
            'where To',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: context.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}