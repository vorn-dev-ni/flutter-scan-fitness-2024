import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/tile_switch.dart';
import 'package:demo/core/riverpod/app_setting_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:demo/utils/localization/translation_helper.dart';

class ChangeThemeScreen extends ConsumerStatefulWidget {
  const ChangeThemeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangeThemeScreenState();
}

class _ChangeThemeScreenState extends ConsumerState<ChangeThemeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appThemeRef = ref.watch(appSettingsControllerProvider);
    return Scaffold(
        appBar: AppBarCustom(
          showheader: false,
          bgColor: AppColors.primaryDark,
          foregroundColor: AppColors.backgroundLight,
          text: tr(context).appearance,
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
                  "${appThemeRef.appTheme == AppTheme.dark ? tr(context).dark : tr(context).light}",
                  appThemeRef.appTheme == AppTheme.dark,
                  (value) => _toggleTheme(appThemeRef.appTheme!),
                ),
              ],
            ),
          ),
        )));
  }

  Future _toggleTheme(AppTheme appThemeRef) async {
    String theme = appThemeRef.name;

    await LocalStorageUtils()
        .setKeyString('theme', theme == 'light' ? 'dark' : 'light');
    ref.read(appSettingsControllerProvider.notifier).updateAppTheme(
        appThemeRef == AppTheme.light ? AppTheme.dark : AppTheme.light);
  }
}
