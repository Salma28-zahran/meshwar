import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/app_spacing.dart';
import 'package:customer_app/features/drawer/presentation/views/drawer.dart' as home_drawer;
import 'package:customer_app/features/home/presentation/widgets/home/home_actions_widget.dart';
import 'package:customer_app/features/home/presentation/widgets/home/home_map_widget.dart';
import 'package:customer_app/features/home/presentation/widgets/home/saved_places_widget.dart';
import 'package:customer_app/features/home/presentation/widgets/home/upcoming_trip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.bgColor,
        systemNavigationBarIconBrightness:
        AppColors.isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        drawer: const home_drawer.Drawer(),

        drawerScrimColor: Colors.black.withValues(
          alpha: .38,
        ),

        drawerEnableOpenDragGesture: true,


        body: LayoutBuilder(
          builder: (context, constraints) {
            final double sheetTop = constraints.maxHeight * 0.42;

            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: sheetTop + AppSpacing.lg,
                  child: const HomeMapWidget(),
                ),

                Positioned(
                  top: sheetTop,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.bgColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppSpacing.lg),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: AppSpacing.sm),

                        Container(
                          width: AppSpacing.xl + AppSpacing.sm,
                          height: AppSpacing.xs,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD7DADD),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.lg,
                            ),
                          ),
                        ),

                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.fromLTRB(
                              AppSpacing.pagePadding,
                              AppSpacing.md,
                              AppSpacing.pagePadding,
                              AppSpacing.ml,
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const HomeActionsWidget(),

                                SizedBox(height: AppSpacing.ml),

                                const SavedPlacesWidget(),

                                SizedBox(height: AppSpacing.md),

                                const UpcomingTripWidget(),

                                SizedBox(height: AppSpacing.sm),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}