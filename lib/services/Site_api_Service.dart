import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/site_response_pojo.dart';


class SiteService {
  final Dio _dio;

  SiteService(this._dio);

  Future<SiteResponse?> getSites(String vendorId) async {
    try {
      final response = await _dio.get(
        'getSites.php',
        queryParameters: {
          'vid': vendorId,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      // Handle both String and Map response
      if (response.data is String) {
        final jsonResponse = json.decode(response.data);
        return SiteResponse.fromJson(jsonResponse);
      } else if (response.data is Map<String, dynamic>) {
        return SiteResponse.fromJson(response.data);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print("SiteService Error: $e");
      return null;
    }
  }
}