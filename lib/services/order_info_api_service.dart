// import 'dart:convert';
// import 'package:dio/dio.dart';
// import '../core/network/api_client.dart';
// import '../models/driverdt_otp_pojo.dart';
//
// class OrderInfoApiService {
//   final Dio _dio;
//
//   OrderInfoApiService() : _dio = ApiClient.getDio();
//   Future<DriverDT?> logindriver(String mobile) async {
//     try {
//       final response = await _dio.post(
//         "order_info.php",
//         data: {'mobile': mobile},
//         options: Options(contentType: Headers.formUrlEncodedContentType),
//       );
//
//       if (response.statusCode == 200) {
//         // print('Response data: ${response.data}'); // Log the response data
//
//         // Check if response data is not null
//         if (response.data != null) {
//           // If response is a String, decode it
//           if (response.data is String) {
//             Map<String, dynamic> jsonResponse = json.decode(response.data);
//             return DriverDT.fromJson(jsonResponse);
//           } else if (response.data is Map<String, dynamic>) {
//             return DriverDT.fromJson(response.data);
//           } else {
//             // print("❌ Unexpected response format.");
//             return null; // Handle unexpected format
//           }
//         } else {
//           // print("❌ Response data is null.");
//           return null; // Handle null response
//         }
//       } else {
//         throw Exception('Failed to load vendor data: ${response.statusCode}');
//       }
//     } catch (e) {
//       //print("❌ Error loading vendor data: $e");
//       return null; // Return null or handle the error as needed
//     }
//   }
// }
import 'dart:convert';
import 'package:dio/dio.dart';
//import '../core/network/api_client.dart';
import '../models/driverdt_otp_pojo.dart';

class OrderInfoApiService {
  final Dio _dio;

  OrderInfoApiService(this._dio);

  Future<DriverDT?> logindriver(String mobile) async {
    try {
      final response = await _dio.post(
        "order_info.php",
        data: {'mobile': mobile},
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      // Handle response based on its type
      if (response.data is String) {
        final jsonResponse = json.decode(response.data);
        return DriverDT.fromJson(jsonResponse);
      } else if (response.data is Map<String, dynamic>) {
        return DriverDT.fromJson(response.data);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      //print("❌ Error loading driver data: $e");
      return null; // Return null or handle the error as needed
    }
  }
}