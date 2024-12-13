import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: non_constant_identifier_names
Widget TagCard({required String label}) {
  return Material(
    color: AppColors.backgroundLight,
    borderRadius: BorderRadius.circular(Sizes.xl),
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.symmetric(
          vertical: Sizes.sm - 2, horizontal: Sizes.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label == 'food' ? "Food" : "Gym",
            style: AppTextTheme.lightTextTheme.labelMedium
                ?.copyWith(color: AppColors.primaryColor),
          ),
          const SizedBox(
            width: Sizes.sm - 4,
          ),
          SvgPicture.string(
            label == 'food' ? SvgAsset.foodTag : SvgAsset.dumbellSvg,
            width: 16,
            height: 16,
            colorFilter: const ColorFilter.mode(
                Color.fromARGB(255, 23, 130, 252), BlendMode.srcIn),
          )
        ],
      ),
    ),
  );
}
