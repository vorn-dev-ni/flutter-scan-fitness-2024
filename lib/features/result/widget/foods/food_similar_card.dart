import 'package:demo/features/result/model/food_model.dart';
import 'package:demo/features/result/widget/foods/unit_tile.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget foodSimilarCard(String header, SimilarRecommendations similars) {
  return SizedBox(
    width: 60.w,
    height: 10.h,
    child: Material(
      borderRadius: BorderRadius.circular(Sizes.lg),
      color: Colors.transparent,
      child: Card(
        color: AppColors.backgroundLight,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Spacer(
              //   flex: 1,
              // ),
              SizedBox(
                height: 3.9.h,
                width: 50.w,
                child: Text(
                  similars.title ?? "N/A",
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.lightTextTheme.labelMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),

              ...List.generate(
                similars.nutritionFacts?.length ?? 0,
                (index) => unitTile(similars?.nutritionFacts![index]),
              )
              // unitTile(similars.?.toString() ?? ""),
              // unitTile(similars.sugar?.toString() ?? ""),
              // unitTile(similars.proteins?.toString() ?? ""),
            ],
          ),
        ),
      ),
    ),
  );
}
