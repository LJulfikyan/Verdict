import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTextTheme {
  static TextTheme build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final bodyColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final base = GoogleFonts.poppinsTextTheme().apply(
      bodyColor: bodyColor,
      displayColor: bodyColor,
    );

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(fontWeight: FontWeight.w700),
      displayMedium: base.displayMedium?.copyWith(fontWeight: FontWeight.w700),
      headlineLarge: base.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      bodyMedium: base.bodyMedium?.copyWith(color: secondaryColor, height: 1.5),
      bodySmall: base.bodySmall?.copyWith(color: secondaryColor, height: 1.4),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
