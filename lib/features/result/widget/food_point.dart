import 'package:demo/features/result/model/food_model.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget foodPoints(NutritionFacts nutrition_fact) {
  Color getColorBullet(iconType) {
    switch (iconType) {
      case 'calories':
        return const Color.fromARGB(255, 240, 144, 0);
      case 'fat':
        return const Color(0xffDD2F2F);
      case 'protein':
        return const Color.fromARGB(255, 141, 185, 246);
      case 'sugar':
        return const Color(0xff9BDCFD);
      case 'carbohydrate':
        return const Color.fromARGB(255, 164, 220, 148);
      default:
        return AppColors.primaryColor;
    }
  }

  return ListTile(
    style: ListTileStyle.list,
    leading: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizes.xxxl),
            color: getColorBullet(nutrition_fact.iconType)),
        width: 4.w,
        height: 2.h),
    contentPadding: const EdgeInsets.all(0),
    horizontalTitleGap: Sizes.sm,
    title: Text(
      nutrition_fact.title!.startsWith('Carbohydrate')
          ? "Carbs"
          : nutrition_fact.title ?? " ",
      style: AppTextTheme.lightTextTheme.labelLarge,
    ),
    subtitle: Text(
      nutrition_fact.value?.toString() ?? "",
      style: AppTextTheme.lightTextTheme.bodySmall,
    ),
  );
}
