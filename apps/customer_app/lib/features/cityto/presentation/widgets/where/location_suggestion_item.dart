import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/features/cityto/data/location_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationSuggestionItem extends StatelessWidget {
  const LocationSuggestionItem({
    super.key,
    required this.option,
    required this.onTap,
  });

  final LocationOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.ms,
        ),
        child: Row(
          children: [
            Icon(
              option.isCountry
                  ? Icons.public_rounded
                  : Icons.location_city_outlined,
              size: 21.sp,
              color: context.primaryColor,
            ),

            SizedBox(width: AppSpacing.ms),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: context.secondaryColor,
                    ),
                  ),

                  if (option.countryName.isNotEmpty) ...[
                    SizedBox(height: AppSpacing.xxs),

                    Text(
                      option.countryName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                        fontSize: 12.sp,
                        color:
                        AppColors.textGreyAndWhite,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}