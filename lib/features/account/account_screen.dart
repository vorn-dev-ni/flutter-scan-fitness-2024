import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/core/riverpod/app_setting_controller.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/features/account/controller/profile_controller.dart';
import 'package:demo/features/account/model/profile_state.dart';
import 'package:demo/features/account/model/tab_setting.dart';
import 'package:demo/features/authentication/controller/auth_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/image_asset.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:demo/utils/localization/translation_helper.dart';
import 'package:share_plus/share_plus.dart';

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
          appPage: AppPage.TERMS,
          title: 'policy_privacy'),
      TabSetting(
          leadSvgString: SvgAsset.inviteFriendSvg,
          tailSvgString: SvgAsset.nextSvg,
          appPage: AppPage.NOTFOUND,
          title: 'invite_friend'),
    ]);
    listGeneralSettings.addAll([
      TabSetting(
          leadSvgString: SvgAsset.appearanceSvg,
          appPage: AppPage.APPEARENCE,
          tailSvgString: SvgAsset.nextSvg,
          title: 'appearance'),
      TabSetting(
          leadSvgString: SvgAsset.notiifcationSvg,
          tailSvgString: SvgAsset.nextSvg,
          appPage: AppPage.NOTIFICATION,
          title: 'notification'),
      TabSetting(
          leadSvgString: SvgAsset.languageSvg,
          tailSvgString: SvgAsset.nextSvg,
          appPage: AppPage.LANG,
          title: 'lang'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
    final translations = AppLocalizations.of(context);
    final appThemeRef = ref.watch(appSettingsControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileTile(profileState, appThemeRef?.appTheme),
        AccountTab(
            translations: translations,
            appThemeRef: appThemeRef!.appTheme,
            header: translations?.settings ?? 'Settings',
            desc: tr(context)?.update_info_setting ??
                'Update your info to keep your account',
            listSettings: listGeneralSettings.toList()),
        AccountTab(
            translations: translations,
            appThemeRef: appThemeRef!.appTheme,
            header: translations?.privacy ?? 'Privacy',
            desc: translations?.app_policy ?? 'App policy and privacy setting',
            listSettings: listPrivacySettings.toList()),
        const SizedBox(
          height: Sizes.lg,
        ),
        ButtonApp(
            height: Sizes.lg,
            splashColor:
                const Color.fromARGB(255, 255, 171, 164).withOpacity(0.1),
            label: translations?.log_out ?? 'Logout',
            onPressed: _handleLogout,
            radius: Sizes.lg,
            textStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                color: AppColors.errorColor,
                fontWeight: FontWeight.w600) as dynamic,
            color: AppColors.errorLight,
            textColor: Colors.white,
            elevation: 0),
        const SizedBox(
          height: Sizes.xl,
        ),
      ],
    );
  }

  Widget AccountTab(
      {required AppLocalizations? translations,
      required String header,
      required String desc,
      required AppTheme? appThemeRef,
      required List<TabSetting> listSettings}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translations != null
                ? AppLocalizations.of(context)!.appsettings(header)
                : header,
            style: appThemeRef == AppTheme.light
                ? AppTextTheme.lightTextTheme.bodyLarge
                : AppTextTheme.darkTextTheme.bodyLarge,
          ),
          Text(
            desc,
            style: appThemeRef == AppTheme.light
                ? AppTextTheme.lightTextTheme.bodySmall
                : AppTextTheme.darkTextTheme.bodySmall,
          ),
          const SizedBox(
            height: Sizes.lg,
          ),
          Material(
            color: appThemeRef == AppTheme.light
                ? AppColors.primaryColor.withOpacity(0.05)
                : AppColors.primaryLight,
            borderRadius: BorderRadius.circular(Sizes.xl),
            child: ListView.builder(
              itemCount: listSettings.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListAccountItem(listSettings[index], appThemeRef!);
              },
            ),
          ),
        ],
      ),
    );
  }

  String getTranslatedText(String key) {
    switch (key) {
      case 'notification':
        return tr(context).app_permission;
      case 'appearance':
        return tr(context).appearance;
      case 'lang':
        return tr(context).lang;
      case 'policy_privacy':
        return tr(context).policy_privacy;
      case 'invite_friend':
        return tr(context).invite_friend;
      default:
        return key;
    }
  }

  Widget ListAccountItem(TabSetting settings, AppTheme appThemeRef) {
    return Container(
      margin: const EdgeInsets.all(Sizes.sm),
      // padding: const EdgeInsets.symmetric(vertical: Sizes.sm),
      child: ListTile(
        onTap: () async {
          if (settings.appPage == AppPage.NOTFOUND) {
            PackageInfo packageInfo = await PackageInfo.fromPlatform();
            String appUrl =
                'https://www.yourapp.com/invite?app=${packageInfo.packageName}';

            Share.share(appUrl,
                subject: 'Hey!!! please check out this cool app');
            return;
          }
          HelpersUtils.navigatorState(context).pushNamed(settings.appPage);
        },
        splashColor: AppColors.primaryColor.withOpacity(0.1),
        title: Text(
          getTranslatedText(settings.title),
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

  Widget ProfileTile(ProfileState profileState, AppTheme? appThemeRef) {
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        onTap: () {
          HelpersUtils.navigatorState(context).pushNamed(AppPage.PROFILE);
        },
        // splashColor: AppColors.primaryColor.withOpacity(0.1),
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
        title: Text(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          profileState.fullName,
          style: appThemeRef == AppTheme.light
              ? AppTextTheme.lightTextTheme.bodyLarge
              : AppTextTheme.darkTextTheme.bodyLarge,
        ),
        subtitle: Text(
          profileState.email,
          style: appThemeRef == AppTheme.light
              ? AppTextTheme.lightTextTheme.bodySmall
              : AppTextTheme.darkTextTheme.bodySmall,
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
    // HelpersUtils.navigatorState(context).pushNamedAndRemoveUntil(
    //     AppPage.FIRST, (Route<dynamic> route) => false);
    await FirebaseFirestore.instance.terminate();

    await authController.logoutUser();
    HelpersUtils.navigatorState(context).pushNamedAndRemoveUntil(
        AppPage.FIRST, (Route<dynamic> route) => false);
  }
}
