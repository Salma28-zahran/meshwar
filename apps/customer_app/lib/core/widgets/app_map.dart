import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AppMapMarker {
  const AppMapMarker({
    required this.point,
    required this.child,
    this.width = 44,
    this.height = 54,
  });

  final LatLng point;
  final Widget child;
  final double width;
  final double height;
}

class AppMap extends StatelessWidget {
  const AppMap({
    super.key,
    required this.center,
    this.zoom = 14.2,
    this.markers = const [],
    this.routePoints = const [],
  });

  final LatLng center;
  final double zoom;
  final List<AppMapMarker> markers;
  final List<LatLng> routePoints;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: zoom,
      ),
      children: [
        TileLayer(
          urlTemplate:
          'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
        ),

        if (routePoints.length > 1)
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                strokeWidth: 3,
                color: colors.primary,
                pattern:  StrokePattern.dashed(
                  segments: [8, 7],
                ),
              ),
            ],
          ),

        MarkerLayer(
          markers: markers
              .map(
                (marker) => Marker(
              point: marker.point,
              width: marker.width,
              height: marker.height,
              child: marker.child,
            ),
          )
              .toList(),
        ),
      ],
    );
  }
}