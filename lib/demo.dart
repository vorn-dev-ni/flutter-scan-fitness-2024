import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/flavor/config.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Welcome Home Screen ${AppConfig.appConfig.flavor.value}',
          style: AppTextTheme.lightTextTheme.bodyLarge
              ?.copyWith(color: AppColors.primaryColor)),
    );
  }
}
