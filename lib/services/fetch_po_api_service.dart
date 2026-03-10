import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/fetch_po_pojo.dart';
//import '../models/fetchsitepolist.dart'; // Adjust the import based on your file structure

class FetchsitepolistService {
  final Dio _dio;

  FetchsitepolistService(this._dio);

  Future<Fetchsitepolist?> fetchFetchsitepolist(String location) async {
    try {
      //print("Sending request with location: $location"); // Debug

      final response = await _dio.post(
        'unmapedlilst.php',
        data: {'location': location}, // Ensure correct key name
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          }, // Ensures proper POST data format
        ),
      );

      //print("Response data: ${response.data}");

      if (response.data is String) {
        final jsonResponse = json.decode(response.data);
        return Fetchsitepolist.fromJson(jsonResponse);
      } else if (response.data is Map<String, dynamic>) {
        return Fetchsitepolist.fromJson(response.data);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      //print("Error: $e");
      return null;
    }
  }
}
