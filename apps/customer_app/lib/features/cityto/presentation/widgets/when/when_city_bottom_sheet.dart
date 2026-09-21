import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum WhenCityStep {
  rideTime,
  passengers,
}

enum RideTimeOption {
  now,
  schedule,
}

class WhenCityBottomSheet extends StatelessWidget {
  const WhenCityBottomSheet({
    super.key,
    required this.step,
    required this.rideTime,
    required this.passengers,
    required this.onRideTimeChanged,
    required this.onDecreasePassengers,
    required this.onIncreasePassengers,
    required this.onContinue,
  });

  final WhenCityStep step;
  final RideTimeOption rideTime;
  final int passengers;

  final ValueChanged<RideTimeOption> onRideTimeChanged;

  final VoidCallback onDecreasePassengers;
  final VoidCallback onIncreasePassengers;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: AppBorders.bottomSheet,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SheetHandle(),

            SizedBox(
              height: AppSpacing.ml,
            ),

            AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 250,
              ),
              child: step == WhenCityStep.rideTime
                  ? _RideTimeBody(
                key: const ValueKey(
                  'ride_time',
                ),
                value: rideTime,
                onChanged: onRideTimeChanged,
              )
                  : _PassengersBody(
                key: const ValueKey(
                  'passengers',
                ),
                passengers: passengers,
                onDecrease:
                onDecreasePassengers,
                onIncrease:
                onIncreasePassengers,
              ),
            ),

            SizedBox(
              height: AppSpacing.lg,
            ),

            AppButton(
              label: 'Continue',
              onPressed: onContinue,
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: AppColors.inputBorderGrey,
        borderRadius: AppBorders.full,
      ),
    );
  }
}

class _RideTimeBody extends StatelessWidget {
  const _RideTimeBody({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final RideTimeOption value;
  final ValueChanged<RideTimeOption> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const _SheetTitle(
          title: 'When to start a ride?',
        ),

        SizedBox(
          height: AppSpacing.lg,
        ),

        _RideOptionTile(
          icon: Icons.access_time_rounded,
          title: 'Ride Now',
          subtitle:
          'Leave as soon as a driver is confirmed',
          selected:
          value == RideTimeOption.now,
          onTap: () {
            onChanged(
              RideTimeOption.now,
            );
          },
        ),

        SizedBox(
          height: AppSpacing.ml,
        ),

        _RideOptionTile(
          icon:
          Icons.calendar_month_outlined,
          title: 'Schedule',
          subtitle:
          'Choose a specific date and time',
          selected:
          value == RideTimeOption.schedule,
          onTap: () {
            onChanged(
              RideTimeOption.schedule,
            );
          },
        ),
      ],
    );
  }
}

class _RideOptionTile extends StatelessWidget {
  const _RideOptionTile({
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
    return InkWell(
      onTap: onTap,
      borderRadius: AppBorders.md,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.xs,
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 25.sp,
              color: context.secondaryColor,
            ),

            SizedBox(
              width: AppSpacing.ms,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                      fontSize: 15.sp,
                      fontWeight:
                      FontWeight.w500,
                      color: context
                          .secondaryColor,
                    ),
                  ),

                  SizedBox(
                    height: AppSpacing.sm,
                  ),

                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                      fontSize: 13.sp,
                      height: 1.5,
                      color: AppColors
                          .textGreyAndWhite,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width: AppSpacing.sm,
            ),

            _SelectionCircle(
              selected: selected,
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionCircle extends StatelessWidget {
  const _SelectionCircle({
    required this.selected,
  });

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 27.r,
      height: 27.r,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? context.primaryColor
              : AppColors.inputBorderGrey,
        ),
      ),
      child: selected
          ? Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.primaryColor,
        ),
      )
          : null,
    );
  }
}

class _PassengersBody extends StatelessWidget {
  const _PassengersBody({
    super.key,
    required this.passengers,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int passengers;

  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const _SheetTitle(
          title: 'How many passengers?',
        ),

        SizedBox(
          height: AppSpacing.lg,
        ),

        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.ml,
          ),
          decoration: BoxDecoration(
            color: context.primaryColor
                .withValues(
              alpha: 0.08,
            ),
            borderRadius: AppBorders.md,
            border: Border.all(
              color: context.primaryColor
                  .withValues(
                alpha: 0.08,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              _CounterButton(
                icon: Icons.remove,
                onTap: onDecrease,
              ),

              Text(
                '$passengers',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                  fontSize: 21.sp,
                  fontWeight:
                  FontWeight.w700,
                  color:
                  context.primaryColor,
                ),
              ),

              _CounterButton(
                icon: Icons.add,
                onTap: onIncrease,
              ),
            ],
          ),
        ),

        SizedBox(
          height: AppSpacing.xl,
        ),

        const _PassengersInfo(),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.primaryColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 34.r,
          height: 34.r,
          child: Icon(
            icon,
            size: 22.sp,
            color: Theme.of(context)
                .colorScheme
                .onPrimary,
          ),
        ),
      ),
    );
  }
}

class _PassengersInfo extends StatelessWidget {
  const _PassengersInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.chatGrey,
        borderRadius: AppBorders.lg,
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 24.sp,
            color: context.secondaryColor,
          ),

          SizedBox(
            width: AppSpacing.ms,
          ),

          Expanded(
            child: Text(
              'Vehicle options will depend on the number of passengers.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                fontSize: 13.sp,
                height: 1.4,
                color:
                context.secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: context.secondaryColor,
      ),
    );
  }
}