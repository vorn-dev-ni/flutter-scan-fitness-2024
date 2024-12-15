import 'package:demo/common/model/grid_meal.dart';
import 'package:demo/features/home/model/user_health.dart';
import 'package:demo/features/home/widget/grid_meal_item.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GridMealView extends StatefulWidget {
  const GridMealView({
    super.key,
    required this.data,
  });

  final List<Gridmeal> data;

  @override
  State<GridMealView> createState() => _GridMealViewState();
}

class _GridMealViewState extends State<GridMealView> {
  late UserHealth _userHealth;
  @override
  void initState() {
    // TODO: implement initState
    _userHealth =
        UserHealth(steps: '200', caloriesBurn: '100', sleepduration: '8');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Sizes.md),
      child: Column(
        children: [
          Material(
            color: const Color.fromARGB(255, 217, 236, 255),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.xl)),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(Sizes.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      userPointActivity(_userHealth.steps, 'steps'),
                      userPointActivity(_userHealth.caloriesBurn, 'calories'),
                      userPointActivity(_userHealth.sleepduration, 'sleeps'),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(Sizes.xxl),
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
                        Text(
                          '95',
                          textAlign: TextAlign.center,
                          style: AppTextTheme.lightTextTheme.displaySmall
                              ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryDark),
                        ),
                        Text(
                          'Health score',
                          textAlign: TextAlign.center,
                          style: AppTextTheme.lightTextTheme.bodyMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primaryDark),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget userPointActivity(String score, String tag) {
    final iconName = _getIconColor(tag);
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(Sizes.sm),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.xxxl),
                color: _getColor(tag)),
            child: SvgPicture.string(iconName),
          ),
          const SizedBox(
            width: Sizes.lg,
          ),
          RichText(
              text: TextSpan(
                  text: score,
                  style: AppTextTheme.lightTextTheme.bodyLarge,
                  children: [
                TextSpan(
                  text: ' ${tag}',
                  style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w300, color: AppColors.textColor),
                )
              ]))
        ],
      ),
    );
  }

  GridView BuilderGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: widget.data.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        final Gridmeal item = widget.data[index];
        return GridMealItem(
          item,
          onTap: () {},
        );
      },
      shrinkWrap: true,
    );
  }

  _getIconColor(String tag) {
    if (tag == 'steps') {
      return SvgAsset.shoesSvg;
    } else if (tag == 'calories') {
      return SvgAsset.caloriesIconSvg;
    } else {
      return SvgAsset.sleepSvg;
    }
  }

  _getColor(String tag) {
    if (tag == 'steps') {
      return AppColors.primaryLight;
    } else if (tag == 'calories') {
      return Color(0xffFF407D);
    } else {
      return Color(0xff0D9276);
    }
  }
}
