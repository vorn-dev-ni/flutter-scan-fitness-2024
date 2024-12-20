import 'package:demo/core/riverpod/app_setting_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppBarCustom extends ConsumerWidget implements PreferredSizeWidget {
  final String? text;
  final Color? bgColor;
  final bool isCenter;
  final Widget? leading;
  final TabBar? tabbar;
  final Color? foregroundColor;
  final bool showheader;

  const AppBarCustom({
    Key? key,
    this.text,
    this.bgColor,
    this.isCenter = true,
    this.leading,
    this.tabbar,
    this.foregroundColor = Colors.black, // Default fallback
    this.showheader = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeRef = ref.watch(appSettingsControllerProvider).appTheme;

    return AppBar(
      centerTitle: isCenter,
      scrolledUnderElevation: 0,
      foregroundColor: foregroundColor != null
          ? appThemeRef == AppTheme.light
              ? foregroundColor
              : AppColors.backgroundLight
          : null,
      elevation: 0,
      toolbarHeight: 80,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: leading,
        ),
      ],
      bottom: tabbar,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text ?? "",
            textAlign: TextAlign.start,
            style: appThemeRef == AppTheme.light
                ? AppTextTheme.lightTextTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: foregroundColor,
                  )
                : AppTextTheme.darkTextTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDarkColor,
                  ),
          ),
          if (showheader) HeaderText(appThemeRef!),
        ],
      ),
      backgroundColor: bgColor != null
          ? appThemeRef == AppTheme.light
              ? AppColors.primaryLight
              : bgColor
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}

Text HeaderText(AppTheme appThemeRef) {
  return Text(FormatterUtils.formatAppDateString(DateTime.now().toString()),
      textAlign: TextAlign.start,
      style: appThemeRef == AppTheme.light
          ? AppTextTheme.lightTextTheme.bodyMedium
              ?.copyWith(color: AppColors.backgroundLight)
          : AppTextTheme.darkTextTheme.bodyMedium);
}
