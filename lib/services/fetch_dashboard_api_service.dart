import 'dart:convert';
import 'package:dio/dio.dart';

import '../models/fetch_dashboard_pojo.dart';

class MaterialOfficerService {
  final Dio _dio;

  MaterialOfficerService(this._dio);

  Future<MaterialOfficerModel?> fetchMaterialOfficerTransaction(
    String siteName,
  ) async {
    try {
      //print("Sending request with sitename: $siteName"); // Debug

      final response = await _dio.post(
        'materialofficer.php',
        data: {'sitename': siteName}, // Ensure correct key name
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          }, // Ensures proper POST data format
        ),
      );

      if (response.data is String) {
        final jsonResponse = json.decode(response.data);
        return MaterialOfficerModel.fromJson(jsonResponse);
      } else if (response.data is Map<String, dynamic>) {
        return MaterialOfficerModel.fromJson(response.data);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      return null;
    }
  }
}
