import 'dart:io';
import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/data/service/gemini_service.dart';
import 'package:demo/features/result/widget/gyms/food_screen.dart';
import 'package:demo/features/result/widget/gyms/gym_screen.dart';
import 'package:demo/features/scan/controller/image_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:demo/utils/localization/translation_helper.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  bool showLoading = true;
  bool isRecent = false;
  late String imageUrl;
  late ActivityTag _activityTag;
  File? file;
  late GeminiService _geminiService = GeminiService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings?.arguments as Map;
    _activityTag = args['type'];

    file = args['file'];
    isRecent = args['recent'];
    imageUrl = args['imageUrl'];
  }

  void _showBottomSheet(BuildContext context, ActivityTag type) {
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
        // height: 28.h,
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
                  // ref.read()(ImageSource.camera, type);
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
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
      HelpersUtils.showErrorSnackbar(
          context, "Failed", "${e.message}", StatusSnackbar.failed);
    }
  }

  Widget renderResult({required ActivityTag type, File? file}) {
    return type == ActivityTag.food
        ? FoodComponent(
            tag: ActivityTag.food,
            file: file,
            imageUrl: imageUrl,
            onAction: _showBottomSheet,
            isRecent: isRecent,
          )
        : GymComponent(
            tag: ActivityTag.gym,
            file: file,
            imageUrl: imageUrl,
            onAction: _showBottomSheet,
            isRecent: isRecent,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        bgColor: AppColors.primaryDark,
        foregroundColor: AppColors.backgroundLight,
        text: _activityTag == ActivityTag.food
            ? tr(context).food_calories
            : tr(context).gym_equipment,
        showheader: false,
        isCenter: false,
      ),
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                renderResult(type: _activityTag, file: file),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
