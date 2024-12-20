import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demo/core/riverpod/app_setting_controller.dart';
import 'package:demo/core/riverpod/connectivity_state.dart';
import 'package:demo/data/service/firebase_remote_config.dart';
import 'package:demo/data/service/notification_service.dart';
import 'package:demo/l10n/I10n.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/flavor/config.dart';
import 'package:demo/utils/global_config.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:demo/utils/theme/schema.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _backgroundHandler(RemoteMessage message) async {
  // Handle background message
}
// import 'package:flutter_config/flutter_config.dart';
void main() async {
  // await FlutterConfig.loadEnvVariables();
  AppConfig.create(flavor: Flavor.dev);
  await GlobalConfig().init();
  await LocalStorageUtils().init();
  await FirebaseRemoteConfigService().init();
  await FirebaseMessaging.instance.requestPermission();

  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

  //Detech Flutter platform crash
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  //Detech Native Platform crash
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late String titleBar;
  late StreamSubscription<dynamic> _streamSubscription;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    HelpersUtils.removeSplashScreen();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Message data: ${message.data}');
      await NotificationLocalService.showNotificaiton(message);
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked! ${message.messageId}');
    });
    _systemDeviceChrome();
    _localNotificationInit();
    _streamSubscription = ref
        .read(connectivityStateProvider.notifier)
        .onConnectivityChange()
        .listen(
      (event) {
        if (kDebugMode) {
          print("Connection state is ${event.toString()}");
        }
        _handleCheckConnection(event);
      },
    );
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    _systemDeviceChrome();
    super.dispose();
  }

  void _handleCheckConnection(List<ConnectivityResult> event) {
    if (event.contains(ConnectivityResult.none)) {
      if (kDebugMode) {
        print("No Internet !! ");
      }
      navigatorKey.currentState?.pushNamed(
        AppPage.NO_INTERNET,
      );
    } else {
      if (kDebugMode) {
        print(" Internet is back !! ");
      }
      if (navigatorKey.currentState?.canPop() == true) {
        navigatorKey.currentState?.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      final appsettingState = ref.watch(appSettingsControllerProvider);

      return MaterialApp(
        title: 'Flutter Dev',
        locale: Locale(appsettingState.localization),
        supportedLocales: L10n.all,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        themeMode: appsettingState.appTheme == AppTheme.light
            ? ThemeMode.light
            : ThemeMode.dark,

        // routes: AppRoutes.getAppRoutes(),
        navigatorKey: navigatorKey,
        onGenerateRoute: (settings) =>
            GlobalConfig.instance.onGenerateRoute(settings),
        darkTheme: SchemaData.darkThemeData(
          Locale(appsettingState.localization),
        ),
        theme: SchemaData.lightThemeData(
          Locale(appsettingState.localization),
        ),
        initialRoute: AppPage.FIRST,
        // home: const MainScreen(),
      );
    });
  }

  Future _systemDeviceChrome() async {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    await DeviceUtils.setToPortraitModeOnly();
  }

  Future _localNotificationInit() async {
    await NotificationLocalService.init(context);
  }
}
