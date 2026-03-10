import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/vendor_transaction_pojo.dart';

class VendorTransactionService {
  final Dio _dio;

  VendorTransactionService(this._dio);

  Future<VendorTransactionList?> fetchVendorTransaction(
    String uid,
    String poid,
  ) async {
    try {
      // print("Sending request with ID: $uid and POID: $poid"); // Debug

      final response = await _dio.post(
        'vendortransaction.php',
        data: {'id': uid, 'poid': poid}, // Ensure correct key names
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          }, // Ensures proper POST data format
        ),
      );

      // print("Response data: ${response.data}");

      if (response.data is String) {
        final jsonResponse = json.decode(response.data);
        return VendorTransactionList.fromJson(jsonResponse);
      } else if (response.data is Map<String, dynamic>) {
        return VendorTransactionList.fromJson(response.data);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      //print("Error: $e");
      return null;
    }
  }
}

// import 'package:dio/dio.dart';
// import '../core/network/api_client.dart';
// import '../models/vendor_transaction_pojo.dart';
//
// class VendorTransactionService {
//   Dio dio = ApiClient.getDio();
//
//   Future<VendorTransactionList?> getPoTransaction(String uid, String poid) async {
//     try {
//       Response response = await dio.post(
//         "vendortransaction.php",
//         data: FormData.fromMap({
//           "id": uid,
//           "poid": poid,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         return VendorTransactionList.fromJson(response.data);
//       } else {
//         print("Error: ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       print("Error fetching data: $e");
//       return null;
//     }
//   }
// }
