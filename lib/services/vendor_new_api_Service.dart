import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/vedor_response_pojo.dart';

class VendorService {
  final Dio _dio;

  VendorService(this._dio);

  Future<VendorResponse?> getvendorslist(String searchText) async {
    try {
      final response = await _dio.get(
        'getexpensevendors.php',
        queryParameters: {
          'vendrosapcode': searchText,
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
        return VendorResponse.fromJson(jsonResponse);
      } else if (response.data is Map<String, dynamic>) {
        return VendorResponse.fromJson(response.data);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print("VendorService Error: $e");
      return null;
    }
  }
}