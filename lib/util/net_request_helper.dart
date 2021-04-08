import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sounds_recorder/util/toast_service.dart';

mixin NetHelper {

   static BaseOptions get options => BaseOptions(
      baseUrl: '',
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      connectTimeout: 20000);

  static Dio? dio;
  static late Response<dynamic> _response;

  static void resetOptions(){
    dio = Dio(options);
  }

  /// 通用的网络请求方法，需传入@param[url]，
  /// 请求成功返回的是接口返回的原始数据，一般为Map，返回数  据有异常返回null,网络错误返回null 要注意判空
  /// @param[data]是可选参数，大部分[ApiAddress]返回的都是带参数的url，不需要[data]，提交审批结果那里是需要data的
  /// @param[file]也是可选参数，是上传图片的时候需要用到的
  static Future<Map<String, dynamic>>? request(String url,
      {FormData? formData, Map<String, dynamic>? data}) async {
    if(dio == null){
      dio = Dio(options);
    }
    try {
      if (data != null) {
        _response = await dio!.post<dynamic>(url, data: data);
      } else if (formData != null) {
        _response = await dio!.post<dynamic>(url, data: formData, onSendProgress: (c, t) {
          print('$c/$t total:${t / 1024}kb');
        });
      } else {
        _response = await dio!.get<dynamic>(url);
      }

      Map<String, dynamic> result;
      if (_response.data.runtimeType == String) {
        result = json.decode(_response.data.toString()) as Map<String, dynamic>;
      } else {
        result = _response.data as Map<String, dynamic>;
      }
      print('请求地址$url--请求参数$data--请求结果' + result.toString());
      return result;
    } on DioError catch (e) {
      print(e);
      switch (e.type) {
        case DioErrorType.connectTimeout:
          Toast.popToast('网络连接超时', position: ToastPosition.center);
          break;
        case DioErrorType.sendTimeout:
          Toast.popToast('发送请求超时', position: ToastPosition.center);
          break;
        case DioErrorType.receiveTimeout:
          Toast.popToast('接收数据超时', position: ToastPosition.center);
          break;
        case DioErrorType.response:
          Toast.popToast('服务器返回数据出错(404、503...)', position: ToastPosition.center);
          break;
        case DioErrorType.cancel:
          Toast.popToast('已取消');
          break;
        case DioErrorType.other:
          Toast.popToast('网络出错', position: ToastPosition.center);
          break;
      }
      return Future.value(null);
    }
  }


  //添加header
  static void addHeader(String token) {
    dio!.options.headers['authorization'] = token;
  }

   //解决https证书校验失败的问题（校验失败的证书仍然去请求）
  static void setIgnoreCert(){
    if(dio == null){
      dio = Dio(options);
    }
    (dio!.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate  = (client) {
      client.badCertificateCallback=(X509Certificate cert, String host, int port){
        return true;
      };
    };
  }

}
