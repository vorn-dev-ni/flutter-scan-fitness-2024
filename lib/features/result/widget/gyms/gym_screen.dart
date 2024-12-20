// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';
import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/common/widget/error_fallback.dart';
import 'package:demo/data/service/gemini_service.dart';
import 'package:demo/features/result/controller/scan_result_controller.dart';
import 'package:demo/features/result/model/gym_model.dart';
import 'package:demo/features/result/model/scan_result_model.dart';
import 'package:demo/features/result/widget/gyms/resource_workout.dart';
import 'package:demo/features/scan/widget/selection_box.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class GymComponent extends ConsumerStatefulWidget {
  late ActivityTag tag;
  late bool isRecent;
  late String imageUrl;
  final Function(BuildContext context, ActivityTag tag) onAction;

  late File? file;
  GymComponent(
      {Key? key,
      required this.tag,
      required this.file,
      required this.imageUrl,
      required this.onAction,
      required this.isRecent})
      : super(key: key);

  @override
  _GymComponentState createState() => _GymComponentState();
}

class _GymComponentState extends ConsumerState<GymComponent> {
  final GeminiService _geminiService = GeminiService();
  late bool isRecent = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _binding();
  }

  void _retry() {
    widget.onAction(context, widget.tag);
  }

  @override
  Widget build(BuildContext context) {
    const activityTag = ActivityTag.gym;
    final scanResult = ref.watch(scanResultControllerProvider(
        activityTag, _geminiService, isRecent, widget.imageUrl));

    return SingleChildScrollView(
        child: scanResult.when(
      data: (data) {
        if (data is ScanModelResult && data.modelResult is GymResultModel) {
          final result = data.modelResult as GymResultModel;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              equipmentHeader(context, result, data.imageFile),
              overviewGym(result),
              workoutSections(result.instructions ?? []),
              ResourceWorkout(
                title: result.name ?? "N/A",
              ),
              const SizedBox(
                height: Sizes.xxl,
              )
            ],
          );
        }
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: errorFallback(
              AppException(title: "Oops", message: "Something went wrong !!!"),
              cb: _retry),
        );
      },
      error: _handleError,
      loading: () {
        return appLoadingSpinner(text: 'Please wait...');
      },
    ));
  }

  Widget? _handleError(error, stackTrace) {
    print('Error calling api ${error}');

    late AppException _appError =
        AppException(title: 'Oops', message: error.toString());

    if (error is AppException) {
      _appError = AppException(title: error.title, message: error.message);
    }

    if (error is ValidationException) {
      _appError =
          ValidationException(title: error.title, message: error.message);
    }

    if (error is FormatException) {
      _appError = AppException(title: 'Oops', message: error.message);
    }

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: errorFallback(
          AppException(title: _appError.title, message: _appError.message),
          cb: _retry),
    );
  }

  void _binding() {
    setState(() {
      isRecent = widget.isRecent;
    });
  }
}

Column equipmentHeader(BuildContext context, GymResultModel gyms, File file) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: Sizes.lg),
      ClipRRect(
          borderRadius: BorderRadius.circular(Sizes.xl),
          child: Image.file(
            file!,
            width: DeviceUtils.getDeviceWidth(context),
            height: 40.h,
            fit: BoxFit.cover,
          )),
      const SizedBox(height: Sizes.md),
      Text(
        gyms.name ?? "N/A",
        // textAlign: TextAlign.,
        style: AppTextTheme.lightTextTheme.bodyLarge
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: Sizes.md),
      Text(
        gyms.summary ??
            "This machine targets the triceps muscles, located on the back of your upper arms. It's a great tool for building strength and definition in your arms.",
        textAlign: TextAlign.left,
        style: AppTextTheme.lightTextTheme.titleSmall,
      ),
    ],
  );
}

Widget workoutSections(List<String> instructions) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: Sizes.md),
      Text(
        "Workout Instructions",
        // textAlign: TextAlign.,
        style: AppTextTheme.lightTextTheme.bodyLarge
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: Sizes.md),
      ListView.builder(
        itemCount: instructions.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: Sizes.sm),
            child: ListTile(
                onTap: () {},
                tileColor: AppColors.secondaryColor,
                splashColor: AppColors.primaryColor.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.xl)),
                contentPadding: const EdgeInsets.all(Sizes.md),
                title: Text(
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  instructions[index],
                  style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                leading: Text(
                  '${index + 1}/. ',
                  style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                trailing: Material(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(Sizes.md),
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.md),
                    child: SvgPicture.string(
                      SvgAsset.dumbellSvg,
                      width: 3.w,
                      height: 3.h,
                    ),
                  ),
                )),
          );
        },
      )
    ],
  );
}

Widget overviewGym(GymResultModel gym) {
  print(json.encode(gym));
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: Sizes.md),
      Text(
        "Overview",
        // textAlign: TextAlign.,
        style: AppTextTheme.lightTextTheme.bodyLarge
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: Sizes.md),
      SelectionBox(
          SizedBox(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gym.caloriesBurnPerSet ?? "0",
                      style: AppTextTheme.lightTextTheme.titleLarge
                          ?.copyWith(color: AppColors.backgroundLight),
                    ),
                    Text(
                      "calories",
                      style: AppTextTheme.lightTextTheme.bodyMedium
                          ?.copyWith(color: AppColors.backgroundLight),
                    ),
                  ],
                ),
                const Spacer(),
                Material(
                  color: Color(0xffF5C3C3),
                  borderRadius: BorderRadius.circular(Sizes.xl),
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.sm),
                    child: SvgPicture.string(
                      SvgAsset.caloriesIconSvg,
                      width: 3.w,
                      height: 3.h,
                      colorFilter: const ColorFilter.mode(
                          Color(0xffFF6767), BlendMode.srcIn),
                    ),
                  ),
                )
              ],
            ),
          ),
          backgroundColor: Color(0xffFF9898),
          splashColor: const Color.fromARGB(255, 235, 69, 69),
          highlightColor: const Color(0xffFF6767).withOpacity(0.2),
          onPress: () {}),
      const SizedBox(height: Sizes.md),
      SelectionBox(
          SizedBox(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gym.set?.toString() ?? "300 -400",
                      style: AppTextTheme.lightTextTheme.titleLarge?.copyWith(
                          color: const Color.fromRGBO(59, 134, 254, 1)),
                    ),
                    Text(
                      "sets",
                      style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                          color: const Color.fromRGBO(59, 134, 254, 1)),
                    ),
                  ],
                ),
                Spacer(),
                Material(
                  color: const Color.fromRGBO(59, 134, 254, 1),
                  borderRadius: BorderRadius.circular(Sizes.xl),
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.sm),
                    child: SvgPicture.string(
                      SvgAsset.durationSvg,
                      width: 3.w,
                      height: 3.h,
                      colorFilter: const ColorFilter.mode(
                          Color.fromARGB(255, 255, 255, 255), BlendMode.srcIn),
                    ),
                  ),
                )
              ],
            ),
          ),
          backgroundColor: Color(0xffBFDDFF),
          splashColor: Color.fromARGB(255, 169, 201, 237),
          highlightColor: const Color.fromARGB(255, 146, 197, 255),
          onPress: () {}),
      const SizedBox(height: Sizes.md),
      SelectionBox(
          SizedBox(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${gym.rep}' ?? "300 -400",
                      style: AppTextTheme.lightTextTheme.titleLarge
                          ?.copyWith(color: AppColors.primaryColor),
                    ),
                    Text(
                      "reps per set ",
                      style: AppTextTheme.lightTextTheme.bodyMedium
                          ?.copyWith(color: AppColors.primaryColor),
                    ),
                  ],
                ),
                Spacer(),
                Material(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(Sizes.xl),
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.sm),
                    child: SvgPicture.string(
                      SvgAsset.dumbellSvg,
                      width: 3.w,
                      height: 3.h,
                      colorFilter: const ColorFilter.mode(
                          Color.fromARGB(255, 255, 255, 255), BlendMode.srcIn),
                    ),
                  ),
                )
              ],
            ),
          ),
          backgroundColor: const Color(0xffF2F8FF),
          splashColor: AppColors.primaryColor.withOpacity(0.2),
          highlightColor:
              const Color.fromARGB(255, 26, 132, 252).withOpacity(0.2),
          onPress: () {})
    ],
  );
}
