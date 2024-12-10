import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/theme/button/elevation_theme.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

class SchemaData {
  SchemaData._();
  static ThemeData lightThemeData =
      ThemeData(useMaterial3: true, fontFamily: 'DMSans').copyWith(
    textTheme: AppTextTheme.lightTextTheme,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    primaryColor: AppColors.primaryColor,
    brightness: Brightness.light,
    elevatedButtonTheme: ElevationTheme.elevationButtonLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      tertiary: AppColors.tertiaryColor,
      error: AppColors.errorColor,
      surface: AppColors.secondaryColor,
    ),
  );
  static ThemeData darkThemeData =
      ThemeData(useMaterial3: true, fontFamily: 'DMSans').copyWith(
    scaffoldBackgroundColor: Colors.black12,
    textTheme: AppTextTheme.darkTextTheme,
    brightness: Brightness.dark,
    elevatedButtonTheme: ElevationTheme.elevationButtonDark,
    primaryColorDark: AppColors.primaryDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      secondary: AppColors.secondaryDark,
      tertiary: AppColors.tertiaryDark,
      error: AppColors.errorColor,
      surface: AppColors.neutralBlack,
    ),
  );
}
