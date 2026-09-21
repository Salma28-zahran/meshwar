import 'package:flutter/material.dart';

@immutable
class AppGradients extends ThemeExtension<AppGradients> {
  const AppGradients({
    required this.primary,
  });

  final LinearGradient primary;

  @override
  AppGradients copyWith({
    LinearGradient? primary,
  }) {
    return AppGradients(
      primary: primary ?? this.primary,
    );
  }

  @override
  AppGradients lerp(
      covariant ThemeExtension<AppGradients>? other,
      double t,
      ) {
    if (other is! AppGradients) return this;

    return AppGradients(
      primary: LinearGradient.lerp(
        primary,
        other.primary,
        t,
      )!,
    );
  }
}