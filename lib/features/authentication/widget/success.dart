import 'dart:async';

import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/image_asset.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SuccessAuth extends StatefulWidget {
  const SuccessAuth({super.key});

  @override
  State<SuccessAuth> createState() => _SuccessAuthState();
}

class _SuccessAuthState extends State<SuccessAuth> {
  final FirebaseAuthService _firebaseService = FirebaseAuthService();
  late StreamSubscription<User?> _authSubscription;
  @override
  void initState() {
    // TODO: implement initState
    print("Run success init");

    super.initState();
    _authSubscription = _firebaseService.authStateChanges.listen((User? user) {
      print("Home User is ${user?.email}");

      _checkUserAuth(user);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCustom(
            bgColor: Colors.transparent,
            text: 'Verify Email ',
            isCenter: true,
            showheader: false),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(Sizes.xl),
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
                      'An Email has been sent to your gmail ',
                      textAlign: TextAlign.center,
                      style: AppTextTheme.lightTextTheme.bodyLarge,
                    ),
                    Text(
                      'Please verify it before you login',
                      textAlign: TextAlign.center,
                      style: AppTextTheme.lightTextTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: Sizes.buttonHeightLg,
                    ),
                    ButtonApp(
                        height: 2.h,
                        splashColor: const Color.fromARGB(255, 255, 171, 164)
                            .withOpacity(0.1),
                        label: 'Resend Email',
                        onPressed: _resendEmail,
                        radius: Sizes.lg,
                        textStyle: AppTextTheme.lightTextTheme.bodyMedium
                            ?.copyWith(
                                color: AppColors.errorColor,
                                fontWeight: FontWeight.w600) as dynamic,
                        color: AppColors.errorLight,
                        textColor: Colors.white,
                        elevation: 0),
                  ],
                ),
              ]),
        )));
  }

  Future _resendEmail() async {
    await _firebaseService.currentUser?.sendEmailVerification();
  }

  Future _checkUserAuth(User? user) async {
    // await _firebaseService.signOut();
    if (user != null) {
      if (user.emailVerified) {
        _authSubscription.cancel();
        // Navigate to the START screen if the user is verified
        if (mounted) {
          HelpersUtils.navigatorState(context).pushNamedAndRemoveUntil(
              AppPage.START, ModalRoute.withName(AppPage.START));
        }
      } else {
        await user.reload();
      }
    }
  }

  void _sendingEmailVerify() async {
    print("Sending email now");
    await _firebaseService.currentUser?.sendEmailVerification();
  }
}
