import 'package:customer_app/config/routing/app_routes.dart';
import 'package:customer_app/config/routing/global_navigator.dart';
import 'package:customer_app/features/auth/complete_profile/presentation/views/completeprofile.dart';
import 'package:customer_app/features/auth/otp_screen/presentation/views/otp_screen.dart';
import 'package:customer_app/features/auth/register/presentation/views/signup_screen.dart';
import 'package:customer_app/features/splash/presentation/views/splash_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.otp,
      builder: (context, state) => const OtpScreen(),
    ),
    GoRoute(
      path: AppRoutes.completeprofile,
      builder: (context, state) => const Completeprofile(),
    ),
  ],
);