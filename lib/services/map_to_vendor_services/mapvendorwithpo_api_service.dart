import 'dart:convert';

import 'package:dio/dio.dart';

import '../../models/add_user_pojo.dart';

class VendorService {
  final Dio dio;

  VendorService(this.dio);

  Future<SetStatus> updatePODetails(
    String vendorid,
    String poid,
    String vname,
  ) async {
    try {
      final response = await dio.post(
        "mapvendorwithpo.php",
        data: FormData.fromMap({
          'vendorid': vendorid,
          'poid': poid,
          'vname': vname,
        }),
      );

      if (response.data is Map<String, dynamic>) {
        return SetStatus.fromJson(response.data);
      } else if (response.data is String) {
        final jsonResponse = jsonDecode(response.data);
        return SetStatus.fromJson(jsonResponse);
      } else {
        return SetStatus(status: "0", message: "Unexpected response format");
      }
    } catch (e) {
      // Handle error
      return SetStatus(status: "0", message: e.toString());
    }
  }
}
