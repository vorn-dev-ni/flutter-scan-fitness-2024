import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

Widget tileSwitch(String label, bool value, Function(bool value) toggleSwitch) {
  return Card(
    color: AppColors.backgroundLight,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: Sizes.lg, vertical: Sizes.xs),
      title: Text(label, style: AppTextTheme.lightTextTheme.labelLarge),
      trailing: Switch(
        value: value,
        onChanged: toggleSwitch,
        activeColor: AppColors.primaryColor,
        trackOutlineColor: const WidgetStatePropertyAll(AppColors.primaryColor),
        thumbColor: const WidgetStatePropertyAll(AppColors.primaryColor),
        inactiveThumbColor: AppColors.monoGrey4,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
  );
}
