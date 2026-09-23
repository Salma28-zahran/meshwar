import 'package:customer_app/config/routing/app_routes.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_map.dart';

class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({super.key});

  static const LatLng _center = LatLng(
    27.1865,
    31.1710,
  );

  static const LatLng _destination = LatLng(
    27.1914,
    31.1668,
  );

  static const List<LatLng> _routePoints = [
    LatLng(27.1914, 31.1668),
    LatLng(27.1903, 31.1670),
    LatLng(27.1891, 31.1676),
    LatLng(27.1878, 31.1681),
    LatLng(27.1862, 31.1688),
    LatLng(27.1847, 31.1697),
    LatLng(27.1832, 31.1708),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: AppMap(
              center: _center,
              zoom: 14.3,
              routePoints: _routePoints,
              markers: [
                AppMapMarker(
                  point: _destination,
                  width: 46.r,
                  height: 54.r,
                  child: Icon(
                    Icons.location_on,
                    size: 46.r,
                    color: AppColors.dangerRed,
                  ),
                ),
              ],
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.lg,
                top: AppSpacing.md,
              ),
              child: _BackButton(
                onTap: () => Navigator.of(context).maybePop(),
              ),
            ),
          ),

          const Align(
            alignment: Alignment.bottomCenter,
            child: _DeliveryBottomCard(),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: const CircleBorder(),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 48.r,
          height: 48.r,
          child: Icon(
            Icons.arrow_back,
            size: 24.r,
            color: AppColors.secondaryColor,
          ),
        ),
      ),
    );
  }
}

class _DeliveryBottomCard extends StatelessWidget {
  const _DeliveryBottomCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.ml,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(18),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delivery',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 25.sp,
              ),
            ),

            SizedBox(height: AppSpacing.md),

            const _CurrentLocation(),

            SizedBox(height: AppSpacing.ml),

            _DeliveryOption(
              icon: Icons.search,
              title: 'To',
              onTap: () {
                context.push(AppRoutes.whered);
              },
            ),

            SizedBox(height: AppSpacing.md),

            const _DeliveryOption(
              icon: Icons.tune,
              title: 'order details',
              showArrow: true,
            ),

            SizedBox(height: AppSpacing.md),

            const _DeliveryOption(
              icon: Icons.account_balance_wallet_outlined,
              title: 'offer you fare',
              showArrow: true,
            ),

            SizedBox(height: AppSpacing.xl),

            AppButton(
              width: double.infinity,
              label: 'Find a courier',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
class _CurrentLocation extends StatelessWidget {
  const _CurrentLocation();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 11.r,
            height: 11.r,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
          ),

          SizedBox(width: AppSpacing.ms),

          Text(
            'Assiut University',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.secondaryColor,
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryOption extends StatelessWidget {
  const _DeliveryOption({
    required this.icon,
    required this.title,
    this.showArrow = false,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final bool showArrow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppBorders.lg,
        child: Container(
          width: double.infinity,
          height: 61.h,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            borderRadius: AppBorders.lg,
            border: Border.all(
              color: AppColors.inputBorderGrey,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 25.r,
                color: const Color(0xFF466482),
              ),

              SizedBox(width: AppSpacing.ms),

              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(
                    fontSize: 14.sp,
                    color: const Color(0xFF536D88),
                  ),
                ),
              ),

              if (showArrow)
                Icon(
                  Icons.chevron_right,
                  size: 28.r,
                  color: const Color(0xFF466482),
                ),
            ],
          ),
        ),
      ),
    );
  }
}