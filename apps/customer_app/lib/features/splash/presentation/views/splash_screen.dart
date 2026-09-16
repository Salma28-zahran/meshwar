import 'package:customer_app/config/routing/app_routes.dart';
import 'package:customer_app/config/theme/app_colors.dart';
import 'package:customer_app/src/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _openNextScreen();
  }

  Future<void> _openNextScreen() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );

    if (!mounted) return;

    context.go(AppRoutes.signup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Image.asset(
          ImageAssets.logo,
        ),
      ),
    );
  }
}