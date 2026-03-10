import 'dart:convert';
import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../models/checkrfid_pojo.dart';

class RfidService {
  final Dio _dio = ApiClient.getDio();

  Future<CheckRfid?> checkRfid(String vehicleNumber, String location) async {
    try {
      // Debug print to check the parameters being sent
      //print('Sending vehicleNumber: $vehicleNumber, location: $location');

      // Use FormData to send data as form-urlencoded
      final response = await _dio.post(
        'map_rfid.php',
        data: FormData.fromMap({
          'vehiclenumber': vehicleNumber,
          'location': location,
        }),
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Parse the JSON response into a Map
        final jsonData = jsonDecode(response.data);

        // Check if the response data is a Map
        if (jsonData is Map<String, dynamic>) {
          return CheckRfid.fromJson(jsonData);
        } else {
          // Handle unexpected response format
          // print('Unexpected response format: ${response.data}');
          return null;
        }
      } else {
        // Handle error response
        // print('Error: ${response.statusCode} - ${response.data}');
        return null;
      }
    } catch (e) {
      // Handle exceptions
      //print('Exception: $e');
      return null;
    }
  }
}
