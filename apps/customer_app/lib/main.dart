import 'package:customer_app/config/routing/app_router.dart';
import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/config/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeModeNotifier,
          builder: (context, themeMode, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Meshwar',

              routerConfig: appRouter,

              themeMode: themeMode,

              theme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.light,
                scaffoldBackgroundColor: const Color(0xFFFCFCFC),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: AppColors.primaryColor,
                  brightness: Brightness.light,
                ),
              ),

              darkTheme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.dark,
                scaffoldBackgroundColor: Colors.black,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: AppColors.primaryColor,
                  brightness: Brightness.dark,
                ),
              ),
            );
          },
        );
      },
    );
  }
}