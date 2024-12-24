import 'dart:convert';
import 'dart:io';
import 'package:demo/features/home/model/user_health.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class FlutterHealthConnectService {
  static final steptypes = [
    HealthDataType.STEPS,
  ];
  static final caloriesTypes = [
    HealthDataType.ACTIVE_ENERGY_BURNED,
    // HealthDataType.TOTAL_CALORIES_BURNED,
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
          HealthDataType.STEPS,
          HealthDataType.SLEEP_ASLEEP,
          HealthDataType.ACTIVE_ENERGY_BURNED,
          // HealthDataType.TOTAL_CALORIES_BURNED,
        };

        // Check if the type is in the read-only list
        return readOnlyTypes.contains(type)
            ? HealthDataAccess.READ_WRITE
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
    final now = DateTime.now().subtract(const Duration(seconds: 1));
    final yesterday = now.add(const Duration(days: -1));

    // Initialize the Health plugin
    Health health = Health();

    // Fetch the total steps in the interval
    try {
      int? steps = await health.getTotalStepsInInterval(yesterday, now,
          includeManualEntry: false);
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

  Future requestBodySensor() async {
    PermissionStatus bodysensors = await Permission.sensors.status;
    if (bodysensors.isDenied) {
      debugPrint("bodysensors permission denied. Requesting...");
      PermissionStatus newbodysensors =
          await Permission.sensorsAlways.request();
      if (!newbodysensors.isGranted) {
        debugPrint("bodysensors permission denied. Returning false.");
        return false;
      }
    }
  }

  Future requestLocationAndActivity() async {
    PermissionStatus activityPermissionStatus =
        await Permission.activityRecognition.status;
    PermissionStatus locationPermissionStatus =
        await Permission.location.status;
    PermissionStatus bodysensors = await Permission.sensorsAlways.status;
    // If both permissions are already granted, no need to request again
    if (activityPermissionStatus.isGranted &&
        locationPermissionStatus.isGranted) {
      debugPrint("activityPermissionStatus Permissions already granted.");
      return true; // Permissions already granted, return true
    }
    if (bodysensors.isGranted && bodysensors.isGranted) {
      debugPrint("bodysensors Permissions already granted.");
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
    if (bodysensors.isDenied) {
      debugPrint("Location permission denied. Requesting...");
      PermissionStatus newbodysensors =
          await Permission.sensorsAlways.request();
      if (!newbodysensors.isGranted) {
        debugPrint("bodysensors permission denied. Returning false.");
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
    // await requestBodySensor();
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

  Future checkPermission() async {
    bool? hasPermissions = await Health()
        .hasPermissions([...steptypes, ...caloriesTypes, ...sleepTypes]);
    return hasPermissions;
  }

  Future<UserHealth?> readLatestData({DateTime? periodDate}) async {
    // Get data within the last 24 hours

    debugPrint("Period date ${periodDate}");
    final now = periodDate ?? DateTime.now();
    final yesterday = now.subtract(const Duration(hours: 24));
    try {
      // Fetch health data for the specified types and time interval
      final healthData = await Health().getHealthDataFromTypes(
        types: [
          HealthDataType.ACTIVE_ENERGY_BURNED,
          HealthDataType.STEPS,
          HealthDataType.SLEEP_ASLEEP,
          HealthDataType.SLEEP_AWAKE
        ],
        startTime: yesterday,
        endTime: now,
        // recordingMethodsToFilter: [
        //   RecordingMethod.unknown,
        //   RecordingMethod.automatic,
        //   RecordingMethod.active,
        // ]
      );

      // Remove duplicates
      List<HealthDataPoint> points = Health().removeDuplicates(healthData);

      // Filter data by type
      final sleepData = points
          .where((data) =>
              data.type == HealthDataType.SLEEP_ASLEEP ||
              data.type == HealthDataType.SLEEP_AWAKE)
          .toList();
      final caloriesData = points
          .where((data) => data.type == HealthDataType.ACTIVE_ENERGY_BURNED)
          .toList();
      final stepData =
          points.where((data) => data.type == HealthDataType.STEPS).toList();
      int? stepsFromInterval = await Health()
          .getTotalStepsInInterval(yesterday, now, includeManualEntry: true);
      // Debugging: Log filtered data
      debugPrint(
          'Sleep data Data: ${json.encode(sleepData)} ${stepsFromInterval}');
      // debugPrint('Sleep Data Count: ${sleepData.length}');
      // debugPrint('Step Data Count: ${stepData.length}');

      // if (healthData.isEmpty) {
      //   debugPrint('No data points found for the specified types and range.');
      //   return null;
      // }

      var hours = sleepData.isNotEmpty
          ? sleepData[0].value.toJson()['numeric_value'] / 60
          : 0.0;

      print("hours ${hours}");
      var calories = caloriesData.isNotEmpty
          ? caloriesData[0].value.toJson()['numeric_value']
          : "0.0";
      // var userSteps = stepData.isNotEmpty
      //     ? stepData[0].value.toJson()['numeric_value']
      //     : "0";

      // Construct UserHealth object with the extracted data
      UserHealth userHealths = UserHealth().copyWith(
        steps: stepsFromInterval.toString(),
        caloriesBurn: double.parse(calories.toString()).toStringAsFixed(2),
        sleepduration: double.parse(hours.toString()).toStringAsFixed(0),
      );

      // Debugging: Log user health data
      debugPrint(
          "User Health Data: ${userHealths.steps}, ${userHealths.caloriesBurn}, ${userHealths.sleepduration}");

      return userHealths;
    } catch (error) {
      debugPrint("Exception in getHealthDataFromTypes: $error");
      return null;
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
