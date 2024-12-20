import 'package:demo/common/model/app_setting_state.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_setting_controller.g.dart';

@riverpod
class AppSettingsController extends _$AppSettingsController {
  @override
  AppSettingState build() {
    return getData();
  }

  void updateNotificationPermission(bool notification) {
    state = state.copyWith(receviedNotification: notification);
  }

  void updateLocalization(String localization) {
    state = state.copyWith(localization: localization);
  }

  void updateAppTheme(AppTheme app_theme) {
    state = state.copyWith(appTheme: app_theme);
  }

  void updateHealthPermission(
      {required bool health_permission,
      required bool location,
      required bool notification,
      required bool activity}) {
    state = state.copyWith(
        health_permission: health_permission,
        location_permission: location,
        receviedNotification: notification,
        body_sensor_permission: activity);
  }

  AppSettingState getData() {
    String? themeMode =
        LocalStorageUtils().getKey('theme') ?? AppTheme.light.name;
    String localization = LocalStorageUtils().getKey('locale') ?? 'en';
    AppTheme appTheme = themeMode == 'dark' ? AppTheme.dark : AppTheme.light;
    return AppSettingState(localization: localization, appTheme: appTheme);
  }
}
