/*
* 进入app的加载页面
* */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sounds_recorder/widgets/my_activity_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 298.h,
          ),
          _appName(),
          SizedBox(height: 50.h),
          MyActivityIndicator(radius: 22.h),
        ],
      ),
    );
  }

  Widget _appName() {
    return GestureDetector(
      onTap: () async {
        FlutterBlue flutterBlue = FlutterBlue.instance;
        flutterBlue.startScan(timeout: Duration(seconds: 4));

        flutterBlue.scanResults.listen((results) {
          for (ScanResult r in results) {
            print('${r.device.name} found');
            r.device.state.listen((BluetoothDeviceState event) {
              print('${r.device.name}:::$event');
            });
          }
        });
      },
      child: SvgPicture.asset(
        'assets/svgs/app_name.svg',
        color: Colors.black,
        height: 33.h,
      ),
    );
  }
}
