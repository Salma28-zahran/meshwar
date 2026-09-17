import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class WhentoMapSection extends StatelessWidget {
  const WhentoMapSection({
    super.key,
    required this.fromTitle,
    required this.toTitle,
    required this.fromPoint,
    required this.toPoint,
    required this.safeTop,
    required this.bottomSheetHeight,
    required this.onBack,
  });

  final String fromTitle;
  final String toTitle;

  final LatLng fromPoint;
  final LatLng toPoint;

  final double safeTop;
  final double bottomSheetHeight;

  final VoidCallback onBack;

  LatLng _pointBetween(
      double value,
      ) {
    return LatLng(
      fromPoint.latitude +
          (toPoint.latitude -
              fromPoint.latitude) *
              value,
      fromPoint.longitude +
          (toPoint.longitude -
              fromPoint.longitude) *
              value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ===================================================================
        // MAP
        // ===================================================================

        Positioned.fill(
          child: FlutterMap(
            options: MapOptions(
              initialCameraFit:
              CameraFit.coordinates(
                coordinates: [
                  fromPoint,
                  toPoint,
                ],
                padding: EdgeInsets.only(
                  left: 60,
                  right: 60,
                  top: safeTop + 140,
                  bottom:
                  bottomSheetHeight *
                      0.58,
                ),
                maxZoom: 15.5,
              ),
              interactionOptions:
              const InteractionOptions(
                flags:
                InteractiveFlag.all,
              ),
            ),
            children: [
              // ============================================================
              // TILES
              // ============================================================

              TileLayer(
                urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                'com.meshwar.customer_app',
              ),

              // ============================================================
              // ROUTE
              // ============================================================

              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [
                      fromPoint,
                      _pointBetween(0.28),
                      _pointBetween(0.55),
                      _pointBetween(0.76),
                      toPoint,
                    ],
                    strokeWidth: 4,
                    color:
                    AppColors.primaryColor,
                    pattern:
                    StrokePattern.dashed(
                      segments: [
                        8,
                        8,
                      ],
                    ),
                  ),
                ],
              ),

              // ============================================================
              // MARKERS
              // ============================================================

              MarkerLayer(
                markers: [
                  // Destination
                  Marker(
                    point: toPoint,
                    width: 44,
                    height: 52,
                    alignment:
                    Alignment.bottomCenter,
                    child: const Icon(
                      Icons.location_on,
                      size: 44,
                      color: Color(
                        0xFFE94A4A,
                      ),
                    ),
                  ),

                  // Car 1
                  Marker(
                    point:
                    _pointBetween(0.43),
                    width: 42,
                    height: 58,
                    child:
                    const _CarMarker(),
                  ),

                  // Car 2
                  Marker(
                    point:
                    _pointBetween(0.82),
                    width: 42,
                    height: 58,
                    child: Transform.rotate(
                      angle: 0.12,
                      child:
                      const _CarMarker(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ===================================================================
        // TOP
        // ===================================================================

        Positioned(
          top: safeTop + 14,
          left: AppSpacing.md,
          right: AppSpacing.md,
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              _BackButton(
                onTap: onBack,
              ),

              SizedBox(
                width:
                AppSpacing.ms,
              ),

              Expanded(
                child:
                _LocationSummaryCard(
                  fromTitle:
                  fromTitle,
                  toTitle:
                  toTitle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// LOCATION SUMMARY
// =============================================================================

class _LocationSummaryCard
    extends StatelessWidget {
  const _LocationSummaryCard({
    required this.fromTitle,
    required this.toTitle,
  });

  final String fromTitle;
  final String toTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints:
      const BoxConstraints(
        minHeight: 92,
      ),
      padding:
      EdgeInsets.symmetric(
        horizontal:
        AppSpacing.md,
        vertical:
        AppSpacing.ms,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        AppBorders.lg,
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(
              alpha: 0.10,
            ),
            blurRadius: 15,
            offset:
            const Offset(
              0,
              3,
            ),
          ),
        ],
      ),
      child: Row(
        children: [
          // ===============================================================
          // DOTS
          // ===============================================================

          SizedBox(
            width: 20,
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              children: [
                Container(
                  width: 11,
                  height: 11,
                  decoration:
                  const BoxDecoration(
                    color:
                    AppColors
                        .primaryColor,
                    shape:
                    BoxShape.circle,
                  ),
                ),

                Container(
                  width: 2,
                  height: 28,
                  color:
                  const Color(
                    0xFFE0E5E8,
                  ),
                ),

                Container(
                  width: 11,
                  height: 11,
                  decoration:
                  const BoxDecoration(
                    color:
                    AppColors
                        .secondaryColor,
                    shape:
                    BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width:
            AppSpacing.ms,
          ),

          // ===============================================================
          // TEXT
          // ===============================================================

          Expanded(
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  fromTitle.isEmpty
                      ? 'Starting location'
                      : fromTitle,
                  maxLines: 1,
                  overflow:
                  TextOverflow
                      .ellipsis,
                  style:
                  Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    fontSize: 14,
                    height: 1.2,
                    fontWeight:
                    FontWeight
                        .w400,
                    letterSpacing: 0,
                    color: AppColors
                        .secondaryColor,
                  ),
                ),

                SizedBox(
                  height:
                  AppSpacing.ml,
                ),

                Text(
                  toTitle.isEmpty
                      ? 'Destination'
                      : toTitle,
                  maxLines: 1,
                  overflow:
                  TextOverflow
                      .ellipsis,
                  style:
                  Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    fontSize: 14,
                    height: 1.2,
                    fontWeight:
                    FontWeight
                        .w400,
                    letterSpacing: 0,
                    color: AppColors
                        .secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// BACK BUTTON
// =============================================================================

class _BackButton
    extends StatelessWidget {
  const _BackButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape:
      const CircleBorder(),
      elevation: 2,
      shadowColor:
      Colors.black.withValues(
        alpha: 0.12,
      ),
      child: InkWell(
        onTap: onTap,
        customBorder:
        const CircleBorder(),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            Icons
                .arrow_back_rounded,
            size: 24,
            color: AppColors
                .secondaryColor,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// CAR
// =============================================================================

class _CarMarker
    extends StatelessWidget {
  const _CarMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 47,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(
          13,
        ),
        border: Border.all(
          color:
          const Color(
            0xFF9DA7AE,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(
              alpha: 0.18,
            ),
            blurRadius: 5,
            offset:
            const Offset(
              0,
              2,
            ),
          ),
        ],
      ),
      alignment:
      Alignment.center,
      child: Icon(
        Icons
            .directions_car_filled,
        size: 24,
        color: AppColors
            .secondaryColor,
      ),
    );
  }
}