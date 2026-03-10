class UpdateResponse {
  final int? status;
  final String? message;

  UpdateResponse({
    required this.status,
    required this.message,
  });

  factory UpdateResponse.fromJson(Map<String, dynamic> json) {
    return UpdateResponse(
      status: json["status"] as int?,
      message: json["message"] as String?,
    );
  }
}