import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/features/authentication/controller/tabbar_controller.dart';
import 'package:demo/features/authentication/widget/login.dart';
import 'package:demo/features/authentication/widget/register.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationScreen extends ConsumerStatefulWidget {
  AuthenticationScreen({super.key});

  @override
  ConsumerState<AuthenticationScreen> createState() =>
      _AuthenticationScreenState();
}

class _AuthenticationScreenState extends ConsumerState<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    final tabBarIndex = ref.watch(tabbarControllerProvider);
    return DefaultTabController(
      length: 2,
      initialIndex: tabBarIndex,
      child: Scaffold(
        appBar: AppBarCustom(
            bgColor: Colors.transparent,
            text: '',
            tabbar: TabBar(
              dividerHeight: 0,
              labelPadding: const EdgeInsets.all(20),
              indicatorColor: AppColors.primaryLight,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: Sizes.xs,
              tabs: [
                Text(
                  "Login",
                  style: AppTextTheme.lightTextTheme.titleLarge,
                ),
                Text(
                  "Register",
                  style: AppTextTheme.lightTextTheme.titleLarge,
                ),
              ],
            ),
            isCenter: false,
            showheader: false),
        body: const SafeArea(
          child: TabBarView(
            children: [
              LoginScreen(),
              RegisterScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
