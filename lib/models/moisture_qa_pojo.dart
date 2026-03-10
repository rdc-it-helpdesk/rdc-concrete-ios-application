// class MoisturePojo {
//   final String name;
//   final int userid;
//   final String useremail;
//   final String usermonbile;
//   final int locationid;
//   final String sitename;
//   final String role;
//   final int status;
//   final List<CompleteMoisture> completemoisture;
//   final List<PendingMoisture> pendingmoisture;
//
//   MoisturePojo({
//     required this.name,
//     required this.userid,
//     required this.useremail,
//     required this.usermonbile,
//     required this.locationid,
//     required this.sitename,
//     required this.role,
//     required this.status,
//     required this.completemoisture,
//     required this.pendingmoisture,
//   });
//
//   factory MoisturePojo.fromJson(Map<String, dynamic> json) {
//     return MoisturePojo(
//       name: json['name'] ?? '',
//       userid: json['userid'] ?? 0,
//       useremail: json['useremail'] ?? '',
//       usermonbile: json['usermonbile'] ?? '',
//       locationid: json['locationid'] ?? 0,
//       sitename: json['sitename'] ?? '',
//       role: json['role'] ?? '',
//       status: json['status'] ?? 0,
//       completemoisture: (json['completemoisture'] as List<dynamic>?)
//           ?.map((i) => CompleteMoisture.fromJson(i))
//           .toList() ??
//           [],
//       pendingmoisture: (json['pendingmoisture'] as List<dynamic>?)
//           ?.map((i) => PendingMoisture.fromJson(i))
//           .toList() ??
//           [],
//     );
//   }
// }
//
// class CompleteMoisture {
//   final String mper;
//   final String driverid;
//   final String sitename;
//   final String vendormobile;
//   final String itemname;
//   final String drivercontact;
//   final String ponumber;
//   final String challanno;
//   final String createdtime;
//   final int orderid;
//   final String netweight;
//   final String grossweight;
//   final String tareweight;
//   final String vehicleno;
//   final String vendorname;
//   final String drivername;
//   final String vendoremail;
//
//   CompleteMoisture({
//     required this.mper,
//     required this.driverid,
//     required this.sitename,
//     required this.vendormobile,
//     required this.itemname,
//     required this.drivercontact,
//     required this.ponumber,
//     required this.challanno,
//     required this.createdtime,
//     required this.orderid,
//     required this.netweight,
//     required this.grossweight,
//     required this.tareweight,
//     required this.vehicleno,
//     required this.vendorname,
//     required this.drivername,
//     required this.vendoremail,
//   });
//
//   factory CompleteMoisture.fromJson(Map<String, dynamic> json) {
//     return CompleteMoisture(
//       mper: json['mper'] ?? '',
//       driverid: json['driverid'] ?? '',
//       sitename: json['sitename'] ?? '',
//       vendormobile: json['vendormobile'] ?? '',
//       itemname: json['itemname'] ?? '',
//       drivercontact: json['drivercontact'] ?? '',
//       ponumber: json['ponumber'] ?? '',
//       challanno: json['challanno'] ?? '',
//       createdtime: json['createdtime'] ?? '',
//       orderid: json['orderid'] ?? 0,
//       netweight: json['netweight'] ?? '',
//       grossweight: json['grossweight'] ?? '',
//       tareweight: json['tareweight'] ?? '',
//       vehicleno: json['vehicleno'] ?? '',
//       vendorname: json['vendorname'] ?? '',
//       drivername: json['drivername'] ?? '',
//       vendoremail: json['vendoremail'] ?? '',
//     );
//   }
// }
//
// class PendingMoisture {
//   final String sitename;
//   final String driverid;
//   final String itemname;
//   final String vendormobile;
//   final String drivercontact;
//   final String ponumber;
//   final String challanno;
//   final String createdtime;
//   final int orderid;
//   final String netweight;
//   final String grossweight;
//   final String tareweight;
//   final String vehicleno;
//   final String vendorname;
//   final String drivername;
//   final String vendoremail;
//
//   PendingMoisture({
//     required this.sitename,
//     required this.driverid,
//     required this.itemname,
//     required this.vendormobile,
//     required this.drivercontact,
//     required this.ponumber,
//     required this.challanno,
//     required this.createdtime,
//     required this.orderid,
//     required this.netweight,
//     required this.grossweight,
//     required this.tareweight,
//     required this.vehicleno,
//     required this.vendorname,
//     required this.drivername,
//     required this.vendoremail,
//   });
//
//   factory PendingMoisture.fromJson(Map<String, dynamic> json) {
//     return PendingMoisture(
//       sitename: json['sitename'] ?? '',
//       driverid: json['driverid'] ?? '',
//       itemname: json['itemname'] ?? '',
//       vendormobile: json['vendormobile'] ?? '',
//       drivercontact: json['drivercontact'] ?? '',
//       ponumber: json['ponumber'] ?? '',
//       challanno: json['challanno'] ?? '',
//       createdtime: json['createdtime'] ?? '',
//       orderid: json['orderid'] ?? 0,
//       netweight: json['netweight'] ?? '',
//       grossweight: json['grossweight'] ?? '',
//       tareweight: json['tareweight'] ?? '',
//       vehicleno: json['vehicleno'] ?? '',
//       vendorname: json['vendorname'] ?? '',
//       drivername: json['drivername'] ?? '',
//       vendoremail: json['vendoremail'] ?? '',
//     );
//   }
// }
class MoisturePojo {
  final String name;
  final int userid;
  final String useremail;
  final String usermonbile;
  final int locationid;
  final String sitename;
  final String role;
  final int status;
  final List<CompleteMoisture> completemoisture;
  final List<PendingMoisture> pendingmoisture;

  MoisturePojo({
    required this.name,
    required this.userid,
    required this.useremail,
    required this.usermonbile,
    required this.locationid,
    required this.sitename,
    required this.role,
    required this.status,
    required this.completemoisture,
    required this.pendingmoisture,
  });

  factory MoisturePojo.fromJson(Map<String, dynamic> json) {
    return MoisturePojo(
      name: json['name']?.toString() ?? '',
      userid: json['userid'] is String
          ? int.tryParse(json['userid']) ?? 0
          : (json['userid'] ?? 0),
      useremail: json['useremail']?.toString() ?? '',
      usermonbile: json['usermonbile']?.toString() ?? '',
      locationid: json['locationid'] is String
          ? int.tryParse(json['locationid']) ?? 0
          : (json['locationid'] ?? 0),
      sitename: json['sitename']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      status: json['status'] is String
          ? int.tryParse(json['status']) ?? 0
          : (json['status'] ?? 0),
      completemoisture: (json['completemoisture'] as List<dynamic>?)
          ?.map((i) => CompleteMoisture.fromJson(i))
          .toList() ??
          [],
      pendingmoisture: (json['pendingmoisture'] as List<dynamic>?)
          ?.map((i) => PendingMoisture.fromJson(i))
          .toList() ??
          [],
    );
  }
}
class CompleteMoisture {
  final String mper;
  final String driverid;
  final String sitename;
  final String vendormobile;
  final String itemname;
  final String drivercontact;
  final String ponumber;
  final String challanno;
  final String createdtime;
  final int orderid;
  final String netweight;
  final String grossweight;
  final String tareweight;
  final String vehicleno;
  final String vendorname;
  final String drivername;
  final String vendoremail;

  CompleteMoisture({
    required this.mper,
    required this.driverid,
    required this.sitename,
    required this.vendormobile,
    required this.itemname,
    required this.drivercontact,
    required this.ponumber,
    required this.challanno,
    required this.createdtime,
    required this.orderid,
    required this.netweight,
    required this.grossweight,
    required this.tareweight,
    required this.vehicleno,
    required this.vendorname,
    required this.drivername,
    required this.vendoremail,
  });

  factory CompleteMoisture.fromJson(Map<String, dynamic> json) {
    return CompleteMoisture(
      mper: json['mper']?.toString() ?? '',
      driverid: json['driverid']?.toString() ?? '',
      sitename: json['sitename']?.toString() ?? '',
      vendormobile: json['vendormobile']?.toString() ?? '',
      itemname: json['itemname']?.toString() ?? '',
      drivercontact: json['drivercontact']?.toString() ?? '',
      ponumber: json['ponumber']?.toString() ?? '',
      challanno: json['challanno']?.toString() ?? '',
      createdtime: json['createdtime']?.toString() ?? '',
      orderid: json['orderid'] is String
          ? int.tryParse(json['orderid']) ?? 0
          : (json['orderid'] ?? 0),
      netweight: json['netweight']?.toString() ?? '',
      grossweight: json['grossweight']?.toString() ?? '',
      tareweight: json['tareweight']?.toString() ?? '',
      vehicleno: json['vehicleno']?.toString() ?? '',
      vendorname: json['vendorname']?.toString() ?? '',
      drivername: json['drivername']?.toString() ?? '',
      vendoremail: json['vendoremail']?.toString() ?? '',
    );
  }
}
class PendingMoisture {
  final String sitename;
  final String driverid;
  final String itemname;
  final String vendormobile;
  final String drivercontact;
  final String ponumber;
  final String challanno;
  final String createdtime;
  final int orderid;
  final String netweight;
  final String grossweight;
  final String tareweight;
  final String vehicleno;
  final String vendorname;
  final String drivername;
  final String vendoremail;

  PendingMoisture({
    required this.sitename,
    required this.driverid,
    required this.itemname,
    required this.vendormobile,
    required this.drivercontact,
    required this.ponumber,
    required this.challanno,
    required this.createdtime,
    required this.orderid,
    required this.netweight,
    required this.grossweight,
    required this.tareweight,
    required this.vehicleno,
    required this.vendorname,
    required this.drivername,
    required this.vendoremail,
  });

  factory PendingMoisture.fromJson(Map<String, dynamic> json) {
    return PendingMoisture(
      sitename: json['sitename']?.toString() ?? '',
      driverid: json['driverid']?.toString() ?? '',
      itemname: json['itemname']?.toString() ?? '',
      vendormobile: json['vendormobile']?.toString() ?? '',
      drivercontact: json['drivercontact']?.toString() ?? '',
      ponumber: json['ponumber']?.toString() ?? '',
      challanno: json['challanno']?.toString() ?? '',
      createdtime: json['createdtime']?.toString() ?? '',
      orderid: json['orderid'] is String
          ? int.tryParse(json['orderid']) ?? 0
          : (json['orderid'] ?? 0),
      netweight: json['netweight']?.toString() ?? '',
      grossweight: json['grossweight']?.toString() ?? '',
      tareweight: json['tareweight']?.toString() ?? '',
      vehicleno: json['vehicleno']?.toString() ?? '',
      vendorname: json['vendorname']?.toString() ?? '',
      drivername: json['drivername']?.toString() ?? '',
      vendoremail: json['vendoremail']?.toString() ?? '',
    );
  }
}
