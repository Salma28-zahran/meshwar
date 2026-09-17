import 'package:customer_app/config/routing/app_routes.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/core/widgets/app_borders.dart';
import 'package:customer_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SeatScreen extends StatefulWidget {
  const SeatScreen({super.key});

  @override
  State<SeatScreen> createState() => _SeatScreenState();
}

class _SeatScreenState extends State<SeatScreen> {
  final Set<String> _selectedSeats = {'4A', '4B'};

  final List<_SeatData> _seats = const [
    _SeatData('1A', null, true),
    _SeatData('1B', null, true),
    _SeatData('1C', 100),
    _SeatData('1D', 120),

    _SeatData('2A', 120),
    _SeatData('2B', 100),
    _SeatData('2C', null, true),
    _SeatData('2D', null, true),

    _SeatData('3A', 120),
    _SeatData('3B', 100),
    _SeatData('3C', 100),
    _SeatData('3D', 120),

    _SeatData('4A', 100),
    _SeatData('4B', 90),
    _SeatData('4C', 90),
    _SeatData('4D', 100),

    _SeatData('5A', 100),
    _SeatData('5B', 90),
    _SeatData('5C', null, true),
    _SeatData('5D', null, true),

    _SeatData('6A', null, true),
    _SeatData('6B', 80),
    _SeatData('6C', 70),
    _SeatData('6D', 100),

    _SeatData('7A', 60),
    _SeatData('7B', 70),
    _SeatData('7C', 70),
    _SeatData('7D', 90),

    _SeatData('8A', 40),
    _SeatData('8B', 40),
    _SeatData('8C', null, true),
    _SeatData('8D', null, true),

    _SeatData('9A', 50),
    _SeatData('9B', 40),
    _SeatData('9C', 50),
    _SeatData('9D', 60),
  ];

  void _toggleSeat(_SeatData seat) {
    if (seat.booked) return;

    setState(() {
      if (_selectedSeats.contains(seat.id)) {
        _selectedSeats.remove(seat.id);
      } else {
        _selectedSeats.add(seat.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                ),
                child: Column(
                  children: [
                    SizedBox(height: AppSpacing.sm),

                    _tripCard(),

                    SizedBox(height: AppSpacing.md),

                    _seatsCard(),

                    SizedBox(height: AppSpacing.ms),

                    _legend(),

                    SizedBox(height: AppSpacing.lg),

                    _priceSection(),

                    SizedBox(height: AppSpacing.lg),

                    AppButton(
                      label: 'Continue',
                      type: AppButtonType.primary,
                      onPressed: _selectedSeats.isEmpty ? null : () {
                        context.push(AppRoutes.price);
                      },
                    ),

                    SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // App bar
  // ---------------------------------------------------------------------------

  Widget _appBar() {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 64,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Row(
          children: [
            SizedBox(
              width: 48,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: colors.primary,
                  size: 22,
                ),
              ),
            ),

            Expanded(
              child: Text(
                'Seat Selection',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.primary,
                ),
              ),
            ),

            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Trip Card
  // ---------------------------------------------------------------------------

  Widget _tripCard() {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.ms),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  'Assiut University',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Icon(
                  Icons.arrow_forward,
                  color: colors.primary,
                  size: 18,
                ),
              ),

              Flexible(
                child: Text(
                  'Assiut Mall',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.ms),

          Row(
            children: [
              const _InfoItem(
                icon: Icons.calendar_today_outlined,
                text: 'Today, 10:30 AM',
              ),
              SizedBox(width: AppSpacing.md),
              const _InfoItem(
                icon: Icons.schedule,
                text: '2h 45m Express',
              ),
            ],
          ),

          SizedBox(height: AppSpacing.ms),

          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: const [
              _FeatureChip(
                icon: Icons.wifi,
                label: 'Free High-Speed Wi-Fi',
              ),
              _FeatureChip(
                icon: Icons.air,
                label: 'Climate AC',
              ),
              _FeatureChip(
                icon: Icons.power_outlined,
                label: 'USB Outlets',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Seats
  // ---------------------------------------------------------------------------

  Widget _seatsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.ms),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _busTop(),

          SizedBox(height: AppSpacing.md),

          const Row(
            children: [
              Expanded(child: _SeatHeader('A', 'Window')),
              Expanded(child: _SeatHeader('B', 'Aisle')),
              SizedBox(
                width: 58,
                child: Text(
                  'PASSAGE',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 8),
                ),
              ),
              Expanded(child: _SeatHeader('C', 'Aisle')),
              Expanded(child: _SeatHeader('D', 'Window')),
            ],
          ),

          SizedBox(height: AppSpacing.sm),

          ...List.generate(9, (index) {
            final row = index + 1;
            final seats = _seats
                .where((seat) => seat.id.startsWith('$row'))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: row == 9 ? 0 : AppSpacing.sm,
              ),
              child: _seatRow(row, seats),
            );
          }),
        ],
      ),
    );
  }

  Widget _busTop() {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _TopChip(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Driver',
                style: textTheme.labelMedium?.copyWith(
                  color: colors.secondary,
                ),
              ),
              Text(
                'Capt. Tarek',
                style: textTheme.labelSmall,
              ),
            ],
          ),
        ),

        _TopChip(
          child: Row(
            children: [
              Icon(
                Icons.door_front_door_outlined,
                color: colors.primary,
                size: 17,
              ),
              SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Door',
                    style: textTheme.labelMedium?.copyWith(
                      color: colors.secondary,
                    ),
                  ),
                  Text(
                    'Step In',
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.primary,
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

  Widget _seatRow(int row, List<_SeatData> seats) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(child: _seat(seats[0])),
        SizedBox(width: AppSpacing.sm),

        Expanded(child: _seat(seats[1])),

        SizedBox(
          width: 58,
          child: Text(
            '$row',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: seats.any(
                    (seat) => _selectedSeats.contains(seat.id),
              )
                  ? colors.primary
                  : colors.outlineVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        Expanded(child: _seat(seats[2])),
        SizedBox(width: AppSpacing.sm),
        Expanded(child: _seat(seats[3])),
      ],
    );
  }

  Widget _seat(_SeatData seat) {
    return _SeatTile(
      seat: seat,
      selected: _selectedSeats.contains(seat.id),
      onTap: () => _toggleSeat(seat),
    );
  }

  // ---------------------------------------------------------------------------
  // Legend
  // ---------------------------------------------------------------------------

  Widget _legend() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.ms,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(.25),
        borderRadius: AppBorders.full,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LegendItem('Available', _LegendType.available),
          SizedBox(width: 16),
          _LegendItem('Selected', _LegendType.selected),
          SizedBox(width: 16),
          _LegendItem('Booked', _LegendType.booked),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Price
  // ---------------------------------------------------------------------------

  Widget _priceSection() {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final selected = _selectedSeats.toList()..sort();
    final count = selected.length;
    final total = count * 180;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    selected.isEmpty ? 'No seats' : selected.join(', '),
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  if (selected.isNotEmpty) ...[
                    SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerHighest,
                        borderRadius: AppBorders.full,
                      ),
                      child: Text(
                        '$count Seats',
                        style: textTheme.labelSmall,
                      ),
                    ),
                  ],
                ],
              ),

              SizedBox(height: AppSpacing.sm),

              Text(
                selected.isEmpty
                    ? 'Select your seat'
                    : 'EGP 180 × $count Standard Fare',
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'EGP $total',
              style: textTheme.titleMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Total Price',
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    final colors = Theme.of(context).colorScheme;

    return BoxDecoration(
      color: colors.surface,
      borderRadius: AppBorders.lg,
      border: Border.all(
        color: colors.outlineVariant,
      ),
    );
  }
}

// =============================================================================
// Seat
// =============================================================================

class _SeatTile extends StatelessWidget {
  const _SeatTile({
    required this.seat,
    required this.selected,
    required this.onTap,
  });

  final _SeatData seat;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final background = selected
        ? colors.primary
        : seat.booked
        ? colors.surfaceContainerHighest
        : colors.surface;

    final foreground = selected
        ? colors.onPrimary
        : seat.booked
        ? colors.outline
        : colors.secondary;

    return InkWell(
      onTap: seat.booked ? null : onTap,
      borderRadius: AppBorders.md,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 47,
        decoration: BoxDecoration(
          color: background,
          borderRadius: AppBorders.md,
          border: Border.all(
            color: selected
                ? colors.primary
                : seat.booked
                ? Colors.transparent
                : colors.outlineVariant,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              seat.id,
              style: textTheme.labelMedium?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: AppSpacing.xs),

            if (seat.booked)
              Icon(
                Icons.lock_outline,
                size: 13,
                color: foreground,
              )
            else
              Text(
                'EGP${seat.price}',
                style: textTheme.labelSmall?.copyWith(
                  fontSize: 9,
                  color: foreground,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Small widgets
// =============================================================================

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: colors.secondary,
        ),
        SizedBox(width: AppSpacing.sm),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: AppBorders.full,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: colors.primary,
          ),
          SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SeatHeader extends StatelessWidget {
  const _SeatHeader(this.title, this.subtitle);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: colors.secondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}

class _TopChip extends StatelessWidget {
  const _TopChip({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.ms),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: AppBorders.lg,
      ),
      child: child,
    );
  }
}

enum _LegendType { available, selected, booked }

class _LegendItem extends StatelessWidget {
  const _LegendItem(this.label, this.type);

  final String label;
  final _LegendType type;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    Color background;

    switch (type) {
      case _LegendType.available:
        background = colors.surface;
        break;

      case _LegendType.selected:
        background = colors.primary;
        break;

      case _LegendType.booked:
        background = colors.surfaceContainerHighest;
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: background,
            borderRadius: AppBorders.xs,
            border: Border.all(
              color: colors.outlineVariant,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}

// =============================================================================
// Model
// =============================================================================

class _SeatData {
  const _SeatData(
      this.id,
      this.price, [
        this.booked = false,
      ]);

  final String id;
  final int? price;
  final bool booked;
}