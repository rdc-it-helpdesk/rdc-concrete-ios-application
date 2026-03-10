import 'package:dio/dio.dart';

class ApiClient {
  //live
  // static const String baseUrl = "http://4.227.130.126/rdc01/";
 static const String baseUrl = "https://vendors.rdc.in/rdc01/";
//--------------
  // static const String baseUrl = "http://192.168.148.173:81/rdc01/";
 //static const String baseUrl = "http://20.172.211.179/rdc01/"; //demo pc
 //  static const String baseUrl = "http://192.168.1.170:81/rdc011/";// local
  // static const String baseUrl = "http://192.168.3.175:81/rdc011/";// local1
  // static const String baseUrl = "http://192.168.1.29:8080/rdc011/rdc011/";// local1

  static Dio getDio() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(minutes: 2),
      receiveTimeout: Duration(minutes: 1),
      sendTimeout: Duration(minutes: 1),
      headers: {'Content-Type': 'application/json'}
    );

    Dio dio = Dio(options);
    dio.interceptors.add(LogInterceptor(responseBody: true));
    return dio;
  }
}

