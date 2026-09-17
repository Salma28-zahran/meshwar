import 'dart:math' as math;

import 'package:customer_app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SavedPlacesWidget extends StatelessWidget {
  const SavedPlacesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Saved Places',
              style:
              Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
                color: AppColors.secondaryColor,
              ),
            ),

            const Spacer(),

            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Text(
                  'EDIT',
                  style:
                  Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 11),

        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SavedPlaceItem(
              icon: Icons.home_outlined,
              label: 'Home',
            ),

            _SavedPlaceItem(
              icon: Icons.work_outline_rounded,
              label: 'Work',
            ),

            _SavedPlaceItem(
              icon: Icons.favorite_border_rounded,
              label: 'Gym',
            ),

            _AddPlaceItem(),
          ],
        ),
      ],
    );
  }
}

class _SavedPlaceItem extends StatelessWidget {
  const _SavedPlaceItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      child: Column(
        children: [
          Container(
            width: 49,
            height: 49,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFEEF8F6),
            ),
            child: Icon(
              icon,
              size: 22,
              color: Color(0xFF00A37D),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 9.5,
              color: AppColors.appBlack,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddPlaceItem extends StatelessWidget {
  const _AddPlaceItem();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      child: Column(
        children: [
          CustomPaint(
            painter: _DashedCirclePainter(
              color: AppColors.primaryColor.withValues(
                alpha: 0.42,
              ),
            ),
            child: SizedBox(
              width: 49,
              height: 49,
              child: Icon(
                Icons.add_rounded,
                size: 25,
                color: AppColors.primaryColor,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Add',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 9.5,
              color: AppColors.appBlack,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter({
    required this.color,
  });

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius =
        math.min(size.width, size.height) / 2 - 1;

    const dashCount = 18;

    final segmentAngle =
        (math.pi * 2) / dashCount;

    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
        segmentAngle * i,
        segmentAngle * 0.55,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
      covariant _DashedCirclePainter oldDelegate,
      ) {
    return oldDelegate.color != color;
  }
}