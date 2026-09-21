import 'dart:math' as math;

import 'package:customer_app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class HomeMapWidget extends StatelessWidget {
  const HomeMapWidget({super.key});

  static const LatLng _mapCenter = LatLng(
    27.18096,
    31.18368,
  );

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.paddingOf(context).top;

    return Stack(
      children: [
        Positioned.fill(
          child: FlutterMap(
            options: const MapOptions(
              initialCenter: _mapCenter,
              initialZoom: 13.8,
              minZoom: 3,
              maxZoom: 18,
              backgroundColor: Color(0xFFE7EBEE),
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.customer_app',
                maxNativeZoom: 19,
              ),

              MarkerLayer(
                markers: [
                  Marker(
                    point: const LatLng(
                      27.1900,
                      31.1770,
                    ),
                    width: 45,
                    height: 65,
                    child: const _CarMarker(
                      rotation: -0.15,
                    ),
                  ),
                  Marker(
                    point: const LatLng(
                      27.1747,
                      31.1860,
                    ),
                    width: 45,
                    height: 65,
                    child: const _CarMarker(
                      rotation: 0.25,
                    ),
                  ),
                ],
              ),

              const RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                  ),
                ],
              ),
            ],
          ),
        ),

        Positioned(
          top: statusBarHeight + 12,
          left: 14,
          child: const _MenuButton(),
        ),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black.withValues(
        alpha: .18,
      ),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          Scaffold.of(context).openDrawer();
        },
        child: SizedBox(
          width: 44.r,
          height: 44.r,
          child: Icon(
            Icons.menu_rounded,
            size: 22.r,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
class _CarMarker extends StatelessWidget {
  const _CarMarker({
    this.rotation = 0,
  });

  final double rotation;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: SizedBox(
        width: 43,
        height: 63,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 37,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.18,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.directions_car_filled_rounded,
                    size: 24,
                    color: Color(0xFF68757C),
                  ),

                  Positioned(
                    top: 4,
                    child: Container(
                      width: 12,
                      height: 3,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF5A5A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 5,
              child: Transform.rotate(
                angle: math.pi / 4,
                child: Container(
                  width: 12,
                  height: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}