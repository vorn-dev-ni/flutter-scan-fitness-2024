import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/app_input.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/features/authentication/controller/auth_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class ForgetPassword extends ConsumerStatefulWidget {
  const ForgetPassword({super.key});

  @override
  ConsumerState<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends ConsumerState<ForgetPassword> {
  late AuthController authController;
  late TextEditingController _textEditingController;
  String _email = "";
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    authController =
        AuthController(firebaseAuthService: FirebaseAuthService(), ref: ref);
  }

  @override
  Widget build(BuildContext context) {
    final appLoadingState = ref.watch(appLoadingStateProvider);

    print("App Loading is ${appLoadingState}");

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
                      text: "Enter your Email",
                      style: AppTextTheme.lightTextTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ])),
                const SizedBox(
                  height: Sizes.lg,
                ),
                AppInput(
                  hintText: "Email Address",
                  controller: _textEditingController,
                  onChanged: (value) => setState(() {
                    _email = value.trim();
                  }),
                ),
                const Spacer(),
                const SizedBox(
                  height: Sizes.lg,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ButtonApp(
                          height: Sizes.lg,
                          splashColor: const Color.fromRGBO(212, 218, 253, 1)
                              .withOpacity(0.1),
                          label: "Confirm",
                          onPressed:
                              appLoadingState == true ? null : _validateEmail,
                          centerLabel: appLoadingState == true
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: AppColors.primaryLight,
                                  ),
                                )
                              : null,
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

  void _validateEmail() {
    if (_email.isNotEmpty) {
      authController.resetPassword(_email);
    } else {
      HelpersUtils.showErrorSnackbar(
          context,
          "Validation Failed",
          'Make sure you provide a valid email that is not empty',
          StatusSnackbar.failed);
    }
  }
}
