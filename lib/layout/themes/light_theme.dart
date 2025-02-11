import 'package:flutter/material.dart';
import 'colors/app_colors.dart';
import 'colors/app_colors_constant.dart';
import 'spacing/spacing.dart';

ThemeData lightTheme(BuildContext context) {
  return ThemeData(
    primaryColor: AppColorsConstant.primaryRed,
    scaffoldBackgroundColor: AppColorsConstant.scaffoldBackground,
    dividerColor: AppColorsConstant.borderColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColorsConstant.primaryRed,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: AppColorsConstant.cardBackground,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: AppColorsConstant.cardBackground),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
          fontSize: 16,
          color: AppColorsConstant.textPrimary,
          fontWeight: FontWeight.w400),
      titleMedium: TextStyle(
          fontSize: 12,
          color: AppColorsConstant.textPrimary,
          fontWeight: FontWeight.w300),
      titleSmall: TextStyle(
          fontSize: 10,
          color: AppColorsConstant.textPrimary,
          fontWeight: FontWeight.w400),
      labelLarge: TextStyle(
          fontSize: 14,
          color: AppColorsConstant.cardBackground,
          fontWeight: FontWeight.bold),
      labelMedium: TextStyle(
          fontSize: 12,
          color: AppColorsConstant.cardBackground,
          fontWeight: FontWeight.bold),
      labelSmall: TextStyle(
          fontSize: 10,
          color: AppColorsConstant.cardBackground,
          fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          color: AppColorsConstant.textPrimary),
      headlineSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColorsConstant.textPrimary),
    ),
    extensions: [
      const AppColors(),
      const AppSpacing(),
    ],
    dividerTheme:
        DividerThemeData(color: AppColorsConstant.cardBackground, thickness: 3),
    iconTheme: IconThemeData(
      color: AppColorsConstant.iconColor,
    ),
    cardTheme: CardTheme(
      color: AppColorsConstant.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing().spacingXS),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColorsConstant.cardBackground,
      selectedColor: AppColorsConstant.primaryRed,
      surfaceTintColor: AppColorsConstant.cardBackground,
      shadowColor: AppColorsConstant.cardBackground,
      showCheckmark: false,
      iconTheme: IconThemeData(color: AppColorsConstant.iconColor),
      padding: EdgeInsets.all(AppSpacing().spacingXS),
      labelStyle: TextStyle(
          fontSize: 12,
          color: AppColorsConstant.textPrimary,
          fontWeight: FontWeight.w500),
      secondaryLabelStyle: TextStyle(
          fontSize: 12,
          color: AppColorsConstant.cardBackground,
          fontWeight: FontWeight.bold),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColorsConstant.secondaryGreen,
        foregroundColor: AppColorsConstant.secondaryGreen,
        side: BorderSide(color: AppColorsConstant.secondaryGreen),
        padding: EdgeInsets.symmetric(horizontal: AppSpacing().spacingXS),
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing().spacingXXS)),
        textStyle: TextStyle(
            fontSize: 10,
            color: AppColorsConstant.cardBackground,
            fontWeight: FontWeight.bold),
      ),
    ),
  );
}
