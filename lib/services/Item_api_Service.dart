import 'dart:convert';
import 'package:dio/dio.dart';

import '../models/item_response_pojo.dart';


class ItemService {
  final Dio _dio;

  ItemService(this._dio);

  Future<ItemResponse?> getItems(String siteCode) async {
    try {
      final response = await _dio.get(
        'itemList.php',
        queryParameters: {
          'sitecode': siteCode,
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
        return ItemResponse.fromJson(jsonResponse);
      } else if (response.data is Map<String, dynamic>) {
        return ItemResponse.fromJson(response.data);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print("ItemService Error: $e");
      return null;
    }
  }
}