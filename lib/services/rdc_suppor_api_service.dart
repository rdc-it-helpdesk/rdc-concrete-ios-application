//
// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:rdc_concrete/models/moisture_qa_pojo.dart';
//
// import '../core/network/api_client.dart';
//
// class RdcSupportApiService {
//   final Dio _dio = ApiClient.getDio();
//   Future<MoisturePojo?> getMoistureList(String id) async {
//     try {
//       final response = await _dio.post(
//         'http://20.172.211.179/rdc01/rdc_support.php', // Use full URL
//         data: {'mobile': id},
//         options: Options(
//           headers: {
//             'Content-Type': 'application/x-www-form-urlencoded',
//           },
//         ),
//       );
//
//       // Log response details for debugging
//       print('getMoistureList Response:');
//       print('Status Code: ${response.statusCode}');
//       print('Headers: ${response.headers}');
//       print('Body: ${response.data}');
//
//       // Check status code
//       if (response.statusCode != 200) {
//         print('Error: Unexpected status code ${response.statusCode}');
//         return null;
//       }
//
//       // Check for empty or whitespace response
//       if (response.data == null || response.data.toString().trim().isEmpty) {
//         print('Error: Empty response from server');
//         return null;
//       }
//
//       // Verify Content-Type
//       final contentType = response.headers['content-type']?.first;
//       if (contentType == null || !contentType.contains('application/json')) {
//         print('Error: Invalid Content-Type: $contentType');
//         return null;
//       }
//
//       // Parse response
//       if (response.data is String) {
//         final jsonResponse = jsonDecode(response.data);
//         return MoisturePojo.fromJson(jsonResponse);
//       } else if (response.data is Map<String, dynamic>) {
//         return MoisturePojo.fromJson(response.data);
//       } else {
//         print('Error: Unexpected response format');
//         return null;
//       }
//     } catch (e) {
//       print("Error in getMoistureList: $e");
//       return null; // Return null instead of rethrowing to match existing behavior
//     }
//   }
// }
//
import 'dart:convert';
import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../models/moisture_qa_pojo.dart';

class RdcSupportApiService {
  final Dio _dio = ApiClient.getDio();

  Future<MoisturePojo?> getMoistureList(String id) async {
    try {
      final response = await _dio.post(
        'rdc_support.php', // Relative endpoint, base URL handled by ApiClient
        data: {'mobile': id},
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json',
          },
        ),
      );

      // print('Response data: ${response.data}'); // Debugging line

      if (response.statusCode == 200) {
        try {
          // Attempt to parse the response as JSON
          final responseData = response.data is String
              ? jsonDecode(response.data)
              : response.data;

          if (responseData is Map<String, dynamic>) {
            return MoisturePojo.fromJson(responseData);
          } else {
            throw Exception('Unexpected response format: $responseData');
          }
        } catch (e) {
          throw Exception('Error parsing response: $e');
        }
      } else {
        throw Exception('Failed to fetch moisture list: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}