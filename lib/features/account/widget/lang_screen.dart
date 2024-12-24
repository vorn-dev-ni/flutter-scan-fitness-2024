import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/core/riverpod/app_setting_controller.dart';
import 'package:demo/l10n/I10n.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:demo/utils/localization/translation_helper.dart';

class LanguageSettingScreen extends ConsumerStatefulWidget {
  const LanguageSettingScreen({super.key});

  @override
  ConsumerState<LanguageSettingScreen> createState() =>
      _LanguageSettingScreenState();
}

class _LanguageSettingScreenState extends ConsumerState<LanguageSettingScreen> {
  List<Locale> _langs = [];
  String? temporaryState = 'en';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    temporaryState = ref.read(appSettingsControllerProvider).localization;
    _langs.addAll(L10n.all);
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final appThemeRef = ref.watch(appSettingsControllerProvider).appTheme;

    return Scaffold(
      appBar: AppBarCustom(
        showheader: false,
        bgColor: AppColors.primaryDark,
        foregroundColor: AppColors.backgroundLight,
        text: tr(context).lang,
      ),
      body: SafeArea(
          child: SizedBox(
        height: 100.h,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: Sizes.xl,
              ),
              Text(translations?.lang_desc ??
                  "Select your preferered language to use"),
              const SizedBox(
                height: Sizes.md,
              ),
              ListView.builder(
                itemCount: _langs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: Sizes.md),
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      color: appThemeRef == AppTheme.light
                          ? AppColors.backgroundLight
                          : AppColors.primaryLight,
                      child: ListTile(
                        splashColor: AppColors.primaryColor.withOpacity(0.1),
                        onTap: () {
                          setState(() {
                            temporaryState = _langs[index].toLanguageTag();
                          });
                        },
                        selected:
                            temporaryState == _langs[index].toLanguageTag(),
                        tileColor: AppColors.backgroundLight,
                        trailing:
                            temporaryState == _langs[index].toLanguageTag()
                                ? const Icon(Icons.check)
                                : null,
                        leading: Text(
                          FormatterUtils.countryCodeToFlag(
                              _langs[index].toLanguageTag() == 'en'
                                  ? 'US'
                                  : 'KH'),
                          style: appThemeRef == AppTheme.light
                              ? AppTextTheme.lightTextTheme.bodyLarge
                              : AppTextTheme.darkTextTheme.bodyLarge,
                        ),
                        title: Text(
                          _langs[index].toLanguageTag() == 'en'
                              ? tr(context).english
                              : tr(context).khmer,
                          style: appThemeRef == AppTheme.light
                              ? AppTextTheme.lightTextTheme.labelLarge
                              : AppTextTheme.darkTextTheme.labelLarge
                                  ?.copyWith(color: AppColors.primaryDark),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),
              ButtonApp(
                  height: 2.h,
                  splashColor: AppColors.primaryDark.withOpacity(0.1),
                  label: translations?.confirm ?? 'Confirm',
                  onPressed: () => _confirmChange(translations),
                  radius: Sizes.lg,
                  textStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                      color: AppColors.backgroundLight,
                      fontWeight: FontWeight.w600) as dynamic,
                  color: AppColors.primaryLight,
                  textColor: Colors.white,
                  elevation: 0),
              const SizedBox(
                height: Sizes.xl,
              ),
            ],
          ),
        ),
      )),
    );
  }

  Future _confirmChange(translations) async {
    if (temporaryState != null) {
      ref
          .read(appSettingsControllerProvider.notifier)
          .updateLocalization(temporaryState!);
      await LocalStorageUtils().setKeyString("locale", temporaryState!);
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          final title = AppLocalizations.of(context)?.success_lang;
          final desc = AppLocalizations.of(context)?.success_lang_desc;
          HelpersUtils.showErrorSnackbar(
              duration: 500,
              context,
              title ?? "Language has been updated",
              desc ?? 'Successfully !!!',
              StatusSnackbar.success);
        },
      );
      // HelpersUtils.navigatorState(context).pop();
    }
  }
}
