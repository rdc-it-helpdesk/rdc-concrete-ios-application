import 'dart:convert';

import 'package:dio/dio.dart';

import '../core/network/api_client.dart';

import '../models/weighbridgestatus_pojo.dart';

class WeighbridgeweightApiService {
  static final Dio _dio = ApiClient.getDio();
  WeighbridgeweightApiService();

  Future<List<WeighbridgeStatus>> getweight(String location, String oid) async {
    // print("loc: $location");
    // print("oid: $oid");
    try {
      final response = await _dio.post(
        'weighbridgeweight.php',
        data: FormData.fromMap({'location': location, 'oid': oid}),
      );

      // print("Response data: ${response.data}");

      if (response.statusCode == 200) {
        if (response.data is String) {
          final List<dynamic> dataList = jsonDecode(response.data);
          return dataList
              .map((item) => WeighbridgeStatus.fromJson(item))
              .toList();
        } else if (response.data is List) {
          return (response.data as List)
              .map((item) => WeighbridgeStatus.fromJson(item))
              .toList();
        } else {
          throw Exception(
            'Expected a List or String but got: ${response.data.runtimeType}',
          );
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }
}
