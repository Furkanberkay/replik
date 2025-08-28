import 'package:flutter/material.dart';

class AppColors {
  static const brand = Color(0xFF00E5FF);
  static const gradientA = Color(0xFF0F2027);
  static const gradientB = Color(0xFF203A43);
  static const gradientC = Color(0xFF2C5364);
  static const card = Color(0xFF0E1A22);
}

const appGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [AppColors.gradientA, AppColors.gradientB, AppColors.gradientC],
);

ThemeData buildAppTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      brightness: Brightness.dark,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontWeight: FontWeight.w700),
      bodyMedium: TextStyle(height: 1.35),
    ),
    // Flutter 3.35 uyumlu CardTheme: margin YOK; shape'i const ile veriyoruz
    cardTheme: const CardThemeData(
      color: AppColors.card,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
    ),
  );
}
