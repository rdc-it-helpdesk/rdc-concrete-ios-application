import 'dart:convert';

import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../models/add_user_pojo.dart';

class GetreceiptidApiService {
  final Dio _dio;

  GetreceiptidApiService() : _dio = ApiClient.getDio();

  Future<SetStatus> getweighbridge(
    String vehicleno,
    String oid,
    String loction,
  ) async {
    try {
      final response = await _dio.post(
        'getreceiptid.php',
        data: {'vehicleno': vehicleno, 'oid': oid, 'loction': loction},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.statusCode == 200) {
        //print('Response data: ${response.data}'); // Log the response data
        // Check if response.data is a String and decode it
        if (response.data is String) {
          Map<String, dynamic> jsonResponse = json.decode(response.data);
          return SetStatus.fromJson(jsonResponse);
        } else {
          return SetStatus.fromJson(response.data);
        }
      } else {
        throw Exception('Failed to add new driver: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding new driver: $e');
    }
  }
}
