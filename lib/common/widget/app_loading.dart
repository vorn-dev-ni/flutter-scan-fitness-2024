import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/image_asset.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

Widget appLoadingSpinner() {
  return SizedBox.fromSize(
    size: Size(100.w, 80.h),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          ImageAsset.lottiesLoadingGym,
          alignment: Alignment.center,
          fit: BoxFit.cover,
          width: 60.w,
          height: 30.h,
        ),
        Text(
          'Generating Result......',
          style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
              color: AppColors.primaryDark, fontWeight: FontWeight.bold),
        )
      ],
    ),
  );
}
