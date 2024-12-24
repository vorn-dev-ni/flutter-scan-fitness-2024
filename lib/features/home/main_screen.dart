import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:demo/common/model/screen_app.dart';
import 'package:demo/core/riverpod/app_setting_controller.dart';
import 'package:demo/core/riverpod/navigation_state.dart';
import 'package:demo/common/routes/routes.dart';
import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/bottom_nav.dart';
import 'package:demo/data/service/firebase_remote_config.dart';
import 'package:demo/data/service/health_connect.dart';
import 'package:demo/features/account/controller/profile_controller.dart';
import 'package:demo/features/account/model/profile_state.dart';
import 'package:demo/features/app_screen.dart';
import 'package:demo/features/home/model/app_bar.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/global_config.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo/utils/localization/translation_helper.dart';
import 'package:permission_handler/permission_handler.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with WidgetsBindingObserver {
  DateTime today = HelpersUtils.getToday();
  final GlobalKey _alertKeyAndroid = GlobalKey();
  final GlobalKey _alertKeyAndroidIOS = GlobalKey();

  late List<BottomNavigationBarItem> navItems = [];
  late List<ScreenApp> renderScreen = [];
  late FlutterHealthConnectService _flutterHealthConnectService;
  late String titleBar = "";
  bool showDialog = false;
  String? username = "";
  String resultText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _flutterHealthConnectService = FlutterHealthConnectService();
    _updatePermission();
    bindingUsername();
    AppRoutes.navigationStacks.forEach(
      (element) {
        navItems.add(
          BottomNavigationBarItem(
            // icon: Icon(Icons.home),
            activeIcon: element.routeName == AppPage.NAV_SCAN
                ? Material(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(Sizes.xxxl),
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.lg),
                      child: SvgPicture.string(
                        element.iconSvg ?? "",
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                            AppColors.backgroundLight, BlendMode.srcIn),
                      ),
                    ),
                  )
                : SvgPicture.string(
                    element.iconSvg ?? "",
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                        AppColors.primaryColor, BlendMode.srcIn),
                  ),
            icon: element.routeName == AppPage.NAV_SCAN
                ? Material(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(Sizes.xxxl),
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.lg),
                      child: SvgPicture.string(
                        element.iconSvg ?? "",
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                            AppColors.backgroundLight, BlendMode.srcIn),
                      ),
                    ),
                  )
                : SvgPicture.string(
                    element.iconSvg ?? "",
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                        AppColors.primaryColor.withOpacity(0.3),
                        BlendMode.srcIn),
                  ),
            backgroundColor: AppColors.backgroundLight,
            label: element.routeName,
          ),
        );
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      debugPrint("App State is resumed");

      _updatePermission();
    }
    if (state == AppLifecycleState.inactive) {
      if (_alertKeyAndroid.currentState != null) {
        _alertKeyAndroid.currentState!.activate();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future _updatePermission() async {
    String title = 'Oops !!!';
    String message = '';

    debugPrint("RUNRUN RUNURNR");

    bool status_health = await _flutterHealthConnectService.checkPermission();
    var status_activity = await Permission.activityRecognition.status;
    var status_location = await Permission.location.status;
    var status_body_sensors = await Permission.sensors.status;

    debugPrint(
        "Reading permission status_health ${status_health} body sensor ${status_body_sensors} status_location ${status_location} ");

    if (Platform.isAndroid) {
      print('_alertKeyAndroid.currentState ${_alertKeyAndroid.currentState}');

      if (!status_location.isGranted || !status_activity.isGranted) {
        title = "Track Activity is disabled";
        message =
            "Please allow location and activity tracking to continue using.";
      }
      if (!status_body_sensors.isGranted) {
        await GlobalConfig.instance.requestBodySensor();
        title = "Body Sensor is disabled";
        message = "Please allow body sensor tracking to continue using.";
      }
      if (status_health == false) {
        title = "Health Permission is disabled";
        message = "Please allow health fitness and activity tracker.";
      }

      debugPrint("message ${message} title ${title}");
      if (message.isNotEmpty && showDialog == false) {
        showDialog = true;
        HelpersUtils.showAlertDialog(context,
            key: _alertKeyAndroid,
            text: title,
            desc: message,
            negativeText: "Cancel", onPresspositive: () async {
          showDialog = false;
          HelpersUtils.navigatorState(context).pop();
          await AppSettings.openAppSettings();
        }, positiveText: "Open Settings");
      } else {
        if (showDialog == true &&
            _alertKeyAndroid.currentState == null &&
            status_location.isGranted &&
            status_body_sensors.isGranted &&
            status_activity.isGranted &&
            status_health == true) {
          HelpersUtils.navigatorState(context).pop();
        }
      }
    } else {
      //IOS
      if (!status_location.isGranted) {
        HelpersUtils.showAlertDialog(context,
            key: _alertKeyAndroidIOS,
            text: "Location is disabled",
            desc:
                "Please allow location and body sensor tracking to continue using.",
            negativeText: "Cancel", onPresspositive: () async {
          HelpersUtils.navigatorState(context).pop();
          await AppSettings.openAppSettings();
        }, positiveText: "Open Settings");
      }
    }

    ref
        .read(appSettingsControllerProvider.notifier)
        .updateHealth(status_health);
  }

  Future bindingUsername() async {
    // _preferences = await SharedPreferences.getInstance();

    setState(() {
      titleBar = FirebaseRemoteConfigService()
              .getString(AppConfigState.banner_tag.value?.toString() ?? "") ??
          "N/A";
    });
    // await FlutterHealthConnectService().getDailyRecords();
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = ref.watch(navigationStateProvider);
    final profileState = ref.watch(profileControllerProvider);
    final appState = ref.watch(appSettingsControllerProvider);

    return Scaffold(
      appBar: _appBar(selectedIndex, profileState),
      body: _widgetBody(selectedIndex, renderScreen),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Add your camera logic here
      //     print("Camera button pressed");
      //   },
      //   child: Icon(Icons.camera_alt),
      //   backgroundColor: Colors.blue,
      // ),
      bottomNavigationBar: CustomBottomNavigationBar(
          appsettingState: appState!,
          selectedIndex: selectedIndex,
          onTap: _onTap,
          items: navItems),
    );
  }

  AppBarConfig getAppBarConfig(int selectedIndex, ProfileState profile_state) {
    switch (selectedIndex) {
      case 0:
        return AppBarConfig(
            text: "${titleBar} ${profile_state.fullName}",
            isCenter: false,
            showHeader: true);
      case 1:
        return AppBarConfig(
            text: tr(context).scan ?? "Scan",
            isCenter: true,
            showHeader: false);
      case 2:
        return AppBarConfig(
            text: tr(context).profile ?? "Profile",
            isCenter: false,
            showHeader: false);
      default:
        return const AppBarConfig(
            text: "", isCenter: false, showHeader: false); // Default values
    }
  }

  PreferredSizeWidget _appBar(int selectedIndex, ProfileState profile_state) {
    return AppBarCustom(
        bgColor: AppColors.primaryDark,
        foregroundColor: AppColors.backgroundLight,
        text: getAppBarConfig(selectedIndex, profile_state).text,
        showheader: getAppBarConfig(selectedIndex, profile_state).showHeader,
        isCenter: getAppBarConfig(selectedIndex, profile_state).isCenter);
  }

  SafeArea _widgetBody(int selectedIndex, renderScreen) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.xl - 2),
      child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: navigationScreen(selectedIndex, context)),
    ));
  }

  void _onTap(int p1) {
    ref.read(navigationStateProvider.notifier).changeIndex(p1);
  }
}
