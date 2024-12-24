import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/core/riverpod/app_setting_controller.dart';
import 'package:demo/features/home/controller/user_health_controller.dart';
import 'package:demo/features/home/controller/user_target_controller.dart';
import 'package:demo/features/home/model/user_health.dart';
import 'package:demo/features/home/widget/calories/bottom_sheet_target.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:demo/utils/localization/translation_helper.dart';

class PersonalInfoScreen extends ConsumerStatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  ConsumerState<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends ConsumerState<PersonalInfoScreen> {
  late DatePickerController datePickerController;
  double targetValue = 0;
  List<DateTime> futureDates = List.generate(
    100, // Show the next 30 days
    (index) => DateTime.now().add(Duration(days: index + 1)),
  );
  DateTime now = DateTime.now();
  late DateTime selectionDate;
  @override
  void initState() {
    super.initState();
    datePickerController = DatePickerController();
    DateTime midnight = DateTime(now.year, now.month, now.day, 0, 0, 0);
    selectionDate = midnight;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      datePickerController
          .animateToDate(DateTime.now().subtract(const Duration(days: 4)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userTargetControllerProvider);
    final appTheme = ref.watch(appSettingsControllerProvider).appTheme;
    final local = ref.watch(appSettingsControllerProvider).localization;
    return Scaffold(
      appBar: AppBarCustom(
        showheader: false,
        isCenter: true,
        bgColor: AppColors.primaryDark,
        foregroundColor: AppColors.backgroundLight,
        text: tr(context).today_summary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Sizes.sm, vertical: Sizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DatePicker(
                  DateTime.now().subtract(const Duration(days: 31)),
                  height: 100,
                  daysCount: 33,
                  locale: local,

                  inactiveDates: futureDates,
                  controller: datePickerController,
                  initialSelectedDate:
                      DateTime.now(), // Starting from 30 days ago
                  selectionColor: AppColors.primaryColor,
                  selectedTextColor: appTheme == AppTheme.light
                      ? Colors.white
                      : AppColors.backgroundLight,
                  deactivatedColor: appTheme == AppTheme.light
                      ? AppColors.primaryGrey
                      : const Color.fromARGB(255, 94, 94, 94),

                  dayTextStyle: appTheme == AppTheme.light
                      ? AppTextTheme.lightTextTheme.labelMedium!
                      : AppTextTheme.darkTextTheme.labelMedium!,
                  dateTextStyle: appTheme == AppTheme.light
                      ? AppTextTheme.lightTextTheme.headlineSmall!
                      : AppTextTheme.darkTextTheme.headlineSmall!,
                  monthTextStyle: appTheme == AppTheme.light
                      ? AppTextTheme.lightTextTheme.labelMedium!
                      : AppTextTheme.darkTextTheme.labelMedium!,

                  onDateChange: (date) {
                    setState(() {
                      selectionDate = date;
                    });
                  },
                ),
                userData.when(
                  loading: () {
                    return appLoadingSpinner(text: tr(context).please_wait);
                  },
                  error: (error, stackTrace) {
                    return const Text('');
                  },
                  data: (data) {
                    final result = data.data() as Map<String, dynamic>;

                    return Column(
                      children: [
                        UserActivityState(
                            healthType: "Steps",
                            datePeriod: selectionDate,
                            date: FormatterUtils.formatDob(selectionDate,
                                prefix: 'EEE, dd MMM'),
                            targetGoal: result['steps'],
                            unit: "step",
                            value: result['steps'],
                            onEdit: () {
                              _showBottomTargetSheet(
                                context,
                                'step',
                                result['steps'].toString() ?? "",
                              );
                            }),
                        UserActivityState(
                            healthType: "Active Calories",
                            datePeriod: selectionDate,
                            date: FormatterUtils.formatDob(selectionDate,
                                prefix: 'EEE, dd MMM'),
                            targetGoal: result['calories'],
                            value: result['calories'],
                            unit: "kcal",
                            onEdit: () {
                              _showBottomTargetSheet(
                                context,
                                'calories',
                                result['calories'].toString() ?? "",
                              );
                            }),
                        UserActivityState(
                            value: result['sleeps'],
                            healthType: "Sleep",
                            datePeriod: selectionDate,
                            unit: 'hour',
                            date: FormatterUtils.formatDob(selectionDate,
                                prefix: 'EEE, dd MMM'),
                            targetGoal: result['sleeps'],
                            onEdit: () {
                              _showBottomTargetSheet(
                                context,
                                'sleep',
                                result['sleeps'].toString(),
                              );
                            }),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomTargetSheet(
    BuildContext context,
    String type,
    value,
  ) {
    String label = getLabel(type);
    int maximum = getMaximum(type);
    showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.backgroundLight,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
        ),
        builder: (context) => BottomSheetTarget(
            label: label,
            maximum: maximum.toDouble(),
            value: int.parse(
              value,
            )));
  }

  String getLabel(type) {
    if (type == 'step') {
      return 'Steps';
    } else if (type == 'sleep') {
      return 'Sleep';
    } else {
      return 'Active Calories';
    }
  }

  int getMaximum(type) {
    if (type == 'step') {
      return 10000;
    } else if (type == 'sleep') {
      return 24;
    } else {
      return 2500;
    }
  }

  Widget UserActivityState({
    String? healthType,
    String? date,
    DateTime? datePeriod,
    String? unit,
    value,
    String? targetGoal,
    Function? onEdit,
  }) {
    final healthData =
        ref.watch(userHealthDataPeriodDateProvider(selectionDate!));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.sm),
      child: SizedBox(
        width: 100.w,
        child: Card(
          elevation: 0,
          color: getBackgroundColor(healthType),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  healthType ?? "Step",
                  style: AppTextTheme.lightTextTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  date ?? "Mon, 21",
                  style: AppTextTheme.lightTextTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: Sizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      healthData.when(
                        data: (data) {
                          String targetUnit = getTargetUnit(healthType, data!);

                          double valueProgress = double.parse(
                                  getValueUnits(healthType, data).toString()) /
                              double.parse(value ?? "0");

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  "${targetUnit}",
                                  style: AppTextTheme
                                      .lightTextTheme.headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(
                                height: Sizes.lg,
                              ),
                              LinearProgressIndicator(
                                minHeight: 16,
                                semanticsLabel: 'Progress',
                                // borderRadius: BorderRadius.all(Radius.circular(100)),
                                value: valueProgress,
                                semanticsValue: 'Target',
                                color: getProgressBackground(healthType),
                                backgroundColor: getForegroundColor(healthType)
                                    ?.withOpacity(0.5),
                              ),
                              const SizedBox(
                                height: Sizes.md,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${targetUnit}",
                                    style: AppTextTheme.lightTextTheme.bodySmall
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "${tr(context).target}: ${targetGoal}",
                                    style: AppTextTheme.lightTextTheme.bodySmall
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                        loading: () {
                          return const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Sizes.xxxl + 0.3),
                            child: CircularProgressIndicator(),
                          );
                        },
                        error: (error, stackTrace) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Sizes.xxxl + 0.3),
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                      const SizedBox(
                        height: Sizes.xxxl,
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          runSpacing: Sizes.sm,
                          spacing: Sizes.sm,
                          children: [
                            TextButton.icon(
                                icon: Icon(
                                  Icons.edit,
                                  size: Sizes.lg,
                                  color: getForegroundColor(healthType),
                                ),
                                onPressed: () {
                                  onEdit != null ? onEdit() : null;
                                },
                                label: Text(
                                  tr(context).edit_target,
                                  style: AppTextTheme.lightTextTheme.labelLarge
                                      ?.copyWith(
                                          color: getForegroundColor(healthType),
                                          fontWeight: FontWeight.w800),
                                )),
                            const SizedBox(
                              width: Sizes.lg,
                            ),
                            Material(
                              color: getForegroundColor(healthType),
                              borderRadius: BorderRadius.circular(Sizes.lg),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${tr(context).target_goal} ${targetGoal ?? "0"} ${unit}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: AppTextTheme.lightTextTheme.bodyMedium
                                      ?.copyWith(
                                          color: AppColors.backgroundLight,
                                          fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: Sizes.xxxl,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color? getBackgroundColor(String? healthType) {
    print(healthType);
    if (healthType == 'Steps') {
      return const Color.fromARGB(255, 217, 236, 255);
    }
    if (healthType == 'Active Calories') {
      return const Color(0xffFFF9F0);
    }
    if (healthType == 'Sleep') {
      return const Color(0xffC6EBC5);
    }
  }

  Color? getProgressBackground(String? healthType) {
    print(healthType);
    if (healthType == 'Steps') {
      return AppColors.primaryColor;
    }
    if (healthType == 'Active Calories') {
      return const Color(0xffFAB12F);
    }
    if (healthType == 'Sleep') {
      return AppColors.successColor;
    }
  }

  Color? getForegroundColor(String? healthType) {
    print(healthType);
    if (healthType == 'Steps') {
      return AppColors.primaryLight;
    }
    if (healthType == 'Active Calories') {
      return const Color(0xffFAB12F);
    }
    if (healthType == 'Sleep') {
      return AppColors.successLight;
    }
  }

  String getValueUnits(String? healthType, UserHealth userHealth) {
    debugPrint('Health type ${healthType}');
    if (healthType == 'Steps') {
      return userHealth.steps ?? "0";
    }
    if (healthType == 'Active Calories') {
      return userHealth.caloriesBurn ?? "0.00";
    }
    if (healthType == 'Sleep') {
      return userHealth.sleepduration ?? "0";
    }

    return "";
  }

  String getTargetUnit(String? healthType, UserHealth userHealth) {
    debugPrint('Health type ${healthType}');
    if (healthType == 'Steps') {
      return int.parse(userHealth.steps.toString()) > 1
          ? "${userHealth.steps} steps"
          : "${userHealth.steps} step" ?? "0";
    }
    if (healthType == 'Active Calories') {
      // return userHealth.caloriesBurn ?? "0";
      return double.parse(userHealth.caloriesBurn ?? "0.00") > 1
          ? "${userHealth.caloriesBurn} kcals"
          : "${userHealth.caloriesBurn} kcal";
    }
    if (healthType == 'Sleep') {
      // return userHealth.sleepduration ?? "0";
      return int.parse(userHealth.sleepduration ?? "0") > 1
          ? "${userHealth.sleepduration} hours"
          : "${userHealth.sleepduration} hour";
    }

    return "";
  }
}
