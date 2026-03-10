import 'dart:convert';

import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../models/add_user_pojo.dart';

class MapToVendorApiService {
  static final Dio _dio = ApiClient.getDio();

  // Existing method to add a new vendor
  static Future<SetStatus?> addNewVendor({
    required String uname,
    required String umobile,
    required String email,
    required String siteid,
    required String password,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "uname": uname,
        "umobile": umobile,
        "email": email,
        "siteid": siteid,
        "password": password,
      });

      Response response = await _dio.post("addnewvendor.php", data: formData);
      //print("Response data: ${response.data}"); // Log the response data

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return SetStatus.fromJson(response.data);
        } else if (response.data is String) {
          // Attempt to decode the string response
          try {
            var jsonResponse = jsonDecode(response.data);
            return SetStatus.fromJson(jsonResponse);
          } catch (e) {
            return SetStatus(
              status: "0",
              message: "Error parsing response: $e",
            );
          }
        } else {
          return SetStatus(status: "0", message: "Unexpected response format");
        }
      } else {
        return SetStatus(status: "0", message: "Failed to add vendor");
      }
    } catch (e) {
      return SetStatus(status: "0", message: "Error: $e");
    }
  }

  // Updated method to update vendor details and add a new vendor
  static Future<SetStatus?> updateVendor({
    required String vendorId,
    required String poId,
    required String vendorName,
    required String uname,
    required String umobile,
    required String email,
    required String siteid,
    required String password,
  }) async {
    try {
      // First, add a new vendor
      SetStatus? addVendorStatus = await addNewVendor(
        uname: uname,
        umobile: umobile,
        email: email,
        siteid: siteid,
        password: password,
      );

      // Check if adding the vendor was successful
      if (addVendorStatus?.status == "1") {
        // If successful, proceed to map the vendor with PO
        FormData formData = FormData.fromMap({
          "vendorid": vendorId,
          "poid": poId,
          "vname": vendorName,
        });

        Response response = await _dio.post(
          "mapvendorwithpo.php",
          data: formData,
        );

        if (response.statusCode == 200) {
          return SetStatus.fromJson(response.data);
        } else {
          return SetStatus(status: "0", message: "Failed to update vendor");
        }
      } else {
        final errorMessage =
            "Failed to add new vendor: ${addVendorStatus?.message}";
        //print(errorMessage); // Print the error
        return SetStatus(status: "0", message: errorMessage);
      }
    } catch (e) {
      return SetStatus(status: "0", message: "Error: $e");
    }
  }
}
