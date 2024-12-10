import 'dart:io';

import 'package:demo/features/result/model/food_model.dart';
import 'package:demo/features/result/widget/foods/food_similar_card.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget foodDetail(FoodModelResult food) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      foodHeaderBox(food),
      similarFoodBuilder(
          header: 'Similar Foods', similars: food.similarRecommendations ?? [])
    ],
  );
}

Widget similarFoodBuilder(
    {required String header, required List<SimilarRecommendations> similars}) {
  return Column(
    children: [
      Text(
        header,
        textAlign: TextAlign.left,
        style: AppTextTheme.lightTextTheme.titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: Sizes.lg,
      ),
      SizedBox.fromSize(
        size: Size(double.maxFinite, 25.h),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          // shrinkWrap: true,
          itemCount: similars.length,
          itemBuilder: (context, index) {
            return foodSimilarCard(header, similars[index]);
          },
        ),
      )
    ],
  );
}

Widget foodHeaderBox(FoodModelResult food) {
  return Column(
    children: [
      const SizedBox(
        height: Sizes.xl,
      ),
      Text(
        food?.title ?? "N/A",
        textAlign: TextAlign.center,
        style: AppTextTheme.lightTextTheme.titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: Sizes.lg,
      ),
      Text(food?.comment ?? "N/A",
          textAlign: TextAlign.start,
          style: AppTextTheme.lightTextTheme.titleMedium),
      const SizedBox(
        height: Sizes.xl,
      ),
    ],
  );
}
