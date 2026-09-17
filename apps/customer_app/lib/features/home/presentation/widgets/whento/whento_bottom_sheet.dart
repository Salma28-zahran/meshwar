import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';

enum RideTimeType {
  now,
  schedule,
}

class WhentoBottomSheet
    extends StatelessWidget {
  const WhentoBottomSheet({
    super.key,
    required this.selectedType,
    required this.scheduleSubtitle,
    required this.onRideNow,
    required this.onSchedule,
    required this.onContinue,
  });

  final RideTimeType selectedType;

  final String scheduleSubtitle;

  final VoidCallback onRideNow;
  final VoidCallback onSchedule;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        AppBorders.bottomSheet,
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(
              alpha: 0.08,
            ),
            blurRadius: 18,
            offset:
            const Offset(
              0,
              -3,
            ),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // ===============================================================
            // CONTENT
            // ===============================================================

            Expanded(
              child:
              SingleChildScrollView(
                physics:
                const ClampingScrollPhysics(),
                padding:
                EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    // ───────────────── HANDLE ─────────────────

                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        margin:
                        EdgeInsets.only(
                          bottom:
                          AppSpacing.lg,
                        ),
                        decoration:
                        BoxDecoration(
                          color:
                          const Color(
                            0xFFD6D9DC,
                          ),
                          borderRadius:
                          AppBorders
                              .full,
                        ),
                      ),
                    ),

                    // ───────────────── TITLE ─────────────────

                    Text(
                      'When to start a ride?',
                      style:
                      Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                        fontSize: 24,
                        height: 1.15,
                        fontWeight:
                        FontWeight
                            .w700,
                        letterSpacing: 0,
                        color: AppColors
                            .secondaryColor,
                      ),
                    ),

                    SizedBox(
                      height:
                      AppSpacing.lg,
                    ),

                    // ───────────────── NOW ─────────────────

                    _RideTimeOption(
                      icon:
                      Icons
                          .schedule_outlined,
                      title:
                      'Ride Now',
                      subtitle:
                      'Leave as soon as a driver is confirmed',
                      selected:
                      selectedType ==
                          RideTimeType
                              .now,
                      onTap:
                      onRideNow,
                    ),

                    SizedBox(
                      height:
                      AppSpacing.lg,
                    ),

                    // ───────────────── SCHEDULE ─────────────────

                    _RideTimeOption(
                      icon: Icons
                          .calendar_month_outlined,
                      title:
                      'Schedule',
                      subtitle:
                      scheduleSubtitle,
                      selected:
                      selectedType ==
                          RideTimeType
                              .schedule,
                      onTap:
                      onSchedule,
                    ),

                    SizedBox(
                      height:
                      AppSpacing.md,
                    ),
                  ],
                ),
              ),
            ),

            // ===============================================================
            // CONTINUE
            // ===============================================================

            Padding(
              padding:
              EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: AppButton(
                label: 'Continue',
                type:
                AppButtonType.primary,
                onPressed:
                onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// OPTION
// =============================================================================

class _RideTimeOption
    extends StatelessWidget {
  const _RideTimeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;

  final String title;
  final String subtitle;

  final bool selected;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
      Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        AppBorders.md,
        child: Padding(
          padding:
          EdgeInsets.symmetric(
            vertical:
            AppSpacing.xs,
          ),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              SizedBox(
                width: 26,
                child: Icon(
                  icon,
                  size: 24,
                  color: AppColors
                      .secondaryColor,
                ),
              ),

              SizedBox(
                width:
                AppSpacing.sm,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      title,
                      style:
                      Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                        fontSize: 16,
                        height: 1.2,
                        fontWeight:
                        FontWeight
                            .w500,
                        letterSpacing: 0,
                        color: AppColors
                            .secondaryColor,
                      ),
                    ),

                    SizedBox(
                      height:
                      AppSpacing.ms,
                    ),

                    Text(
                      subtitle,
                      style:
                      Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        fontSize: 15,
                        height: 1.45,
                        fontWeight:
                        FontWeight
                            .w400,
                        letterSpacing: 0,
                        color:
                        const Color(
                          0xFF557694,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width:
                AppSpacing.sm,
              ),

              Padding(
                padding:
                const EdgeInsets.only(
                  top: 1,
                ),
                child:
                _SelectionCircle(
                  selected:
                  selected,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// RADIO
// =============================================================================

class _SelectionCircle
    extends StatelessWidget {
  const _SelectionCircle({
    required this.selected,
  });

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration:
      const Duration(
        milliseconds: 180,
      ),
      width: 26,
      height: 26,
      padding:
      const EdgeInsets.all(
        4,
      ),
      decoration: BoxDecoration(
        shape:
        BoxShape.circle,
        border: Border.all(
          width: 1.2,
          color: selected
              ? AppColors
              .primaryColor
              : const Color(
            0xFF7C8995,
          ),
        ),
      ),
      child: AnimatedContainer(
        duration:
        const Duration(
          milliseconds: 180,
        ),
        decoration:
        BoxDecoration(
          shape:
          BoxShape.circle,
          color: selected
              ? AppColors
              .primaryColor
              : Colors.transparent,
        ),
      ),
    );
  }
}