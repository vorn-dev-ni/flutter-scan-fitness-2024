import 'dart:io';
import 'package:demo/features/scan/controller/image_controller.dart';
import 'package:demo/features/scan/widget/selection_box.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/constant/string_text.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

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
                StringAsset.scanBtnTop,
                style: AppTextTheme.lightTextTheme.bodyLarge,
              ),
              Text(
                StringAsset.bodyGym,
                style: AppTextTheme.lightTextTheme.bodySmall,
              ),
              SvgPicture.string(
                SvgAsset.gymFitnessSvg,
                width: 18.w,
                height: 18.h,
                fit: BoxFit.cover,
              ),
              // Text(
              //   StringAsset.bodyGym,
              //   style: AppTextTheme.lightTextTheme.bodySmall,
              // ),

              // Image.asset(
              //   ImageAsset.fit,
              //   width: 109,
              //   height: 109,
              //   fit: BoxFit.contain,
              // )
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
                StringAsset.scanBtnBottom,
                style: AppTextTheme.lightTextTheme.bodyLarge,
              ),
              Text(
                StringAsset.detailFoods,
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
      final imageTemp = File(image.path);
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
          context, "Failed", "${e.message}", StatusSnackbar.failed);
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
              const Text(
                "Choose",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  "Camera",
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
                  "Gallery",
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
