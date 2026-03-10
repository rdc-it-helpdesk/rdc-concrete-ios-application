import 'dart:convert';
import 'package:dio/dio.dart';

import '../models/add_user_pojo.dart';
import '../models/insert_transaction_new_pojo.dart';
   // Your response model

class InsertSparesService {
  final Dio _dio;

  InsertSparesService(this._dio);

  Future<SetStatus?> addnewtransaction(InsertTransactionNew insertdata) async {
    try {
      final response = await _dio.post(
        'insertspares.php',
        data: insertdata.toJson(), // Send as JSON
        options: Options(
          headers: {
            'Content-Type': 'application/json', // JSON body
          },
        ),
      );

      // Handle response
      if (response.data is String) {
        final jsonResponse = json.decode(response.data);
        return SetStatus.fromJson(jsonResponse);
      } else if (response.data is Map<String, dynamic>) {
        return SetStatus.fromJson(response.data);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print("InsertSparesService Error: $e");
      return null;
    }
  }
}