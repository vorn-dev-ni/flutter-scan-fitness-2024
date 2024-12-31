import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/backdrop.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/core/riverpod/app_setting_controller.dart';
import 'package:demo/features/authentication/controller/tabbar_controller.dart';
import 'package:demo/features/authentication/widget/login.dart';
import 'package:demo/features/authentication/widget/register.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:flutter/material.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthenticationScreen extends ConsumerStatefulWidget {
  AuthenticationScreen({super.key});

  @override
  ConsumerState<AuthenticationScreen> createState() =>
      _AuthenticationScreenState();
}

class _AuthenticationScreenState extends ConsumerState<AuthenticationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    final tabBarIndex = ref.read(tabbarControllerProvider);

    _tabController =
        TabController(initialIndex: tabBarIndex, vsync: this, length: 2);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final appTheme = ref.watch(appSettingsControllerProvider).appTheme;
    final socialLoading = ref.watch(socaiLoginLoadingStateProvider);
    final appLoading = ref.watch(appLoadingStateProvider);
    return GestureDetector(
      onTap: () {
        DeviceUtils.hideKeyboard(context);
      },
      child: DefaultTabController(
        length: 2,
        // initialIndex: 1,
        initialIndex: _tabController.index,
        child: Scaffold(
          appBar: AppBarCustom(
              bgColor: appTheme == AppTheme.light
                  ? AppColors.backgroundLight
                  : AppColors.primaryDark,
              text: '',
              tabbar: TabBar(
                dividerHeight: 0,
                labelPadding: const EdgeInsets.all(20),
                indicatorColor: !socialLoading && !appLoading
                    ? (appTheme == AppTheme.light
                        ? AppColors.primaryColor
                        : AppColors.backgroundLight)
                    : Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                isScrollable: false,
                physics: const NeverScrollableScrollPhysics(),
                onTap: (value) {
                  if (socialLoading || appLoading) {
                    return;
                  }
                  _tabController.index = value;
                },
                indicatorWeight: 2,
                tabs: [
                  Text(
                    translations?.login ?? "Login",
                    style: appTheme == AppTheme.light
                        ? AppTextTheme.lightTextTheme.titleLarge
                            ?.copyWith(color: AppColors.backgroundLight)
                        : AppTextTheme.darkTextTheme.titleLarge,
                  ),
                  Text(
                    translations?.register ?? "Register",
                    style: appTheme == AppTheme.light
                        ? AppTextTheme.lightTextTheme.titleLarge
                            ?.copyWith(color: AppColors.backgroundLight)
                        : AppTextTheme.darkTextTheme.titleLarge,
                  ),
                ],
              ),
              isCenter: false,
              showheader: false),
          body: SafeArea(
            child: Stack(
              children: [
                TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    LoginScreen(),
                    RegisterScreen(),
                  ],
                ),
                if (socialLoading || appLoading) backDropComponent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
