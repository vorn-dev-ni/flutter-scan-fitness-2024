import 'dart:io';

import 'package:demo/features/result/model/food_model.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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

            label: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${food?.rating}", // This part is the rating
                    style: AppTextTheme.lightTextTheme.headlineLarge?.copyWith(
                        color: AppColors.backgroundLight,
                        fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: "/5", // This part is "/5"
                    style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                      color: AppColors.backgroundLight,
                    ),
                  ),
                ],
              ),
            )),
        const SizedBox(
          height: Sizes.lg,
        ),
        ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(Sizes.xl),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Image.file(
                  file,
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    // This widget will be displayed if the image fails to load
                    return Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[300], // Fallback background color
                      child: const Icon(
                        Icons
                            .image_not_supported, // Icon indicating image error
                        color: Colors.white,
                        size: 50,
                      ),
                    );
                  },
                ),
                Positioned(
                  right: 2,
                  top: 4,
                  child: Card(
                    elevation: 4,
                    color: AppColors.backgroundLight,
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.xs - 2),
                      child: SvgPicture.string(
                        food?.isHealthy == true
                            ? SvgAsset.thumbnailUp
                            : SvgAsset.thumbnailDown,
                        width: 50,
                        height: 50,
                        colorFilter: const ColorFilter.mode(
                            AppColors.primaryColor, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ],
    ),
  );
}
