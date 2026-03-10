import 'dart:convert';

import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../models/userlist.dart'; // Import the POJO class

class UserService {
  final Dio _dio = ApiClient.getDio();

  // Future<List<UserList>> fetchUsers(String role, String location) async {
  //   try {
  //     Response response = await _dio.post(
  //       "users_list.php",
  //       data: FormData.fromMap({
  //         "role": role,
  //         "location": location,
  //       }),
  //     );
  //
  //     // Log the response for debugging
  //     print("API Response: ${response.data}");
  //     print("Response type: ${response.data.runtimeType}");
  //
  //     if (response.statusCode == 200) {
  //       // Check if the response is a list
  //       if (response.data is List) {
  //         return response.data.map((json) => UserList.fromJson(json)).toList();
  //       }
  //       // Check if the response is a map and contains a 'users' key
  //       else if (response.data is Map) {
  //         if (response.data.containsKey('users') && response.data['users'] is List) {
  //           return response.data['users'].map((json) => UserList.fromJson(json)).toList();
  //         } else {
  //           throw Exception("Unexpected response format: Missing 'users' key or not a list.");
  //         }
  //       } else {
  //         throw Exception("Unexpected response format: ${response.data}");
  //       }
  //     } else {
  //       throw Exception("Failed to load users: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Error fetching users: $e");
  //     return [];
  //   }
  // }
  Future<List<UserList>> fetchUsers(String role, String location) async {
    try {
      Response response = await _dio.post(
        "users_list.php",
        data: FormData.fromMap({"role": role, "location": location}),
      );

      // Log the raw response for debugging
      // print("Raw API Response: ${response.data}");
      // print("Response type: ${response.data.runtimeType}");

      if (response.statusCode == 200) {
        // Check if the response is a list
        if (response.data is List) {
          return (response.data as List)
              .map((json) => UserList.fromJson(json))
              .toList();
        } else if (response.data is String) {
          // If the response is a string, you might want to parse it as JSON
          try {
            final List<dynamic> jsonList = jsonDecode(response.data);
            return jsonList.map((json) => UserList.fromJson(json)).toList();
          } catch (e) {
            throw Exception("Failed to parse JSON from string: $e");
          }
        } else {
          throw Exception(
            "Unexpected response format: Expected a list or a JSON string.",
          );
        }
      } else {
        throw Exception("Failed to load users: ${response.statusCode}");
      }
    } catch (e) {
      //print("Error fetching users: $e");
      return [];
    }
  }
}

// Future<List<UserList>> fetchUsers(String role, String location) async {
//   try {
//     Response response = await _dio.post(
//       "users_list.php",
//       data: FormData.fromMap({
//         "role": role,
//         "location": location,
//       }),
//     );
//
//     // Log the response for debugging
//     print("API Response: ${response.data}");
//
//     if (response.statusCode == 200) {
//       // Check if the response is a list
//       if (response.data is List) {
//         return response.data.map((json) => UserList.fromJson(json)).toList();
//       } else {
//         throw Exception("Unexpected response format: ${response.data}");
//       }
//     } else {
//       throw Exception("Failed to load users");
//     }
//   } catch (e) {
//     print("Error fetching users: $e");
//     return [];
//   }
// }
