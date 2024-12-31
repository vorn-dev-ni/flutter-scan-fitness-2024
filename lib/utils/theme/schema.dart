import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/theme/button/elevation_theme.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

class SchemaData {
  SchemaData._();
  static String getFontFamily(Locale locale) {
    if (locale.languageCode == 'km') {
      return 'KohSantepheap';
    }
    return 'DMSans';
  }

  static ThemeData lightThemeData(Locale locale) {
    print(locale);
    return ThemeData(
      useMaterial3: true,
      fontFamily: getFontFamily(locale),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: ZoomPageTransitionsBuilder(
            allowSnapshotting: false,
          ),
        },
      ),
    ).copyWith(
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
      datePickerTheme: const DatePickerThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
    );
  }

  static ThemeData darkThemeData(Locale locale) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: getFontFamily(locale),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: ZoomPageTransitionsBuilder(
            allowSnapshotting: false,
          ),
        },
      ),
    ).copyWith(
      scaffoldBackgroundColor: Colors.black12,
      datePickerTheme: const DatePickerThemeData(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
      ),
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
}
