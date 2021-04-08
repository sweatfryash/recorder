import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sounds_recorder/app_settings.dart';
import 'package:sounds_recorder/theme/colors.dart';
import 'package:sounds_recorder/theme/text_style.dart';
import 'package:sounds_recorder/widgets/buttons.dart';

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  ValueNotifier<bool> _isRecording = ValueNotifier<bool>(false);
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  ValueNotifier<Duration> _duration = ValueNotifier(Duration(microseconds: 0));
  late DateTime _dateTime;
  bool _hasRecord = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(width: double.infinity, height: 45.h),
          appBar(),
          SizedBox(height: 190.h),
          Container(
            color: kPrimaryColor,
            width: 63.w,
            height: 30.7.h,
          ),
          SizedBox(height: 66.33.h),
          buildTime(),
          SizedBox(height: 242.98.h),
          Row(
            children: [
              SizedBox(width: 147.5.w),
              recordButton(),
              SizedBox(width: 40.5.w),
              saveButton(context)
            ],
          )
        ],
      ),
    );
  }

  Widget saveButton(BuildContext context) {
    return MyButton(
      image: 'circle_btn_80',
      size: 62.w,
      onTap: () => onSaveButtonTap(context),
      child: Text(
        '完成',
        style: MyText.bodyText1.copyWith(color: const Color(0xff2c3d59)),
      ),
    );
  }

  Widget recordButton() {
    return ValueListenableBuilder(
      valueListenable: _isRecording,
      builder: (BuildContext context, bool value, Widget? child) {
        return MyButton(
          image: 'circle_btn_80',
          onTap: onRecordButtonTap,
          size: 80.w,
          child: SvgPicture.asset(
            value ? 'assets/svgs/pause.svg' : 'assets/svgs/mic.svg',
            width: value ? 21.w : 22.96.w,
          ),
        );
      },
    );
  }

  Future<void> onRecordButtonTap() async {
    if (_isRecording.value) {
      _recorder.pauseRecorder();
    } else {
      if (await Permission.microphone.request().isGranted) {
        if (!_recorder.isPaused) {
          _recorder.openAudioSession().then((_) async {
            _dateTime = DateTime.now();
            String path =
                AppSettings.basePath + '/sounds/' + _dateTime.toString().split('.').first;
            _recorder.startRecorder(toFile: path, codec: Codec.aacADTS);
            _hasRecord = true;
          });
        } else {
          _recorder.resumeRecorder();
        }
      } else {
        print('----请设置录音权限');
      }
    }
    _isRecording.value = !_isRecording.value;
  }

  Future<void> onSaveButtonTap(BuildContext context) async {
    if (_hasRecord) {
      _isRecording.value = false;
      if (!_recorder.isPaused) {
        _recorder.pauseRecorder();
      }
      TextEditingController textEditingController =
          TextEditingController(text: _dateTime.toString().split('.').first);
      showDialog(
          context: context,
          builder: (c) {
            return AlertDialog(
              title: Text(
                '输入文件名称',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    color: kBodyTextColor),
              ),
              content: TextField(
                cursorColor: kPrimaryColor,
                controller: textEditingController,
                autofocus: true,
                style: MyText.bodyText1.copyWith(fontSize: 18.sp),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor)
                  ),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('取消', style: MyText.bodyText1)),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      '确定',
                      style: MyText.bodyText1.copyWith(color: kPrimaryColor),
                    ))
              ],
            );
          }).then((value) async {
        print(value);
        //点击确定
        if (value) {
          _recorder.stopRecorder().then((path) {
            if (path != null) {
              File sound = File(path);
              sound.renameSync(AppSettings.basePath +
                  '/sounds/' +
                  textEditingController.text);
              Navigator.of(context).pop();
            }
          });
        }
      });
    } else {
      print('还未开始录音');
    }
  }

  Text buildTime() {
    return Text(
      '00:00:00',
      style: TextStyle(
          color: kBodyTextColor, fontWeight: FontWeight.w400, fontSize: 50.sp),
    );
  }

  Widget appBar() {
    return Row(
      children: [
        SizedBox(width: 12.w),
        backButton(),
        Spacer(),
        Text(
          '新录音',
          style: MyText.title,
        ),
        Spacer(),
        SizedBox(width: 42.h + 12.w),
      ],
    );
  }

  MyButton backButton() {
    return MyButton(
        size: 42.h,
        image: 'back',
        onTap: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });
  }
}
