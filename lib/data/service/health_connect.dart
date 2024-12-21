import 'dart:io';
import 'package:demo/features/home/model/user_health.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class FlutterHealthConnectService {
  static final steptypes = [
    HealthDataType.STEPS,
  ];
  static final caloriesTypes = [
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];
  static final sleepTypes = [
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_AWAKE,
  ];
  List<RecordingMethod> recordingMethodsToFilter = [];

  static final FlutterHealthConnectService _instance =
      FlutterHealthConnectService._internal();

  FlutterHealthConnectService._internal();

  factory FlutterHealthConnectService() {
    return _instance;
  }
  List<HealthDataAccess> get permissions =>
      [...steptypes, ...caloriesTypes, ...sleepTypes].map((type) {
        // Define a set of types that require only READ access
        const readOnlyTypes = {
          HealthDataType.ELECTROCARDIOGRAM,
          HealthDataType.EXERCISE_TIME,
          HealthDataType.STEPS,
          HealthDataType.SLEEP_ASLEEP,
          HealthDataType.SLEEP_IN_BED,
          HealthDataType.SLEEP_AWAKE,
        };

        // Check if the type is in the read-only list
        return readOnlyTypes.contains(type)
            ? HealthDataAccess.READ
            : HealthDataAccess.READ_WRITE;
      }).toList();

  Future<void> init() async {
    await Health().configure();
    await Health().getHealthConnectSdkStatus();
  }

  /// Install Google Health Connect on the device
  Future<void> installHealthConnect() async {
    if (Platform.isAndroid) {
      await Health().installHealthConnect();
    } else {
      debugPrint("Health Connect is only available on Android.");
    }
  }

  Future<bool> authorize() async {
    if (!Platform.isAndroid) {
      debugPrint("Authorization is only required on Android.");
      return false;
    }

    HealthConnectSdkStatus? sdkStatus = await getHealthConnectSdkStatus();

    if (sdkStatus == HealthConnectSdkStatus.sdkUnavailable ||
        sdkStatus ==
            HealthConnectSdkStatus.sdkUnavailableProviderUpdateRequired) {
      debugPrint("Health Connect not installed, installing now...");
      await installHealthConnect();
    } else {
      debugPrint("Health Connect is already installed.");
    }

    // Once permissions are granted, proceed to request Health Connect permission
    return requestHealthConnectPermission();
  }

  Future<int?> fetchSteps() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(hours: 24));

    // Initialize the Health plugin
    Health health = Health();

    // Fetch the total steps in the interval
    try {
      int? steps = await health.getTotalStepsInInterval(yesterday, now);
      print('Steps in the last 1 seconds: $steps');
      if (steps != null) {
        print('Steps in the last 1 seconds: $steps');
      } else {
        print(' fetch steps. ${steps}');
      }
      return steps;
    } catch (e) {
      print('Error fetching steps: $e');
    }
  }

  Future requestLocationAndActivity() async {
    PermissionStatus activityPermissionStatus =
        await Permission.activityRecognition.status;
    PermissionStatus locationPermissionStatus =
        await Permission.location.status;

    // If both permissions are already granted, no need to request again
    if (activityPermissionStatus.isGranted &&
        locationPermissionStatus.isGranted) {
      debugPrint("Permissions already granted.");
      return true; // Permissions already granted, return true
    }

    if (activityPermissionStatus.isDenied) {
      debugPrint("Activity recognition permission denied. Requesting...");
      PermissionStatus newActivityStatus =
          await Permission.activityRecognition.request();
      if (!newActivityStatus.isGranted) {
        debugPrint("Activity recognition permission denied. Returning false.");
        return false;
      }
    }

    if (locationPermissionStatus.isDenied) {
      debugPrint("Location permission denied. Requesting...");
      PermissionStatus newLocationStatus = await Permission.location.request();
      if (!newLocationStatus.isGranted) {
        debugPrint("Location permission denied. Returning false.");
        return false;
      }
    }
  }

  Future<bool> requestHealthConnectPermission() async {
    bool? hasPermissions = await Health().hasPermissions(
        [...steptypes, ...caloriesTypes, ...sleepTypes],
        permissions: permissions);
    debugPrint("Health permission is ${hasPermissions}");
    if (hasPermissions == false || hasPermissions == null) {
      try {
        bool authorized = await Health().requestAuthorization(
          [...steptypes, ...caloriesTypes, ...sleepTypes],
          permissions: permissions,
        );
        return authorized;
      } catch (error) {
        debugPrint("Exception in requesting permissions: $error");
        return false;
      }
    }
    return hasPermissions ?? false;
  }

  Future<UserHealth?> readLatestData() async {
    // get data within the last 24 hours
    final now = DateTime.now();
    UserHealth? userhealths;

    final yesterday = now.subtract(const Duration(hours: 24));
    int? userSteps = await fetchSteps();
    debugPrint("User step is ${userSteps}");
    // _healthDataList.clear();
    try {
      List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: [...caloriesTypes, ...sleepTypes],
        startTime: yesterday,
        endTime: now,
      );
      debugPrint('Total number of data points: ${healthData.length}. '
          '${healthData.length > 100 ? 'Only showing the first 100.' : ''}');
      // healthData.sort((a, b) => b.dateTo.compareTo(a.dateTo));
      // healthData = Health().removeDuplicates(healthData);

      String caloriesBurn = '0';
      String sleepduration = '0';
      for (var dataPoint in healthData) {
        if (dataPoint.type == HealthDataType.TOTAL_CALORIES_BURNED) {
          caloriesBurn = dataPoint.value.toString();
        } else if (dataPoint.type == HealthDataType.SLEEP_IN_BED) {
          sleepduration = dataPoint.value.toString();
        }
        userhealths = UserHealth().copyWith(
            sleepduration: sleepduration,
            caloriesBurn: caloriesBurn,
            steps: userSteps?.toString());
      }

      return userhealths;

      // save all the new data points (only the first 100)
    } catch (error) {
      debugPrint("Exception in getHealthDataFromTypes: $error");
    }
  }

  Future<HealthConnectSdkStatus?> getHealthConnectSdkStatus() async {
    if (Platform.isAndroid) {
      return await Health().getHealthConnectSdkStatus();
    } else {
      throw UnsupportedError("Health Connect is only supported on Android.");
    }
  }
}
