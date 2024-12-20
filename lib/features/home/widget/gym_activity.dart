import 'package:demo/common/model/grid_meal.dart';
import 'package:demo/data/service/firebase_remote_config.dart';
import 'package:demo/features/account/profile_screen.dart';
import 'package:demo/features/home/controller/activity_controller.dart';
import 'package:demo/features/home/controller/user_health_controller.dart';
import 'package:demo/features/home/widget/activity_list.dart';
import 'package:demo/features/home/widget/grid_meal_view.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
