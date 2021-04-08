/*
* 提示连接蓝牙设备界面
* */
import 'package:flutter/material.dart';
import 'package:sounds_recorder/theme/colors.dart';
import 'package:sounds_recorder/theme/text_style.dart';
import 'package:sounds_recorder/widgets/buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LinkFailedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: DefaultTextStyle(
        style: MyText.bodyText1,
        child: Column(
          children: [
            SizedBox(width: double.infinity),
            SizedBox(height: 128.h),
            Row(
              children: [
                SizedBox(width: 13.w),
                MyButton(
                  image: 'circle_btn_32',
                  size: 32.w,
                ),
                SizedBox(width: 9.w),
                _smallButton('1'),
                SizedBox(width: 17.w),
                _smallButton('2'),
                SizedBox(width: 17.w),
                _smallButton('3'),
              ],
            ),
            SizedBox(height: 41.h),
            Text(
              '没有找到与LeMuna的连接',
              style: TextStyle(color: kTitleTextColor),
            ),
            SizedBox(height: 113.h),
            Row(
              children: [
                SizedBox(width: 42.w),
                _smallButton('1'),
                SizedBox(width: 9.w),
                Text('将蓝牙关闭，5秒后再打开')
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                SizedBox(width: 42.w),
                _smallButton('2'),
                SizedBox(width: 9.w),
                Text('确保它在此设备的10米范围内')
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                SizedBox(width: 42.w),
                _smallButton('3'),
                SizedBox(width: 9.w),
                Text('断开任何其他设备与LeMuna的蓝牙链接')
              ],
            ),
          ],
        ),
      ),
    );
  }

  MyButton _smallButton(String str) {
    return MyButton(
      image: 'circle_btn_32',
      size: 32.w,
      child: Text(
        str,
        style: TextStyle(color: Color(0xff545C69)),
      ),
    );
  }
}
