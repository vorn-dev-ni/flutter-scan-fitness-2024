// ignore_for_file: non_constant_identifier_names
import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/common/widget/bodyno_found.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/common/widget/duration_card.dart';
import 'package:demo/common/widget/error_fallback.dart';
import 'package:demo/common/widget/tag_cad.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/features/home/controller/activity_controller.dart';
import 'package:demo/features/home/model/activity_model.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/image_asset.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityList extends ConsumerStatefulWidget {
  late bool showHeader;
  ActivityList({super.key, this.showHeader = true});

  @override
  ConsumerState<ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends ConsumerState<ActivityList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activitiesStream = ref.watch(
      activityControllerProvider(
          FirebaseAuthService().currentUser?.uid ?? "", widget.showHeader),
    );

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.lg),
        child: activitiesStream.when(
          data: (data) {
            final activities = data.docs;
            if (activities.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.showHeader == true) TouchableHeader(),
                    Center(
                      child: bodyNoFound(
                          context,
                          body:
                              "You no recent activities yet, let\'s start now !!!",
                          "No Activity"),
                    )
                  ],
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: widget.showHeader
                  ? const NeverScrollableScrollPhysics()
                  : const AlwaysScrollableScrollPhysics(),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final mapRespose =
                    activities[index].data() as Map<String, dynamic>;
                final data = ActivityModel.fromJson(mapRespose);
                return Column(
                  children: [
                    if (index == 0 && widget.showHeader) TouchableHeader(),
                    AcitivtyTabItem(data)
                  ],
                );
              },
            );
          },
          error: (error, stackTrace) {
            print(error.toString());
            final appError =
                AppException(title: "Oops", message: error.toString());
            return errorFallback(appError, cb: () {
              ref.invalidate(activityControllerProvider);
            });
          },
          loading: () {
            return appLoadingSpinner();
          },
        ));
  }

  Widget AcitivtyTabItem(ActivityModel activities) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.sm),
      child: Material(
        color: AppColors.secondaryColor,
        elevation: 0,
        type: MaterialType.button,
        // clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(Sizes.xl),
        child: InkWell(
          onTap: () => _handleNavigate(activities),
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.blue.withOpacity(0.3),
          highlightColor: Colors.blue.withOpacity(0.1),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    fadeInCurve: Curves.linear,
                    fadeOutCurve: Curves.bounceOut,
                    width: 80,
                    height: 80,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        ImageAsset.placeHolderImage,
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                      );
                    },
                    // imageCacheHeight: 80,
                    // imageCacheWidth: 80,
                    fadeInDuration: const Duration(milliseconds: 500),
                    placeholder: ImageAsset.placeHolderImage,
                    image: activities.imageUrl ?? "",
                  ),
                ),
              ),
              const SizedBox(
                width: Sizes.sm,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      activities.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.lightTextTheme.titleMedium
                          ?.copyWith(color: AppColors.primaryColor),
                    ),
                    // const SizedBox(
                    //   height: Sizes.sm - 2,
                    // ),
                    const SizedBox(
                      height: Sizes.sm - 2,
                    ),
                    Row(
                      // mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // const SizedBox(
                        //   height: Sizes.sm - 2,
                        // ),
                        const SizedBox(
                          height: Sizes.sm - 2,
                        ),
                        TagCard(label: activities.tag),
                        const Spacer(),
                        const SizedBox(
                          height: Sizes.sm - 2,
                        ),
                        if (activities.createdAt != null)
                          Padding(
                              padding: const EdgeInsets.only(right: Sizes.lg),
                              child: DurationCard(
                                  label:
                                      "${timeago.format(activities!.createdAt!)}")),
                      ],
                    ),
                    const SizedBox(
                      height: Sizes.sm - 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget TouchableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Sizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Activity',
            style: AppTextTheme.lightTextTheme.bodyLarge
                ?.copyWith(color: AppColors.textColor),
          ),
          ButtonApp(
              splashColor: AppColors.primaryColor,
              label: 'View All',
              onPressed: () {
                HelpersUtils.navigatorState(context)
                    .pushNamed(AppPage.ACTIVITIES);
              },
              radius: Sizes.lg,
              textStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600) as dynamic,
              color: AppColors.secondaryColor,
              textColor: Colors.white,
              elevation: 0),
        ],
      ),
    );
  }

  _handleNavigate(activities) {
    try {
      print(activities.imageUrl);
      if (activities.imageUrl != null || activities.imageUrl != "") {
        HelpersUtils.navigatorState(context)
            .pushNamed(AppPage.RESULT, arguments: {
          'type': activities.tag == 'food' ? ActivityTag.food : ActivityTag.gym,
          'imageUrl': activities?.imageUrl,
          'recent': true
        });
      }
    } catch (e) {
      HelpersUtils.showErrorSnackbar(
          context, "Oops", e.toString(), StatusSnackbar.failed);
    }
  }
}
