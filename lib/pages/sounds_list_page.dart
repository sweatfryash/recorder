import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sounds_recorder/theme/colors.dart';
import 'package:sounds_recorder/theme/text_style.dart';
import 'package:sounds_recorder/widgets/buttons.dart';

class SoundsListPage extends StatefulWidget {
  @override
  _SoundsListPageState createState() => _SoundsListPageState();
}

class _SoundsListPageState extends State<SoundsListPage> {
  //文件名列表
  List<String> sounds = <String>[
    '录音——201-02/18 22：2 5：录音——201-02/18 22：2 5：录音——201-02/18 22：2 5：',
    '3/18备忘',
    '录音——201-02/18 22：2 5：03',
    '录音——201-02/18 22：2 5：03',
    '录音——201-02/18 22：2 5：03',
    '录音——201-02/18 22：2 5：03',
    '录音——201-02/18 22：2 5：03',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(width: double.infinity, height: 45.h),
                appBar(),
                SizedBox(height: 21.h),
                Row(
                  children: [
                    SizedBox(width: 15.w),
                    Text(
                      '最近录音',
                      style: MyText.bodyText2
                          .copyWith(color: const Color(0xffa2a3a7)),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemExtent: 120.h,
                      itemCount: sounds.length,
                      itemBuilder: itemBuilder,
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            right: 37.w,
            bottom: 31.h,
            child: MyButton(
              image: 'red_mic',
              size: 50.w,
              onTap: onMicTap,
            ),
          )
        ],
      ),
    );
  }

  Widget appBar() {
    return Row(
      children: [
        SizedBox(width: 12.w),
        MyButton(
          size: 42.h,
          image: 'menu',
          onTap: onMenuTap,
        ),
        Spacer(),
        Text(
          'LeMuna AI',
          style: MyText.bodyText1
              .copyWith(fontWeight: FontWeight.bold, color: kTitleTextColor,fontSize: 18),
        ),
        Spacer(),
        SizedBox(width: 42.h + 12.w)
      ],
    );
  }

  void onMenuTap() {}
  //右下角的悬浮图标
  void onMicTap() {}

  void onTransTap() {}

  void onPlayTap() {}
  //‘转换至’右边的语言按钮
  void onLanguageTap() {}

  Widget itemBuilder(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        padding:
            EdgeInsets.only(left: 11.w, top: 14.5.h, right: 22.w, bottom: 16.h),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(6.w)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(sounds[index],
                          style: MyText.bodyText1.copyWith(fontSize: 16,height: 1),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis)),
                  Row(
                    children: [
                      Text(
                        '转换至',
                        style: MyText.bodyText2.copyWith(),
                      ),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: onLanguageTap,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 7.w,vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xfff4f5f7),
                            borderRadius: BorderRadius.circular(8.w)
                          ),
                            child: Row(
                              children: [
                                Transform.translate(
                                  offset: Offset(0,1.5.h),
                                  child: Text(
                                    '英文',
                                    style: MyText.bodyText2
                                        .copyWith(color: kPrimaryColor,height: 1),
                                  ),
                                ),
                                SizedBox(width: 7),
                                SvgPicture.asset('assets/svgs/right_arrow.svg',height: 9.h,)
                              ],
                            ),

                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      Text(
                        '转换结果:',
                        style:
                            MyText.bodyText2.copyWith(fontSize: 12, height: 1),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(width: 2.w),
            Column(
              children: [
                MyButton(
                  image: '24_play',
                  size: 24.w,
                  onTap: onPlayTap,
                ),
                SizedBox(height: 13.h),
                Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: MyButton(
                    image: '20_trans',
                    size: 20.w,
                    onTap: onTransTap,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
