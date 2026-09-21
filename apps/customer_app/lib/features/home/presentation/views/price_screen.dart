import 'dart:async';

import 'package:customer_app/config/routing/app_routes.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:customer_app/core/widgets/app_map.dart';
import 'package:customer_app/features/home/data/ride_demo_data.dart';
import 'package:customer_app/features/home/data/ride_models.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_cancel_widgets.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_common_widgets.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_driver_status_sheets.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_driver_widgets.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_offer_sheets.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_progress_sheet.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_review_sheet.dart';
import 'package:customer_app/features/home/presentation/widgets/price/ride_top_widgets.dart';
import 'package:customer_app/features/ride_type/data/ride_data.dart';
import 'package:customer_app/features/ride_type/ride_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({
    super.key,
    this.rideData,
  });

  final RideData? rideData;

  @override
  State<PriceScreen> createState() =>
      _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  RideStage _stage = RideStage.price;

  DriverInfo? _selectedDriver;

  Timer? _findingTimer;
  Timer? _statusTimer;

  int _offer = 220;

  // ===========================================================================
  // RIDE DATA
  // ===========================================================================

  bool get _isCityToCity {
    return widget.rideData?.rideType ==
        RideType.cityToCity;
  }

  DriverInfo get _driver {
    return _selectedDriver ??
        RideDemoData.drivers.first;
  }

  bool get _showRoute => switch (_stage) {
    RideStage.selectDriver ||
    RideStage.reviewRide ||
    RideStage.driverOnWay ||
    RideStage.driverArrived ||
    RideStage.rideInProgress =>
    true,
    _ => false,
  };

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  @override
  void dispose() {
    _cancelTimers();

    super.dispose();
  }

  void _cancelTimers() {
    _findingTimer?.cancel();
    _statusTimer?.cancel();

    _findingTimer = null;
    _statusTimer = null;
  }

  // ===========================================================================
  // STAGE
  // ===========================================================================

  void _setStage(RideStage stage) {
    if (!mounted || _stage == stage) {
      return;
    }

    setState(() {
      _stage = stage;
    });
  }

  // ===========================================================================
  // OFFER
  // ===========================================================================

  void _increaseOffer() {
    setState(() {
      _offer += 10;
    });
  }

  void _decreaseOffer() {
    if (_offer <= 10) {
      return;
    }

    setState(() {
      _offer -= 10;
    });
  }

  // ===========================================================================
  // RIDE FLOW
  // ===========================================================================

  void _findDriver() {
    _setStage(
      RideStage.findingDriver,
    );

    _startFindingDriverTimer();
  }

  void _startFindingDriverTimer() {
    _findingTimer?.cancel();

    _findingTimer = Timer(
      const Duration(seconds: 2),
          () {
        if (!mounted ||
            _stage !=
                RideStage.findingDriver) {
          return;
        }

        _setStage(
          RideStage.selectDriver,
        );
      },
    );
  }

  void _selectDriver(
      DriverInfo driver,
      ) {
    _cancelTimers();

    setState(() {
      _selectedDriver = driver;
      _stage = RideStage.reviewRide;
    });
  }

  void _changeOffer() {
    _cancelTimers();

    setState(() {
      _selectedDriver = null;
      _stage = RideStage.price;
    });
  }

  void _confirmRide() {
    _setStage(
      RideStage.driverOnWay,
    );

    _startDriverOnWayTimer();
  }

  void _startDriverOnWayTimer() {
    _scheduleStatus(
      const Duration(seconds: 4),
      expectedStage:
      RideStage.driverOnWay,
      action: () {
        _setStage(
          RideStage.driverArrived,
        );

        _startDriverArrivedTimer();
      },
    );
  }

  void _startDriverArrivedTimer() {
    _scheduleStatus(
      const Duration(seconds: 4),
      expectedStage:
      RideStage.driverArrived,
      action: () {
        _setStage(
          RideStage.rideInProgress,
        );

        _startRideInProgressTimer();
      },
    );
  }

  void _startRideInProgressTimer() {
    _scheduleStatus(
      const Duration(seconds: 5),
      expectedStage:
      RideStage.rideInProgress,
      action: _openSuccessScreen,
    );
  }

  void _scheduleStatus(
      Duration duration, {
        required RideStage expectedStage,
        required VoidCallback action,
      }) {
    _statusTimer?.cancel();

    _statusTimer = Timer(
      duration,
          () {
        if (!mounted ||
            _stage != expectedStage) {
          return;
        }

        action();
      },
    );
  }

  void _resumeAutomaticFlow() {
    switch (_stage) {
      case RideStage.findingDriver:
        _startFindingDriverTimer();
        return;

      case RideStage.driverOnWay:
        _startDriverOnWayTimer();
        return;

      case RideStage.driverArrived:
        _startDriverArrivedTimer();
        return;

      case RideStage.rideInProgress:
        _startRideInProgressTimer();
        return;

      default:
        return;
    }
  }

  // ===========================================================================
  // SUCCESS
  // ===========================================================================

  void _openSuccessScreen() {
    if (!mounted ||
        _stage == RideStage.cancelled) {
      return;
    }

    _cancelTimers();

    context.go(
      AppRoutes.success,
      extra: {
        'driver': _driver,
        'totalFare': _offer,

        // City to City data
        'rideData': widget.rideData,
      },
    );
  }

  // ===========================================================================
  // CANCEL RIDE
  // ===========================================================================

  Future<void>
  _requestCancelRide() async {
    if (_stage == RideStage.cancelled) {
      return;
    }

    _cancelTimers();

    final shouldCancel =
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return CancelRideDialog(
          onKeepRide: () {
            Navigator.of(
              dialogContext,
            ).pop(false);
          },
          onCancelRide: () {
            Navigator.of(
              dialogContext,
            ).pop(true);
          },
        );
      },
    );

    if (!mounted) {
      return;
    }

    if (shouldCancel == true) {
      _confirmCancelRide();
      return;
    }

    _resumeAutomaticFlow();
  }

  void _confirmCancelRide() {
    _cancelTimers();

    setState(() {
      _selectedDriver = null;
      _stage = RideStage.cancelled;
    });
  }

  void _backToHome() {
    _cancelTimers();

    context.go(
      AppRoutes.home,
    );
  }

  // ===========================================================================
  // BACK
  // ===========================================================================

  void _back() {
    switch (_stage) {
      case RideStage.price:
        Navigator.maybePop(context);
        return;

      case RideStage.findingDriver:
        _requestCancelRide();
        return;

      case RideStage.selectDriver:
        _setStage(
          RideStage.price,
        );
        return;

      case RideStage.reviewRide:
        _setStage(
          RideStage.selectDriver,
        );
        return;

      case RideStage.driverOnWay:
      case RideStage.driverArrived:
        _statusTimer?.cancel();

        _setStage(
          RideStage.reviewRide,
        );
        return;

      case RideStage.rideInProgress:
        _statusTimer?.cancel();

        Navigator.maybePop(context);
        return;

      case RideStage.cancelled:
        _backToHome();
        return;
    }
  }

  // ===========================================================================
  // UI
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    if (_stage ==
        RideStage.cancelled) {
      return RideCanceledScreen(
        onBackHome: _backToHome,
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // ===================================================================
          // MAP
          // ===================================================================

          Positioned.fill(
            child: AppMap(
              center:
              RideDemoData.center,
              zoom: 14.2,
              markers: _markers,
              routePoints: _showRoute
                  ? RideDemoData.route
                  : const [],
            ),
          ),

          // ===================================================================
          // TOP
          // ===================================================================

          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(
                AppSpacing.md,
              ),
              child: _topContent,
            ),
          ),

          // ===================================================================
          // BOTTOM SHEET
          // ===================================================================

          Align(
            alignment:
            Alignment.bottomCenter,
            child: AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 250,
              ),
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

  // ===========================================================================
  // TOP CONTENT
  // ===========================================================================

  Widget get _topContent {
    final title = switch (_stage) {
      RideStage.reviewRide =>
      'Review Your Ride',
      RideStage.driverOnWay =>
      'On the way',
      RideStage.driverArrived =>
      'Driver Arrived',
      RideStage.rideInProgress =>
      'Trip in Progress',
      _ => null,
    };

    if (title != null) {
      return RideStatusTopBar(
        title: title,
        onBack: _back,
      );
    }

    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        RideBackButton(
          onPressed: _back,
        ),

        SizedBox(
          width: AppSpacing.sm,
        ),

        Expanded(
          child: _isCityToCity &&
              widget.rideData != null
              ? _CityToCityLocationCard(
            rideData:
            widget.rideData!,
          )
              : const RideLocationCard(),
        ),
      ],
    );
  }

  // ===========================================================================
  // BOTTOM CONTENT
  // ===========================================================================

  Widget get _bottomContent =>
      switch (_stage) {
        RideStage.price =>
            PriceOfferSheet(
              offer: _offer,
              onIncrease:
              _increaseOffer,
              onDecrease:
              _decreaseOffer,
              onFindDriver:
              _findDriver,
            ),

        RideStage.findingDriver =>
            FindingDriverSheet(
              offer: _offer,
              onCancel:
              _requestCancelRide,
            ),

        RideStage.selectDriver =>
            SelectDriverSheet(
              offer: _offer,
              drivers:
              RideDemoData.drivers,
              onDriverSelected:
              _selectDriver,
              onChangeOffer:
              _changeOffer,
              onCancel:
              _requestCancelRide,
            ),

        RideStage.reviewRide =>
            ReviewRideSheet(
              driver: _driver,
              offer: _offer,
              onConfirm:
              _confirmRide,
            ),

        RideStage.driverOnWay =>
            DriverOnWaySheet(
              driver: _driver,
              onCancel:
              _requestCancelRide,
            ),

        RideStage.driverArrived =>
            DriverArrivedSheet(
              driver: _driver,
              fare: _offer,
              onCancel:
              _requestCancelRide,
            ),

        RideStage.rideInProgress =>
            RideInProgressSheet(
              driver: _driver,
              fare: _offer,
              onShare: () {},
            ),

        RideStage.cancelled =>
        const SizedBox.shrink(),
      };

  // ===========================================================================
  // MAP MARKERS
  // ===========================================================================

  List<AppMapMarker> get _markers {
    if (_stage == RideStage.price) {
      return const [
        AppMapMarker(
          point:
          RideDemoData.car,
          child: MapCarMarker(),
        ),
        AppMapMarker(
          point:
          RideDemoData.nearbyCar,
          child: MapCarMarker(),
        ),
      ];
    }

    if (_stage ==
        RideStage.findingDriver) {
      return const [
        AppMapMarker(
          point:
          RideDemoData.car,
          child: MapCarMarker(),
        ),
      ];
    }

    return const [
      AppMapMarker(
        point:
        RideDemoData.pickup,
        child: MapPickupMarker(),
      ),
      AppMapMarker(
        point:
        RideDemoData.car,
        child: MapCarMarker(),
      ),
    ];
  }
}

// =============================================================================
// CITY TO CITY LOCATION CARD
// =============================================================================

class _CityToCityLocationCard
    extends StatelessWidget {
  const _CityToCityLocationCard({
    required this.rideData,
  });

  final RideData rideData;

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context)
            .colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.ms,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius:
        AppBorders.lg,
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration:
                BoxDecoration(
                  color:
                  colors.primary,
                  shape:
                  BoxShape.circle,
                ),
              ),

              Container(
                width: 1,
                height: 28,
                color: colors
                    .outlineVariant,
              ),

              Container(
                width: 10,
                height: 10,
                decoration:
                BoxDecoration(
                  color:
                  colors.secondary,
                  shape:
                  BoxShape.circle,
                ),
              ),
            ],
          ),

          SizedBox(
            width: AppSpacing.ms,
          ),

          Expanded(
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  rideData.from,
                  maxLines: 1,
                  overflow:
                  TextOverflow
                      .ellipsis,
                  style:
                  Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color: colors
                        .secondary,
                    fontWeight:
                    FontWeight
                        .w500,
                  ),
                ),

                SizedBox(
                  height:
                  AppSpacing.md,
                ),

                Text(
                  rideData.to,
                  maxLines: 1,
                  overflow:
                  TextOverflow
                      .ellipsis,
                  style:
                  Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color: colors
                        .secondary,
                    fontWeight:
                    FontWeight
                        .w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: AppSpacing.sm,
          ),

          Column(
            crossAxisAlignment:
            CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize:
                MainAxisSize.min,
                children: [
                  Icon(
                    Icons
                        .person_outline_rounded,
                    size: 16,
                    color:
                    colors.primary,
                  ),

                  SizedBox(
                    width:
                    AppSpacing.xs,
                  ),

                  Text(
                    '${rideData.passengers}',
                    style:
                    Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(
                      color: colors
                          .secondary,
                    ),
                  ),
                ],
              ),

              if (rideData.vehicleName !=
                  null) ...[
                SizedBox(
                  height:
                  AppSpacing.sm,
                ),

                Text(
                  rideData.vehicleName!,
                  style:
                  Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(
                    color: colors
                        .primary,
                    fontWeight:
                    FontWeight
                        .w600,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}