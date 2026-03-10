class UserList {
  final String username;
  final int userid;
  final String vendorid;
  final String usermobile;
  final String joindate;
  final String useremail;
  final String userrole;

  UserList({
    required this.username,
    required this.userid,
    required this.vendorid,
    required this.usermobile,
    required this.joindate,
    required this.useremail,
    required this.userrole,
  });

  // Factory constructor to create an instance from JSON
  factory UserList.fromJson(Map<String, dynamic> json) {
    return UserList(
      username: json['username'] ?? '',
      userid: json['userid'] ?? 0,
      vendorid: json['vendorid'] ?? '',
      usermobile: json['usermobile'] ?? '',
      joindate: json['joindate'] ?? '',
      useremail: json['useremail'] ?? '',
      userrole: json['userrole'] ?? '',
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'userid': userid,
      'vendorid': vendorid,
      'usermobile': usermobile,
      'joindate': joindate,
      'useremail': useremail,
      'userrole': userrole,
    };
  }
}
