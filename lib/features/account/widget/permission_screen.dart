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
import 'package:sizer/sizer.dart';
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
                  "Allow Location Always",
                  appState?.location_permission ?? false,
                  (value) => _openSettings(),
                ),
                if (Platform.isAndroid)
                  tileSwitch(
                    "Allow Activity Recognition",
                    appState?.body_sensor_permission ?? false,
                    (value) => _openSettings(),
                  ),
                tileSwitch(
                  "Allow Notification",
                  appState?.receviedNotification ?? false,
                  (value) => _openSettings(),
                ),
                tileSwitch("Allow Health Tracker",
                    appState?.health_permission ?? false, (value) {
                  _openSettings();
                }),
              ],
            ),
          ),
        )));
  }

  Future _openSettings() async {
    await AppSettings.openAppSettings();
  }

  Future _requestPermission() async {
    bool isValid =
        await FlutterHealthConnectService().requestHealthConnectPermission();

    ref
        .read(appSettingsControllerProvider.notifier)
        .updateHealthPermission(health_permission: isValid);
  }
}
