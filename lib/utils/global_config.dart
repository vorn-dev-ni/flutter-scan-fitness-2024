import 'dart:io';

import 'package:demo/common/model/route_app.dart';
import 'package:demo/common/model/screen_app.dart';
import 'package:demo/common/routes/routes.dart';
import 'package:demo/data/service/health_connect.dart';
import 'package:demo/features/home/main_screen.dart';
import 'package:demo/features/other/not_found.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/firebase/firebase.dart';
import 'package:demo/utils/firebase/firebase_options.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:permission_handler/permission_handler.dart';

class GlobalConfig {
  static final GlobalConfig instance = GlobalConfig._internal();
  final FlutterHealthConnectService _flutterHealthConnectService =
      FlutterHealthConnectService();

  GlobalConfig._internal(); //Private Constructor
  factory GlobalConfig() {
    return instance;
  }
  Future requestBodySensor() async {
    // PermissionStatus permissionStatus = await Permission.sensors.status;
    // debugPrint('${permissionStatus}');
    // if (permissionStatus.isPermanentlyDenied || permissionStatus.isDenied) {
    //   return;
    // }
    PermissionStatus bodysensors = await Permission.sensors.request();
    if (bodysensors.isDenied) {
      debugPrint("bodysensors permission denied. Requesting...");
      if (!bodysensors.isGranted) {
        debugPrint("bodysensors permission denied. Returning false.");
        // return false;
      }
    }
  }

  Future healthInit() async {
    await _flutterHealthConnectService.init();
    // Check and request permissions
    bool isAuthorized = await _flutterHealthConnectService.authorize();
    print("request areceived >> ${isAuthorized}");

    HelpersUtils.delay(3000, () async {
      await _flutterHealthConnectService.requestHealthConnectPermission();
    });
  }

  Future<void> init() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await dotenv.load(fileName: ".env.dev");
    // await _flutterHealthConnectService.requestPermissions();
    // await healthInit();
    await initializeFirebaseApp(DefaultFirebaseOptions.currentPlatform);
    await Permission.activityRecognition.request();
    await Permission.location.request();
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // print('App Routes ${AppRoutes.mainStacks.toString()}');

    final email = LocalStorageUtils().getKey('email');
    final fullname = LocalStorageUtils().getKey('fullname');

    if (kDebugMode) {
      print('>>> On initial route call setting ${settings.name} ${email}');
    }

    final matchingRoute = AppRoutes.mainStacks.firstWhere(
      (route) => route.routeName == settings.name,
      orElse: () => RoutesApp(
          routeName: AppPage.NOTFOUND, builder: (context) => NotFoundScreen()),
    );

    final navigationRoute = AppRoutes.navigationStacks.firstWhere(
      (route) => route.routeName == settings.name,
      orElse: () => ScreenApp(
          routeName: AppPage.NOTFOUND,
          arguments: null,
          builder: (context) => NotFoundScreen()),
    );

    if (navigationRoute.routeName == AppPage.NOTFOUND &&
        matchingRoute.routeName == AppPage.NOTFOUND) {
      // Screen does not exist
      return MaterialPageRoute(
        builder: (context) => NotFoundScreen(),
        settings: settings,
      );
    }

    if (settings.name == "Welcome" && email != null && fullname != null) {
      return MaterialPageRoute(
        builder: (context) => const MainScreen(),
        settings: settings,
      );
    }

    return MaterialPageRoute(
      builder: (context) => matchingRoute.builder(context),
      settings: settings,
    );
  }
}
