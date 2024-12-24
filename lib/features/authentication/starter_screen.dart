import 'dart:async';
import 'dart:io';
import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/data/service/health_connect.dart';
import 'package:demo/features/authentication/controller/tabbar_controller.dart';
import 'package:demo/features/other/app_info.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/image_asset.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/flavor/config.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StartingScreen extends ConsumerStatefulWidget {
  const StartingScreen({super.key});

  @override
  ConsumerState<StartingScreen> createState() => _StartingScreenState();
}

class _StartingScreenState extends ConsumerState<StartingScreen> {
  final FirebaseAuthService _firebaseService = FirebaseAuthService();

  late StreamSubscription<User?> _userSubscription;
  late StreamSubscription<User?> _authStateSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestHealthKit();
    _userSubscription = _firebaseService.userStateChanges.listen((User? user) {
      _checkUserAuth(user);
    });
    _authStateSubscription =
        _firebaseService.authStateChanges.listen((User? user) {
      _checkAuthenticated(user);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _userSubscription.cancel();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      appBar: AppBarCustom(
          bgColor: AppColors.primaryLight,
          text: 'FitScan KH ${AppConfig.appConfig.flavor.value}',
          isCenter: false,
          showheader: false),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(Sizes.xl),
        child: SingleChildScrollView(
          child: SizedBox(
            height: 100.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape
                          .circle, // Automatically applies a circular shape
                    ),
                    width: 70.w, // Ensure width and height are equal
                    height: 30.h,
                    child: Image.asset(ImageAsset.fitnessHealth),
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 75.w,
                      child: Text(
                        // maxLines: 1,
                        translations?.intro_let_get_start ?? "",
                        style: AppTextTheme.lightTextTheme.displaySmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: Sizes.md,
                    ),
                    Text(
                      translations?.intro_desc ?? "",
                      style: AppTextTheme.lightTextTheme.labelLarge,
                    ),
                  ],
                ),
                const SizedBox(
                  height: Sizes.xxxl,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ButtonApp(
                          height: Sizes.lg,
                          label: translations?.login ?? "",
                          textStyle: AppTextTheme.lightTextTheme.bodyMedium
                              ?.copyWith(
                                  color: AppColors.backgroundLight,
                                  fontWeight: FontWeight.w600) as dynamic,
                          splashColor: AppColors.primaryLight,
                          onPressed: () => _navigationToAuth('login')),
                    ),
                  ],
                ),
                const SizedBox(
                  height: Sizes.lg,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ButtonApp(
                          height: Sizes.lg,
                          label: translations?.sign_up ?? "",
                          color: AppColors.backgroundLight,
                          textStyle: AppTextTheme.lightTextTheme.bodyMedium
                              ?.copyWith(
                                  color: AppColors.backgroundDark,
                                  fontWeight: FontWeight.w600) as dynamic,
                          splashColor: AppColors.primaryLight,
                          onPressed: () => _navigationToAuth('signup')),
                    ),
                  ],
                ),
                const AppInfo()
              ],
            ),
          ),
        ),
      )),
    );
  }

  void _navigationToAuth(String auth) {
    ref
        .read(tabbarControllerProvider.notifier)
        .updateIndex(auth != "login" ? 1 : 0);

    HelpersUtils.navigatorState(context).pushNamed(AppPage.AUTH.toString());
  }

  Future syncUserToStorage(User user) async {
    await LocalStorageUtils().setKeyString("fullname", user!.displayName!);
    await LocalStorageUtils().setKeyString("email", user!.email!);
    print("has sync to database success");
  }

  Future _checkUserAuth(User? user) async {
    print("Check user state");
    if (user != null) {
      if (user.emailVerified && ref.read(tabbarControllerProvider) == 2) {
        await syncUserToStorage(user);
        _userSubscription.cancel();
        // Navigate to the START screen if the user is verified
        if (mounted) {
          // await user.reload();
          HelpersUtils.navigatorState(context).pushNamedAndRemoveUntil(
              AppPage.START, (Route<dynamic> route) => false);
        }
      } else {
        if (ref.read(tabbarControllerProvider) == 2) {
          await user.reload();
        }
      }
    }
  }

  Future _reload() async {
    await FirebaseAuthService().getAuth?.currentUser?.reload();
  }

  Future _requestHealthKit() async {
    debugPrint("Requesting health kit");
    if (Platform.isAndroid) {
      await FlutterHealthConnectService().authorize();
    }
  }

  void _checkAuthenticated(User? user) {
    if (user == null || !user!.emailVerified) {
      debugPrint("User is not valid at all");
      // HelpersUtils.navigatorState(context).pushNamedAndRemoveUntil(
      //     AppPage.FIRST, (Route<dynamic> route) => false);
    }
  }
}
