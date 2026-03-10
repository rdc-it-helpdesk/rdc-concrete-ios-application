// import 'dart:convert';
// import 'package:dio/dio.dart';
//
// import '../core/network/api_client.dart';
// import '../models/add_user_pojo.dart';  // Ensure you are importing the correct model
//
// class AddUserApiService {
//   final Dio _dio = ApiClient.getDio();
//
//   Future<SetStatus> addNewUser({
//     required String uname,
//     required String umobile,
//     required String email,
//     required String pass,
//     required String siteid,
//     required String roleid,
//   }) async {
//     try {
//       print("🚀 Calling API with: uname=$uname, umobile=$umobile, email=$email, pass=$pass, siteid=$siteid, roleid=$roleid");
//
//       Response response = await _dio.post(
//         "addnewuser.php",
//         data: FormData.fromMap({
//           "uname": uname,
//           "umobile": umobile,
//           "email": email,
//           "pass": pass,
//           "siteid": siteid,
//           "roleid": roleid,
//         }),
//       );
//
//       print("📌 Raw API Response: ${response.data}");
//
//       if (response.data == null) {
//         print("❌ API returned null response");
//         return SetStatus(
//           status: "0",
//           message: "Null response from API",
//           createdid: "",
//           sitename: "",
//         );
//       }
//
//       if (response.data is Map<String, dynamic>) {
//         print("✅ Parsed JSON Response: ${response.data}");
//         return SetStatus.fromJson(response.data);
//       } else {
//         print("❌ Invalid Response Format: ${response.data}");
//         return SetStatus(
//           status: "0",
//           message: "Invalid response format",
//           createdid: "",
//           sitename: "",
//         );
//       }
//     } catch (e) {
//       print("🚨 API Call Error: $e");
//       return SetStatus(
//         status: "0",
//         message: "Error: $e",
//         createdid: "",
//         sitename: "",
//       );
//     }
//   }
//
//
// }
import 'dart:convert';
import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../models/add_user_pojo.dart'; // Ensure you are importing the correct model

class AddUserApiService {
  final Dio _dio = ApiClient.getDio();

  Future<SetStatus> addNewUser({
    required String uname,
    required String umobile,
    required String email,
    required String pass,
    required String siteid,
    required String roleid,
  }) async {
    try {
      //   print("🚀 Calling API with: uname=$uname, umobile=$umobile, email=$email, pass=$pass, siteid=$siteid, roleid=$roleid");

      Response response = await _dio.post(
        "addnewuser.php",
        data: FormData.fromMap({
          "uname": uname,
          "umobile": umobile,
          "email": email,
          "pass": pass,
          "siteid": siteid,
          "roleid": roleid,
        }),
        options: Options(
          responseType:
              ResponseType.json, // Ensure the response is treated as JSON
        ),
      );

      // print(" Raw API Response: ${response.toString()}"); // Log the entire response

      if (response.data == null) {
        return SetStatus(
          status: "0",
          message: "Null response from API",
          createdid: "",
          sitename: "",
        );
      }

      // Check if response.data is a String
      if (response.data is String) {
        //   print(" Response is a String, attempting to parse it as JSON");
        final jsonResponse = json.decode(response.data);
        if (jsonResponse is Map<String, dynamic>) {
          return SetStatus.fromJson(jsonResponse);
        } else {
          return SetStatus(
            status: "0",
            message: "Invalid response format",
            createdid: "",
            sitename: "",
          );
        }
      }

      // Check if response.data is a Map
      if (response.data is Map<String, dynamic>) {
        return SetStatus.fromJson(response.data);
      } else {
        return SetStatus(
          status: "0",
          message: "Invalid response format",
          createdid: "",
          sitename: "",
        );
      }
    } catch (e) {
      return SetStatus(
        status: "0",
        message: "Error: $e",
        createdid: "",
        sitename: "",
      );
    }
  }
}
