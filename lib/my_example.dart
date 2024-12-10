import 'package:demo/core/riverpod/navigation_state.dart';
import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/common/widget/bottom_nav.dart';
import 'package:demo/features/app_screen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/svg_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ExampleScreen extends ConsumerStatefulWidget {
  const ExampleScreen({super.key});

  @override
  ConsumerState<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends ConsumerState<ExampleScreen> {
  late List<BottomNavigationBarItem> navItems;

  @override
  void initState() {
    super.initState();

    // Initialize navItems
    navItems = [
      BottomNavigationBarItem(
        activeIcon: SvgPicture.string(
          SvgAsset.homeSvg,
          width: 20,
          height: 20,
          colorFilter:
              const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
        ),
        icon: SvgPicture.string(
          SvgAsset.homeSvg,
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(
              AppColors.primaryColor.withOpacity(0.5), BlendMode.srcIn),
        ),
        backgroundColor: AppColors.backgroundLight,
        label: AppPage.FIRST,
      ),
      BottomNavigationBarItem(
        activeIcon: SvgPicture.string(
          SvgAsset.accountSvg,
          width: 20,
          height: 20,
          colorFilter:
              const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
        ),
        icon: SvgPicture.string(
          SvgAsset.accountSvg,
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(
              AppColors.primaryColor.withOpacity(0.5), BlendMode.srcIn),
        ),
        backgroundColor: AppColors.backgroundLight,
        label: AppPage.SECOND,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Watch the navigation state provider
    int selectedIndex = ref.watch(navigationStateProvider);

    return Scaffold(
      appBar: AppBarCustom(
        bgColor: AppColors.backgroundLight,
        text: 'Welcome back Vorn',
        isCenter: false,
      ),
      body: navigationScreen(selectedIndex, context),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: selectedIndex,
        onTap: (int index) =>
            ref.read(navigationStateProvider.notifier).changeIndex(index),
        items: navItems,
      ),
    );
  }
}
