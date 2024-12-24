import 'package:demo/utils/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:demo/utils/constant/app_colors.dart';

class ElevationTheme {
  ElevationTheme._();

  // Light Theme ElevatedButton
  static final ElevatedButtonThemeData elevationButtonLight =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      // padding: const EdgeInsets.all(Sizes.sm),

      elevation: 0, // Light theme elevation
      splashFactory: InkRipple.splashFactory,
      backgroundColor: AppColors.secondaryColor, // Button background
      foregroundColor: AppColors.backgroundLight, // Button text color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.xl), // Rounded corners
      ),

      overlayColor: Colors.transparent,
    ),
  );

  // Dark Theme ElevatedButton
  static final ElevatedButtonThemeData elevationButtonDark =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      // padding: const EdgeInsets.all(Sizes.xs),
      elevation: 4, // Dark theme elevation (slightly higher for contrast)
      backgroundColor: AppColors.primaryDark, // Button background
      foregroundColor: AppColors.backgroundDark, // Button text color
      shadowColor: AppColors.neutralBlack.withOpacity(0.5), // Dark shadow color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        // Rounded corners
      ),
    ),
  );
}
