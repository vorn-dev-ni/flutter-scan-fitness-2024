import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/app_input.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/features/authentication/widget/login.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
          bgColor: Colors.transparent,
          text: 'Forget Password',
          isCenter: false,
          showheader: false),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(Sizes.lg),
        child: SingleChildScrollView(
          child: SizedBox(
            height: 75.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.string(
                  SvgAsset.forgetPasswordSvg,
                ),
                const Spacer(),
                Text.rich(TextSpan(children: [
                  TextSpan(
                      text: "For",
                      style: AppTextTheme.lightTextTheme.bodyMedium),
                  TextSpan(
                      text: " Nightpp19@gmail.com",
                      style: AppTextTheme.lightTextTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ])),
                const SizedBox(
                  height: Sizes.lg,
                ),
                const AppInput(
                  hintText: "New Password",
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ButtonApp(
                          height: Sizes.lg,
                          splashColor: const Color.fromRGBO(212, 218, 253, 1)
                              .withOpacity(0.1),
                          label: "Confirm",
                          onPressed: () {
                            HelpersUtils.navigatorState(context).pop();
                          },
                          radius: Sizes.lg,
                          textStyle: AppTextTheme.lightTextTheme.bodyMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white) as dynamic,
                          color: AppColors.primaryColor,
                          textColor: Colors.white,
                          elevation: 0),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
