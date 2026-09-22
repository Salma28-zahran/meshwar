import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:customer_app/core/widgets/app_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class WhenCityMapHeader extends StatelessWidget {
  const WhenCityMapHeader({
    super.key,
    required this.center,
    required this.routePoints,
    required this.from,
    required this.to,
  });

  final LatLng center;
  final List<LatLng> routePoints;
  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 0.62.sh,
      child: Stack(
        children: [
          Positioned.fill(
            child: AppMap(
              center: center,
              zoom: 13.5,
              routePoints: routePoints,
              markers: [
                if (routePoints.isNotEmpty)
                  AppMapMarker(
                    point: routePoints.first,
                    child: Icon(
                      Icons.location_on_rounded,
                      size: 36.sp,
                      color: context.primaryColor,
                    ),
                  ),
              ],
            ),
          ),

          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.sm,
              ),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  _MapBackButton(
                    onTap: () {
                      context.pop();
                    },
                  ),

                  SizedBox(
                    width: AppSpacing.ms,
                  ),

                  Expanded(
                    child: _RouteCard(
                      from: from,
                      to: to,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapBackButton extends StatelessWidget {
  const _MapBackButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 48.r,
          height: 48.r,
          child: Icon(
            Icons.arrow_back_rounded,
            size: 24.sp,
            color: context.secondaryColor,
          ),
        ),
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.from,
    required this.to,
  });

  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgColor,
      borderRadius: AppBorders.lg,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.ms,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _RouteLine(),

            SizedBox(
              width: AppSpacing.ms,
            ),

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  _RouteText(
                    text: from,
                  ),

                  SizedBox(
                    height: AppSpacing.ml,
                  ),

                  _RouteText(
                    text: to,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteLine extends StatelessWidget {
  const _RouteLine();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.r,
          height: 10.r,
          decoration: BoxDecoration(
            color: context.primaryColor,
            shape: BoxShape.circle,
          ),
        ),

        Container(
          width: 1.w,
          height: 30.h,
          color: AppColors.inputBorderGrey,
        ),

        Container(
          width: 10.r,
          height: 10.r,
          decoration: BoxDecoration(
            color: context.secondaryColor,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

class _RouteText extends StatelessWidget {
  const _RouteText({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
        color: context.secondaryColor,
      ),
    );
  }
}