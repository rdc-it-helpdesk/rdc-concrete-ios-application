import 'dart:convert';

import 'package:dio/dio.dart';
import '../models/user_list_pojo.dart';

class UserListApiService {
  final Dio _dio;

  UserListApiService(this._dio);

  Future<List<User>?> getUsers(String role, String location) async {
    try {
      final response = await _dio.post(
        'users_list.php', // Adjust API endpoint
        data: {'role': role, 'location': location},
        // data: {'location': location},
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
      );

      // print("Response data: ${response.data}");

      List<User> users = [];

      if (response.data is String) {
        final jsonResponse = json.decode(response.data);
        users =
            (jsonResponse as List).map((user) => User.fromJson(user)).toList();
      } else if (response.data is List) {
        users = response.data.map((user) => User.fromJson(user)).toList();
      } else {
        throw Exception('Unexpected response format');
      }

      // Filter users based on the required role
      List<User> filteredUsers = users.toList();

      return filteredUsers;
    } catch (e) {
      //print("Error fetching users: $e");
      return null;
    }
  }
}
// Future<List<User>?> getUsers(String role, String location) async {
//   try {
//     print("Sending request with role: $role, location: $location"); // Debug log
//
//     final response = await _dio.post(
//       'users_list.php', // Adjust API endpoint accordingly
//       data: {'role': role, 'location': location}, // Send role & location
//       options: Options(
//         headers: {
//           'Content-Type': 'application/x-www-form-urlencoded'
//         }, // Ensure proper POST data format
//       ),
//     );
//
//     print("Response data: ${response.data}");
//
//     if (response.data is String) {
//       final jsonResponse = json.decode(response.data);
//       return (jsonResponse as List).map((user) => User.fromJson(user)).toList();
//     } else if (response.data is List) {
//       return response.data.map((user) => User.fromJson(user)).toList();
//     } else {
//       throw Exception('Unexpected response format');
//     }
//   } catch (e) {
//     print("Error fetching users: $e");
//     return null;
//   }
// }
//}

// Future<List<User>?> getUsers(String role, String location) async {
//   try {
//     print("Sending request with role: $role, location: $location"); // Debug log
//
//     final response = await _dio.post(
//       'users_list.php', // Adjust API endpoint accordingly
//       data: {'role': role, 'location': location},
//       options: Options(
//         headers: {
//           'Content-Type': 'application/x-www-form-urlencoded'
//         }, // Ensure proper POST data format
//       ),
//     );
//
//     print("Response data: ${response.data}");
//
//     if (response.data is String) {
//       final jsonResponse = json.decode(response.data);
//       return (jsonResponse as List).map((user) => User.fromJson(user)).toList();
//     } else if (response.data is List) {
//       return response.data.map((user) => User.fromJson(user)).toList();
//     } else {
//       throw Exception('Unexpected response format');
//     }
//   } catch (e) {
//     print("Error fetching users: $e");
//     return null;
//   }
// }
//}

//------------old--------------
// // lib/services/api_service.dart
//
// import 'dart:convert';
//
// import 'package:dio/dio.dart';
// import '../core/network/api_client.dart';
//
// import '../models/user_list_pojo.dart';
//
//
// class UserListApiService {
//   final Dio _dio = ApiClient.getDio();
//
//   Future<List<User>> getUsers(String role, String location) async {
//     try {
//       final response = await _dio.post(
//         'users_list.php',
//         data: {
//           'userrole': role,
//           'location': location,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         dynamic responseData = response.data;
//
//         // Decode if responseData is a String
//         if (responseData is String) {
//           responseData = json.decode(responseData);
//         }
//
//         if (responseData is List) {
//           return responseData.map((user) => User.fromJson(user)).toList();
//         } else {
//           throw Exception('Unexpected response format: $responseData');
//         }
//       } else {
//         throw Exception('Failed to load users: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Failed to load users: $e');
//     }
//   }
//
// }
