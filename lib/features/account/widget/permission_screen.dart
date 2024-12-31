import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/tile_switch.dart';
import 'package:demo/core/riverpod/app_setting_controller.dart';
import 'package:demo/data/service/health_connect.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:demo/utils/localization/translation_helper.dart';
import 'package:demo/utils/localization/translation_helper.dart';

class NotificationSettingScreen extends ConsumerStatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  ConsumerState<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState
    extends ConsumerState<NotificationSettingScreen>
    with WidgetsBindingObserver {
  late final FlutterHealthConnectService _flutterHealthConnectService;

  @override
  void initState() {
    super.initState();

    _flutterHealthConnectService = FlutterHealthConnectService();
    _requestPermission();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _requestPermission();
      debugPrint("didChangeAppLifecycleState");
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appSettingsControllerProvider);
    return Scaffold(
        appBar: AppBarCustom(
          showheader: false,
          bgColor: AppColors.primaryDark,
          foregroundColor: AppColors.backgroundLight,
          text: tr(context).app_permission,
        ),
        body: SafeArea(
            child: SizedBox(
          height: 100.h,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(
                  height: Sizes.xl,
                ),
                tileSwitch(
                  tr(context).allow_location,
                  appState?.location_permission ?? false,
                  (value) => _openSettings(),
                ),
                if (Platform.isAndroid)
                  tileSwitch(
                    tr(context).allow_recognition,
                    appState?.body_sensor_permission ?? false,
                    (value) => _openSettings(),
                  ),
                if (Platform.isAndroid)
                  tileSwitch(
                    tr(context).allow_body_sensors,
                    appState?.device_sensor_permission ?? false,
                    (value) => _openSettings(),
                  ),
                tileSwitch(
                  tr(context).allow_notification,
                  appState?.receviedNotification ?? false,
                  (value) => _openSettings(),
                ),
              ],
            ),
          ),
        )));
  }

  Future _openSettings() async {
    await AppSettings.openAppSettings();
  }

  Future _requestPermission() async {
    // bool isValid =
    //     await FlutterHealthConnectService().requestHealthConnectPermission();
    bool permissionActivity = true;
    bool permissionLocation = true;
    bool permissionNotification = true;
    bool permissionSensors = true;
    bool status_health = await _flutterHealthConnectService.checkPermission();

    debugPrint("Reading permission _updatePermission ${status_health}");

    var status_activity = await Permission.activityRecognition.status;
    var status_location = await Permission.location.status;
    var status_notification = await Permission.notification.status;
    var status_body_sensors = await Permission.sensors.status;

    if (!status_location.isGranted) {
      permissionLocation = false;
    }
    if (!status_notification.isGranted) {
      permissionNotification = false;
    }
    if (!status_activity.isGranted) {
      permissionActivity = false;
    }
    if (!status_body_sensors.isGranted) {
      permissionSensors = false;
    }
    ref.read(appSettingsControllerProvider.notifier).updateAppPermission(
        activity: permissionActivity,
        notification: permissionNotification,
        deviceSensors: permissionSensors,
        location: permissionLocation);
    debugPrint(
        "Notification: ${status_notification} Location: ${status_location} Activity ${status_activity} Permission ${permissionSensors}");
  }
}
