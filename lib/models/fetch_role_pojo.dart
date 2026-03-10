// Model class for RoleList
class RoleList {
  final int roleId;
  final String roleName;

  RoleList({required this.roleId, required this.roleName});

  factory RoleList.fromJson(Map<String, dynamic> json) {
    return RoleList(roleId: json['roleid'], roleName: json['rolename']);
  }
}
