import 'dart:convert';

import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../models/version_check_pojo.dart';

class VersionCheckService {
  final Dio _dio = ApiClient.getDio();

  // Future<CheckVersion?> getVersionCheck(String id, String deviceId, String userVersion) async {
  //   try {
  //     FormData formData = FormData.fromMap({
  //       'id': id,
  //       'device_id': deviceId,
  //       'u_v': userVersion,
  //     });
  //
  //     final response = await _dio.post(
  //       'version_check.php',
  //       data: formData,
  //     );
  //
  //     print("id: $id, deviceId: $deviceId, userVersion: $userVersion");
  //
  //     if (response.statusCode == 200) {
  //       return CheckVersion.fromJson(response.data);
  //     } else {
  //       print('Error: ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Exception: $e');
  //     return null;
  //   }
  // }
  Future<CheckVersion?> getVersionCheck(
    String id,
    String deviceId,
    String userVersion,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'id': id,
        'device_id': deviceId,
        'u_v': userVersion,
      });

      final response = await _dio.post('version_check.php', data: formData);

      //print("id: $id, deviceId: $deviceId, userVersion: $userVersion");

      if (response.statusCode == 200) {
        // Manually decode the response data
        final Map<String, dynamic> jsonResponse = jsonDecode(response.data);
        return CheckVersion.fromJson(jsonResponse);
      } else {
        //print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // print('Exception: $e');
      return null;
    }
  }
}
