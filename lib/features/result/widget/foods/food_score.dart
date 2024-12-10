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
          style: AppTextTheme.lightTextTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w600),
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
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(Sizes.xl),
            child: Image.file(
              file!,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                // This widget will be displayed if the image fails to load
                return Container(
                  width: 200,
                  height: 200,
                  color: Colors.grey[300], // Fallback background color
                  child: const Icon(
                    Icons.image_not_supported, // Icon indicating image error
                    color: Colors.white,
                    size: 50,
                  ),
                );
              },
            )),
      ],
    ),
  );
}
