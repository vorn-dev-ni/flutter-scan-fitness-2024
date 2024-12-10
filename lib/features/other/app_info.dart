import 'package:demo/common/widget/error_fallback.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfo extends StatefulWidget {
  const AppInfo({
    super.key,
  });

  @override
  State<AppInfo> createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
  late Future<PackageInfo> _result;
  String deviceName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDevicename();
    _result = _checkAppinfo();
  }

  Future<void> getDevicename() async {
    final resultName = await DeviceUtils.getDeviceName();
    setState(() {
      deviceName = resultName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _result,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final appInfo = snapshot.data;
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: Sizes.lg,
                  ),
                  Text('App Version Code ${appInfo?.version}'),
                ],
              ),
            );
          }
        }

        if (snapshot.hasError) {
          return errorFallback(
              cb: () {},
              AppException(
                title: "Oops",
                message: snapshot.error.toString(),
              ));
        }

        return const Text('');
      },
    );
  }

  Future<PackageInfo> _checkAppinfo() async {
    return await DeviceUtils.getAppInfoPackage();
  }
}
