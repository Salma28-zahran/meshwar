import 'package:customer_app/config/routing/app_routes.dart';
import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeActionsWidget extends StatelessWidget {
  const HomeActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _ServicesRow(),

        SizedBox(height: AppSpacing.md),

        const _SearchDestination(),

        SizedBox(height: AppSpacing.ms),

        const _LocationItem(
          text: 'Assiut University',
        ),

        SizedBox(height: AppSpacing.sm),

        const _LocationItem(
          text: 'Al-Azhar Mosque, Assiut',
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Services
// ─────────────────────────────────────────────────────────────────────────────

class _ServicesRow extends StatelessWidget {
  const _ServicesRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
         Expanded(
          child: _ServiceCard(
            icon: Icons.directions_car_filled_rounded,
            title: 'Ride',
            onTap: () {
              context.push(AppRoutes.whereto);
            },
          ),
        ),

        SizedBox(width: AppSpacing.ms),

        Expanded(
          child: _ServiceCard(
            icon: Icons.local_shipping_rounded,
            title: 'City to city',
            onTap: () {
              context.push(AppRoutes.wherecity);
            },
          ),
        ),

        SizedBox(width: AppSpacing.ms),

        const Expanded(
          child: _ServiceCard(
            icon: Icons.delivery_dining_rounded,
            title: 'Delivery',
          ),
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.icon,
    required this.title,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color onPrimary =
        Theme.of(context).colorScheme.onPrimary;

    return Material(
      color: Colors.transparent,
      borderRadius: AppBorders.lg,
      clipBehavior: Clip.antiAlias,
      child: Ink(
        height: 77.h,
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: AppBorders.lg,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppBorders.lg,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 23.sp,
                  color: onPrimary,
                ),

                SizedBox(height: AppSpacing.sm),

                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    letterSpacing: 0,
                    color: onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
// Search Destination
// ─────────────────────────────────────────────────────────────────────────────

class _SearchDestination extends StatelessWidget {
  const _SearchDestination();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppBorders.lg,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: AppBorders.lg,
        onTap: () {
          context.push(AppRoutes.whereto);
        },
        child: Ink(
          width: double.infinity,
          height: 52.h,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.bgColor,
            borderRadius: AppBorders.lg,
            border: Border.all(
              color: AppColors.inputBorderGrey,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 25.sp,
                color: context.secondaryColor,
              ),

              SizedBox(width: AppSpacing.ms),

              Expanded(
                child: Text(
                  'Where to & for how much?',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    fontSize: 12.sp,
                    height: 1.2,
                    letterSpacing: 0,
                    color: AppColors.textGreyAndWhite,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Saved Location Item
// ─────────────────────────────────────────────────────────────────────────────

class _LocationItem extends StatelessWidget {
  const _LocationItem({
    required this.text,
    this.onTap,
  });

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppBorders.sm,
      child: InkWell(
        borderRadius: AppBorders.sm,
        onTap: onTap ?? () {},
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.xs,
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 22.sp,
                color: context.secondaryColor,
              ),

              SizedBox(width: AppSpacing.sm),

              Expanded(
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    fontSize: 12.sp,
                    height: 1.2,
                    letterSpacing: 0,
                    color: AppColors.textGreyAndWhite,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}