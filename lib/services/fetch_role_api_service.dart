import 'dart:convert';

import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../models/fetch_role_pojo.dart';

class RoleService {
  final Dio _dio = ApiClient.getDio();

  Future<List<RoleList>> getRoles(String id) async {
    try {
      Response response = await _dio.post(
        'roles.php',
        data: {'id': id},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.statusCode == 200) {
        List<dynamic> data;
        if (response.data is String) {
          data = jsonDecode(response.data); // Decode if it's a string
        } else {
          data = response.data; // Use directly if it's a list
        }
        return data.map((json) => RoleList.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load roles");
      }
    } catch (e) {
      throw Exception("Error fetching roles: $e");
    }
  }
}

// import 'package:dio/dio.dart';
//
// import '../core/network/api_client.dart';
// import '../models/fetch_role_pojo.dart';
//
// class RoleService {
//   final Dio _dio = ApiClient.getDio();
//
//   Future<List<RoleList>> getRoles(String id) async {
//     try {
//       Response response = await _dio.post(
//         'roles.php',
//         data: {'id': id},
//         options: Options(contentType: Headers.formUrlEncodedContentType),
//       );
//
//       if (response.statusCode == 200) {
//         List<dynamic> data = response.data;
//         return data.map((json) => RoleList.fromJson(json)).toList();
//       } else {
//         throw Exception("Failed to load roles");
//       }
//     } catch (e) {
//       throw Exception("Error fetching roles: $e");
//     }
//   }
// }
