import 'dart:io';

import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/app_input.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/features/account/controller/profile_controller.dart';
import 'package:demo/features/account/controller/upload_image_controller.dart';
import 'package:demo/features/account/controller/user_state_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/image_asset.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late TextEditingController _textEditingFullName;
  late TextEditingController _textEditingEmail;
  late UploadImageController _uploadImageController;
  late String _avatarImage;
  File? _imageTem = null;

  @override
  void initState() {
    super.initState();

    _initialBinding();
  }

  @override
  Widget build(BuildContext context) {
    final appStateloading = ref.watch(appLoadingStateProvider);

    return GestureDetector(
      onTap: () {
        DeviceUtils.hideKeyboard(context);
      },
      child: Scaffold(
        appBar: AppBarCustom(
            bgColor: Colors.transparent,
            text: 'Profile',
            isCenter: true,
            foregroundColor: AppColors.backgroundLight,
            showheader: false),
        backgroundColor: AppColors.primaryLight,
        bottomSheet: Padding(
          padding: const EdgeInsets.all(Sizes.xl),
          child: Row(
            children: [
              Expanded(
                child: ButtonApp(
                    height: Sizes.lg,
                    splashColor: const Color.fromARGB(255, 190, 209, 241),
                    label: 'Save Changes',
                    onPressed: appStateloading == false
                        ? () {
                            _handleSaveProfile();
                          }
                        : null,
                    centerLabel: appStateloading == true
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: AppColors.primaryLight,
                            ),
                          )
                        : null,
                    radius: Sizes.lg,
                    textStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white) as dynamic,
                    color: AppColors.primaryColor,
                    textColor: Colors.white,
                    elevation: 0),
              )
            ],
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: SizedBox(
            height: 100.h,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.xl),
              child: Column(
                children: [
                  const SizedBox(
                    height: Sizes.lg,
                  ),
                  profileAvatar(),
                  inputTextSection(),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  void _showGallerySelection(BuildContext context) {
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
                  // _selectionBottomSheet(ImageSource.camera, type);
                  _selectionBottomSheet(ImageSource.camera);
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
                  _selectionBottomSheet(ImageSource.gallery);
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

  Column inputTextSection() {
    return Column(
      children: [
        const SizedBox(
          height: Sizes.lg,
        ),
        AppInput(
          hintText: "Full Name",
          obscureText: false,
          fillColor: true,
          backgroundColor: AppColors.backgroundLight,
          controller: _textEditingFullName,
          onChanged: (value) {
            ref
                .read(userStateControllerProvider.notifier)
                .updateFullName(value);
          },
          keyboardType: TextInputType.text,
        ),

        const SizedBox(
          height: Sizes.lg,
        ),
        AppInput(
          hintText: "Email",
          fillColor: true,
          backgroundColor: AppColors.backgroundLight,
          obscureText: false,
          controller: _textEditingEmail,
          enabled: false,
        ),
        // Spacer()
      ],
    );
  }

  Row profileAvatar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: Sizes.xs - 2,
          color: AppColors.backgroundLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                Sizes.xxxl + 100), // Match the border radius
          ),
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.xxxl + 100),
                  border: Border.all(width: Sizes.sm, color: Colors.white)),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Sizes.xxxl + 100),
                    clipBehavior: Clip.hardEdge,
                    child: _imageTem == null && _avatarImage == ""
                        ? Image.asset(
                            ImageAsset.defaultAvatar,
                            fit: BoxFit.cover,
                            height: 130,
                            width: 130,
                          )
                        : _imageTem == null
                            ? FadeInImage.assetNetwork(
                                fit: BoxFit.cover,
                                fadeInCurve: Curves.linear,
                                fadeOutCurve: Curves.bounceOut,
                                width: 130,
                                height: 130,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                    ImageAsset.placeHolderImage,
                                    fit: BoxFit.cover,
                                    height: 130,
                                    width: 130,
                                  );
                                },
                                fadeInDuration:
                                    const Duration(milliseconds: 500),
                                placeholder: ImageAsset.placeHolderImage,
                                image: _avatarImage)
                            : Image.file(
                                _imageTem!,
                                fit: BoxFit.cover,
                                height: 130,
                                width: 130,
                              ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    // left: 0,

                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color
                          shape: BoxShape.circle, // Makes it fit the icon
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.1), // Shadow color
                              blurRadius: 6, // Blur radius for the shadow
                              spreadRadius: 2, // Spread radius for the shadow
                              offset: Offset(0, 3), // Offset for the shadow
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () => _showGallerySelection(context),
                          icon: const Icon(
                            Icons.edit,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Future<void> _handleSaveProfile() async {
    ref.read(appLoadingStateProvider.notifier).setState(true);
    String email = ref.read(profileControllerProvider).email;
    String imageUrl = ref.read(profileControllerProvider).imageUrl;
    if (_imageTem != null) {
      //Meaning user has image upload we store to firebase and get downurl and store to firestore
      imageUrl = await _uploadImageController.uploadFile(_imageTem) ?? "";
      // print(_imageTem);
    }

    print(" Saving Image Url >>> ${imageUrl}");
    ref
        .read(profileControllerProvider.notifier)
        .saveUserProfile(email, _textEditingFullName.text, imageUrl ?? "", ref);
  }

  Future<void> _selectionBottomSheet(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        _imageTem = imageTemp;
      });
      // ref.read(imageControllerProvider.notifier).updateFile(imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
      HelpersUtils.showErrorSnackbar(
          duration: 2000,
          context,
          "Failed",
          "${e.message}",
          StatusSnackbar.failed);
    }
  }

  void _initialBinding() {
    _uploadImageController = UploadImageController(ref: ref);
    _textEditingFullName = TextEditingController();
    _textEditingEmail = TextEditingController();
    _textEditingFullName.text = ref.read(profileControllerProvider).fullName;
    _textEditingEmail.text = ref.read(profileControllerProvider).email;
    _avatarImage = ref.read(profileControllerProvider).imageUrl;
  }
}
