import 'package:demo/common/widget/button.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

Widget bodyNoFound(BuildContext context, description,
    {String body =
        'This screen doesnt exist or you dont have permission to view it',
    bool showButton = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset(
        SvgAsset.noFoundSvg,
        width: 40.w,
        height: 25.h,
      ),
      const SizedBox(
        height: Sizes.xxxl,
      ),
      Text(
        description,
        textAlign: TextAlign.center,
        style: AppTextTheme.lightTextTheme.headlineSmall
            ?.copyWith(fontWeight: FontWeight.w500),
      ),
      const SizedBox(
        height: Sizes.lg,
      ),
      Text(
        textAlign: TextAlign.center,
        body,
        style: AppTextTheme.lightTextTheme.bodySmall,
      ),
      const SizedBox(
        height: Sizes.xxl,
      ),
      if (showButton == true)
        ButtonApp(
            height: 2.h,
            splashColor:
                const Color.fromARGB(255, 255, 171, 164).withOpacity(0.1),
            label: 'Return Home',
            onPressed: () {
              HelpersUtils.navigatorState(context).pushNamedAndRemoveUntil(
                AppPage.START,
                (route) => false,
              );
            },
            radius: Sizes.lg,
            textStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                color: AppColors.errorColor,
                fontWeight: FontWeight.w600) as dynamic,
            color: AppColors.errorLight,
            textColor: Colors.white,
            elevation: 0),
    ],
  );
}
