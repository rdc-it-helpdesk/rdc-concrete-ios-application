import 'dart:convert';
import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../models/add_user_pojo.dart';

class UpdatetransactionApiService {
  static final Dio _dio = ApiClient.getDio();


  static Future<SetStatus?> updateTransaction({
    required String orderid,
    required String selectedvehId,
    required String selectedUserId,
    required String challannumber,
    required String netweight,
    required String challanone,
    required String netone,
  })
  async {
    try {
      // Prepare the form data
      FormData formData = FormData.fromMap({
        'orderid': orderid,
        'vehicleno': selectedvehId,
        'driverid': selectedUserId,
        'challano': challannumber,
        'weight': netweight,
        'challano123': challanone,
        'weight12': netone,
      });

      // Make the API call
      Response response = await _dio.post(
        "update_transaction.php",
        data: formData,
      );
      // print("Response data: ${response.data}"); // Log the response data

      // Check the response status
      if (response.statusCode == 200) {
        // Handle the response data
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
        return SetStatus(
          status: "0",
          message:
              "Failed to update transaction. Status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      return SetStatus(status: "0", message: "Error: $e");
    }
  }

}
