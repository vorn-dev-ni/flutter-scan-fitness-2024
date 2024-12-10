import 'package:demo/features/result/model/food_model.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget unitTile(NutritionFacts? units) {
  final labelIcon = _getIcon(units?.iconType ?? "calories");
  return Padding(
    padding: const EdgeInsets.only(top: Sizes.md),
    child: Row(
      children: [
        SvgPicture.string(
          labelIcon,
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(
              units?.iconType == 'calories'
                  ? const Color.fromARGB(255, 255, 171, 46)
                  : units?.iconType == 'protein'
                      ? AppColors.primaryColor
                      : Colors.redAccent,
              BlendMode.srcIn),
        ),
        const SizedBox(
          width: Sizes.md,
        ),
        Text(
          units?.value?.toString() ?? "0",
          textAlign: TextAlign.left,
          style: AppTextTheme.lightTextTheme.labelSmall,
        ),
      ],
    ),
  );
}

_getIcon(String? iconType) {
  switch (iconType) {
    case 'calories':
      return SvgAsset.caloriesIconSvg;

    case 'protein':
      return SvgAsset.dumbellSvg;
    case 'sugar':
      return SvgAsset.sugarSvg;
    default:
      return SvgAsset.dumbellSvg;
  }
}
