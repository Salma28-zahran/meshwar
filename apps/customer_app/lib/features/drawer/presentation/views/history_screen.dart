import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedFilter = 0;

  final List<String> filters = const [
    'All',
    'Rides',
    'City to City',
    'Delivery',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _HistoryAppBar(
              onBack: () => Navigator.maybePop(context),
            ),

            SizedBox(height: AppSpacing.sm),

            _filters(),

            SizedBox(height: AppSpacing.lg),

            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.lg,
                ),
                children: [
                  const HistoryTripCard(
                    type: 'Ride',
                    date: 'Aug 12, 2026, 3:30 PM',
                    price: 'EGP 230',
                    driverName: 'Ahmed Mohamed',
                    rating: '4.8',
                    car: 'Toyota Corolla (White)',
                    pickup: 'Assiut University',
                    destination: 'Assiut Railway Station',
                    distance: '8.5 km',
                    duration: '18 min',
                    icon: Icons.directions_car_outlined,
                  ),

                  SizedBox(height: AppSpacing.lg),

                  const HistoryTripCard(
                    type: 'City to City',
                    date: 'Aug 10, 2026, 9:00 AM',
                    price: 'EGP 800',
                    driverName: 'Ahmed Ali',
                    rating: '4.9',
                    car: 'Toyota Corolla (White)',
                    pickup: 'Assiut',
                    destination: 'Qena',
                    distance: '9 km',
                    duration: '18 min',
                    icon: Icons.airport_shuttle_outlined,
                  ),

                  SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filters() {
    return SizedBox(
      height: 40.r,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
        ),
        itemCount: filters.length,
        separatorBuilder: (_, __) {
          return SizedBox(width: AppSpacing.sm);
        },
        itemBuilder: (context, index) {
          return _FilterChip(
            label: filters[index],
            selected: _selectedFilter == index,
            onTap: () {
              setState(() {
                _selectedFilter = index;
              });
            },
          );
        },
      ),
    );
  }
}

// =============================================================================
// APP BAR
// =============================================================================

class _HistoryAppBar extends StatelessWidget {
  const _HistoryAppBar({
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      height: 58.r,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: AppSpacing.sm,
            top: 0,
            bottom: 0,
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onBack,
                  customBorder: const CircleBorder(),
                  child: SizedBox(
                    width: 44.r,
                    height: 44.r,
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: 22.r,
                      color: colors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Center(
            child: Text(
              'Trip history',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// FILTER
// =============================================================================

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppBorders.full,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            gradient: selected
                ? AppColors.primaryGradient
                : null,
            color: selected
                ? null
                : colors.primary.withValues(
              alpha: .08,
            ),
            borderRadius: AppBorders.full,
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(
                milliseconds: 200,
              ),
              curve: Curves.easeOut,
              style: theme.textTheme.labelMedium!.copyWith(
                color: selected
                    ? Colors.white
                    : colors.primary,
                fontWeight: selected
                    ? FontWeight.w600
                    : FontWeight.w500,
              ),
              child: Text(label),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// TRIP CARD
// =============================================================================

class HistoryTripCard extends StatelessWidget {
  const HistoryTripCard({
    super.key,
    required this.type,
    required this.date,
    required this.price,
    required this.driverName,
    required this.rating,
    required this.car,
    required this.pickup,
    required this.destination,
    required this.distance,
    required this.duration,
    required this.icon,
  });

  final String type;
  final String date;
  final String price;

  final String driverName;
  final String rating;
  final String car;

  final String pickup;
  final String destination;

  final String distance;
  final String duration;

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.ms),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppBorders.lg,
        border: Border.all(
          color: colors.outlineVariant.withValues(
            alpha: .7,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(
              alpha: .04,
            ),
            blurRadius: 14.r,
            offset: Offset(
              0,
              5.r,
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          _TripHeader(
            type: type,
            date: date,
            price: price,
            icon: icon,
          ),

          SizedBox(height: AppSpacing.md),

          _DriverRow(
            name: driverName,
            rating: rating,
            car: car,
          ),

          SizedBox(height: AppSpacing.sm),

          Divider(
            height: 1,
            color: colors.outlineVariant.withValues(
              alpha: .7,
            ),
          ),

          SizedBox(height: AppSpacing.ms),

          _RouteRow(
            color: colors.primary,
            text: pickup,
          ),

          SizedBox(height: AppSpacing.ms),

          _RouteRow(
            color: colors.secondary,
            text: destination,
          ),

          SizedBox(height: AppSpacing.md),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              _SmallInfo(
                icon: Icons.route_outlined,
                text: distance,
              ),
              _SmallInfo(
                icon: Icons.access_time_rounded,
                text: duration,
              ),
            ],
          ),

          SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              Expanded(
                child: _OutlineActionButton(
                  label: 'View Details',
                  onPressed: () {},
                ),
              ),

              SizedBox(width: AppSpacing.ms),

              Expanded(
                child: _PrimaryActionButton(
                  label: 'Repeat Trip',
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// TRIP HEADER
// =============================================================================

class _TripHeader extends StatelessWidget {
  const _TripHeader({
    required this.type,
    required this.date,
    required this.price,
    required this.icon,
  });

  final String type;
  final String date;
  final String price;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38.r,
          height: 38.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.primary.withValues(
              alpha: .08,
            ),
          ),
          child: Icon(
            icon,
            size: 20.r,
            color: colors.primary,
          ),
        ),

        SizedBox(width: AppSpacing.sm),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style:
                theme.textTheme.titleMedium?.copyWith(
                  color: colors.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: AppSpacing.xxs),

              Text(
                date,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                theme.textTheme.labelSmall?.copyWith(
                  color: colors.secondary.withValues(
                    alpha: .65,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: AppSpacing.sm),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              price,
              style:
              theme.textTheme.labelMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: AppSpacing.xs),

            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: colors.primary.withValues(
                  alpha: .08,
                ),
                borderRadius: AppBorders.full,
              ),
              child: Text(
                'Completed',
                style:
                theme.textTheme.labelSmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// =============================================================================
// DRIVER
// =============================================================================

class _DriverRow extends StatelessWidget {
  const _DriverRow({
    required this.name,
    required this.rating,
    required this.car,
  });

  final String name;
  final String rating;
  final String car;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        CircleAvatar(
          radius: 19.r,
          backgroundColor: colors.primary.withValues(
            alpha: .08,
          ),
          child: Icon(
            Icons.person_rounded,
            size: 22.r,
            color: colors.primary,
          ),
        ),

        SizedBox(width: AppSpacing.sm),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                theme.textTheme.labelMedium?.copyWith(
                  color: colors.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: AppSpacing.xs),

              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 15.r,
                    color: AppColors.ratingStar,
                  ),

                  SizedBox(width: AppSpacing.xs),

                  Flexible(
                    child: Text(
                      '$rating • $car',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme
                          .textTheme.labelSmall
                          ?.copyWith(
                        color:
                        colors.secondary.withValues(
                          alpha: .7,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// ROUTE
// =============================================================================

class _RouteRow extends StatelessWidget {
  const _RouteRow({
    required this.color,
    required this.text,
  });

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 7.r,
          height: 7.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),

        SizedBox(width: AppSpacing.ms),

        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.secondary,
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// SMALL INFO
// =============================================================================

class _SmallInfo extends StatelessWidget {
  const _SmallInfo({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 19.r,
          color: colors.secondary,
        ),

        SizedBox(width: AppSpacing.xs),

        Text(
          text,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colors.secondary,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// OUTLINE BUTTON
// =============================================================================

class _OutlineActionButton extends StatelessWidget {
  const _OutlineActionButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      height: 48.r,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          side: BorderSide(
            color: colors.secondary,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppBorders.md,
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colors.secondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// PRIMARY BUTTON
// =============================================================================

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      height: 48.r,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: AppBorders.md,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: AppBorders.md,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style:
                  theme.textTheme.labelMedium?.copyWith(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}