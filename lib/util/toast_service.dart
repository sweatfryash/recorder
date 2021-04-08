import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sounds_recorder/theme/text_style.dart';

class Toast {
  //提供一个弹出toast的方法在okToast的方法基础上设置了一些基本参数，使用时只需传入@param[msg]
  static void popToast(String msg, {ToastPosition position = ToastPosition.bottom,bool dismissOtherToast = true}) {
    //这里调用的是okToast库的方法
    showToast(
      msg,
      backgroundColor: Colors.black87,
      textPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      textStyle: MyText.bodyText1.copyWith(color: Colors.white),
      position: position,
      dismissOtherToast: dismissOtherToast,
      radius: 5
    );
  }

}
