import 'package:customer_app/config/routing/app_routes.dart';
import 'package:customer_app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeActionsWidget extends StatelessWidget {
  const HomeActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ServiceCard(
                icon: Icons.directions_car_filled_rounded,
                title: 'Ride',
              ),
            ),

            SizedBox(width: 14),

            Expanded(
              child: _ServiceCard(
                icon: Icons.local_shipping_rounded,
                title: 'City to city',
              ),
            ),

            SizedBox(width: 14),

            Expanded(
              child: _ServiceCard(
                icon: Icons.delivery_dining_rounded,
                title: 'Delivery',
              ),
            ),
          ],
        ),

        SizedBox(height: 17),

        _SearchDestination(),

        SizedBox(height: 12),

        _LocationItem(
          text: 'Assiut University',
        ),

        SizedBox(height: 8),

        _LocationItem(
          text: 'Al-Azhar Mosque, Assiut',
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Ink(
          height: 77,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF02BE8C),
                Color(0xFF02A87D),
                Color(0xFF058266),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 23,
                color: Colors.white,
              ),

              const SizedBox(height: 7),

              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchDestination extends StatelessWidget {
  const _SearchDestination();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        context.push(AppRoutes.whereto);
      },
      child: Container(
        width: double.infinity,
        height: 52,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
        ),
        decoration: BoxDecoration(
          color: AppColors.bgColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xFFC5CED7),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              size: 25,
              color: Color(0xFF0C2C4C),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                'Where to & for how much?',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  fontSize: 12,
                  letterSpacing: 0,
                  color: AppColors.secondaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _LocationItem extends StatelessWidget {
  const _LocationItem({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {},
      child: SizedBox(
        height: 24,
        child: Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 22,
              color: Color(0xFF174367),
            ),

            const SizedBox(width: 9),

            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 11.5,
                  letterSpacing: 0,
                  color: AppColors.secondaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}