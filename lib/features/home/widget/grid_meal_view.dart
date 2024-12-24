import 'package:demo/common/model/grid_meal.dart';
import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/core/riverpod/app_setting_controller.dart';
import 'package:demo/features/home/controller/user_health_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:demo/utils/localization/translation_helper.dart';

class GridMealView extends ConsumerStatefulWidget {
  const GridMealView({
    super.key,
    required this.data,
  });

  final List<Gridmeal> data;

  @override
  ConsumerState<GridMealView> createState() => _GridMealViewState();
}

class _GridMealViewState extends ConsumerState<GridMealView> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final healthData = ref.watch(userHealthControllerProvider);
    final appTheme = ref.watch(appSettingsControllerProvider).appTheme;
    return Padding(
      padding: const EdgeInsets.only(top: Sizes.md),
      child: healthData.when(
        data: (data) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: Sizes.md,
              ),
              Material(
                color: const Color.fromARGB(255, 217, 236, 255),
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.xl)),
                elevation: 0,
                child: InkWell(
                  onTap: _onNavigateToSummary,
                  highlightColor: AppColors.primaryLight.withOpacity(0.3),
                  splashColor: AppColors.backgroundLight,
                  splashFactory: NoSplash.splashFactory,
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.lg),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              tr(context).today_summary,
                              style: appTheme == AppTheme.light
                                  ? AppTextTheme.lightTextTheme.bodyLarge
                                  : AppTextTheme.darkTextTheme.bodyLarge
                                      ?.copyWith(
                                          color: AppColors.backgroundDark),
                            ),
                            const Icon(
                              Icons.navigate_next_outlined,
                              size: Sizes.iconLg,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: Sizes.lg,
                                ),
                                userPointActivity(data?.steps ?? "0", 'steps'),
                                userPointActivity(
                                    "${data?.caloriesBurn ?? "0"}" ?? "0",
                                    'calories'),
                                userPointActivity(
                                    "${data?.sleepduration ?? "0"}h" ?? "0",
                                    'sleeps'),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Sizes.buttonHeightSm,
                                  horizontal: Sizes.lg),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                // border: Border.all(),
                                borderRadius: BorderRadius.circular(Sizes.xxl),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize
                                    .max, // Ensures the column takes minimal space
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        style: AppTextTheme
                                            .lightTextTheme.headlineMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    AppColors.backgroundLight),
                                        text:
                                            FormatterUtils.calculateHealthPercentage(
                                                    sleepDuration: double.parse(
                                                        data?.sleepduration ??
                                                            "0"),
                                                    stepsTaken: int.parse(
                                                        data?.steps ?? "0"),
                                                    caloriesBurned: double.parse(
                                                        data?.caloriesBurn ??
                                                            "0"))
                                                .toStringAsFixed(2),
                                        children: [
                                          TextSpan(
                                            text: '/ 100',
                                            style: AppTextTheme
                                                .lightTextTheme.bodySmall
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors
                                                        .backgroundLight),
                                          )
                                        ]),
                                  ),
                                  Text(
                                    tr(context).health_score ?? 'Health score',
                                    textAlign: TextAlign.center,
                                    style: AppTextTheme
                                        .lightTextTheme.bodyMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.backgroundLight),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
        error: (error, stackTrace) {
          return null;
        },
        loading: () => appLoadingSpinner(text: tr(context).please_wait),
      ),
    );
  }

  Widget userPointActivity(String score, String tag) {
    final iconName = _getIconColor(tag);
    final translateTag = _getTranslateTag(tag);
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(Sizes.sm),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10000),
                color: _getColor(tag)),
            child: SvgPicture.string(
              iconName,
              width: 25,
              height: 25,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                  AppColors.backgroundLight, BlendMode.srcIn),
            ),
          ),
          const SizedBox(
            width: Sizes.lg,
          ),
          RichText(
              text: TextSpan(
                  text: score.toString(),
                  style: AppTextTheme.lightTextTheme.bodyLarge,
                  children: [
                TextSpan(
                  text: ' ${translateTag}',
                  style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w300, color: AppColors.textColor),
                )
              ]))
        ],
      ),
    );
  }

  _getIconColor(String tag) {
    if (tag == 'steps') {
      return SvgAsset.shoesSvg;
    } else if (tag == 'calories') {
      return SvgAsset.burnedIconSvg;
    } else {
      return SvgAsset.nightSvg;
    }
  }

  _getColor(String tag) {
    if (tag == 'steps') {
      return AppColors.primaryMed;
    } else if (tag == 'calories') {
      return AppColors.successLight;
    } else {
      return AppColors.primaryLight;
    }
  }

  _getTranslateTag(String tag) {
    if (tag == 'steps') {
      return tr(context).steps;
    } else if (tag == 'calories') {
      // return tr(context).calories;
      return tr(context).kcal;
    } else {
      return tr(context).sleeps;
    }
  }

  // Future _updatePermission() async {
  //   bool permissionActivity = true;
  //   bool permissionLocation = true;
  //   bool permissionNotification = true;
  //   debugPrint("Reading permission _updatePermission");
  //   bool status_health = await _flutterHealthConnectService.checkPermission();
  //   var status_activity = await Permission.activityRecognition.status;
  //   var status_location = await Permission.location.status;
  //   var status_notification = await Permission.notification.status;
  //   if (status_location.isDenied) {
  //     permissionLocation = false;
  //   }
  //   if (status_notification.isDenied) {
  //     permissionNotification = false;
  //   }
  //   if (status_activity.isDenied) {
  //     permissionActivity = false;
  //   }
  //   if (Platform.isAndroid) {
  //     if (!status_health) {
  //       HelpersUtils.showAlertDialog(context,
  //           text: "Health Permission",
  //           desc: "Please allow health fitness and activity tracker.",
  //           negativeText: "Cancel", onPresspositive: () async {
  //         await AppSettings.openAppSettings();
  //       }, positiveText: "Open Settings");
  //     }
  //     if (permissionLocation == false || permissionActivity == false) {
  //       HelpersUtils.showAlertDialog(context,
  //           text: "Track Activity",
  //           desc:
  //               "Please allow location and body sensor tracking to continue using.",
  //           negativeText: "Cancel", onPresspositive: () async {
  //         await AppSettings.openAppSettings();
  //       }, positiveText: "Open Settings");
  //     }
  //   } else {
  //     //IOS
  //     if (permissionLocation == false) {
  //       HelpersUtils.showAlertDialog(context,
  //           text: "Track Activity",
  //           desc:
  //               "Please allow location and body sensor tracking to continue using.",
  //           negativeText: "Cancel", onPresspositive: () async {
  //         await AppSettings.openAppSettings();
  //       }, positiveText: "Open Settings");
  //     }
  //   }

  //   ref.read(appSettingsControllerProvider.notifier).updateHealthPermission(
  //       activity: permissionActivity,
  //       health_permission: status_health,
  //       notification: permissionNotification,
  //       location: permissionLocation);
  // }

  void _onNavigateToSummary() {
    HelpersUtils.navigatorState(context).pushNamed(AppPage.CALORIES);
  }
}
