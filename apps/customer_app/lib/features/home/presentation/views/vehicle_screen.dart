import 'package:customer_app/config/routing/app_routes.dart';
import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:customer_app/features/ride_type/data/ride_data.dart';
import 'package:customer_app/features/ride_type/ride_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({
    super.key,
    this.rideType = RideType.normal,
    this.rideData,
  });

  final RideType rideType;
  final RideData? rideData;

  @override
  State<VehicleScreen> createState() =>
      _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  int _selectedIndex = 0;

  // ===========================================================================
  // CURRENT RIDE TYPE
  // ===========================================================================

  RideType get _currentRideType {
    return widget.rideData?.rideType ??
        widget.rideType;
  }

  // ===========================================================================
  // NORMAL RIDE VEHICLES
  // ===========================================================================

  static const List<_VehicleModel> _normalVehicles = [
    _VehicleModel(
      title: 'Economy',
      description: 'Affordable everyday rides',
      capacity: '1–4',
      price: 'EGP 250',
      imagePath: 'assets/images/economy.png',
      isBestValue: true,
    ),
    _VehicleModel(
      title: 'Comfort',
      description: 'More comfortable vehicles',
      capacity: '1–4',
      price: 'EGP 270',
      imagePath: 'assets/images/comfort.png',
    ),
    _VehicleModel(
      title: 'XL',
      description: 'For groups and extra space',
      capacity: 'Up to 6',
      price: 'EGP 280',
      imagePath: 'assets/images/xl.png',
    ),
    _VehicleModel(
      title: 'Premium',
      description: 'Premium vehicles & extra comfort',
      capacity: '1–4',
      price: 'EGP 300',
      imagePath: 'assets/images/economy.png',
    ),
    _VehicleModel(
      title: 'Bus',
      description: 'Reserved seat',
      capacity: 'Up to 45 seats',
      price: 'From EGP 40',
      imagePath: 'assets/images/bus.png',
    ),
  ];

  // ===========================================================================
  // CITY TO CITY VEHICLES
  // ===========================================================================

  static const List<_VehicleModel> _cityToCityVehicles = [
    _VehicleModel(
      title: 'Motorcycle',
      description: 'Small packages • Fast',
      capacity: '',
      price: 'EGP 50',
      imagePath: 'assets/images/motorcycle.png',
      isBestValue: true,
    ),
    _VehicleModel(
      title: 'Car',
      description: 'Medium • Protection',
      capacity: '',
      price: 'EGP 120',
      imagePath: 'assets/images/economy.png',
    ),
    _VehicleModel(
      title: 'Van',
      description: 'Large • Extra space',
      capacity: '',
      price: 'EGP 200',
      imagePath: 'assets/images/van.png',
    ),
  ];

  // ===========================================================================
  // VEHICLES
  // ===========================================================================

  List<_VehicleModel> get _vehicles {
    return _currentRideType ==
        RideType.cityToCity
        ? _cityToCityVehicles
        : _normalVehicles;
  }

  // ===========================================================================
  // CONTINUE
  // ===========================================================================

  void _continue() {
    final selectedVehicle =
    _vehicles[_selectedIndex];

    debugPrint(
      'Ride Type: $_currentRideType',
    );

    debugPrint(
      'Vehicle: ${selectedVehicle.title}',
    );

    // =======================================================================
    // CITY TO CITY
    // =======================================================================

    if (_currentRideType ==
        RideType.cityToCity) {
      final updatedRideData =
      widget.rideData?.copyWith(
        vehicleName: selectedVehicle.title,
      );

      debugPrint(
        'From: ${updatedRideData?.from}',
      );

      debugPrint(
        'To: ${updatedRideData?.to}',
      );

      debugPrint(
        'Passengers: ${updatedRideData?.passengers}',
      );

      debugPrint(
        'Selected Vehicle: ${updatedRideData?.vehicleName}',
      );

      context.push(
        AppRoutes.price,
        extra: updatedRideData,
      );

      return;
    }

    // =======================================================================
    // NORMAL RIDE
    // =======================================================================

    context.push(
      AppRoutes.seat,
    );
  }

  // ===========================================================================
  // UI
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,

      // =======================================================================
      // APP BAR
      // =======================================================================

      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        toolbarHeight: 72,
        leadingWidth: 72,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 24,
            color: AppColors.primaryColor,
          ),
        ),
        title: Text(
          'Choose Your Ride',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
            color: AppColors.primaryColor,
          ),
        ),
      ),

      // =======================================================================
      // BODY
      // =======================================================================

      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.lg,
                ),
                itemCount: _vehicles.length,
                separatorBuilder: (_, __) {
                  return SizedBox(
                    height: AppSpacing.lg,
                  );
                },
                itemBuilder: (
                    context,
                    index,
                    ) {
                  final vehicle =
                  _vehicles[index];

                  return _VehicleCard(
                    vehicle: vehicle,
                    selected:
                    _selectedIndex == index,
                    onTap: () {
                      setState(() {
                        _selectedIndex =
                            index;
                      });
                    },
                  );
                },
              ),
            ),

            // =================================================================
            // CONTINUE
            // =================================================================

            Container(
              color: AppColors.bgColor,
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: AppButton(
                label: 'Continue',
                type: AppButtonType.primary,
                onPressed: _continue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// VEHICLE CARD
// =============================================================================

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({
    required this.vehicle,
    required this.selected,
    required this.onTap,
  });

  final _VehicleModel vehicle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selectedBackground =
    AppColors.primaryColor.withValues(
      alpha: 0.07,
    );

    final normalBorder =
        AppColors.inputBorderGrey;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppBorders.md,
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 180,
              ),
              width: double.infinity,
              constraints:
              const BoxConstraints(
                minHeight: 122,
              ),
              padding: EdgeInsets.fromLTRB(
                AppSpacing.ms,
                AppSpacing.md,
                AppSpacing.ms,
                AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? selectedBackground
                    : AppColors.bgColor,
                borderRadius:
                AppBorders.md,
                border: Border.all(
                  color: selected
                      ? AppColors.primaryColor
                      : normalBorder,
                  width:
                  selected ? 1.7 : 1,
                ),
                boxShadow: selected
                    ? null
                    : [
                  BoxShadow(
                    color: AppColors
                        .appBlack
                        .withValues(
                      alpha: 0.035,
                    ),
                    blurRadius: 10,
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
                  // ===========================================================
                  // IMAGE
                  // ===========================================================

                  SizedBox(
                    width: 84,
                    height: 70,
                    child: Center(
                      child: Image.asset(
                        vehicle.imagePath,
                        width: 84,
                        height: 65,
                        fit: BoxFit.contain,
                        errorBuilder: (
                            context,
                            error,
                            stackTrace,
                            ) {
                          return Icon(
                            Icons
                                .directions_car_filled_rounded,
                            size: 55,
                            color: AppColors
                                .secondaryColor,
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(
                    width: AppSpacing.ms,
                  ),

                  // ===========================================================
                  // INFO
                  // ===========================================================

                  Expanded(
                    child: Column(
                      mainAxisSize:
                      MainAxisSize.min,
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Text(
                          vehicle.title,
                          maxLines: 1,
                          overflow:
                          TextOverflow
                              .ellipsis,
                          style:
                          Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                            fontSize:
                            15,
                            fontWeight:
                            FontWeight
                                .w500,
                            letterSpacing:
                            0,
                            color: AppColors
                                .secondaryColor,
                          ),
                        ),

                        SizedBox(
                          height:
                          AppSpacing.sm,
                        ),

                        Text(
                          vehicle.description,
                          maxLines: 1,
                          overflow:
                          TextOverflow
                              .ellipsis,
                          style:
                          Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            fontSize:
                            12,
                            fontWeight:
                            FontWeight
                                .w400,
                            letterSpacing:
                            0,
                            color: AppColors
                                .textGreyAndWhite,
                          ),
                        ),

                        if (vehicle.capacity
                            .isNotEmpty) ...[
                          SizedBox(
                            height:
                            AppSpacing
                                .xs,
                          ),

                          Row(
                            children: [
                              Icon(
                                Icons
                                    .person_outline_rounded,
                                size: 18,
                                color: AppColors
                                    .textGreyAndWhite,
                              ),

                              SizedBox(
                                width:
                                AppSpacing
                                    .xs,
                              ),

                              Expanded(
                                child: Text(
                                  vehicle
                                      .capacity,
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow
                                      .ellipsis,
                                  style: Theme.of(
                                    context,
                                  )
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                    fontSize:
                                    12,
                                    fontWeight:
                                    FontWeight
                                        .w400,
                                    letterSpacing:
                                    0,
                                    color: AppColors
                                        .textGreyAndWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(
                    width: AppSpacing.sm,
                  ),

                  // ===========================================================
                  // PRICE
                  // ===========================================================

                  Align(
                    alignment:
                    Alignment.topRight,
                    child: Padding(
                      padding:
                      EdgeInsets.only(
                        top: vehicle
                            .isBestValue
                            ? 18
                            : 0,
                      ),
                      child: Text(
                        vehicle.price,
                        textAlign:
                        TextAlign.right,
                        style:
                        Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(
                          fontSize:
                          13,
                          fontWeight:
                          FontWeight
                              .w700,
                          letterSpacing:
                          0,
                          color: AppColors
                              .secondaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // =====================================================================
        // BEST VALUE
        // =====================================================================

        if (vehicle.isBestValue)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              height: 25,
              padding:
              EdgeInsets.symmetric(
                horizontal:
                AppSpacing.ms,
              ),
              alignment:
              Alignment.center,
              decoration:
              const BoxDecoration(
                color:
                AppColors.primaryColor,
                borderRadius:
                BorderRadius.only(
                  topRight:
                  Radius.circular(12),
                  bottomLeft:
                  Radius.circular(9),
                ),
              ),
              child: Text(
                'Best Value',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                  FontWeight.w500,
                  color:
                  Theme.of(context)
                      .colorScheme
                      .onPrimary,
                ),
              ),
            ),
          ),

        // =====================================================================
        // SELECTED CHECK
        // =====================================================================

        if (selected)
          Positioned(
            right: -9,
            top: 47,
            child: Container(
              width: 21,
              height: 21,
              decoration: BoxDecoration(
                color:
                AppColors.primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color:
                    AppColors.bgColor,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.check_rounded,
                size: 15,
                color: Theme.of(context)
                    .colorScheme
                    .onPrimary,
              ),
            ),
          ),
      ],
    );
  }
}

// =============================================================================
// MODEL
// =============================================================================

class _VehicleModel {
  const _VehicleModel({
    required this.title,
    required this.description,
    required this.capacity,
    required this.price,
    required this.imagePath,
    this.isBestValue = false,
  });

  final String title;
  final String description;
  final String capacity;
  final String price;
  final String imagePath;
  final bool isBestValue;
}