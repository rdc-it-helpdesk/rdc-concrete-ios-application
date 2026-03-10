import 'dart:convert';

import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../models/add_user_pojo.dart';

class DefaultmoistureApiService {
  final Dio _dio;

  DefaultmoistureApiService() : _dio = ApiClient.getDio();

  Future<SetStatus> defaultmoisture(
    String oid,
    String moistureper,
    String uid,
    String timenow,
  ) async {
    try {
      final response = await _dio.post(
        'defaultmoisture.php',
        data: {
          'o_id': oid,
          'moistureper': moistureper,
          'uid': uid,
          'timenow': timenow,
        },
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
