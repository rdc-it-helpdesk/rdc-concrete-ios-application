import 'dart:convert';

import 'package:dio/dio.dart';
import '../../models/add_user_pojo.dart';

class AddNewVendor {
  final Dio dio;
  AddNewVendor(this.dio);
  // Future<SetStatus> addNewVendor(String uname, String mobile, String email, String siteId, String password) async {
  //   try {
  //     // Sending a POST request to the PHP endpoint as FormData
  //     final response = await dio.post(
  //       "addnewvendor.php",
  //       data: FormData.fromMap({
  //         'uname': uname, // Vendor name
  //         'umobile': mobile, // Mobile number
  //         'email': email, // Email address
  //         'siteid': siteId, // Site ID
  //         'password': password, // Password
  //       }),
  //     );
  //
  //     // Check if the response is in JSON format
  //     if (response.data is Map<String, dynamic>) {
  //       return SetStatus.fromJson(response.data);
  //     } else {
  //       // If the response is not a JSON object, handle it accordingly
  //       return SetStatus(status: "0", message: "Unexpected response format");
  //     }
  //   } catch (e) {
  //     // Handle any errors that occur during the request
  //     return SetStatus(status: "0", message: e.toString());
  //   }
  // }

  Future<SetStatus> addNewVendor(
    String uname,
    String mobile,
    String email,
    String siteId,
    String password,
  ) async {
    try {
      final response = await dio.post(
        "addnewvendor.php",
        data: FormData.fromMap({
          'uname': uname,
          'umobile': mobile,
          'email': email,
          'siteid': siteId,
          'password': password,
        }),
      );

      //print("Response status code: ${response.statusCode}");
      //print("Response data: ${response.data}");
      // print("Type of response.data: ${response.data.runtimeType}");

      // Check if the response is in JSON format
      if (response.data is Map<String, dynamic>) {
        return SetStatus.fromJson(response.data);
      } else if (response.data is String) {
        final jsonResponse = jsonDecode(response.data);
        return SetStatus.fromJson(jsonResponse);
      } else {
        return SetStatus(status: "0", message: "Unexpected response format");
      }
    } catch (e) {
      return SetStatus(status: "0", message: e.toString());
    }
  }
}
