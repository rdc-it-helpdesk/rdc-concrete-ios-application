
import 'package:dio/dio.dart';

class ApiClientOTP {
  // static const String baseUrl = "http://4.227.130.126/rdc01/";
  static const String baseUrl = "https://smsc5.smsconnexion.com/sendsms/";
  //static const String baseUrl = "http://192.168.177.173:81/rdc01/";
  //static const String baseUrl = "http://192.168.43.173:81/rdc01/";
  //static const String baseUrl = "http://192.168.180.173:81/rdc01/";
  // static const String baseUrl = "http://192.168.148.173:81/rdc01/";
  //static const String baseUrl = "http://20.172.211.179/rdc01/";

  static Dio getDio() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(minutes: 2),
      receiveTimeout: Duration(minutes: 1),
      sendTimeout: Duration(minutes: 1),
      headers: {'Content-Type': 'application/json'},
    );

    Dio dio = Dio(options);
    dio.interceptors.add(LogInterceptor(responseBody: true));
    return dio;
  }
}
