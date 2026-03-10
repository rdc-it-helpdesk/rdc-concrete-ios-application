// This will be generated

class Completereport {
  final int orderid;
  final String ponumber;
  final String vendorname;
  final String grossweight;
  final String tareweight;
  final String actiontime;
  final String rdcgross;
  final String rdctare;
  final String rdcnet;
  final String itemname;
  final String netweight;
  final String mrnno;
  final String challanno;
  final String sitename;
  final String vehiclenumber;
  final String lastaction;
  final String drivername;
  final String moisture;
  final String reciept;
  final String uom;
  final int acceptvy;
  final String drivermobile;
  final String net1;
  final String challanno1;

  Completereport({
    required this.orderid,
    required this.ponumber,
    required this.vendorname,
    required this.grossweight,
    required this.tareweight,
    required this.actiontime,
    required this.rdcgross,
    required this.rdctare,
    required this.rdcnet,
    required this.itemname,
    required this.netweight,
    required this.mrnno,
    required this.challanno,
    required this.sitename,
    required this.vehiclenumber,
    required this.lastaction,
    required this.drivername,
    required this.moisture,
    required this.reciept,
    required this.uom,
    required this.acceptvy,
    required this.drivermobile,
    required this.net1,
    required this.challanno1,
  });

  factory Completereport.fromJson(Map<String, dynamic> json) {
    return Completereport(
      orderid: json["orderid"] ?? 0,
      ponumber: json["ponumber"] ?? "",
      vendorname: json["vendorname"] ?? "",
      grossweight: json["grossweight"] ?? "",
      tareweight: json["tareweight"] ?? "",
      actiontime: json["actiontime"] ?? "",
      rdcgross: json["rdcgross"] ?? "",
      rdctare: json["rdctare"] ?? "",
      rdcnet: json["rdcnet"] ?? "",
      itemname: json["itemname"] ?? "",
      netweight: json["netweight"] ?? "",
      mrnno: json["mrnno"] ?? "",
      challanno: json["challanno"] ?? "",
      sitename: json["sitename"] ?? "",
      vehiclenumber: json["vehiclenumber"] ?? "",
      lastaction: json["lastaction"] ?? "",
      drivername: json["drivername"] ?? "",
      moisture: json["moisture"] ?? "",
      reciept: json["reciept"] ?? "",
      uom: json["uom"] ?? "",
      acceptvy: json["acceptvy"] ?? 0,
      drivermobile: json["drivermobile"] ?? "",
      net1: json["NET1"] ?? "",
      challanno1: json["challan_no1"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "orderid": orderid,
      "ponumber": ponumber,
      "vendorname": vendorname,
      "grossweight": grossweight,
      "tareweight": tareweight,
      "actiontime": actiontime,
      "rdcgross": rdcgross,
      "rdctare": rdctare,
      "rdcnet": rdcnet,
      "itemname": itemname,
      "netweight": netweight,
      "mrnno": mrnno,
      "challanno": challanno,
      "sitename": sitename,
      "vehiclenumber": vehiclenumber,
      "lastaction": lastaction,
      "drivername": drivername,
      "moisture": moisture,
      "reciept": reciept,
      "uom": uom,
      "acceptvy": acceptvy,
      "drivermobile": drivermobile,
      "NET1": net1,
      "challan_no1": challanno1,
    };
  }
}

class ReportModel {
  final int status;
  final String message;
  final int completecounter;
  final int activecounter;
  final List<Completereport> completereport;

  ReportModel({
    required this.status,
    required this.message,
    required this.completecounter,
    required this.activecounter,
    required this.completereport,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      status: json["status"] ?? 0,
      message: json["message"] ?? "",
      completecounter: json["completecounter"] ?? 0,
      activecounter: json["activecounter"] ?? 0,
      completereport:
          json["completereport"] == null
              ? []
              : List<Completereport>.from(
                json["completereport"].map((x) => Completereport.fromJson(x)),
              ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "completecounter": completecounter,
      "activecounter": activecounter,
      "completereport": List<dynamic>.from(
        completereport.map((x) => x.toJson()),
      ),
    };
  }
}
