import 'package:customer_app/config/routing/app_routes.dart';
import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/features/cityto/presentation/widgets/when/when_city_bottom_sheet.dart';
import 'package:customer_app/features/cityto/presentation/widgets/when/when_city_map_header.dart';
import 'package:customer_app/features/ride_type/data/ride_data.dart';
import 'package:customer_app/features/ride_type/ride_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class WhenCity extends StatefulWidget {
  const WhenCity({
    super.key,
    required this.from,
    required this.to,
  });

  final String from;
  final String to;

  @override
  State<WhenCity> createState() =>
      _WhenCityState();
}

class _WhenCityState extends State<WhenCity> {
  WhenCityStep _step =
      WhenCityStep.rideTime;

  RideTimeOption _rideTime =
      RideTimeOption.now;

  int _passengers = 4;

  static const LatLng _center = LatLng(
    27.1865,
    31.1710,
  );

  static const List<LatLng> _routePoints = [
    LatLng(27.1930, 31.1665),
    LatLng(27.1905, 31.1680),
    LatLng(27.1880, 31.1690),
    LatLng(27.1850, 31.1705),
    LatLng(27.1815, 31.1725),
  ];

  // ===========================================================================
  // CONTINUE
  // ===========================================================================

  void _continue() {
    // First step:
    // Ride time -> passengers
    if (_step == WhenCityStep.rideTime) {
      setState(() {
        _step =
            WhenCityStep.passengers;
      });

      return;
    }

    // Second step:
    // Pass ride data to VehicleScreen
    final rideData = RideData(
      rideType: RideType.cityToCity,
      from: widget.from,
      to: widget.to,
      passengers: _passengers,
    );

    debugPrint(
      'From: ${rideData.from}',
    );

    debugPrint(
      'To: ${rideData.to}',
    );

    debugPrint(
      'Ride Time: $_rideTime',
    );

    debugPrint(
      'Passengers: ${rideData.passengers}',
    );

    debugPrint(
      'Ride Type: ${rideData.rideType}',
    );

    context.push(
      AppRoutes.vehicle,
      extra: rideData,
    );
  }

  // ===========================================================================
  // PASSENGERS
  // ===========================================================================

  void _increasePassengers() {
    setState(() {
      _passengers++;
    });
  }

  void _decreasePassengers() {
    if (_passengers <= 1) {
      return;
    }

    setState(() {
      _passengers--;
    });
  }

  // ===========================================================================
  // UI
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          // ===================================================================
          // MAP
          // ===================================================================

          WhenCityMapHeader(
            center: _center,
            routePoints: _routePoints,
            from: widget.from,
            to: widget.to,
          ),

          // ===================================================================
          // BOTTOM SHEET
          // ===================================================================

          Align(
            alignment:
            Alignment.bottomCenter,
            child: WhenCityBottomSheet(
              step: _step,
              rideTime: _rideTime,
              passengers: _passengers,

              onRideTimeChanged: (value) {
                setState(() {
                  _rideTime = value;
                });
              },

              onDecreasePassengers:
              _decreasePassengers,

              onIncreasePassengers:
              _increasePassengers,

              onContinue: _continue,
            ),
          ),
        ],
      ),
    );
  }
}