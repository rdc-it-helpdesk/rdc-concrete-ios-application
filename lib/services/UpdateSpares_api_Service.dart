import 'dart:convert';
import 'package:dio/dio.dart';

import '../models/update_response_pojo.dart';

class UpdateSparesService {
  final Dio _dio;

  UpdateSparesService(this._dio);

  Future<UpdateResponse?> updateSpares({
    required String poId,
    required String status,
    required String userId,
  }) async {
    try {
      final response = await _dio.get(
        'updatespares.php',
        queryParameters: {
          'po_id': poId,
          'status': status,
          'user_id': userId,
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
        return UpdateResponse.fromJson(jsonResponse);
      } else if (response.data is Map<String, dynamic>) {
        return UpdateResponse.fromJson(response.data);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print("UpdateSparesService Error: $e");
      return null;
    }
  }
}