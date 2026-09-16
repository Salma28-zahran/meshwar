import 'package:customer_app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class UpcomingTripWidget extends StatelessWidget {
  const UpcomingTripWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 112,
      padding: const EdgeInsets.fromLTRB(
        14,
        12,
        14,
        10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7F4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 31,
                height: 31,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.access_time_rounded,
                  size: 20,
                  color: Color(0xFF00A982),
                ),
              ),

              const SizedBox(width: 8),

              Text(
                'Upcoming Trip',
                style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF009D79),
                ),
              ),

              const Spacer(),

              InkWell(
                onTap: () {},
                child: Text(
                  'View Details',
                  style:
                  Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF009D79),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            'Tomorrow · 10:30 AM',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryColor,
            ),
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              Flexible(
                child: Text(
                  'Assiut University',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                  Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 9.5,
                    color: AppColors.textGreyAndWhite,
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 17,
                  color: Color(0xFF40627C),
                ),
              ),

              Flexible(
                child: Text(
                  'Cairo Festival City',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                  Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 9.5,
                    color: AppColors.textGreyAndWhite,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}