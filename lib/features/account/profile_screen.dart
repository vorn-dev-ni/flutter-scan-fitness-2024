import 'dart:io';
import 'package:demo/core/riverpod/app_setting_controller.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/localization/translation_helper.dart';
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
import 'package:intl/intl.dart';
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
  DateTime? _selectedDate;
  String? _selectedGender;
  File? _imageTem = null;

  @override
  void initState() {
    super.initState();

    _initialBinding();
  }

  @override
  Widget build(BuildContext context) {
    final appStateloading = ref.watch(appLoadingStateProvider);
    final appSettings = ref.watch(appSettingsControllerProvider);
    return GestureDetector(
      onTap: () {
        DeviceUtils.hideKeyboard(context);
      },
      child: Scaffold(
        appBar: AppBarCustom(
            bgColor: AppColors.primaryDark,
            text: tr(context).profile,
            isCenter: true,
            foregroundColor: AppColors.backgroundLight,
            showheader: false),
        backgroundColor: appSettings.appTheme == AppTheme.light
            ? AppColors.backgroundLight
            : AppColors.backgroundDark,
        bottomSheet: Container(
          color: AppColors.backgroundLight,
          child: Padding(
            padding: const EdgeInsets.all(Sizes.xl),
            child: Row(
              children: [
                Expanded(
                  child: ButtonApp(
                      height: 20,
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
                      textStyle: AppTextTheme.lightTextTheme.bodyMedium
                          ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white) as dynamic,
                      color: AppColors.primaryColor,
                      textColor: Colors.white,
                      elevation: 0),
                )
              ],
            ),
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
                  profileAvatar(appSettings.appTheme!),
                  inputTextSection(
                      appSettings.appTheme!, appSettings.localization),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, appSettings) async {
    DateTime currentDate = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      locale: Locale(appSettings),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      // if (widget.onDateSelected != null) {
      //   widget.onDateSelected!(_selectedDate!);
      // }
    }
  }

  void _showGallerySelection(BuildContext context, AppTheme appTheme) {
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
                  // _selectionBottomSheet(ImageSource.camera, type);
                  _selectionBottomSheet(ImageSource.camera);
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
                  _selectionBottomSheet(ImageSource.gallery);
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

  Column inputTextSection(AppTheme appThemeRef, local) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: Sizes.lg,
        ),

        AppInput(
          hintText: "Full Name",
          obscureText: false,
          fillColor: false,
          placeholder: 'Full Name',
          controller: _textEditingFullName,
          onChanged: (value) {
            ref
                .read(userStateControllerProvider.notifier)
                .updateFullName(value);
          },
          keyboardType: TextInputType.text,
        ),

        const SizedBox(
          height: Sizes.sm,
        ),

        // const Text('Gender'),
        Text(
          'Select Gender',
          style: appThemeRef == AppTheme.light
              ? AppTextTheme.lightTextTheme.bodyLarge
              : AppTextTheme.darkTextTheme.bodyLarge,
        ),
        Row(
          children: [
            Radio<String>(
              value: _selectedGender ?? "",
              groupValue: 'Male',
              onChanged: (String? value) {
                setState(() {
                  _selectedGender = 'Male';
                });
              },
            ),
            Text(
              'Male',
              style: appThemeRef == AppTheme.light
                  ? AppTextTheme.lightTextTheme.bodyMedium
                  : AppTextTheme.darkTextTheme.bodyMedium,
            ),
            const SizedBox(width: 20),
            Radio<String>(
              value: _selectedGender ?? "",
              groupValue: 'Female',
              onChanged: (String? value) {
                setState(() {
                  _selectedGender = 'Female';
                });
              },
            ),
            Text(
              'Female',
              style: appThemeRef == AppTheme.light
                  ? AppTextTheme.lightTextTheme.bodyMedium
                  : AppTextTheme.darkTextTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(
          height: Sizes.sm,
        ),
        Text(
          'Date of birth',
          style: appThemeRef == AppTheme.light
              ? AppTextTheme.lightTextTheme.bodyLarge
              : AppTextTheme.darkTextTheme.bodyLarge,
        ),
        const SizedBox(
          height: Sizes.sm,
        ),
        InkWell(
          onTap: () {
            _selectDate(context, local);
          },
          child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(Sizes.xl),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1,
                    color: appThemeRef == AppTheme.dark
                        ? AppColors.backgroundLight
                        : AppColors.backgroundDark),
                borderRadius: BorderRadius.circular(Sizes.lg)),
            child: Text(
              _selectedDate != null
                  ? '${FormatterUtils.formatDob(_selectedDate!)}'
                  : 'Please select your date',
              style: appThemeRef == AppTheme.light
                  ? AppTextTheme.lightTextTheme.bodyLarge
                  : AppTextTheme.darkTextTheme.bodyLarge,
            ),
          ),
        )
        // Spacer()
      ],
    );
  }

  Row profileAvatar(AppTheme appTheme) {
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
                          onPressed: () =>
                              _showGallerySelection(context, appTheme),
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
    DeviceUtils.hideKeyboard(context);
    ref.read(appLoadingStateProvider.notifier).setState(true);
    String email = ref.read(profileControllerProvider).email;
    String imageUrl = ref.read(profileControllerProvider).imageUrl;
    String? gender = _selectedGender;
    String? dob;
    if (_selectedDate != null) {
      dob = FormatterUtils.formatDob(_selectedDate!);
    }
    if (_imageTem != null) {
      //Meaning user has image upload we store to firebase and get downurl and store to firestore
      imageUrl = await _uploadImageController.uploadFile(_imageTem) ?? "";
      // print(_imageTem);
    }
    print(" Saving Image Url >>> ${imageUrl}");
    ref.read(profileControllerProvider.notifier).saveUserProfile(
        email, _textEditingFullName.text, imageUrl ?? "", ref,
        dob: dob, gender: gender);
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
    DateFormat format = DateFormat("dd-MM-yyyy");
    _uploadImageController = UploadImageController(ref: ref);
    _textEditingFullName = TextEditingController();
    _textEditingEmail = TextEditingController();
    _textEditingFullName.text = ref.read(profileControllerProvider).fullName;
    _textEditingEmail.text = ref.read(profileControllerProvider).email;
    _selectedGender = ref.read(profileControllerProvider).gender;
    if (ref.read(profileControllerProvider).dob != "") {
      _selectedDate =
          format.parse(ref.read(profileControllerProvider).dob ?? "");
    }
    _avatarImage = ref.read(profileControllerProvider).imageUrl;
  }
}
