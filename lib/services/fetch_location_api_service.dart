import 'dart:convert';
import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../models/fetch_location_pojo.dart';

class LocationService {
  final Dio _dio = ApiClient.getDio();

  Future<List<LocationList>> getLocations(String userId) async {
    try {
      final response = await _dio.get(
        'location_list.php',
        queryParameters: {'id': userId},
      );

      // Log the raw response and headers
      // print("Raw response: ${response.data}");
      //print("Response headers: ${response.headers}");

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse;
        if (response.data is String) {
          jsonResponse = jsonDecode(response.data);
        } else {
          jsonResponse = response.data;
        }
        return jsonResponse
            .map((location) => LocationList.fromJson(location))
            .toList();
      } else {
        throw Exception('Failed to load locations: ${response.statusCode}');
      }
    } catch (e) {
      //print("Error fetching locations: $e");
      rethrow; // Rethrow the error for further handling
    }
  }
}
