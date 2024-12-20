import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/features/home/controller/activity_controller.dart';
import 'package:demo/features/home/widget/activity_list.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/utils/localization/translation_helper.dart';
import 'package:sizer/sizer.dart';

class AllActivitiesScreen extends ConsumerStatefulWidget {
  const AllActivitiesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AllActivitiesScreenState();
}

class _AllActivitiesScreenState extends ConsumerState<AllActivitiesScreen> {
  String? sortBy = 'desc';
  @override
  Widget build(BuildContext context) {
    debugPrint("Re render ${sortBy}");
    final isLoading = ref.watch(appLoadingStateProvider);
    return Scaffold(
        appBar: _appBar(isLoading),
        body: SafeArea(
          child: RefreshIndicator(
            color: AppColors.backgroundLight,
            backgroundColor: AppColors.primaryColor,
            onRefresh: () {
              // ref.invalidate(userHealthControllerProvider);
              ref.invalidate(activityControllerProvider);
              debugPrint("Refreshing state now");
              return Future.delayed(const Duration(seconds: 2));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.lg),
              child: Padding(
                padding: const EdgeInsets.only(top: Sizes.lg),
                child: ActivityList(
                  showHeader: false,
                  // key: UniqueKey(),
                  sortBy: sortBy,
                ),
              ),
            ),
          ),
        ));
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        width: double.maxFinite,

        height: 20.h,
        // height: 28.h,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: Sizes.sm),
                onTap: () {
                  // ref.read()(ImageSource.camera, type);
                  // _selectionBottomSheet(ImageSource.camera, type);
                  setState(() {
                    sortBy = 'asc';
                    HelpersUtils.navigatorState(context).pop();
                  });
                },
                trailing: sortBy == 'asc'
                    ? const Icon(
                        Icons.check,
                        color: AppColors.primaryColor,
                      )
                    : null,
                title: Text(
                  "Sort by date Ascending",
                  style: AppTextTheme.lightTextTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w400),
                ),
              ),
              const Divider(
                color: AppColors.primaryGrey,
              ),
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: Sizes.sm),
                trailing: sortBy == 'desc'
                    ? const Icon(
                        Icons.check,
                        color: AppColors.primaryColor,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    sortBy = 'desc';
                    HelpersUtils.navigatorState(context).pop();
                  });
                },
                title: Text(
                  "Sort by date Descending",
                  style: AppTextTheme.lightTextTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(bool isloading) {
    return AppBarCustom(
        bgColor: AppColors.primaryDark,
        foregroundColor: AppColors.backgroundLight,
        text: tr(context).activities,
        showheader: false,
        leading: !isloading
            ? IconButton(
                onPressed: () {
                  _showBottomSheet(context);
                },
                icon: const Icon(
                  Icons.sort_outlined,
                  size: Sizes.xxxl,
                ))
            : null,
        isCenter: true);
  }
}
