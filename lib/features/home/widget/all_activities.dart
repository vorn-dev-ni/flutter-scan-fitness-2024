import 'package:demo/common/widget/app_bar_custom.dart';
import 'package:demo/data/service/firebase_service.dart';
import 'package:demo/data/service/firestore_service.dart';
import 'package:demo/features/home/widget/activity_list.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllActivitiesScreen extends ConsumerStatefulWidget {
  const AllActivitiesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AllActivitiesScreenState();
}

class _AllActivitiesScreenState extends ConsumerState<AllActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.lg),
            child: ActivityList(
              showHeader: false,
            ),
          ),
        ));
  }

  AppBar _appBar() {
    return AppBarCustom(
        leading: TextButton(
            onPressed: () async {
              await FirestoreService(firebaseAuthService: FirebaseAuthService())
                  .deleteAllDocument('activities');
            },
            child: Text("Delete All")),
        bgColor: AppColors.backgroundLight,
        text: 'Activities',
        showheader: false,
        isCenter: true);
  }
}
