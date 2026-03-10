// import 'package:dio/dio.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:rdc_concrete/core/network/api_client.dart';
// import 'package:rdc_concrete/models/moisture_pojo.dart';
//
// class ApiService {
//   final Dio _dio = ApiClient.getDio();
//
//   Future<MoisturePojo?> login(String uname, String upass) async {
//     try {
//       Response response = await _dio.post(
//         "rdcprofilelogin.php",
//         data: FormData.fromMap({"uname": uname, "upass": upass}),
//       );
//
//       if (response.statusCode == 200) {
//         Map<String, dynamic> jsonResponse;
//
//         if (response.data is String) {
//           jsonResponse = jsonDecode(response.data);
//         } else {
//           jsonResponse = response.data;
//         }
//
//         MoisturePojo user = MoisturePojo.fromJson(jsonResponse);
//
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//
//         // Store sitename, role, and loginDate
//         if (jsonResponse.containsKey("sitename")) {
//           await prefs.setString("sitename", jsonResponse["sitename"]);
//         }
//
//         if (jsonResponse.containsKey("role")) {
//           await prefs.setString("role", jsonResponse["role"]);
//         }
//
//         // ✅ Store login date
//         await prefs.setString("loginDate", DateTime.now().toIso8601String());
//
//         return user;
//       }
//
//     } catch (e) {
//       // print("Login Error: $e");
//       return null;
//     }
//   }
//   Future<bool> shouldLogoutNow() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? loginDateStr = prefs.getString("loginDate");
//
//     if (loginDateStr == null) return true;
//
//     DateTime loginTime = DateTime.parse(loginDateStr);
//     DateTime now = DateTime.now();
//
//     // If login date is NOT today, it's past midnight — logout
//     if (loginTime.day != now.day ||
//         loginTime.month != now.month ||
//         loginTime.year != now.year) {
//       print("✅ Midnight logout triggered");
//       return true;
//     }
//
//     return false;
//   }
//
//
//
//
// }
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rdc_concrete/core/network/api_client.dart';
import 'package:rdc_concrete/models/moisture_pojo.dart';
import 'package:rdc_concrete/models/token_model.dart';

class ApiService {
  final Dio _dio = ApiClient.getDio();

  Future<MoisturePojo?> login(String uname, String upass) async {
    try {
      Response response = await _dio.post(
        "rdcprofilelogin.php",
        data: FormData.fromMap({"uname": uname, "upass": upass}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse;

        if (response.data is String) {
          jsonResponse = jsonDecode(response.data);
        } else {
          jsonResponse = response.data;
        }

        print("Login response: $jsonResponse");

        MoisturePojo user = MoisturePojo.fromJson(jsonResponse);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("sitename", user.sitename);
        await prefs.setString("role", user.role);
        await prefs.setString("loginDate", DateTime.now().toIso8601String());
        await prefs.setString("uname", user.name);
        await prefs.setString("userid", user.userid.toString());
        await prefs.setString("locationid", user.locationid.toString());

        // Store tokens if provided
        if (jsonResponse.containsKey("access_token") && jsonResponse.containsKey("refresh_token")) {
          await prefs.setString("access_token", jsonResponse["access_token"].toString());
          await prefs.setString("refresh_token", jsonResponse["refresh_token"].toString());
          print("Tokens stored: access_token=${jsonResponse["access_token"]}, refresh_token=${jsonResponse["refresh_token"]}");
        } else {
          print("Warning: No tokens in login response, proceeding without tokens");
        }

        return user;
      }
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
    return null;
  }

  Future<TokenModel?> refreshToken(String refreshToken) async {
    try {
      print("Attempting to refresh token with: $refreshToken");
      Response response = await _dio.post(
        "refresh_token.php",
        data: FormData.fromMap({"refresh_token": refreshToken}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse;

        if (response.data is String) {
          jsonResponse = jsonDecode(response.data);
        } else {
          jsonResponse = response.data;
        }

        print("Refresh token response: $jsonResponse");

        TokenModel tokens = TokenModel.fromJson(jsonResponse);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("access_token", tokens.accessToken);
        if (tokens.refreshToken != null) {
          await prefs.setString("refresh_token", tokens.refreshToken!);
          print("New refresh token stored: ${tokens.refreshToken}");
        }

        return tokens;
      }
    } catch (e) {
      print("Refresh Token Error: $e");
      return null;
    }
    return null;
  }

  Future<bool> shouldLogoutNow() async {
    final prefs = await SharedPreferences.getInstance();
    String? loginDateStr = prefs.getString("loginDate");

    if (loginDateStr == null) {
      print("No login date found, triggering logout");
      return true;
    }

    DateTime loginTime = DateTime.parse(loginDateStr).toLocal();
    DateTime now = DateTime.now();

    print("Login time: $loginTime, Current time: $now");

    // If login date is NOT today, it's past midnight — logout
    if (loginTime.day != now.day ||
        loginTime.month != now.month ||
        loginTime.year != now.year) {
      print("✅ Midnight logout triggered");
      return true;
    }

    return false;
  }
}