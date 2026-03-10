import 'dart:convert';
import 'package:dio/dio.dart';

import '../models/po_reasponse_pojo.dart';


class POForMOService {
  final Dio _dio;

  POForMOService(this._dio);

  Future<POResponse?> getcreatedpoformo({
    required int page,
    required String sitename,
  }) async {
    try {
      final response = await _dio.get(
        'getcreatedpoformo.php',
        queryParameters: {
          'page': page,
          'sitename': sitename,
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
        return POResponse.fromJson(jsonResponse);
      } else if (response.data is Map<String, dynamic>) {
        return POResponse.fromJson(response.data);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print("POForMOService Error: $e");
      return null;
    }
  }
}