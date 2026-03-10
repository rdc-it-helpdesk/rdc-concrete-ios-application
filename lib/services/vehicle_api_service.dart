import 'dart:convert';

import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../models/vehicle_list.dart';
// Import the POJO class

class VehicleService {
  final Dio _dio = ApiClient.getDio();

  Future<List<VehicleList>> fetchVehicles(String id) async {
    try {
      Response response = await _dio.post(
        "vehicle_list.php",
        data: FormData.fromMap({"id": id}),
      );

      if (response.statusCode == 200) {
        if (response.data is String) {
          final jsonResponse = json.decode(response.data.trim());
          // print("API Response: $jsonResponse");

          if (jsonResponse is List) {
            return jsonResponse
                .map((json) => VehicleList.fromJson(json))
                .toList();
          } else {
            throw Exception("Unexpected response format: $jsonResponse");
          }
        } else {
          throw Exception("Unexpected response format: ${response.data}");
        }
      } else {
        throw Exception("Failed to load vehicles");
      }
    } catch (e) {
      //print("Error fetching vehicles: $e");
      return [];
    }
  }
}

// import 'package:dio/dio.dart';
//
// import '../core/network/api_client.dart';
// import '../models/Vehiclelist.dart';
//
// class VehicleService {
//   final Dio _dio = ApiClient.getDio();
//
//   Future<List<VehicleList>> fetchVehicles(String id) async {
//     try {
//       Response response = await _dio.post(
//         "vehicle_list.php",
//         data: FormData.fromMap({"id": id}),
//       );
//
//       // Log the response for debugging
//       print("API Response: ${response.data}");
//
//       if (response.statusCode == 200) {
//         // Ensure response.data is a list
//         if (response.data is List) {
//           List<dynamic> jsonResponse = response.data as List<dynamic>;
//           return jsonResponse.map((json) => VehicleList.fromJson(json as Map<String, dynamic>)).toList();
//         } else {
//           throw Exception("Unexpected response format: ${response.data}");
//         }
//       } else {
//         throw Exception("Failed to load vehicles");
//       }
//     } catch (e) {
//       print("Error fetching vehicles: $e");
//       return [];
//     }
//   }
// }
