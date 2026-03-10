import 'dart:convert';
import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../models/current_loc_pojo.dart';
// Import ApiClient

class LocationService {
  final Dio _dio = ApiClient.getDio(); // Use ApiClient to get Dio instance

  Future<LocationPoJo?> fetchLocationOfSite(String siteName) async {
    try {
      //print("Sending request with sitename: $siteName"); // Debug log

      final response = await _dio.post(
        'getlatlong.php', // Will be appended to baseUrl from ApiClient
        data: {'Sitename': siteName}, // Ensure correct parameter
        options: Options(

          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
      );

      // print("Response data: ${response.data}");

      if (response.data is String) {
        final jsonResponse = json.decode(response.data);
        return LocationPoJo.fromJson(jsonResponse);
      } else if (response.data is Map<String, dynamic>) {
        return LocationPoJo.fromJson(response.data);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      //print("Error: $e");
      return null;
    }
  }
}
