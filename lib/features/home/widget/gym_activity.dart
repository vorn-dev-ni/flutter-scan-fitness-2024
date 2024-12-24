import 'package:demo/common/model/grid_meal.dart';
import 'package:demo/features/home/widget/activity_list.dart';
import 'package:demo/features/home/widget/grid_meal_view.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/flavor/config.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'package:sizer/sizer.dart';

class GymActivity extends ConsumerStatefulWidget {
  GymActivity({
    super.key,
    required this.myMeals,
  });

  final List<Gridmeal> myMeals;

  @override
  ConsumerState<GymActivity> createState() => _GymActivityState();
}

class _GymActivityState extends ConsumerState<GymActivity> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GridMealView(data: widget.myMeals),
          // if (AppConfig.appConfig.flavor == Flavor.dev)
          //   Row(
          //     children: [
          //       TextButton(
          //           onPressed: () async {
          //             HelpersUtils.navigatorState(context)
          //                 .pushNamed(AppPage.SLEEPS);
          //             // var now = DateTime.now();
          //             // final yesterday = now.add(const Duration(days: -1));

          //             // await Health().writeHealthData(
          //             //   value: 7, // Use `1` as a placeholder (if needed).
          //             //   unit: HealthDataUnit.HOUR,
          //             //   type: HealthDataType.SLEEP_ASLEEP,
          //             //   startTime: yesterday,
          //             //   endTime: now,
          //             //   recordingMethod: RecordingMethod.automatic,
          //             // );
          //           },
          //           child: Text('Save Sleep')),
          //       TextButton(
          //           onPressed: () async {
          //             var now = DateTime.now();
          //             final yesterday = now.add(const Duration(days: -1));

          //             await Health().writeHealthData(
          //                 value: 200,
          //                 // unit: HealthDataUnit.SMALL_CALORIE,
          //                 type: HealthDataType.ACTIVE_ENERGY_BURNED,
          //                 startTime: yesterday,
          //                 endTime: now,
          //                 recordingMethod: RecordingMethod.automatic);
          //           },
          //           child: Text('Save Calories')),
          //       TextButton(
          //           onPressed: () async {
          //             var now = DateTime.now();
          //             final yesterday = now.add(const Duration(days: -1));

          //             await Health().writeHealthData(
          //                 value: 100,
          //                 unit: HealthDataUnit.COUNT,
          //                 type: HealthDataType.STEPS,
          //                 startTime: yesterday,
          //                 endTime: now,
          //                 recordingMethod: RecordingMethod.active);
          //           },
          //           child: Text('Save Steps')),
          //     ],
          //   ),

          Expanded(
            child: ActivityList(
              showHeader: true,
            ),
          ),
        ],
      ),
    );
  }
}
