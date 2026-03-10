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

  Future<Vendordt> vendordata(String id) async {
    try {
      final response = await _dio.post(
        "vendor_info.php",
        data: {'id': id},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.statusCode == 200) {
        //  print('Response data: ${response.data}'); // Log the response data
        // Check if response.data is a String and decode it
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
      throw Exception('Error loading vendor data: $e');
    }
  }
}
