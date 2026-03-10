import 'dart:convert';

import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../models/inserttransaction_pojo.dart';
import '../models/add_user_pojo.dart';
// Import your Setstatus model

class AddnewtransactionApiService {
  final Dio _dio = ApiClient.getDio();
  Future<SetStatus> addNewTransaction(InsertTransaction insertData) async {
    try {
      final response = await _dio.post(
        'inserttransaction.php',
        data: insertData.toJson(),
      );

      // print('Response data: ${response.data}'); // Debugging line

      if (response.statusCode == 200) {
        try {
          // Attempt to parse the response as JSON
          final responseData =
          response.data is String
              ? jsonDecode(response.data)
              : response.data;

          if (responseData is Map<String, dynamic>) {
            return SetStatus.fromJson(responseData);
          } else {
            throw Exception('Unexpected response format: $responseData');
          }
        } catch (e) {
          throw Exception('Error parsing response: $e');
        }
        // if (response.data is Map<String, dynamic>) {
        //   return SetStatus.fromJson(response.data);
        // } else {
        //   throw Exception('Unexpected response format: ${response.data}');
        // }
      } else {
        throw Exception('Failed to add transaction: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  // Future<SetStatus> addNewTransaction(InsertTransaction insertData) async {
  //   try {
  //     final response = await _dio.post(
  //       'inserttransaction.php',
  //       data: insertData.toJson(), // Assuming you have a toJson method in your model
  //     );
  //
  //     if (response.statusCode == 200) {
  //       return SetStatus.fromJson(response.data); // Assuming you have a fromJson method
  //     } else {
  //       throw Exception('Failed to add transaction: ${response.statusCode}');
  //     }
  //   } on DioError catch (e) {
  //     // Handle Dio errors
  //     throw Exception('Dio error: ${e.message}');
  //   } catch (e) {
  //     // Handle other errors
  //     throw Exception('Error: $e');
  //   }
  // }


}
