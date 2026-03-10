import 'dart:convert';
import 'package:dio/dio.dart';

import '../models/po_reasponse_pojo.dart';


class POService {
  final Dio _dio;

  POService(this._dio);

  Future<POResponse?> getcreatedpo({
    required int page,
    required int vendorId,
  }) async {
    try {
      final response = await _dio.get(
        'getcreatedpo.php',
        queryParameters: {
          'page': page,
          'v_id': vendorId,
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
      print("POService Error: $e");
      return null;
    }
  }
}