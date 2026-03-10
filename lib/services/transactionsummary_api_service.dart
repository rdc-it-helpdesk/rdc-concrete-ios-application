import 'dart:convert';

import 'package:dio/dio.dart';
import '../core/network/api_client.dart';

import '../models/reportmodel_pojo.dart';

class TransactionsummaryApiService {
  final Dio _dio;

  TransactionsummaryApiService() : _dio = ApiClient.getDio();

  Future<ReportModel> getreport(
    String id,
    String startdate,
    String enddate,
  ) async {
    try {
      final response = await _dio.post(
        'transactionsummury.php',
        data: {'id': id, 'startdate': startdate, 'enddate': enddate},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.statusCode == 200) {
        //  print('Response data: ${response.data}'); // Log the response data
        // Check if response.data is a String and decode it
        if (response.data is String) {
          Map<String, dynamic> jsonResponse = json.decode(response.data);
          return ReportModel.fromJson(jsonResponse);
        } else {
          return ReportModel.fromJson(response.data);
        }
      } else {
        throw Exception('Failed to add new driver: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding new driver: $e');
    }
  }
}
