import 'package:demo/utils/constant/image_asset.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

Widget appLoadingSpinner({String text = ''}) {
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
          width: 50.w,
          height: 22.h,
        ),
        Text(
          text,
          style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
              color: const Color.fromARGB(255, 25, 74, 139),
              fontWeight: FontWeight.w700),
        )
      ],
    ),
  );
}
