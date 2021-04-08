import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sounds_recorder/app_settings.dart';
import 'package:sounds_recorder/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_recorder/theme/text_style.dart';
import 'package:sounds_recorder/widgets/auto_marquee.dart';
import 'package:sounds_recorder/widgets/buttons.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({Key? key, required this.sound}) : super(key: key);

  final String sound;

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  ValueNotifier<bool> _isPlaying = ValueNotifier<bool>(false);
  File get _file => File(AppSettings.basePath + '/sounds/' + widget.sound);
  FlutterSoundPlayer _player = FlutterSoundPlayer();
  ValueNotifier<Duration> _currentPosition =
      ValueNotifier<Duration>(Duration.zero);
  Duration _totalDuration = Duration.zero;
  bool isSeeking = false;
  @override
  void initState() {
    super.initState();
    FlutterSoundFFprobe()
        .getMediaInformation(AppSettings.basePath + '/sounds/' + widget.sound)
        .then((FlutterSoundMediaInformation value) {
      String duration = value.getMediaProperties()!['duration'];
      _totalDuration = Duration(
          microseconds:
              (double.parse(duration) * Duration.microsecondsPerSecond)
                  .toInt());
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: kBackgroundColor,
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
            SizedBox(height: 59.31.h),
            progressBar(),
            SizedBox(height: 5.h),
            timer(),
            SizedBox(height: 38.h),
            playButton()
          ],
        ),
      ),
    );
  }

  Widget timer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Row(
        children: [
          ValueListenableBuilder(
            valueListenable: _currentPosition,
            builder: (BuildContext context, Duration value, Widget? child) {
              return Text(
                value.toStringAsMyFormat(),
                style: MyText.bodyText2,
              );
            },
          ),
          Spacer(),
          Text(
            _totalDuration.toStringAsMyFormat(),
            style: MyText.bodyText2,
          ),
        ],
      ),
    );
  }

  Future<bool> onWillPop() async {
    if (_player.isPaused || _player.isPlaying) {
      await _player.stopPlayer();
      _player.closeAudioSession();
    }
    return Future.value(true);
  }

  Widget progressBar() {
    return Padding(
      padding: EdgeInsets.only(left: 30.w, right: 10.w),
      child: SliderTheme(
        data: Theme.of(context).sliderTheme.copyWith(
            trackHeight: 6.h,
            activeTrackColor: kPrimaryColor,
            inactiveTrackColor: const Color(0xffd3d5d8),
            thumbColor: const Color(0xfffbfbfb),
            thumbShape: RoundSliderThumbShape(
                elevation: 2,
                enabledThumbRadius: 11.h,
                disabledThumbRadius: 11.h),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 0)),
        child: ValueListenableBuilder(
          valueListenable: _currentPosition,
          builder: (BuildContext context, Duration value, Widget? child) {
            return Slider(
              value: _currentPosition.value.inMicroseconds.toDouble(),
              min: 0.0,
              max: _totalDuration.inMicroseconds.toDouble(),
              onChanged: (double value) {
                _currentPosition.value = Duration(microseconds: value.toInt());
              },
              onChangeStart: (double value) {
                isSeeking = true;
                if (_player.isPlaying) {
                  _player.pausePlayer();
                  _isPlaying.value = false;
                }
              },
              onChangeEnd: (double value) {
                isSeeking = false;
                if (_player.isOpen()) {
                  _player.seekToPlayer(Duration(microseconds: value.toInt()));
                  if (_player.isPaused) {
                    //_player.resumePlayer();
                    _isPlaying.value = true;
                  }
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget playButton() {
    return ValueListenableBuilder(
        valueListenable: _isPlaying,
        builder: (BuildContext context, bool value, Widget? child) {
          return MyButton(
            image: 'circle_btn_80',
            size: 80.w,
            onTap: onPlayTap,
            child: value
                ? SvgPicture.asset(
                    'assets/svgs/pause.svg',
                    width: 21.w,
                  )
                : Row(
                    children: [
                      SizedBox(width: 32.w),
                      SvgPicture.asset(
                        'assets/svgs/play.svg',
                        width: 21.w,
                      ),
                    ],
                  ),
          );
        });
  }

  Future<void> onPlayTap() async {
    if (_isPlaying.value) {
      await _player.pausePlayer();
      _isPlaying.value = false;
    } else if (_file.existsSync()) {
      if (_player.isPaused) {
        await _player.resumePlayer();
      } else {
        _player.openAudioSession().then((_) async {
          _player.startPlayer(
              fromDataBuffer: _file.readAsBytesSync(),
              codec: Codec.aacADTS,
              whenFinished: () async {
                _isPlaying.value = false;
                await _player.closeAudioSession();
                _currentPosition.value = Duration.zero;
              });
          await _player.setSubscriptionDuration(Duration(milliseconds: 1));
          _player.onProgress!.listen((event) {
            if (!isSeeking) {
              if (event.position.compareTo(_totalDuration) < 0) {
                if (event.position.compareTo(_currentPosition.value) > 0) {
                  _currentPosition.value = event.position;
                }
              } else {
                _currentPosition.value = _totalDuration;
              }
            }
          });
        });
      }
      _isPlaying.value = true;
    }
  }

  Widget appBar() {
    return Row(
      children: [
        SizedBox(width: 12.w),
        backButton(),
        SizedBox(width: 10.w),
        Expanded(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Center(
                child: Container(
                  height: 24,
                  child: OverflowScrollText(
                      text: widget.sound,
                      textStyle: MyText.title,
                      maxWidth: constraints.maxWidth),
                ),
              );
            },
          ),
        ),
        SizedBox(width: 42.h + 17.w),
      ],
    );
  }

  MyButton backButton() {
    return MyButton(
        size: 42.h,
        image: 'back',
        onTap: () {
          if (Navigator.of(context).canPop()) {
            onWillPop();
            Navigator.of(context).pop();
          }
        });
  }
}

extension DurationExtension on Duration {
  String toStringAsMyFormat() {
    String res = this.toString().split('.').first;
    if (this.inHours < 10) {
      res = '0' + res;
    }
    return res;
  }
}
