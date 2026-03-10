// import 'package:dio/dio.dart';
//
// import '../core/network/api_config.dart';
// import '../models/driverdt_otp_pojo.dart';
//
// class OtpApiService {
//   final Dio _dio;
//
//   OtpApiService() : _dio = ApiClientOTP.getDio();
//   Future<DriverDT> thisorder({
//     required String username,
//     required String password,
//     required String type,
//     required String sender,
//     required String mobile,
//     required String message,
//   }) async {
//     try {
//       final response = await _dio.post(
//         'https://smsc5.smsconnexion.com/sendsms/bulksms.php',
//         options: Options(
//           contentType: Headers.formUrlEncodedContentType,
//         ),
//         data: {
//           'user': username,
//           'pass': password,
//           'type': type,
//           'sender': sender,
//           'to': mobile,
//           'text': message,
//         },
//       );
//
//       // Log the response details
//       print("Response: ${response.statusCode} ${response.statusMessage}  (${response.realUri})");
//       print("Headers: ${response.headers}");
//       print("Body: ${response.data}");
//
//       // Assuming the response body is in JSON format
//       return DriverDT.fromJson(response.data);
//     } on DioException catch (e) {
//       print("Error sending SMS: ${e.response?.data}");
//       throw Exception('Failed to send SMS: ${e.response?.data}');
//     }
//   }
//
// // Future<DriverDT> thisorder({
//   //   required String username,
//   //   required String password,
//   //   required String type,
//   //   required String sender,
//   //   required String mobile,
//   //   required String message,
//   // }) async
//   // {
//   //   try {
//   //     final response = await _dio.post(
//   //       'bulksms.php',
//   //       data: {
//   //         'username': username,
//   //         'password': password,
//   //         'type': type,
//   //         'sender': sender,
//   //         'mobile': mobile,
//   //         'message': message,
//   //       },
//   //     );
//   //
//   //     return DriverDT.fromJson(response.data);
//   //   } on DioException catch (e) {
//   //     // Handle error
//   //     throw Exception('Failed to send SMS: ${e.response?.data}');
//   //   }
//   // }
// }
import 'package:dio/dio.dart';

import '../core/network/api_config.dart';
import '../models/driverdt_otp_pojo.dart';

class OtpApiService {
  final Dio _dio;

  OtpApiService() : _dio = ApiClientOTP.getDio();

  Future<DriverDT> thisorder({
    required String username,
    required String password,
    required String type,
    required String sender,
    required String mobile,
    required String message,
    required String entityId,
    required String tempId,
  }) async
  {
    try {

      final String url = 'https://smsc5.smsconnexion.com/sendsms/bulksms.php?'
          'username=$username&'
          'password=$password&'
          'type=$type&'
          'sender=$sender&'
          'mobile=$mobile&'
          'entityId=$entityId&'
          'tempId=$tempId&'
          'message=${Uri.encodeComponent(message)}';

      final response = await _dio.post(
        url,
        options: Options(
          // You can add any necessary headers here if required by the API
          headers: {
            // Example: 'Authorization': 'Bearer your_token' (if needed)
          },
        ),
      );

      // Check if the response data is a String
      if (response.data is String) {
        // Split the response string by the delimiter '|'
        final parts = response.data.split('|');
        if (parts.length >= 3) {
          // Assuming the first part is the status, second is the ID, and third is the mobile number
          final status = parts[0].trim();
          final driverId = parts[1].trim();
     //     final mobileNumber = parts[2].trim();

          // Create a DriverDT object with default values for other fields
          return DriverDT(
            status: status == "SUCCESS" ? 1 : 0, // Assuming 1 for success, 0 for failure
            drivername: "Unknown", // You may want to set this based on your logic
            driverid: driverId,
            completecounter: 0, // Default value
            activecounter: 0, // Default value
            pendingcounter: 0, // Default value
            cancelcounter: 0, // Default value
            complete: [], // Default value
            cancel: [], // Default value
            active: [], // Default value
            pending: [], // Default value
          );
        } else {
          throw Exception('Unexpected response format: ${response.data}');
        }
      } else {
        throw Exception('Unknown response type: ${response.data}');
      }
    } on DioException catch (e) {
      // Log error response
   //  print("Error sending SMS: ${e.response?.data}");
      throw Exception('Failed to send SMS: ${e.response?.data}');
    }
  }
}