import 'package:demo/common/model/grid_meal.dart';
import 'package:demo/data/service/firebase_remote_config.dart';
import 'package:demo/features/home/widget/activity_list.dart';
import 'package:demo/features/home/widget/grid_meal_view.dart';
import 'package:flutter/material.dart';

class GymActivity extends StatefulWidget {
  const GymActivity({
    super.key,
    required this.myMeals,
  });

  final List<Gridmeal> myMeals;

  @override
  State<GymActivity> createState() => _GymActivityState();
}

class _GymActivityState extends State<GymActivity> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (FirebaseRemoteConfigService().getBoolean("health_track") == true)
          GridMealView(data: widget.myMeals),
        ActivityList(
          showHeader: true,
        )
      ],
    );
  }
}
