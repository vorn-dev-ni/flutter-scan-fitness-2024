import 'package:demo/common/model/app_setting_state.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:flutter/material.dart';

Widget CustomBottomNavigationBar(
    {required int selectedIndex,
    required AppSettingState appsettingState,
    required void Function(int) onTap,
    required List<BottomNavigationBarItem> items
// The onTap should receive the index
    }) {
  return BottomNavigationBar(
    currentIndex: selectedIndex,
    onTap: onTap, // Use onTap callback to update the index
    items: items,
    enableFeedback: false, // Disable splash/ripple effect

    selectedItemColor: appsettingState.appTheme == AppTheme.light
        ? AppColors.primaryColor
        : AppColors.backgroundLight,
    backgroundColor: appsettingState.appTheme == AppTheme.light
        ? AppColors.backgroundLight
        : AppColors.primaryDark,
    showUnselectedLabels: false,
    showSelectedLabels: false,
    elevation: 0,

    unselectedItemColor: appsettingState.appTheme == AppTheme.light
        ? AppColors.primaryLight
        : AppColors.primaryLight,
    unselectedLabelStyle: const TextStyle(color: Colors.grey),
    type: BottomNavigationBarType.fixed, // Type similar to MUI 3 style
  );
}
// [
//       BottomNavigationBarItem(
//         icon: Icon(Icons.home),
//         label: AppPage.WELCOME_HOME,
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.search),
//         label: 'Search',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.notifications),
//         label: 'Notifications',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.person),
//         label: 'Profile',
//       ),
//     ]