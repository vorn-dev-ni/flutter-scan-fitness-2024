import 'dart:io';

import 'package:demo/features/result/model/food_model.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

Widget foodScore({required FoodModelResult? food, required File file}) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: Sizes.lg,
        ),
        Text(
          'Total Score',
          style: AppTextTheme.lightTextTheme.headlineSmall,
        ),
        const SizedBox(
          height: Sizes.lg,
        ),
        Badge(
          backgroundColor: AppColors.primaryColor,
          largeSize: Sizes.xxl,
          smallSize: Sizes.md,
          padding: const EdgeInsets.all(
              Sizes.lg), // Adjust padding to make the badge larger

          label: Text(
            "${food?.rating}/5",
            style: AppTextTheme.lightTextTheme.titleLarge
                ?.copyWith(color: AppColors.backgroundLight),
          ),
        ),
        const SizedBox(
          height: Sizes.lg,
        ),
        ClipRRect(
            borderRadius: BorderRadius.circular(Sizes.xl),
            child: Image.file(
              file!,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            )),
      ],
    ),
  );
}
