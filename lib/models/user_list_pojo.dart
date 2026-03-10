// lib/models/user.dart

class User {
  final String username;
  final int userid;
  final String vendorid;
  final String usermobile;
  final String joindate;
  final String useremail;
  final String userrole;

  User({
    required this.username,
    required this.userid,
    required this.vendorid,
    required this.usermobile,
    required this.joindate,
    required this.useremail,
    required this.userrole,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      userid: json['userid'],
      vendorid: json['vendorid'],
      usermobile: json['usermobile'],
      joindate: json['joindate'],
      useremail: json['useremail'],
      userrole: json['userrole'],
    );
  }
}
