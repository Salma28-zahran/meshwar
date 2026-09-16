import 'package:customer_app/config/theme/theme_controller.dart';
import 'package:flutter/material.dart';

import '../../main.dart';



class AppColors {
  AppColors._();

  // ── Dark mode detector ───────────────────────────────────────────────────
  //*
  static bool get isDark {
    final mode = themeModeNotifier.value;
    if (mode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return mode == ThemeMode.dark;
  }


  // ── Primary (never changes) ──────────────────────────────────────────────
  static const primaryColor = Color(0xFF02BE8C);
/////// secondary color ///////
  static const secondaryColor = Color(0xFF0C2C4C);

  // ── Black / White (swap in dark) ─────────────────────────────────────────
  static Color get appBlack => isDark ? const Color(0xFFFFFFFF) : const Color(0xFF1A1A1A);
  static Color get bgColor  => isDark ? const Color(0xFF000000) : const Color(0xFFFCFCFC);
  static Color get white    => isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF);

  // ── Greys → primaryColor in dark ─────────────────────────────────────────
  static Color get boldGrey            => isDark ? const Color(0xFFFFFFFF) : const Color(0xFF6B6B6B);
  static Color get grey                => isDark ? primaryColor : const Color(0xFF6E6E6E);
  static Color get textGrey => isDark ? const Color(0x80B7B6B6) : const Color(0xFF6C6C6C);
  static Color get textGreyAndWhite => isDark ? const Color(0xFFFFFFFF) : const Color(0xFF6C6C6C);
  static Color get inputTextColor      => isDark ?const Color(0xFFFFFFFF) : const Color(0xFF6C6C6C);
  static Color get inputBorderGrey     => isDark ? primaryColor : const Color(0xFFB7B6B6);
  static Color get dividerAuthColor    => isDark ? primaryColor.withValues(alpha:0.40) : const Color(0xFFDDDDDD);
  static Color get lightBorder         => isDark ? primaryColor.withValues(alpha:0.20) : const Color(0x33B7B6B6);
  static Color get cardBorder50        => isDark ? primaryColor.withValues(alpha:0.50) : const Color(0x80B7B6B6);
  static Color get chatGrey            => isDark ? primaryColor.withValues(alpha:0.30) : const Color(0xFFE8E8EA);
  static Color get paymentDashedLine   => isDark ? primaryColor.withValues(alpha: 0.35) : const Color(0xFFE2E2E5);
  static Color get paymentPlanHeaderBorder => isDark ? primaryColor.withValues(alpha:0.20) : const Color(0xFFEEEEF0);
  static Color get readingProgressTrack   => isDark ? primaryColor.withValues(alpha:0.25) : const Color(0xFFE4E2DD);
  static Color get borderInputColor  => isDark ? primaryColor.withValues(alpha:0.25) :  Colors.grey.shade200;
  static Color get whiteOrange  => isDark ? const Color(0xFF1A1A1A) : const  Color(0xFFFAF3EF);

  // ── Fixed colors (never change) ──────────────────────────────────────────
  static const dangerRed                   = Color(0xFFEA2626);
  static const green                       = Color(0xFF027A48);
  static const whiteGreen                  = Color(0xFFECFDF3);
  static const borderGreen                 = Color(0xFF6CE9A6);
  static const ratingStar                  = Color(0xFFF2B01E);
  static const ratingScoreDisplay          = Color(0xFFDBA102);
  static const ratingStarInactive          = Color(0xFFE0E0E0);
  static const paymentMethodSelectedBorder = Color(0xB3A0181A);
  static const sliderColor    = Color(0xFFB7B6B6) ;

}

// ── Extension ────────────────────────────────────────────────────────────────
extension AppColorsX on BuildContext {
  bool get isDark => AppColors.isDark;
}