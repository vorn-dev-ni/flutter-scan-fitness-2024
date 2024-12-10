import 'package:demo/common/widget/app_input.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/data/service/firebase_remote_config.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/features/authentication/controller/auth_controller.dart';
import 'package:demo/features/authentication/controller/register_controller.dart';
import 'package:demo/features/authentication/model/register_state.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:demo/utils/constant/screen_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  late AuthController authController;
  @override
  void initState() {
    super.initState();

    authController =
        AuthController(firebaseAuthService: FirebaseAuthService(), ref: ref);
  }

  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(registerControllerProvider);
    final appStateloading = ref.watch(appLoadingStateProvider);

    return SingleChildScrollView(
      child: Container(
          height: 80.h,
          color: AppColors.backgroundLight,
          child: Padding(
            padding: const EdgeInsets.all(Sizes.lg),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              appHeader(),
              inputArea(),
              const Spacer(),
              registerSection(registerState, appStateloading)
            ]),
          )),
    );
  }

  Column registerSection(RegisterState register_state, bool appStateloading) {
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
                  label: ScreenText.registerScreen['login'],
                  onPressed: appStateloading ? null : _handleRegister,
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
                      color: Colors.white) as dynamic,
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
                    label: ScreenText.registerScreen['loginApple'],
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
                    splashColor: const Color.fromARGB(255, 171, 188, 255)
                        .withOpacity(0.1),
                    label: ScreenText.registerScreen['loginGoogle'],
                    onPressed: () {},
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

  Column inputArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInput(
          hintText: "Fullname",
          onChanged: (value) => ref
              .read(registerControllerProvider.notifier)
              .updateFullname(value.toString()),
        ),
        const SizedBox(
          height: Sizes.lg,
        ),
        AppInput(
          hintText: "Email or user name",
          onChanged: (value) => ref
              .read(registerControllerProvider.notifier)
              .updateEmail(value.toString()),
        ),
        const SizedBox(
          height: Sizes.lg,
        ),
        AppInput(
          hintText: "Password",
          obscureText: true,
          onChanged: (value) => ref
              .read(registerControllerProvider.notifier)
              .updatePassword(value.toString()),
        ),
        const SizedBox(
          height: Sizes.lg,
        ),
        AppInput(
          hintText: "Confirm Password",
          obscureText: true,
          onChanged: (value) => ref
              .read(registerControllerProvider.notifier)
              .updateConfirmPassword(value.toString()),
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
                ScreenText.LoginScreen['forgetPassword'],
                style: AppTextTheme.lightTextTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column appHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ScreenText.registerScreen['header'],
          style: AppTextTheme.lightTextTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          ScreenText.registerScreen['enterCred'],
          style: AppTextTheme.lightTextTheme.bodyMedium,
        ),
        const SizedBox(
          height: Sizes.lg,
        ),
      ],
    );
  }

  void _handleRegister() {
    bool? isValid =
        ref.read(registerControllerProvider.notifier).checkValidation(context);
    if (isValid == true) {
      authController.createUser();
    }
  }
}
