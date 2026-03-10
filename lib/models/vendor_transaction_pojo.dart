import 'dart:convert';

VendorTransactionList vendorTransactionListFromJson(String str) =>
    VendorTransactionList.fromJson(json.decode(str));

String vendorTransactionListToJson(VendorTransactionList data) =>
    json.encode(data.toJson());

class VendorTransactionList {
  int status;
  String message;
  int completeCounter;
  int activeCounter;
  List<Completevendor> completeVendor;
  List<Activevendor> activeVendor;

  VendorTransactionList({
    required this.status,
    required this.message,
    required this.completeCounter,
    required this.activeCounter,
    required this.completeVendor,
    required this.activeVendor,
  });

  factory VendorTransactionList.fromJson(Map<String, dynamic> json) =>
      VendorTransactionList(
        status: json["status"] ?? 0,
        message: json["message"] ?? "",
        completeCounter: json["completecounter"] ?? 0,
        activeCounter: json["activecounter"] ?? 0,
        completeVendor:
            json["completevendor"] == null
                ? []
                : List<Completevendor>.from(
                  json["completevendor"].map((x) => Completevendor.fromJson(x)),
                ),
        activeVendor:
            json["activevendor"] == null
                ? []
                : List<Activevendor>.from(
                  json["activevendor"].map((x) => Activevendor.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "completecounter": completeCounter,
    "activecounter": activeCounter,
    "completevendor": List<dynamic>.from(completeVendor.map((x) => x.toJson())),
    "activevendor": List<dynamic>.from(activeVendor.map((x) => x.toJson())),
  };
}

class Completevendor {
  int? orderid;
  String? ponumber;
  String? mrnno;
  String? vendorname;
  int? grossweight;
  int? tareweight;
  String? itemname;
  String? actiontime;
  int? netweight;
  String? challanno;
  String? sitename;
  String? vehiclenumber;
  String? lastaction;
  String? drivername;
  String? moisture;
  String? reciept;
  String? uom;
  String? drivermobile;
  String? orderstatus;
  String? challanNo1;
  String? net1;

  Completevendor({
    this.orderid,
    this.ponumber,
    this.mrnno,
    this.vendorname,
    this.grossweight,
    this.tareweight,
    this.itemname,
    this.actiontime,
    this.netweight,
    this.challanno,
    this.sitename,
    this.vehiclenumber,
    this.lastaction,
    this.drivername,
    this.moisture,
    this.reciept,
    this.uom,
    this.drivermobile,
    this.orderstatus,
    this.challanNo1,
    this.net1,
  });

  factory Completevendor.fromJson(Map<String, dynamic> json) => Completevendor(
    orderid: json["orderid"] ?? 0,
    ponumber: json["ponumber"] ?? "",
    mrnno: json["mrnno"] ?? "",
    vendorname: json["vendorname"] ?? "",
    grossweight: json["grossweight"] ?? 0,
    tareweight: json["tareweight"] ?? 0,
    itemname: json["itemname"] ?? "",
    actiontime: json["actiontime"] ?? "",
    netweight: json["netweight"] ?? 0,
    challanno: json["challanno"] ?? "",
    sitename: json["sitename"] ?? "",
    vehiclenumber: json["vehiclenumber"] ?? "",
    lastaction: json["lastaction"] ?? "",
    drivername: json["drivername"] ?? "",
    moisture: json["moisture"] ?? "",
    reciept: json["reciept"] ?? "",
    uom: json["uom"] ?? "",
    drivermobile: json["drivermobile"] ?? "",
    orderstatus: json["orderstatus"] ?? "",
    challanNo1: json["challan_no1"] ?? "",
    net1: json["NET1"]?.toString() ?? "", // Ensure it's treated as a String
  );

  Map<String, dynamic> toJson() => {
    "orderid": orderid,
    "ponumber": ponumber,
    "mrnno": mrnno,
    "vendorname": vendorname,
    "grossweight": grossweight,
    "tareweight": tareweight,
    "itemname": itemname,
    "actiontime": actiontime,
    "netweight": netweight,
    "challanno": challanno,
    "sitename": sitename,
    "vehiclenumber": vehiclenumber,
    "lastaction": lastaction,
    "drivername": drivername,
    "moisture": moisture,
    "reciept": reciept,
    "uom": uom,
    "drivermobile": drivermobile,
    "orderstatus": orderstatus,
    "challan_no1": challanNo1,
    "NET1": net1,
  };
}

class Activevendor {
  int? orderid;
  String? ponumber;
  String? mrnno;
  String? vendorname;
  int? grossweight;
  int? tareweight;
  String? itemname;
  String? actiontime;
  int? netweight;
  String? challanno;
  String? sitename;
  String? vehiclenumber;
  String? lastaction;
  String? drivername;
  String? moisture;
  String? reciept;
  String? uom;
  String? drivermobile;
  String? orderstatus;
  String? challanNo1;
  String? net1;

  Activevendor({
    this.orderid,
    this.ponumber,
    this.mrnno,
    this.vendorname,
    this.grossweight,
    this.tareweight,
    this.itemname,
    this.actiontime,
    this.netweight,
    this.challanno,
    this.sitename,
    this.vehiclenumber,
    this.lastaction,
    this.drivername,
    this.moisture,
    this.reciept,
    this.uom,
    this.drivermobile,
    this.orderstatus,
    this.challanNo1,
    this.net1,
  });

  factory Activevendor.fromJson(Map<String, dynamic> json) => Activevendor(
    orderid: json["orderid"] ?? 0,
    ponumber: json["ponumber"] ?? "",
    mrnno: json["mrnno"] ?? "",
    vendorname: json["vendorname"] ?? "",
    grossweight: json["grossweight"] ?? 0,
    tareweight: json["tareweight"] ?? 0,
    itemname: json["itemname"] ?? "",
    actiontime: json["actiontime"] ?? "",
    netweight: json["netweight"] ?? 0,
    challanno: json["challanno"] ?? "",
    sitename: json["sitename"] ?? "",
    vehiclenumber: json["vehiclenumber"] ?? "",
    lastaction: json["lastaction"] ?? "",
    drivername: json["drivername"] ?? "",
    moisture: json["moisture"] ?? "",
    reciept: json["reciept"] ?? "",
    uom: json["uom"] ?? "",
    drivermobile: json["drivermobile"] ?? "",
    orderstatus: json["orderstatus"] ?? "",
    challanNo1: json["challan_no1"] ?? "",
    net1: json["NET1"]?.toString() ?? "", // Ensure it's treated as a String
  );

  Map<String, dynamic> toJson() => {
    "orderid": orderid,
    "ponumber": ponumber,
    "mrnno": mrnno,
    "vendorname": vendorname,
    "grossweight": grossweight,
    "tareweight": tareweight,
    "itemname": itemname,
    "actiontime": actiontime,
    "netweight": netweight,
    "challanno": challanno,
    "sitename": sitename,
    "vehiclenumber": vehiclenumber,
    "lastaction": lastaction,
    "drivername": drivername,
    "moisture": moisture,
    "reciept": reciept,
    "uom": uom,
    "drivermobile": drivermobile,
    "orderstatus": orderstatus,
    "challan_no1": challanNo1,
    "NET1": net1,
  };
}

// import 'dart:convert';
//
// VendorTransactionList vendorTransactionListFromJson(String str) => VendorTransactionList.fromJson(json.decode(str));
//
// String vendorTransactionListToJson(VendorTransactionList data) => json.encode(data.toJson());
//
// class VendorTransactionList {
//   int status;
//   String message;
//   int completeCounter;
//   int activeCounter;
//   List<Vendor> completeVendor;
//   List<Vendor> activeVendor;
//
//   VendorTransactionList({
//     required this.status,
//     required this.message,
//     required this.completeCounter,
//     required this.activeCounter,
//     required this.completeVendor,
//     required this.activeVendor,
//   });
//
//   factory VendorTransactionList.fromJson(Map<String, dynamic> json) => VendorTransactionList(
//     status: json["status"],
//     message: json["message"],
//     completeCounter: json["completecounter"],
//     activeCounter: json["activecounter"],
//     completeVendor: List<Vendor>.from(json["completevendor"].map((x) => Vendor.fromJson(x))),
//     activeVendor: List<Vendor>.from(json["activevendor"].map((x) => Vendor.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "completecounter": completeCounter,
//     "activecounter": activeCounter,
//     "completevendor": List<dynamic>.from(completeVendor.map((x) => x.toJson())),
//     "activevendor": List<dynamic>.from(activeVendor.map((x) => x.toJson())),
//   };
// }
//
// class Vendor {
//   int? orderid;
//   String? ponumber;
//   String? vendorname;
//   int? grossweight;
//   int? tareweight;
//   String? itemname;
//   String? actiontime;
//   int? netweight;
//   String? challanno;
//   String? sitename;
//   String? vehiclenumber;
//   String? lastaction;
//   String? drivername;
//   String? moisture;
//   String? reciept;
//   String? uom;
//   String? drivermobile;
//   String? orderstatus;
//   String? challanNo1;
//   String? net1;
//
//   Vendor({
//     required this.orderid,
//     required this.ponumber,
//     required this.vendorname,
//     required this.grossweight,
//     required this.tareweight,
//     required this.itemname,
//     required this.actiontime,
//     required this.netweight,
//     required this.challanno,
//     required this.sitename,
//     required this.vehiclenumber,
//     required this.lastaction,
//     required this.drivername,
//     required this.moisture,
//     required this.reciept,
//     required this.uom,
//     required this.drivermobile,
//     required this.orderstatus,
//     required this.challanNo1,
//     required this.net1,
//   });
//
//   factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
//     orderid: json["orderid"],
//     ponumber: json["ponumber"],
//     vendorname: json["vendorname"],
//     grossweight: json["grossweight"]?? 0,
//     tareweight: json["tareweight"]?? 0,
//     itemname: json["itemname"],
//     actiontime: json["actiontime"],
//     netweight: json["netweight"]?? 0,
//     challanno: json["challanno"],
//     sitename: json["sitename"],
//     vehiclenumber: json["vehiclenumber"],
//     lastaction: json["lastaction"],
//     drivername: json["drivername"],
//     moisture: json["moisture"],
//     reciept: json["reciept"],
//     uom: json["uom"],
//     drivermobile: json["drivermobile"],
//     orderstatus: json["orderstatus"],
//     challanNo1: json["challan_no1"],
//     net1: json["NET1"]?? 0,
//   );
//
//   Map<String, dynamic> toJson() => {
//     "orderid": orderid,
//     "ponumber": ponumber,
//     "vendorname": vendorname,
//     "grossweight": grossweight,
//     "tareweight": tareweight,
//     "itemname": itemname,
//     "actiontime": actiontime,
//     "netweight": netweight,
//     "challanno": challanno,
//     "sitename": sitename,
//     "vehiclenumber": vehiclenumber,
//     "lastaction": lastaction,
//     "drivername": drivername,
//     "moisture": moisture,
//     "reciept": reciept,
//     "uom": uom,
//     "drivermobile": drivermobile,
//     "orderstatus": orderstatus,
//     "challan_no1": challanNo1,
//     "NET1": net1,
//   };
// }
