import 'package:demo/common/model/screen_app.dart';
import 'package:demo/core/riverpod/navigation_state.dart';
import 'package:demo/common/routes/routes.dart';
import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/bottom_nav.dart';
import 'package:demo/data/service/firebase_remote_config.dart';
import 'package:demo/features/account/controller/profile_controller.dart';
import 'package:demo/features/account/model/profile_state.dart';
import 'package:demo/features/app_screen.dart';
import 'package:demo/features/home/model/app_bar.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  DateTime today = HelpersUtils.getToday();
  late List<BottomNavigationBarItem> navItems = [];
  late List<ScreenApp> renderScreen = [];
  late String titleBar = "";
  String? username = "";

  @override
  void initState() {
    super.initState();
    bindingUsername();
    AppRoutes.navigationStacks.forEach(
      (element) {
        navItems.add(
          BottomNavigationBarItem(
            // icon: Icon(Icons.home),
            activeIcon: element.routeName == AppPage.NAV_SCAN
                ? Material(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(Sizes.xxxl),
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.lg),
                      child: SvgPicture.string(
                        element.iconSvg ?? "",
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                            AppColors.backgroundLight, BlendMode.srcIn),
                      ),
                    ),
                  )
                : SvgPicture.string(
                    element.iconSvg ?? "",
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                        AppColors.primaryColor, BlendMode.srcIn),
                  ),
            icon: element.routeName == AppPage.NAV_SCAN
                ? Material(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(Sizes.xxxl),
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.lg),
                      child: SvgPicture.string(
                        element.iconSvg ?? "",
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                            AppColors.backgroundLight, BlendMode.srcIn),
                      ),
                    ),
                  )
                : SvgPicture.string(
                    element.iconSvg ?? "",
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                        AppColors.primaryColor.withOpacity(0.3),
                        BlendMode.srcIn),
                  ),
            backgroundColor: AppColors.backgroundLight,
            label: element.routeName,
          ),
        );
      },
    );
  }

  Future bindingUsername() async {
    // _preferences = await SharedPreferences.getInstance();
    setState(() {
      titleBar = FirebaseRemoteConfigService()
              .getString(AppConfigState.banner_tag.value?.toString() ?? "") ??
          "N/A";
    });
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = ref.watch(navigationStateProvider);
    final profileState = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: _appBar(selectedIndex, profileState),
      body: _widgetBody(selectedIndex, renderScreen),
      bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: selectedIndex, onTap: _onTap, items: navItems),
    );
  }

  AppBarConfig getAppBarConfig(int selectedIndex, ProfileState profile_state) {
    switch (selectedIndex) {
      case 0:
        return AppBarConfig(
            text: "${titleBar} ${profile_state.fullName}",
            isCenter: false,
            showHeader: true);
      case 1:
        return const AppBarConfig(
            text: "Scan", isCenter: true, showHeader: false);
      case 2:
        return const AppBarConfig(
            text: "Profile", isCenter: false, showHeader: false);
      default:
        return const AppBarConfig(
            text: "", isCenter: false, showHeader: false); // Default values
    }
  }

  AppBar _appBar(int selectedIndex, ProfileState profile_state) {
    return AppBarCustom(
        bgColor: AppColors.backgroundLight,
        text: getAppBarConfig(selectedIndex, profile_state).text,
        showheader: getAppBarConfig(selectedIndex, profile_state).showHeader,
        isCenter: getAppBarConfig(selectedIndex, profile_state).isCenter);
  }

  SafeArea _widgetBody(int selectedIndex, renderScreen) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.xl - 2),
      child: SingleChildScrollView(
          child: navigationScreen(selectedIndex, context)),
    ));
  }

  void _onTap(int p1) {
    ref.read(navigationStateProvider.notifier).changeIndex(p1);
  }
}
