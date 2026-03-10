import 'dart:convert';
import 'package:dio/dio.dart';

import '../models/order_info_pojo.dart';
 // Adjust path to your orderInfo model

class OrderInfoService {
  final Dio _dio;

  OrderInfoService(this._dio);

  Future<OrderInfo?> thisorder({
    required String id,
    required String oId,
  }) async {
    try {
      final response = await _dio.post(
        'order_info.php',
        data: {
          'id': id,
          'o_id': oId,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      // Handle both String and Map response
      if (response.data is String) {
        final jsonResponse = json.decode(response.data);
        return OrderInfo.fromJson(jsonResponse);
      } else if (response.data is Map<String, dynamic>) {
        return OrderInfo.fromJson(response.data);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print("OrderInfoService Error: $e");
      return null;
    }
  }
}