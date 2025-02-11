import 'package:flutter/material.dart';

import 'app_colors_constant.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color primaryRed;
  final Color secondaryGreen;
  final Color warningPurple;
  final Color highlightYellow;
  final Color scaffoldBackground;
  final Color cardBackground;
  final Color textPrimary;
  final Color textSecondary;
  final Color iconColor;
  final Color borderColor;

  const AppColors({
    this.primaryRed = AppColorsConstant.primaryRed,
    this.secondaryGreen = AppColorsConstant.secondaryGreen,
    this.warningPurple = AppColorsConstant.warningPurple,
    this.highlightYellow = AppColorsConstant.highlightYellow,
    this.scaffoldBackground = AppColorsConstant.scaffoldBackground,
    this.cardBackground = AppColorsConstant.cardBackground,
    this.textPrimary = AppColorsConstant.textPrimary,
    this.textSecondary = AppColorsConstant.textSecondary,
    this.iconColor = AppColorsConstant.iconColor,
    this.borderColor = AppColorsConstant.borderColor,
  });

  static AppColors of(BuildContext context) {
    return Theme.of(context).extension<AppColors>()!;
  }

  @override
  ThemeExtension<AppColors> copyWith({
    Color? primaryRed,
    Color? secondaryGreen,
    Color? warningPurple,
    Color? highlightYellow,
    Color? scaffoldBackground,
    Color? cardBackground,
    Color? textPrimary,
    Color? textSecondary,
    Color? iconColor,
    Color? borderColor,
  }) {
    return AppColors(
      primaryRed: primaryRed ?? this.primaryRed,
      secondaryGreen: secondaryGreen ?? this.secondaryGreen,
      warningPurple: warningPurple ?? this.warningPurple,
      highlightYellow: highlightYellow ?? this.highlightYellow,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      cardBackground: cardBackground ?? this.cardBackground,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      iconColor: iconColor ?? this.iconColor,
      borderColor: borderColor ?? this.borderColor,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(
      covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }

    return AppColors(
      primaryRed: Color.lerp(primaryRed, other.primaryRed, t)!,
      secondaryGreen: Color.lerp(secondaryGreen, other.secondaryGreen, t)!,
      warningPurple: Color.lerp(warningPurple, other.warningPurple, t)!,
      highlightYellow: Color.lerp(highlightYellow, other.highlightYellow, t)!,
      scaffoldBackground:
          Color.lerp(scaffoldBackground, other.scaffoldBackground, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
    );
  }
}
