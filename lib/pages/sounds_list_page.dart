import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sounds_recorder/app_settings.dart';
import 'package:sounds_recorder/pages/about_page.dart';
import 'package:sounds_recorder/pages/play_page.dart';
import 'package:sounds_recorder/pages/record_page.dart';
import 'package:sounds_recorder/theme/colors.dart';
import 'package:sounds_recorder/theme/text_style.dart';
import 'package:sounds_recorder/widgets/buttons.dart';

class SoundsListPage extends StatefulWidget {
  @override
  _SoundsListPageState createState() => _SoundsListPageState();
}

class _SoundsListPageState extends State<SoundsListPage> {
  //文件名列表
  final List<Sound> soundList = <Sound>[];
  late Future _future;

  @override
  void initState() {
    super.initState();
    _future = _getSoundList();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      if (!await Permission.microphone.request().isGranted) {
        print('----请设置录音权限');
      }
    });
  }

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
                Expanded(
                    child: RefreshIndicator(
                  onRefresh: () {
                    setState(() {
                      _future = _getSoundList();
                    });
                    return Future.value();
                  },
                  child: FutureBuilder(
                    future: _future,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return _soundListView();
                        } else {
                          if (soundList.isEmpty) {
                            return Text('loading...');
                          } else {
                            return _soundListView();
                          }
                        }
                      }
                    },
                  ),
                )),
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

  Column _soundListView() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 15.w),
            Text(
              '最近录音',
              style: MyText.bodyText2.copyWith(color: const Color(0xffa2a3a7)),
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
              itemCount: soundList.length,
              itemBuilder: itemBuilder,
            ),
          ),
        )
      ],
    );
  }

  Future<void> _getSoundList() async {
    Directory dir = Directory(AppSettings.basePath + '/sounds');
    if (!dir.existsSync()) {
      dir.createSync();
    }
    List<FileSystemEntity> list = dir.listSync();
    soundList.clear();
    for (FileSystemEntity item in list) {
      DateTime changeTime = (await item.stat()).changed;
      soundList.add(Sound(item.path.split('/').last, changeTime));
    }
    soundList.sort((a, b) => b.changedTime.compareTo(a.changedTime));
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
          style: MyText.bodyText1.copyWith(
              fontWeight: FontWeight.bold,
              color: kTitleTextColor,
              fontSize: 18),
        ),
        Spacer(),
        SizedBox(width: 42.h + 12.w)
      ],
    );
  }

  void onMenuTap() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => AboutPage()));
  }

  //右下角的悬浮图标
  void onMicTap() {
    Navigator.push(context,
        CupertinoPageRoute(builder: (BuildContext context) => RecordPage()));
  }

  void onTransTap() {}

  void onPlayTap(int index) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) =>
                PlayPage(sound: soundList[index].path)));
  }

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
                      child: Text(soundList[index].path,
                          style: MyText.bodyText1
                              .copyWith(fontSize: 16, height: 1),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 7.w, vertical: 2.h),
                          decoration: BoxDecoration(
                              color: const Color(0xfff4f5f7),
                              borderRadius: BorderRadius.circular(8.w)),
                          child: Row(
                            children: [
                              Transform.translate(
                                offset: Offset(0, 1.5.h),
                                child: Text(
                                  '英文',
                                  style: MyText.bodyText2.copyWith(
                                      color: kPrimaryColor, height: 1),
                                ),
                              ),
                              SizedBox(width: 7),
                              SvgPicture.asset(
                                'assets/svgs/right_arrow.svg',
                                height: 9.h,
                              )
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
                  onTap: () => onPlayTap(index),
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

class Sound {
  Sound(this.path, this.changedTime);

  String path;
  DateTime changedTime;
}
