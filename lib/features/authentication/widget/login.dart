import 'dart:async';

import 'package:demo/common/widget/app_input.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/core/riverpod/app_setting_controller.dart';
import 'package:demo/data/service/firebase_remote_config.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/features/account/controller/profile_controller.dart';
import 'package:demo/features/authentication/controller/auth_controller.dart';
import 'package:demo/features/authentication/controller/login_controller.dart';
import 'package:demo/features/authentication/controller/tabbar_controller.dart';
import 'package:demo/features/authentication/model/login_state.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/screen_text.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late AuthController authController;
  bool _showPassword = false;
  @override
  void initState() {
    super.initState();
    authController =
        AuthController(firebaseAuthService: FirebaseAuthService(), ref: ref);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);
    final translations = AppLocalizations.of(context);
    final appTheme = ref.watch(appSettingsControllerProvider).appTheme;

    return SingleChildScrollView(
      child: Container(
          color: appTheme == AppTheme.light
              ? AppColors.backgroundLight
              : AppColors.backgroundDark,
          height: 75.h,
          child: Padding(
            padding: const EdgeInsets.all(Sizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appHeader(translations, appTheme!),
                inputArea(context, translations, appTheme),
                const Spacer(),
                loginSection(context, loginState, translations)
              ],
            ),
          )),
    );
  }

  Column loginSection(BuildContext context, LoginState loginState,
      AppLocalizations? translations) {
    final appStateloading = ref.watch(appLoadingStateProvider);
    return Column(
      children: [
        const SizedBox(
          height: Sizes.lg,
        ),
        Row(
          children: [
            Expanded(
              child: ButtonApp(
                  height: Sizes.lg,
                  splashColor:
                      const Color.fromARGB(255, 75, 100, 240).withOpacity(0.1),
                  label: translations?.login ?? "Login",
                  onPressed: appStateloading == false ? _handleLogin : null,
                  centerLabel: appStateloading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                        )
                      : null,
                  radius: Sizes.lg,
                  textStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.backgroundLight) as dynamic,
                  color: AppColors.primaryLight,
                  textColor: Colors.white,
                  elevation: 0),
            )
          ],
        ),
        const SizedBox(
          height: Sizes.lg,
        ),
        if (FirebaseRemoteConfigService()
                .getBoolean(AppConfigState.social_login.value) ==
            true)
          Row(
            children: [
              Expanded(
                child: ButtonApp(
                    height: Sizes.lg,
                    splashColor: const Color.fromARGB(255, 236, 239, 229)
                        .withOpacity(0.1),
                    label: ScreenText.LoginScreen['loginApple'],
                    onPressed: () {},
                    iconButton: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Sizes.sm),
                      child: SvgPicture.string(
                        SvgAsset.appleSvg,
                        width: 2.5.w,
                        height: 2.5.h,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    ),
                    radius: Sizes.lg,
                    textStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                        color: AppColors.backgroundLight,
                        fontWeight: FontWeight.w600) as dynamic,
                    color: AppColors.neutralBlack,
                    textColor: Colors.white,
                    elevation: 0),
              )
            ],
          ),
        const SizedBox(
          height: Sizes.lg,
        ),
        if (FirebaseRemoteConfigService()
                .getBoolean(AppConfigState.social_login.value) ==
            true)
          Row(
            children: [
              Expanded(
                child: ButtonApp(
                    height: Sizes.lg,
                    iconButton: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Sizes.sm),
                      child: SvgPicture.string(
                        SvgAsset.googleSvg,
                        width: 2.5.w,
                        height: 2.5.h,
                      ),
                    ),
                    centerLabel: appStateloading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                            ),
                          )
                        : null,
                    splashColor: const Color.fromARGB(255, 171, 188, 255)
                        .withOpacity(0.1),
                    label: ScreenText.LoginScreen['loginGoogle'],
                    onPressed: () {
                      // print('Primary Button Pressed');
                    },
                    radius: Sizes.lg,
                    textStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                        color: AppColors.neutralBlack,
                        fontWeight: FontWeight.w600) as dynamic,
                    color: AppColors.secondaryColor,
                    textColor: Colors.white,
                    elevation: 0),
              )
            ],
          ),
      ],
    );
  }

  Column inputArea(
      BuildContext context, AppLocalizations? translations, AppTheme appTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInput(
          maxLength: 50,
          hintText: translations?.email ?? "Email",
          onChanged: (value) => ref
              .read(loginControllerProvider.notifier)
              .updateEmail(value.toString()),
        ),
        const SizedBox(
          height: Sizes.lg,
        ),
        AppInput(
          hintText: translations?.password ?? "Password",
          maxLength: 16,
          obscureText: !_showPassword,
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
              icon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.sm),
                child: Icon(
                    _showPassword ? Icons.visibility_off : Icons.visibility),
              )),
          onChanged: (value) => ref
              .read(loginControllerProvider.notifier)
              .updatePassword(value.toString()),
        ),
        const SizedBox(
          height: Sizes.lg,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                HelpersUtils.navigatorState(context).pushNamed(AppPage.FORGET);
              },
              child: Text(
                textAlign: TextAlign.right,
                "${translations?.forget_password} ?" ?? "Forget password ?",
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: appTheme == AppTheme.light
                        ? AppColors.textColor
                        : AppColors.textDarkColor),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column appHeader(AppLocalizations? translations, AppTheme appTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(translations?.auth_welcome ?? "Welcome back",
            style: AppTextTheme.lightTextTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: appTheme == AppTheme.dark
                    ? AppColors.textDarkColor
                    : AppColors.textColor)),
        Text(translations?.auth_login ?? "Enter your crediential to conitnue",
            style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: appTheme == AppTheme.dark
                    ? AppColors.textDarkColor
                    : AppColors.textColor)),
        const SizedBox(
          height: Sizes.lg,
        ),
      ],
    );
  }

  Future _handleLogin() async {
    bool? isValid =
        ref.read(loginControllerProvider.notifier).checkValidation(context);
    ref.read(appLoadingStateProvider.notifier).setState(true);

    if (isValid == true) {
      await authController.loginUser(context);
      ref.invalidate(tabbarControllerProvider);
      ref.invalidate(profileControllerProvider);
      HelpersUtils.navigatorState(context).pushNamedAndRemoveUntil(
          AppPage.FIRST, (Route<dynamic> route) => false);
    }
  }
}
