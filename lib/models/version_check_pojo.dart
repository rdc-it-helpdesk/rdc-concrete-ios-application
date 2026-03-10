class CheckVersion {
  final String currentV; // Using camelCase for Dart
  final String updateAt; // Using camelCase for Dart
  final String vFile; // Using camelCase for Dart

  // Constructor
  CheckVersion({
    required this.currentV,
    required this.updateAt,
    required this.vFile,
  });

  // Factory method to create an instance from JSON
  factory CheckVersion.fromJson(Map<String, dynamic> json) {
    return CheckVersion(
      currentV: json['current_v'],
      updateAt: json['update_at'],
      vFile: json['v_file'],
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {'current_v': currentV, 'update_at': updateAt, 'v_file': vFile};
  }
}
