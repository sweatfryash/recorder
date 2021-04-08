/*
* 关于界面
* */
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sounds_recorder/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_recorder/theme/text_style.dart';
import 'package:sounds_recorder/widgets/buttons.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          SizedBox(height: 115.h, width: double.infinity),
          Image.asset('assets/images/icon.png', width: 73.w),
          SizedBox(height: 26.h),
          SvgPicture.asset(
            'assets/svgs/app_name.svg',
            color: Color(0xffB0B0B0),
            width: 160.w,
          ),
          SizedBox(height: 144.h),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 28.w, right: 25.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('产品使用说明', style: MyText.bodyText1),
                    MyButton(
                        image: '36_link', size: 36.w, onTap: onProductUseTap)
                  ],
                ),
                buildDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('官网', style: MyText.bodyText1),
                    MyButton(
                        image: '36_link', size: 36.w, onTap: onWebsiteTap)
                  ],
                ),
                buildDivider(),
                Row(
                  children: [
                    Text('语言', style: MyText.bodyText1),
                    Spacer(),
                    //这个‘中文’值应该是要从全局的设置里取
                    Text('中文',
                        style: MyText.bodyText1
                            .copyWith(color: const Color(0xff666666))),
                    SizedBox(
                      width: 11.58.w,
                    ),
                    MyButton(
                        image: '36_right_arrow',
                        size: 36.w,
                        onTap: onLanguageTap)
                  ],
                ),
                buildDivider(),
              ],
            ),
          ))
        ],
      ),
    );
  }

  Divider buildDivider() => Divider(
        height: 30.h,
        thickness: 0.5.h,
        color: const Color(0xffdddddd),
      );
  //‘产品使用说明’
  void onProductUseTap() {}
  //‘官网’
  void onWebsiteTap() {}
  //'语言'
  void onLanguageTap() {}
}
