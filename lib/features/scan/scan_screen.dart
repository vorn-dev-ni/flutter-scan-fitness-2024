import 'dart:io';
import 'package:demo/features/scan/controller/image_controller.dart';
import 'package:demo/features/scan/widget/selection_box.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:demo/utils/localization/translation_helper.dart';
import 'package:image_cropper/image_cropper.dart';

class ScanScreen extends ConsumerStatefulWidget {
  ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  File? image;
  @override
  Widget build(BuildContext context) {
    ref.watch(imageControllerProvider);
    return Column(
      children: [
        const SizedBox(
          height: Sizes.xl,
        ),
        SelectionBox(
          onPress: () {
            // _handleScanGym(context)
            showBottomSheet(context, ActivityTag.gym);
          },
          backgroundColor: const Color(0xffF0F0FF),
          highlightColor: const Color.fromARGB(255, 207, 207, 255),
          splashColor: const Color.fromARGB(255, 221, 221, 255),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                tr(context).gym_equipment,
                style: AppTextTheme.lightTextTheme.bodyLarge,
              ),
              Text(
                tr(context).gym_equipment_info,
                style: AppTextTheme.lightTextTheme.bodySmall,
              ),
              SvgPicture.string(
                SvgAsset.gymFitnessSvg,
                width: 18.w,
                height: 18.h,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: Sizes.lg,
        ),
        SelectionBox(
          onPress: () {
            // _handleScanFoods(context);
            showBottomSheet(context, ActivityTag.food);
          },
          backgroundColor: const Color(0xffFFF9F0),
          highlightColor: const Color.fromARGB(255, 255, 241, 214),
          splashColor: const Color.fromARGB(255, 255, 239, 215),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                tr(context).food_calories,
                style: AppTextTheme.lightTextTheme.bodyLarge,
              ),
              Text(
                tr(context).food_calories_info,
                style: AppTextTheme.lightTextTheme.bodySmall,
              ),
              SvgPicture.string(
                SvgAsset.foodCaloriesSvg,
                width: 18.w,
                height: 18.h,
                fit: BoxFit.cover,
              ), // SvgPicture.asset(
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectionBottomSheet(
      ImageSource imageSource, ActivityTag type) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 50,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppColors.primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
            ],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
            ],
          ),
        ],
      );
      final path = croppedFile!.path;
      final imageTemp = File(path);
      ref.read(imageControllerProvider.notifier).updateFile(imageTemp);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        HelpersUtils.navigatorState(context).pushNamed(AppPage.RESULT,
            arguments: {
              'type': type,
              'file': imageTemp,
              'recent': false,
              'imageUrl': ""
            });
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
      HelpersUtils.showErrorSnackbar(
          duration: 5000,
          context,
          "Failed",
          "${e.message}",
          StatusSnackbar.failed);
    }
  }

  // Future<File?> _openGalleryCamera() async {
  void showBottomSheet(BuildContext context, ActivityTag type) {
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
        height: 25.h,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr(context).choose,
                style: AppTextTheme.lightTextTheme?.bodyLarge
                    ?.copyWith(color: AppColors.backgroundDark),
              ),
              const SizedBox(
                height: Sizes.xl,
              ),
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: Sizes.sm),
                onTap: () {
                  _selectionBottomSheet(ImageSource.camera, type);
                  HelpersUtils.navigatorState(context).pop();
                },
                title: Text(
                  tr(context).camera,
                  style: AppTextTheme.lightTextTheme.labelLarge,
                ),
                leading: SvgPicture.string(
                  SvgAsset.cameraSvg,
                  width: 18,
                  height: 18,
                ),
              ),
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: Sizes.sm),
                onTap: () {
                  _selectionBottomSheet(ImageSource.gallery, type);
                  HelpersUtils.navigatorState(context).pop();
                },
                title: Text(
                  tr(context).gallery,
                  style: AppTextTheme.lightTextTheme.labelLarge,
                ),
                leading: SvgPicture.string(
                  SvgAsset.gallerySvg,
                  width: 18,
                  height: 18,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
