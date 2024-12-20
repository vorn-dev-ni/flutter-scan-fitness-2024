import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/features/authentication/controller/auth_controller.dart';
import 'package:demo/features/authentication/controller/tabbar_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/image_asset.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RevalidatePasswordSuccess extends ConsumerStatefulWidget {
  const RevalidatePasswordSuccess({super.key});

  @override
  ConsumerState<RevalidatePasswordSuccess> createState() =>
      _RevalidatePasswordSuccessState();
}

class _RevalidatePasswordSuccessState
    extends ConsumerState<RevalidatePasswordSuccess> {
  late AuthController authController;
  late String _email;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    _email = args['email'];
  }

  @override
  Widget build(BuildContext context) {
    final appLoadingState = ref.watch(appLoadingStateProvider);
    final translations = AppLocalizations.of(context);

    return Scaffold(
        appBar: AppBarCustom(
            bgColor: Colors.transparent,
            text: translations?.check_email ?? 'Check Email',
            isCenter: true,
            showheader: false),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(Sizes.xl),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  child: Container(
                      clipBehavior: Clip.none,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 185, 218, 255),
                        shape: BoxShape
                            .circle, // Automatically applies a circular shape
                      ),
                      width: 70.w, // Ensure width and height are equal
                      height: 30.h,
                      child: Image.asset(
                        ImageAsset.emailSvg,
                        fit: BoxFit.contain,
                        width: 80.w,
                        height: 80.h,
                      )),
                ),
                const SizedBox(
                  height: Sizes.buttonHeightLg,
                ),
                Column(
                  children: [
                    Text(
                      '',
                      textAlign: TextAlign.center,
                      style: AppTextTheme.lightTextTheme.bodyLarge,
                    ),
                    Text(
                      translations?.please_change_pw ??
                          'Please change your new password with the following email',
                      textAlign: TextAlign.center,
                      style: AppTextTheme.lightTextTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: Sizes.buttonHeightLg,
                    ),
                    ButtonApp(
                        height: 2.h,
                        splashColor: AppColors.primaryLight,
                        label: translations?.resent_email ?? 'Resent Email',
                        onPressed:
                            appLoadingState == true ? null : _resendEmail,
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
                                color: AppColors.backgroundLight,
                                fontWeight: FontWeight.w600) as dynamic,
                        color: AppColors.primaryColor,
                        textColor: Colors.white,
                        elevation: 0),
                    const SizedBox(
                      height: Sizes.md,
                    ),
                    ButtonApp(
                        height: 2.h,
                        splashColor: AppColors.primaryColor.withOpacity(0.1),
                        label: translations?.back_to_login ?? 'Back to login',
                        onPressed: () {
                          ref.invalidate(tabbarControllerProvider);
                          HelpersUtils.navigatorState(context)
                              .popUntil((route) => route.isFirst);
                        },
                        radius: Sizes.lg,
                        textStyle: AppTextTheme.lightTextTheme.bodyMedium
                            ?.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600) as dynamic,
                        color: const Color.fromARGB(255, 220, 229, 244),
                        textColor: Colors.white,
                        elevation: 0),
                  ],
                ),
              ]),
        )));
  }

  Future _resendEmail() async {
    await authController.resendPasswordEmail(_email);
  }
}
