import 'dart:io';
import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/data/service/gemini_service.dart';
import 'package:demo/features/result/controller/scan_result_controller.dart';
import 'package:demo/features/result/model/gym_model.dart';
import 'package:demo/features/result/model/scan_result_model.dart';
import 'package:demo/features/result/widget/gyms/food_screen.dart';
import 'package:demo/features/result/widget/gyms/gym_screen.dart';
import 'package:demo/features/scan/controller/image_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  bool showLoading = true;
  bool isDisposed = false;
  late ActivityTag _activityTag;
  late File file;
  late GeminiService _geminiService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _geminiService = GeminiService(
        model: GenerativeModel(
      model: dotenv!.env!['MODEL']!.toString(),
      apiKey: dotenv!.env!['GEMINI_API'].toString(),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings?.arguments as Map;
    _activityTag = args['type'];
    file = args['file'];
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
                  // ref.read()(ImageSource.camera, type);
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

  Future<void> _selectionBottomSheet(
      ImageSource imageSource, ActivityTag type) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;
      final imageTemp = File(image.path);
      ref.read(imageControllerProvider.notifier).updateFile(imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
      HelpersUtils.showErrorSnackbar(
          context, "Failed", "${e.message}", StatusSnackbar.failed);
    }
  }

  Widget renderResult({required ActivityTag type, required File file}) {
    return type == ActivityTag.food
        ? FoodComponent(
            tag: ActivityTag.food,
            file: this.file,
            onAction: _showBottomSheet,
          )
        : GymComponent(
            tag: ActivityTag.gym,
            file: this.file,
            onAction: _showBottomSheet,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        bgColor: AppColors.backgroundLight,
        text: _activityTag == ActivityTag.food ? "Foods" : "Gym",
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

  void _retry() {}
}
