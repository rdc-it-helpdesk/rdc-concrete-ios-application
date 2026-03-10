// // import 'package:dio/dio.dart';
// // import '../core/network/api_client.dart';
// // import '../models/add_user_pojo.dart';
// //
// //
// // class CurrentLocUpdateApiServce {
// //   final Dio _dio = ApiClient.getDio();
// //
// //   Future<SetStatus> uploadAddress(String id, String address) async {
// //     try {
// //       FormData formData = FormData.fromMap({
// //         'id': id,
// //         'address': address,
// //       });
// //
// //       Response response = await _dio.post("update_address.php", data: formData);
// //
// //       if (response.statusCode == 200) {
// //         return SetStatus.fromJson(response.data);
// //       } else {
// //         throw Exception("Failed to update address");
// //       }
// //     } catch (e) {
// //       throw Exception("Error: $e");
// //     }
// //   }
// // }
//
// import 'package:dio/dio.dart';
// import '../core/network/api_client.dart';
// import '../models/add_user_pojo.dart';
// import 'dart:convert'; // Import for jsonDecode
//
// class CurrentLocUpdateApiServce {
//   final Dio _dio = ApiClient.getDio();
//
//   Future<SetStatus> uploadAddress(String id, String address) async {
//     try {
//       FormData formData = FormData.fromMap({
//         'id': id,
//         'address': address,
//       });
//
//       Response response = await _dio.post("http://4.227.130.126/rdc01/update_address.php", data: formData);
//
//       if (response.statusCode == 200) {
//         String responseData = response.data.toString().trim();
//         print("Raw response: $responseData"); // Log the raw response
//
//         if (responseData.startsWith('{') && responseData.endsWith('}')) {
//           return SetStatus.fromJson(jsonDecode(responseData));
//         } else {
//           print("Invalid JSON response: $responseData");
//           throw Exception("Invalid JSON response: $responseData");
//         }
//       }
//       else {
//         throw Exception("Failed to update address, status code: ${response.statusCode}");
//       }
//     } catch (e) {
//       throw Exception("Error: $e");
//     }
//   }
// }

import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../models/add_user_pojo.dart';
import 'dart:convert'; // Import for jsonDecode

class CurrentLocUpdateApiServce {
  final Dio _dio = ApiClient.getDio();

  Future<SetStatus> uploadAddress(String id, String address) async {
    try {
      FormData formData = FormData.fromMap({'id': id, 'address': address});

      Response response = await _dio.post(
        "http://4.227.130.126/rdc01/update_address.php",
        data: formData,
      );

      if (response.statusCode == 200) {
        String responseData = response.data.toString().trim();
        // print("Raw response: $responseData"); // Log the raw response

        // Use a regex to extract the JSON part from the response
        RegExp jsonRegExp = RegExp(r'(\{.*\})');
        Match? match = jsonRegExp.firstMatch(responseData);

        if (match != null) {
          String jsonString = match.group(0)!; // Extract the JSON string
          return SetStatus.fromJson(jsonDecode(jsonString));
        } else {
          // print("Invalid JSON response: $responseData");
          throw Exception("Invalid JSON response: $responseData");
        }
      } else {
        throw Exception(
          "Failed to update address, status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
