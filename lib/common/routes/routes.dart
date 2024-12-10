import 'package:demo/common/model/grid_meal.dart';
import 'package:demo/common/model/route_app.dart';
import 'package:demo/common/model/screen_app.dart';
import 'package:demo/features/account/account_screen.dart';
import 'package:demo/features/authentication/auth.dart';
import 'package:demo/features/authentication/widget/forget_password.dart';
import 'package:demo/features/authentication/home.dart';
import 'package:demo/features/authentication/widget/login.dart';
import 'package:demo/features/authentication/widget/register.dart';
import 'package:demo/features/authentication/widget/success.dart';
import 'package:demo/features/home/welcome_screen.dart';
import 'package:demo/features/home/widget/gym_activity.dart';
import 'package:demo/features/other/no_internet.dart';
import 'package:demo/features/result/result_screen.dart';
import 'package:demo/features/scan/scan_screen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();
  static List<Gridmeal> myMeals = [
    Gridmeal(
        label: 'Calories',
        value: 720,
        perUnit: 'kcal',
        backgroundColor: const Color(0xffFF9898),
        textColors: AppColors.backgroundLight),
    Gridmeal(
        label: 'Calories',
        value: 720,
        perUnit: 'kcal',
        backgroundColor: AppColors.secondaryDark,
        textColors: AppColors.backgroundLight),
    Gridmeal(
        label: 'Calories',
        value: 720,
        perUnit: 'kcal',
        backgroundColor: const Color(0xffFFE5E2),
        textColors: const Color(0xffFF9898)),
    Gridmeal(
        label: 'Calories',
        value: 720,
        perUnit: 'kcal',
        backgroundColor: const Color(0xff4099FF),
        textColors: AppColors.backgroundLight),
  ];

  static final List<RoutesApp> mainStacks = [
    // GymActivity(myMeals: myMeals),
    // const ScanScreen(),
    // const AccountScreen(),
    // const LoginScreen(),
    // const WelcomeScreen(),
    // const RegisterScreen(),
    RoutesApp(
        routeName: AppPage.START, builder: (context) => const WelcomeScreen()),

    RoutesApp(
        routeName: AppPage.RESULT, builder: (context) => const ResultScreen()),
    RoutesApp(
        routeName: AppPage.LOGIN, builder: (context) => const LoginScreen()),
    RoutesApp(
        routeName: AppPage.REGISTER,
        builder: (context) => const RegisterScreen()),
    RoutesApp(
        routeName: AppPage.FIRST, builder: (context) => const StartingScreen()),
    RoutesApp(
        routeName: AppPage.AUTH, builder: (context) => AuthenticationScreen()),
    RoutesApp(
        routeName: AppPage.FORGET,
        builder: (context) => const ForgetPassword()),
    RoutesApp(
        routeName: AppPage.EMAIL_VERIFY,
        builder: (context) => const SuccessAuth()),
    RoutesApp(
        routeName: AppPage.NO_INTERNET,
        builder: (context) => const NoInternet()),
  ];
  static final List<ScreenApp> navigationStacks = [
    ScreenApp(
        routeName: AppPage.NAV_WELCOME_HOME,
        arguments: null,
        builder: (context) => GymActivity(myMeals: myMeals),
        iconSvg: SvgAsset.homeSvg),
    ScreenApp(
        routeName: AppPage.NAV_SCAN,
        arguments: null,
        builder: (context) => ScanScreen(),
        iconSvg: SvgAsset.cameraSvg),
    ScreenApp(
        routeName: AppPage.NAV_ACCOUNT,
        arguments: null,
        builder: (context) => const AccountScreen(),
        iconSvg: SvgAsset.accountSvg),
  ];
  // static final List<ScreenApp> screens = [
  //   ScreenApp(
  //       routeName: AppPage.DEMO,
  //       arguments: null,
  //       builder: (context) => const ExampleScreen(),
  //       iconSvg: SvgAsset.cameraSvg),
  //   ScreenApp(
  //       routeName: AppPage.FIRST,
  //       arguments: null,
  //       builder: (context) => const WelcomeScreen(),
  //       iconSvg: SvgAsset.homeSvg),
  //   ScreenApp(
  //       routeName: AppPage.SECOND,
  //       arguments: null,
  //       builder: (context) => const LoginScreen(),
  //       iconSvg: SvgAsset.cameraSvg),
  // ];

  static Map<String, WidgetBuilder> getAppRoutes() {
    Map<String, WidgetBuilder> routeMap = Map.fromEntries(
      AppRoutes.mainStacks.map((e) => MapEntry(e.routeName, e.builder)),
    );

    return routeMap;
  }
}