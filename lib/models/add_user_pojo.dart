// class SetStatus {
//   final String status;
//   final String message;
//   final String? createdId; // Nullable
//   final String? sitename;  // Nullable
//
//   SetStatus({
//     required this.status,
//     required this.message,
//     this.createdId,
//     this.sitename,
//   });
//
//   factory SetStatus.fromJson(Map<String, dynamic> json) {
//     return SetStatus(
//       status: json["status"] ?? "0",  // Default to "0" if null
//       message: json["message"] ?? "Unknown error",
//       createdId: json["createdId"],  // Nullable
//       sitename: json["sitename"],    // Nullable
//     );
//   }
// }
class SetStatus {
  final String status;
  final String message;
  final String? createdid; // Nullable
  final String? sitename; // Nullable

  SetStatus({
    required this.status,
    required this.message,
    this.createdid,
    this.sitename,
  });

  factory SetStatus.fromJson(Map<String, dynamic> json) {
    return SetStatus(
      status:
          (json['status'] is int
              ? json['status'].toString()
              : json['status']) ?? "0",
      message:  (json['message'] ?? json['mesage'])?.toString() ??   "No message available",
      createdid: json['createdid'] as String?, // Nullable
      sitename: json['sitename'] as String?,

    );
  }
}
