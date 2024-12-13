import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

AppBar AppBarCustom(
    {String? text,
    Color? bgColor,
    bool? isCenter = true,
    Widget? leading,
    TabBar? tabbar,
    Color? foregroundColor = AppColors.neutralBlack,
    bool showheader = true}) {
  return AppBar(
    centerTitle: isCenter,
    scrolledUnderElevation: 0,
    foregroundColor: foregroundColor,
    elevation: 0,
    actions: [
      Padding(
        padding: EdgeInsets.only(right: Sizes.lg),
        child: leading,
      )
    ],
    bottom: tabbar,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text ?? "",
          textAlign: TextAlign.start,
          style: AppTextTheme.lightTextTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold, color: foregroundColor),
        ),
        if (showheader) HeaderText(),
      ],
    ),
    backgroundColor: bgColor ?? AppColors.backgroundLight,
  );
}

Text HeaderText() {
  return Text(
    FormatterUtils.formatAppDateString(DateTime.now().toString()),
    textAlign: TextAlign.start,
    style: AppTextTheme.lightTextTheme.bodyMedium
        ?.copyWith(color: const Color(0xff404446)),
  );
}
