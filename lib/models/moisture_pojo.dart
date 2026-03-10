// class MoisturePojo {
//   final String name;
//   final int userid;
//   final String useremail;
//   final String usermobile;
//   final int locationid;
//   final String sitename;
//   final String role;
//   final String status;
//
//   MoisturePojo({
//     required this.name,
//     required this.userid,
//     required this.useremail,
//     required this.usermobile,
//     required this.locationid,
//     required this.sitename,
//     required this.role,
//     required this.status,
//   });
//
//   factory MoisturePojo.fromJson(Map<String, dynamic> json) {
//     return MoisturePojo(
//       name: json['name'] ?? "",
//       userid: json['userid'] ?? 0,
//       useremail: json['useremail'] ?? "",
//       usermobile: json['usermonbile'] ?? "",
//       locationid: json['locationid'] ?? 0,
//       sitename: json['sitename'] ?? "",
//       role: json['role'] ?? "",
//       status: json['status'] ?? "0",
//     );
//   }
// }
class MoisturePojo {
  final String name;
  final int userid;
  final String useremail;
  final String usermobile;
  final int locationid;
  final String sitename;
  final String role;
  final String status;

  MoisturePojo({
    required this.name,
    required this.userid,
    required this.useremail,
    required this.usermobile,
    required this.locationid,
    required this.sitename,
    required this.role,
    required this.status,
  });

  factory MoisturePojo.fromJson(Map<String, dynamic> json) {
    return MoisturePojo(
      name: json['name']?.toString() ?? "",
      userid: json['userid'] is String ? int.tryParse(json['userid']) ?? 0 : json['userid'] ?? 0,
      useremail: json['useremail']?.toString() ?? "",
      usermobile: json['usermonbile']?.toString() ?? "", // Fixed typo: usermonbile -> usermobile
      locationid: json['locationid'] is String ? int.tryParse(json['locationid']) ?? 0 : json['locationid'] ?? 0,
      sitename: json['sitename']?.toString() ?? "",
      role: json['role']?.toString() ?? "",
      status: json['status']?.toString() ?? "0",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'userid': userid,
      'useremail': useremail,
      'usermonbile': usermobile,
      'locationid': locationid,
      'sitename': sitename,
      'role': role,
      'status': status,
    };
  }
}