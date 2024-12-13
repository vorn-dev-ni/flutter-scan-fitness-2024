import 'package:demo/core/riverpod/navigation_state.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/features/account/controller/profile_controller.dart';
import 'package:demo/features/account/model/profile_state.dart';
import 'package:demo/features/account/model/tab_setting.dart';
import 'package:demo/features/authentication/controller/auth_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/image_asset.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  late List<TabSetting> listPrivacySettings = [];
  late List<TabSetting> listGeneralSettings = [];
  late AuthController authController;
  late FirebaseAuthService _firebaseAuthService;
  late String displayEmail;
  late String displayName;
  @override
  void initState() {
    super.initState();
    _firebaseAuthService = FirebaseAuthService();

    authController =
        AuthController(firebaseAuthService: _firebaseAuthService, ref: ref);

    listPrivacySettings.addAll([
      TabSetting(
          leadSvgString: SvgAsset.policySvg,
          tailSvgString: SvgAsset.nextSvg,
          title: 'Policy and privacy terms'),
      TabSetting(
          leadSvgString: SvgAsset.inviteFriendSvg,
          tailSvgString: SvgAsset.nextSvg,
          title: 'Invite Your Friends'),
    ]);
    listGeneralSettings.addAll([
      TabSetting(
          leadSvgString: SvgAsset.appearanceSvg,
          tailSvgString: SvgAsset.nextSvg,
          title: 'Appearances'),
      TabSetting(
          leadSvgString: SvgAsset.notiifcationSvg,
          tailSvgString: SvgAsset.nextSvg,
          title: 'Notifications'),
      TabSetting(
          leadSvgString: SvgAsset.languageSvg,
          tailSvgString: SvgAsset.nextSvg,
          title: 'Languages'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileTile(profileState),
        AccountTab(
            header: 'Settings',
            desc: 'Update your info to keep your account',
            listSettings: listGeneralSettings.toList()),
        AccountTab(
            header: 'Privacy',
            desc: 'App policy and privacy setting',
            listSettings: listPrivacySettings.toList()),
        const SizedBox(
          height: Sizes.lg,
        ),
        ButtonApp(
            height: 2.h,
            splashColor:
                const Color.fromARGB(255, 255, 171, 164).withOpacity(0.1),
            label: 'Logout',
            onPressed: _handleLogout,
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

  Widget AccountTab(
      {required String header,
      required String desc,
      required List<TabSetting> listSettings}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: AppTextTheme.lightTextTheme.bodyLarge,
          ),
          Text(
            desc,
            style: AppTextTheme.lightTextTheme.bodySmall,
          ),
          const SizedBox(
            height: Sizes.lg,
          ),
          Material(
            color: AppColors.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(Sizes.xl),
            child: ListView.builder(
              itemCount: listSettings.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListAccountItem(listSettings[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget ListAccountItem(TabSetting settings) {
    return Container(
      margin: const EdgeInsets.all(Sizes.sm),
      // padding: const EdgeInsets.symmetric(vertical: Sizes.sm),
      child: ListTile(
        onTap: () {},
        splashColor: AppColors.primaryColor.withOpacity(0.1),
        title: Text(
          settings.title,
          style: AppTextTheme.lightTextTheme.bodyMedium,
        ),
        leading: SvgPicture.string(
          settings
              .leadSvgString, // Ensure the path is correct and case-sensitive
          width: 25,
          height: 25,
          fit: BoxFit.cover,
          allowDrawingOutsideViewBox: true, // Optional, remove if not needed
        ),
        trailing: SvgPicture.string(
          settings
              .tailSvgString, // Ensure the path is correct and case-sensitive
          width: 25,
          height: 25,
          fit: BoxFit.cover,
          allowDrawingOutsideViewBox: true, // Optional, remove if not needed
        ),
      ),
    );
  }

  Widget ProfileTile(ProfileState profileState) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.xl),
      child: ListTile(
        onTap: () {
          HelpersUtils.navigatorState(context).pushNamed(AppPage.PROFILE);
        },
        splashColor: AppColors.primaryColor.withOpacity(0.1),
        contentPadding: const EdgeInsets.all(0),
        leading: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue, // Border color
              width: 2.0, // Border width
            ),
            borderRadius:
                BorderRadius.circular(Sizes.xxxl + 20), // Same as ClipRRect
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Sizes.xxxl + 20),
            clipBehavior: Clip.hardEdge,
            child: profileState.imageUrl.isNotEmpty
                ? FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    fadeInCurve: Curves.linear,
                    fadeOutCurve: Curves.bounceOut,
                    height: 50,
                    width: 50,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        ImageAsset.placeHolderImage,
                        fit: BoxFit.cover,
                        height: 50,
                        width: 50,
                      );
                    },
                    // imageCacheHeight: 200,
                    // imageCacheWidth: 200,
                    fadeInDuration: const Duration(milliseconds: 500),
                    placeholder: ImageAsset.placeHolderImage,
                    image: profileState.imageUrl)
                : Image.asset(
                    ImageAsset.defaultAvatar,
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50,
                  ),
          ),
        ),
        // leading: ClipRRect(
        //   borderRadius: BorderRadius.circular(Sizes.xxxl + 20),
        //   clipBehavior: Clip.hardEdge,
        //   child: FadeInImage.assetNetwork(
        //     fit: BoxFit.cover,
        //     fadeInCurve: Curves.linear,
        //     fadeOutCurve: Curves.bounceOut,
        //     width: 50,
        //     height: 50,
        //     // imageCacheHeight: 50,
        //     // imageCacheWidth: 50,
        //     fadeInDuration: const Duration(milliseconds: 500),
        //     placeholder: ImageAsset.placeHolderImage,

        //     image:
        //         'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?q=80&w=3307&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        //   ),
        // ),
        title: Text(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          profileState.fullName,
          style: AppTextTheme.lightTextTheme.bodyLarge,
        ),
        subtitle: Text(
          profileState.email,
          style: AppTextTheme.lightTextTheme.bodySmall,
        ),
        trailing: SvgPicture.string(
          SvgAsset.nextSvg, // Ensure the path is correct and case-sensitive
          width: 30,
          height: 30,
          fit: BoxFit.cover,
          allowDrawingOutsideViewBox: true, // Optional, remove if not needed
        ),
      ),
    );
  }

  Future _handleLogout() async {
    await authController.logoutUser();
    HelpersUtils.navigatorState(context).pushNamedAndRemoveUntil(
        AppPage.FIRST, (Route<dynamic> route) => false);
    ref.invalidate(navigationStateProvider);
  }
}
