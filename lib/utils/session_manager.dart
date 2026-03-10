// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:rdc_concrete/screens/select_profile.dart';
//
// import '../services/api_service.dart';
//
//
// class SessionManager {
//   static Future<void> checkAutoLogoutOnce() async {
//     final prefs = await SharedPreferences.getInstance();
//     // check if session exists
//     String? sitename = prefs.getString("sitename");
//     String? role = prefs.getString("role");
//     String? loginDate = prefs.getString("loginDate");
//
//
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setString("role", role);
// //     await prefs.setString("rdcrole", role);
// //     await prefs.setString("sitename", sitename);
// //     await prefs.setString("uname", uname);
// //     await prefs.setInt("locationid", locationid);
// //     await prefs.setInt("uprofileid", uprofileid);
// //     await prefs.setString("loginDate", DateTime.now().toIso8601String());
//     if (sitename == null || role == null || loginDate == null) {
//       // 🚨 App reopen → don't clear session if keys exist
//       print("⚠️ No session found. Staying on login screen.");
//       return; // ❌ don't logout here
//     }
//
//     final apiService = ApiService();
//     bool logout = await apiService.shouldLogoutNow();
//     if (logout) {
//       await prefs.clear();
//       Get.offAll(() => const SelectProfile());
//     }
//   }
//
//
//
//   // static void checkAutoLogoutOnce() async {
//   //   final apiService = ApiService();
//   //   bool logout = await apiService.shouldLogoutNow();
//   //   if (logout) {
//   //     final prefs = await SharedPreferences.getInstance();
//   //     await prefs.clear();
//   //     Get.offAll(() => const SelectProfile());
//   //   }
//   //   // if (logout) {
//   //   //   final prefs = await SharedPreferences.getInstance();
//   //   //   await prefs.clear();
//   //   //   Get.offAll(() => const SelectProfile());
//   //   // }
//   // }
//
//   static void scheduleMidnightLogout(BuildContext context) {
//     DateTime now = DateTime.now();
//     DateTime midnight = DateTime(now.year, now.month, now.day + 1);
//
//     Duration timeUntilMidnight = midnight.difference(now);
//
//     Timer(timeUntilMidnight, () async {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.clear();
//       Get.offAll(() => const SelectProfile());
//     });
//
//     //print("🕛 Logout scheduled at midnight: $midnight");
//   }
// }
// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:rdc_concrete/screens/select_profile.dart';
// // import '../screens/home_page.dart';
// // import '../services/api_service.dart';
// // // import 'home_page.dart';
// //
// // class SessionManager {
// //   // Save session data after successful login
// //   static Future<void> saveSession({
// //     required String role,
// //     required String sitename,
// //     required String uname,
// //     required int locationid,
// //     required int uprofileid,
// //   }) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setString("role", role);
// //     await prefs.setString("rdcrole", role);
// //     await prefs.setString("sitename", sitename);
// //     await prefs.setString("uname", uname);
// //     await prefs.setInt("locationid", locationid);
// //     await prefs.setInt("uprofileid", uprofileid);
// //     await prefs.setString("loginDate", DateTime.now().toIso8601String());
// //   }
// //
// //   // Check if a valid session exists on app start
// //   static Future<bool> hasValidSession() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     String? role = prefs.getString("role");
// //     String? sitename = prefs.getString("sitename");
// //     String? loginDate = prefs.getString("loginDate");
// //
// //     if (role == null || sitename == null || loginDate == null) {
// //       print("⚠️ No valid session found.");
// //       return false;
// //     }
// //
// //     // Check if the login date is from today
// //     DateTime storedLoginDate = DateTime.parse(loginDate);
// //     DateTime now = DateTime.now();
// //     bool isSameDay = storedLoginDate.day == now.day &&
// //         storedLoginDate.month == now.month &&
// //         storedLoginDate.year == now.year;
// //
// //     if (!isSameDay) {
// //       print("⚠️ Session expired (not same day).");
// //       await prefs.clear(); // Clear session if it's not from today
// //       return false;
// //     }
// //
// //     // Optional: Check with API if needed
// //     final apiService = ApiService();
// //     bool shouldLogout = await apiService.shouldLogoutNow();
// //     if (shouldLogout) {
// //       print("⚠️ API indicates session should be terminated.");
// //       await prefs.clear();
// //       return false;
// //     }
// //
// //     print("✅ Valid session found.");
// //     return true;
// //   }
// //
// //   // Navigate to HomePage if session is valid, otherwise to SelectProfile
// //   static Future<void> checkSessionAndNavigate(BuildContext context) async {
// //     bool hasSession = await hasValidSession();
// //     if (hasSession) {
// //       final prefs = await SharedPreferences.getInstance();
// //       String? role = prefs.getString("role");
// //       String? sitename = prefs.getString("sitename");
// //       String? uname = prefs.getString("uname");
// //       int? locationid = prefs.getInt("locationid");
// //       int? uprofileid = prefs.getInt("uprofileid");
// //
// //       if (role != null &&
// //           sitename != null &&
// //           uname != null &&
// //           locationid != null &&
// //           uprofileid != null) {
// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(
// //             builder: (context) => HomePage(
// //               role: role,
// //               sitename: sitename,
// //               uname: uname,
// //               locationid: locationid,
// //               uprofileid: uprofileid,
// //             ),
// //           ),
// //         );
// //       } else {
// //         Get.offAll(() => const SelectProfile());
// //       }
// //     } else {
// //       Get.offAll(() => const SelectProfile());
// //     }
// //   }
// //
// //   // Schedule midnight logout
// //   static void scheduleMidnightLogout(BuildContext context) {
// //     DateTime now = DateTime.now();
// //     DateTime midnight = DateTime(now.year, now.month, now.day + 1);
// //
// //     Duration timeUntilMidnight = midnight.difference(now);
// //
// //     Timer(timeUntilMidnight, () async {
// //       print("🕛 Midnight logout triggered.");
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.clear();
// //       Get.offAll(() => const SelectProfile());
// //     });
// //
// //     print("🕛 Logout scheduled at midnight: $midnight");
// //   }
// // }

// Updated session_manager.dart
// I've uncommented and adjusted the saveSession and hasValidSession functions.
// Also integrated the checkAutoLogoutOnce logic into hasValidSession for validation.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rdc_concrete/screens/select_profile.dart';

import '../services/api_service.dart';

class SessionManager {
  // Save session data after successful login
  static Future<void> saveSession({
    required String role,
    required String sitename,
    required String uname,
    required int locationid,
    required int uprofileid,
    String? umobile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("role", role);
    await prefs.setString("rdcrole", role);
    await prefs.setString("sitename", sitename);
    await prefs.setString("uname", uname);
    await prefs.setInt("locationid", locationid);
    await prefs.setInt("uprofileid", uprofileid);
    if (umobile != null) {
      await prefs.setString("umobile", umobile);
    }
    await prefs.setString("loginDate", DateTime.now().toIso8601String());

  }

  // Check if a valid session exists on app start
  static Future<bool> hasValidSession() async {
    final prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString("role");
    String? sitename = prefs.getString("sitename");
    String? loginDate = prefs.getString("loginDate");

    if (role == null || sitename == null || loginDate == null) {
      print("⚠️ No valid session found.");
      return false;
    }

    // Check if the login date is from today
    DateTime storedLoginDate = DateTime.parse(loginDate);
    DateTime now = DateTime.now();
    bool isSameDay = storedLoginDate.day == now.day &&
        storedLoginDate.month == now.month &&
        storedLoginDate.year == now.year;

    if (!isSameDay) {
      print("⚠️ Session expired (not same day).");
      await prefs.clear(); // Clear session if it's not from today
      return false;
    }

    // Check with API if should logout
    final apiService = ApiService();
    bool shouldLogout = await apiService.shouldLogoutNow();
    if (shouldLogout) {
      print("⚠️ API indicates session should be terminated.");
      await prefs.clear();
      return false;
    }

    print("✅ Valid session found.");
    return true;
  }

  static Future<void> checkAutoLogoutOnce() async {
    final prefs = await SharedPreferences.getInstance();
    // check if session exists
    String? sitename = prefs.getString("sitename");
    String? role = prefs.getString("role");
    String? loginDate = prefs.getString("loginDate");

    if (sitename == null || role == null || loginDate == null) {
      // 🚨 App reopen → don't clear session if keys exist
      print("⚠️ No session found. Staying on login screen.");
      return; // ❌ don't logout here
    }

    final apiService = ApiService();
    bool logout = await apiService.shouldLogoutNow();
    if (logout) {
      await prefs.clear();
      Get.offAll(() => const SelectProfile());
    }
  }

  static void scheduleMidnightLogout(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day + 1);

    Duration timeUntilMidnight = midnight.difference(now);

    Timer(timeUntilMidnight, () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Get.offAll(() => const SelectProfile());
    });

    //print("🕛 Logout scheduled at midnight: $midnight");
  }
}