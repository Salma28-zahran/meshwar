import 'package:customer_app/config/routing/app_routes.dart';
import 'package:customer_app/config/routing/global_navigator.dart';
import 'package:customer_app/features/auth/complete_profile/presentation/views/completeprofile.dart';
import 'package:customer_app/features/auth/otp_screen/presentation/views/otp_screen.dart';
import 'package:customer_app/features/auth/register/presentation/views/signup_screen.dart';
import 'package:customer_app/features/cityto/presentation/views/when_city.dart';
import 'package:customer_app/features/cityto/presentation/views/where_city.dart';
import 'package:customer_app/features/delivery/presentation/views/address_screen.dart';
import 'package:customer_app/features/delivery/presentation/views/delivery_screen.dart';
import 'package:customer_app/features/delivery/presentation/views/package_screen.dart';
import 'package:customer_app/features/delivery/presentation/views/where_d_screen.dart';
import 'package:customer_app/features/drawer/presentation/views/chat_screen.dart';
import 'package:customer_app/features/drawer/presentation/views/history_screen.dart';
import 'package:customer_app/features/drawer/presentation/views/support_screen.dart';
import 'package:customer_app/features/home/data/ride_models.dart';
import 'package:customer_app/features/home/presentation/views/price_screen.dart';
import 'package:customer_app/features/home/presentation/views/success_screen.dart';
import 'package:customer_app/features/home/presentation/views/vehicle_screen.dart';
import 'package:customer_app/features/home/presentation/views/home_screen.dart';
import 'package:customer_app/features/home/presentation/views/seat_screen.dart';
import 'package:customer_app/features/home/presentation/views/whento_screen.dart';
import 'package:customer_app/features/home/presentation/views/whereto_screen.dart';
import 'package:customer_app/features/location/presentation/views/location_screen.dart';
import 'package:customer_app/features/ride_type/data/ride_data.dart';
import 'package:customer_app/features/ride_type/ride_type.dart';
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
    GoRoute(
      path: AppRoutes.location,
      builder: (context, state) => const LocationScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.whereto,
      builder: (context, state) => const WheretoScreen(),
    ),
    GoRoute(
      path: AppRoutes.whento,
      builder: (context, state) {
        final extra =
        state.extra as Map<String, dynamic>?;

        return WhentoScreen(
          fromTitle:
          extra?['fromTitle'] as String? ?? '',
          toTitle:
          extra?['toTitle'] as String? ?? '',
        );
      },
    ),
    GoRoute(
      path: AppRoutes.vehicle,
      builder: (context, state) {
        final extra = state.extra;

        if (extra is RideData) {
          return VehicleScreen(
            rideType: extra.rideType,
            rideData: extra,
          );
        }

        if (extra is RideType) {
          return VehicleScreen(
            rideType: extra,
          );
        }

        return const VehicleScreen(
          rideType: RideType.normal,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.seat,
      builder: (context, state) => const SeatScreen(),
    ),
    GoRoute(
      path: AppRoutes.price,
      builder: (context, state) {
        final extra = state.extra;

        return PriceScreen(
          rideData:
          extra is RideData
              ? extra
              : null,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.success,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        return SuccessScreen(
          driver: extra['driver'] as DriverInfo,
          totalFare: extra['totalFare'] as int,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.history,
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: AppRoutes.chat,
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: AppRoutes.support,
      builder: (context, state) => const SupportScreen(),
    ),
    GoRoute(
      path: AppRoutes.wherecity,
      builder: (context, state) => const WhereCity(),
    ),
    GoRoute(
      path: AppRoutes.whencity,
      builder: (context, state) {
        final data =
        state.extra as Map<String, dynamic>?;

        return WhenCity(
          from: data?['from'] as String? ?? '',
          to: data?['to'] as String? ?? '',
        );
      },
    ),
    GoRoute(
      path: AppRoutes.delivery,
      builder: (context, state) => const DeliveryScreen(),
    ),
    GoRoute(
      path: AppRoutes.whered,
      builder: (context, state) => const WhereDScreen(),
    ),

    GoRoute(
      path: AppRoutes.address,
      builder: (context, state) => const AddressScreen(),
    ),

    GoRoute(
      path: AppRoutes.package,
      builder: (context, state) => const PackageScreen(),
    ),
  ],
);