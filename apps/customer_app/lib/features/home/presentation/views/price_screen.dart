import 'dart:async';

import 'package:customer_app/config/routing/app_routes.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_map.dart';
import 'package:customer_app/features/home/data/ride_demo_data.dart';
import 'package:customer_app/features/home/data/ride_models.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_common_widgets.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_driver_status_sheets.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_driver_widgets.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_offer_sheets.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_progress_sheet.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_review_sheet.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_top_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  RideStage _stage = RideStage.price;
  DriverInfo? _selectedDriver;

  Timer? _findingTimer;
  Timer? _statusTimer;

  int _offer = 220;

  DriverInfo get _driver =>
      _selectedDriver ?? RideDemoData.drivers.first;

  bool get _showRoute => switch (_stage) {
    RideStage.selectDriver ||
    RideStage.reviewRide ||
    RideStage.driverOnWay ||
    RideStage.rideInProgress =>
    true,
    _ => false,
  };

  @override
  void dispose() {
    _findingTimer?.cancel();
    _statusTimer?.cancel();
    super.dispose();
  }

  void _setStage(RideStage stage) {
    if (!mounted || _stage == stage) return;
    setState(() => _stage = stage);
  }

  void _increaseOffer() => setState(() => _offer += 10);

  void _decreaseOffer() {
    if (_offer > 10) {
      setState(() => _offer -= 10);
    }
  }

  // ---------------------------------------------------------------------------
  // Ride flow
  // ---------------------------------------------------------------------------

  void _findDriver() {
    _setStage(RideStage.findingDriver);
    _findingTimer?.cancel();

    _findingTimer = Timer(
      const Duration(seconds: 2),
          () {
        if (!mounted || _stage != RideStage.findingDriver) return;
        _setStage(RideStage.selectDriver);
      },
    );
  }

  void _selectDriver(DriverInfo driver) {
    setState(() {
      _selectedDriver = driver;
      _stage = RideStage.reviewRide;
    });
  }

  void _changeOffer() {
    setState(() {
      _selectedDriver = null;
      _stage = RideStage.price;
    });
  }

  void _confirmRide() {
    _setStage(RideStage.driverOnWay);

    // Demo flow until API statuses are connected.
    _scheduleStatus(
      const Duration(seconds: 4),
      expectedStage: RideStage.driverOnWay,
      action: () {
        _setStage(RideStage.driverArrived);

        _scheduleStatus(
          const Duration(seconds: 4),
          expectedStage: RideStage.driverArrived,
          action: () {
            _setStage(RideStage.rideInProgress);

            _scheduleStatus(
              const Duration(seconds: 5),
              expectedStage: RideStage.rideInProgress,
              action: _openSuccessScreen,
            );
          },
        );
      },
    );
  }

  void _scheduleStatus(
      Duration duration, {
        required RideStage expectedStage,
        required VoidCallback action,
      }) {
    _statusTimer?.cancel();

    _statusTimer = Timer(duration, () {
      if (!mounted || _stage != expectedStage) return;
      action();
    });
  }

  void _openSuccessScreen() {
    if (!mounted) return;

    _statusTimer?.cancel();

    context.go(
      AppRoutes.success,
      extra: {
        'driver': _driver,
        'totalFare': _offer,
      },
    );
  }

  void _cancelRide() {
    _findingTimer?.cancel();
    _statusTimer?.cancel();

    setState(() {
      _selectedDriver = null;
      _stage = RideStage.price;
    });
  }

  void _back() {
    switch (_stage) {
      case RideStage.price:
        Navigator.maybePop(context);

      case RideStage.findingDriver:
        _cancelRide();

      case RideStage.selectDriver:
        _setStage(RideStage.price);

      case RideStage.reviewRide:
        _setStage(RideStage.selectDriver);

      case RideStage.driverOnWay:
      case RideStage.driverArrived:
        _statusTimer?.cancel();
        _setStage(RideStage.reviewRide);

      case RideStage.rideInProgress:
        _statusTimer?.cancel();
        Navigator.maybePop(context);
    }
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AppMap(
              center: RideDemoData.center,
              zoom: 14.2,
              markers: _markers,
              routePoints:
              _showRoute ? RideDemoData.route : const [],
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: _topContent,
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: RideSheetShell(
                key: ValueKey(_stage),
                child: _bottomContent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _topContent {
    final title = switch (_stage) {
      RideStage.reviewRide => 'Review Your Ride',
      RideStage.driverOnWay => 'On the way',
      RideStage.driverArrived => 'Driver Arrived',
      RideStage.rideInProgress => 'Trip in Progress',
      _ => null,
    };

    if (title != null) {
      return RideStatusTopBar(
        title: title,
        onBack: _back,
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RideBackButton(onPressed: _back),
        SizedBox(width: AppSpacing.sm),
        const Expanded(child: RideLocationCard()),
      ],
    );
  }

  Widget get _bottomContent => switch (_stage) {
    RideStage.price => PriceOfferSheet(
      offer: _offer,
      onIncrease: _increaseOffer,
      onDecrease: _decreaseOffer,
      onFindDriver: _findDriver,
    ),
    RideStage.findingDriver => FindingDriverSheet(
      offer: _offer,
      onCancel: _cancelRide,
    ),
    RideStage.selectDriver => SelectDriverSheet(
      offer: _offer,
      drivers: RideDemoData.drivers,
      onDriverSelected: _selectDriver,
      onChangeOffer: _changeOffer,
      onCancel: _cancelRide,
    ),
    RideStage.reviewRide => ReviewRideSheet(
      driver: _driver,
      offer: _offer,
      onConfirm: _confirmRide,
    ),
    RideStage.driverOnWay => DriverOnWaySheet(
      driver: _driver,
      onCancel: _cancelRide,
    ),
    RideStage.driverArrived => DriverArrivedSheet(
      driver: _driver,
      fare: _offer,
      onCancel: _cancelRide,
    ),
    RideStage.rideInProgress => RideInProgressSheet(
      driver: _driver,
      fare: _offer,
      onShare: () {},
    ),
  };

  List<AppMapMarker> get _markers {
    if (_stage == RideStage.price) {
      return const [
        AppMapMarker(
          point: RideDemoData.car,
          child: MapCarMarker(),
        ),
        AppMapMarker(
          point: RideDemoData.nearbyCar,
          child: MapCarMarker(),
        ),
      ];
    }

    if (_stage == RideStage.findingDriver) {
      return const [
        AppMapMarker(
          point: RideDemoData.car,
          child: MapCarMarker(),
        ),
      ];
    }

    return const [
      AppMapMarker(
        point: RideDemoData.pickup,
        child: MapPickupMarker(),
      ),
      AppMapMarker(
        point: RideDemoData.car,
        child: MapCarMarker(),
      ),
    ];
  }
}