import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../models/reachplant_pojo.dart';
import 'dart:convert'; // Import this to use jsonDecode

class ReachplantornotApiService {
  static final Dio _dio = ApiClient.getDio();
  ReachplantornotApiService();

  Future<ReachPlant> reachSite(String oid, String uid, String status) async {
    try {
      final response = await _dio.post(
        'reachplantornot.php',
        data: FormData.fromMap({'oid': oid, 'uid': uid, 'status': status}),
      );

      if (response.statusCode == 200) {
        // Decode the response data
        final Map<String, dynamic> jsonResponse = jsonDecode(response.data);
        return ReachPlant.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }
}

// class ReachplantornotApiService {
//   static final Dio _dio = ApiClient.getDio();
//   ReachplantornotApiService();
//
//   Future<ReachPlant> reachSite(String oid, String uid, String status) async {
//     try {
//       final response = await _dio.post(
//         'reachplantornot.php',
//
//         data: FormData.fromMap({
//           'oid': oid,
//           'uid': uid,
//           'status': status,
//
//         }),
//         // data: {
//         //   'oid': oid,
//         //   'uid': uid,
//         //   'status': status,
//         // },
//       );
//
//       if (response.statusCode == 200) {
//         return ReachPlant.fromJson(response.data);
//       } else {
//         throw Exception('Failed to load data: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error occurred: $e');
//     }
//   }
// }
