import 'dart:math' as math;

import 'package:customer_app/config/routing/app_routes.dart';
import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/features/ride_type/ride_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../widgets/whento/whento_bottom_sheet.dart';
import '../widgets/whento/whento_map_section.dart';

class WhentoScreen extends StatefulWidget {
  const WhentoScreen({
    super.key,
    required this.fromTitle,
    required this.toTitle,
    this.fromPoint = const LatLng(
      27.18786,
      31.17020,
    ),
    this.toPoint = const LatLng(
      27.18038,
      31.18819,
    ),
  });

  final String fromTitle;
  final String toTitle;

  final LatLng fromPoint;
  final LatLng toPoint;

  @override
  State<WhentoScreen> createState() =>
      _WhentoScreenState();
}

class _WhentoScreenState extends State<WhentoScreen> {
  RideTimeType _selectedType = RideTimeType.now;

  DateTime? _scheduledDateTime;

  // ===========================================================================
  // SCHEDULE
  // ===========================================================================

  Future<void> _selectSchedule() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledDateTime ?? now,
      firstDate: DateUtils.dateOnly(now),
      lastDate: DateUtils.dateOnly(
        now.add(
          const Duration(days: 365),
        ),
      ),
    );

    if (date == null || !mounted) {
      return;
    }

    final initialTime =
    _scheduledDateTime != null
        ? TimeOfDay.fromDateTime(
      _scheduledDateTime!,
    )
        : TimeOfDay.now();

    final time = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (time == null || !mounted) {
      return;
    }

    setState(() {
      _selectedType = RideTimeType.schedule;

      _scheduledDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  // ===========================================================================
  // SCHEDULE TEXT
  // ===========================================================================

  String _scheduleSubtitle() {
    if (_scheduledDateTime == null) {
      return 'Choose a specific date and time';
    }

    final localizations =
    MaterialLocalizations.of(context);

    final date =
    localizations.formatMediumDate(
      _scheduledDateTime!,
    );

    final time =
    localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(
        _scheduledDateTime!,
      ),
    );

    return '$date • $time';
  }

  // ===========================================================================
  // CONTINUE
  // ===========================================================================

  Future<void> _continue() async {
    if (_selectedType == RideTimeType.schedule &&
        _scheduledDateTime == null) {
      await _selectSchedule();

      if (_scheduledDateTime == null) {
        return;
      }
    }

    if (!mounted) {
      return;
    }

    debugPrint(
      'FROM: ${widget.fromTitle}',
    );

    debugPrint(
      'TO: ${widget.toTitle}',
    );

    debugPrint(
      'RIDE TIME TYPE: $_selectedType',
    );

    debugPrint(
      'SCHEDULE: $_scheduledDateTime',
    );

    debugPrint(
      'FLOW TYPE: ${RideType.normal}',
    );

    context.push(
      AppRoutes.vehicle,
      extra: RideType.normal,
    );
  }

  // ===========================================================================
  // UI
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: LayoutBuilder(
        builder: (
            context,
            constraints,
            ) {
          final screenHeight =
              constraints.maxHeight;

          final screenWidth =
              constraints.maxWidth;

          final safeTop =
              MediaQuery.paddingOf(
                context,
              ).top;

          final sheetHeight = math.min(
            screenHeight * 0.46,
            445.0,
          );

          final safeSheetHeight = math.max(
            sheetHeight,
            math.min(
              350.0,
              screenHeight * 0.56,
            ),
          );

          return Stack(
            children: [
              // ============================================================
              // MAP
              // ============================================================

              Positioned.fill(
                child: WhentoMapSection(
                  fromTitle: widget.fromTitle,
                  toTitle: widget.toTitle,
                  fromPoint: widget.fromPoint,
                  toPoint: widget.toPoint,
                  safeTop: safeTop,
                  bottomSheetHeight:
                  safeSheetHeight,
                  onBack: () {
                    context.pop();
                  },
                ),
              ),

              // ============================================================
              // BOTTOM SHEET
              // ============================================================

              Align(
                alignment:
                Alignment.bottomCenter,
                child: SizedBox(
                  width: screenWidth,
                  height: safeSheetHeight,
                  child: WhentoBottomSheet(
                    selectedType:
                    _selectedType,
                    scheduleSubtitle:
                    _scheduleSubtitle(),

                    onRideNow: () {
                      setState(() {
                        _selectedType =
                            RideTimeType.now;
                      });
                    },

                    onSchedule:
                    _selectSchedule,

                    onContinue: _continue,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}