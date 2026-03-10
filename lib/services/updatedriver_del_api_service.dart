
import 'dart:convert';
import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../models/add_user_pojo.dart';

class UpdatedriverDelApiService {
  final Dio _dio;

  UpdatedriverDelApiService() : _dio = ApiClient.getDio();

  Future<SetStatus> setStatus(
      String oid,
      String cid,
      String lastaction,
      bool picked,
      bool denied,
      ) async {
    try {
      final response = await _dio.post(
        'update.php',
        data: {
          'o_id': oid,
          'c_id': cid,
          'lastaction': lastaction,
          'picked': picked,
          'denied': denied,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      print("📡 API RAW RESPONSE: ${response.data}");

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse;

        // ✅ Handle both String and Map response
        if (response.data is String) {
          jsonResponse = json.decode(response.data);
        } else if (response.data is Map<String, dynamic>) {
          jsonResponse = response.data;
        } else {
          throw Exception("Unexpected API response format");
        }

        print("✅ Parsed JSON: $jsonResponse");

        final rawStatus = jsonResponse['status'];
        final message = jsonResponse['message'];

        // ✅ Safely convert to int
        final statusInt = int.tryParse(rawStatus.toString().trim()) ?? 0;

        print("🔎 STATUS (raw): $rawStatus");
        print("🔎 STATUS (int): $statusInt");
        print("🔎 MESSAGE: $message");

        // ✅ Only throw if statusInt != 1
        if (statusInt != 1) {
          throw Exception("API Failed: $message");
        }

        return SetStatus.fromJson(jsonResponse);
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("🔥 API Error: $e");
      rethrow;
    }
  }
}
