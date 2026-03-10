import 'dart:convert';

import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../models/add_user_pojo.dart';

class InsertvehicleApiService {
  final Dio _dio;

  InsertvehicleApiService() : _dio = ApiClient.getDio();

  Future<SetStatus> insertvehicle(String rfifno, String vehicleno) async {
    try {
      final response = await _dio.post(
        'insertvehicle.php',

        data: FormData.fromMap({'rfifno': rfifno, 'vehicleno': vehicleno}),
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      // print("vehicleno ${vehicleno} rfifno ${rfifno} ");
      if (response.statusCode == 200) {
        //print('Response data: ${response.data}'); // Log the response data
        // Check if response.data is a String and decode it
        if (response.data is String) {
          Map<String, dynamic> jsonResponse = json.decode(response.data);
          return SetStatus.fromJson(jsonResponse);
        } else {
          return SetStatus.fromJson(response.data);
        }
      } else {
        throw Exception('Failed to add new driver: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding new driver: $e');
    }
  }
}
