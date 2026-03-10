//
//
// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:rdc_concrete/core/network/api_client.dart';
// import 'package:rdc_concrete/models/vendor_pojo.dart';
//
// import '../models/vendordt.dart';
//
// class VendorService {
//   final Dio _dio = ApiClient.getDio();
//   Future<Vendordt?> loginVendor(
//       String mobile, String vsapid, String password) async {
//     print("mobile: $mobile, vsapid: $vsapid, password: $password");
//     try {
//       Response response = await _dio.post(
//         'venndordata.php', // Ensure this URL is correct
//         data: FormData.fromMap({
//           'mobile': mobile,
//           'vsapid': vsapid,
//           'password': password,
//         }),
//       );
//
//       // Print raw response for debugging
//       print("🚀 Raw API Response: ${response.data}");
//
//       if (response.statusCode == 200) {
//         dynamic responseData = response.data;
//
//         // If response is a String, decode it
//         if (responseData is String) {
//           try {
//             responseData = jsonDecode(responseData);
//           } catch (e) {
//             print("❌ JSON Parsing Error: $e");
//             return null;
//           }
//         }
//
//         // Check if responseData is a Map
//         if (responseData is Map<String, dynamic>) {
//           print("✅ Parsed JSON: $responseData");
//           // Ensure that the response contains the expected fields
//           if (responseData['status'] != null && responseData['status'] == 1) {
//             return Vendordt.fromJson(responseData); // Assuming you have a fromJson method in Vendor
//           } else {
//             print("❌ Unexpected response format: ${response.data}");
//             return null;
//           }
//         } else {
//           print("❌ Unexpected response format: ${response.data}");
//           return null;
//         }
//       } else {
//         print("❌ API Error: Status Code ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       print("❌ Connection Error: $e");
//       return null;
//     }
//   }
//
// }
// import 'dart:convert';
//
// import 'package:dio/dio.dart';
//
// import '../core/network/api_client.dart';
// import '../models/vendordt.dart';
//
// class VendorService {
//   final Dio _dio = ApiClient.getDio();
//
//   VendorService(Dio dio);
//
//   Future<Vendordt> vendordata(String id) async {
//     try {
//       final response = await _dio.post(
//         "vendor_info.php",
//         data: FormData.fromMap({
//           'id': id,
//         }),
//       );
//
//       print('Response data: ${response.data}'); // Print the entire response
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> jsonResponse = jsonDecode(response.data);
//         return Vendordt.fromJson(jsonResponse);
//       } else {
//         throw Exception('Failed to load vendor data');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
// }
import 'dart:convert';
import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../models/vendordt.dart';

class VendorService {
  final Dio _dio;

  VendorService() : _dio = ApiClient.getDio();

  Future<Vendordt?> loginVendor(
    String mobile,
    String vsapid,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        "venndordata.php",
        data: {'mobile': mobile, 'vsapid': vsapid, 'password': password},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.statusCode == 200) {
        // print('Response data: ${response.data}'); // Log the response data

        // Check if response contains HTML content
        // if (response.data is String && response.data.contains('<')) {
        //   print("❌ Received HTML response instead of JSON.");
        //   return null; // Handle the error as needed
        // }

        // If response is a String, decode it
        if (response.data is String) {
          Map<String, dynamic> jsonResponse = json.decode(response.data);
          return Vendordt.fromJson(jsonResponse);
        } else {
          return Vendordt.fromJson(response.data);
        }
      } else {
        throw Exception('Failed to load vendor data: ${response.statusCode}');
      }
    } catch (e) {
      //print("❌ Error loading vendor data: $e");
      return null; // Return null or handle the error as needed
    }
  }
}
