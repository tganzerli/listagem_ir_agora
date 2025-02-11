import 'package:flutter/material.dart';

/// A class that defines spacing constants for the Ui app.
class AppSpacing extends ThemeExtension<AppSpacing> {
  /// Extra extra small spacing.
  ///
  /// Size Value: `4`
  final double spacingXXS;

  /// Extra small spacing.
  ///
  /// Size Value: `8`
  final double spacingXS;

  /// Small spacing.
  ///
  /// Size Value: `12`
  final double spacingSM;

  /// Medium spacing.
  ///
  /// Size Value: `16`
  final double spacingMD;

  /// Large spacing.
  ///
  /// Size Value: `24`
  final double spacingLG;

  /// Extra large spacing.
  ///
  /// Size Value: `32`
  final double spacingXL;

  /// Extra extra large spacing.
  ///
  /// Size Value: `48`
  final double spacingXXL;

  /// Extra extra extra large spacing.
  ///
  /// Size Value: `64`
  final double spacingXXXL;

  /// The margin used in the app.
  ///
  /// Size Value: `16`
  final double marginApp;

  /// Constructor for the [AppSpacing] class.
  ///
  const AppSpacing({
    this.spacingXXS = 4,
    this.spacingXS = 8,
    this.spacingSM = 12,
    this.spacingMD = 16,
    this.spacingLG = 24,
    this.spacingXL = 32,
    this.spacingXXL = 48,
    this.spacingXXXL = 64,
    this.marginApp = 16,
  });

  /// Retrieves the [AppSpacing] instance from the [BuildContext].
  static AppSpacing of(BuildContext context) {
    return Theme.of(context).extension<AppSpacing>()!;
  }

  @override
  AppSpacing copyWith({
    double? figmaWidth,
    double? spacingXXS,
    double? spacingXS,
    double? spacingSM,
    double? spacingMD,
    double? spacingLG,
    double? spacingXL,
    double? spacingXXL,
    double? spacingXXXL,
    double? marginApp,
  }) {
    return AppSpacing(
      spacingXXS: spacingXXS ?? this.spacingXXS,
      spacingXS: spacingXS ?? this.spacingXS,
      spacingSM: spacingSM ?? this.spacingSM,
      spacingMD: spacingMD ?? this.spacingMD,
      spacingLG: spacingLG ?? this.spacingLG,
      spacingXL: spacingXL ?? this.spacingXL,
      spacingXXL: spacingXXL ?? this.spacingXXL,
      spacingXXXL: spacingXXXL ?? this.spacingXXXL,
      marginApp: marginApp ?? this.marginApp,
    );
  }

  @override
  ThemeExtension<AppSpacing> lerp(
      covariant ThemeExtension<AppSpacing>? other, double t) {
    if (other is! AppSpacing) {
      return this;
    }

    return AppSpacing();
  }
}
