import 'package:ezpark/core/theme/colors/colors.dart';
import 'package:flutter/material.dart';

import '../sizes/font_size.dart';

class DefaultTheme {
  DefaultTheme();

  ThemeData get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.brandPrimary,
          onPrimary: AppColors.brandSecondary,
          tertiary: AppColors.brandThird,
          onTertiary: AppColors.neutral1000,
          secondary: AppColors.brandSecondary,
          onSecondary: AppColors.neutral500,
          error: AppColors.supportError,
          onError: AppColors.neutral1000,
          background: AppColors.brandPrimary,
          onBackground: AppColors.neutral1000,
          surface: AppColors.brandSecondary,
          onSurface: AppColors.brandPrimary,
        ),
        cardTheme: CardTheme(
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          shadowColor: Colors.black,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: AppColors.brandPrimary,
              width: .5,
            ),
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
            fontSize: FontSize.lg,
          ),
          titleMedium: TextStyle(
            color: Colors.white,
            fontSize: FontSize.md,
          ),
          titleSmall: TextStyle(
            color: Colors.white,
            fontSize: FontSize.sm,
          ),
          headlineLarge: TextStyle(
            color: Colors.white,
            fontSize: FontSize.lg,
          ),
          headlineMedium: TextStyle(
            color: Colors.white,
            fontSize: FontSize.md,
          ),
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: FontSize.sm,
          ),
          bodyLarge: TextStyle(
            color: Colors.white,
            fontSize: FontSize.lg,
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: FontSize.md,
          ),
          bodySmall: TextStyle(
            color: Colors.white,
            fontSize: FontSize.sm,
          ),
          labelLarge: TextStyle(
            fontSize: FontSize.lg,
            fontWeight: FontWeight.w500,
          ),
          labelMedium: TextStyle(
            fontSize: FontSize.md,
            fontWeight: FontWeight.w400,
          ),
          labelSmall: TextStyle(
            fontSize: FontSize.sm,
            fontWeight: FontWeight.w400,
          ),
          displayLarge: TextStyle(
            color: Colors.white,
            fontSize: FontSize.lg,
          ),
          displayMedium: TextStyle(
            color: Colors.white,
            fontSize: FontSize.md,
          ),
          displaySmall: TextStyle(
            color: Colors.white,
            fontSize: FontSize.sm,
          ),
        ),
      );
}
