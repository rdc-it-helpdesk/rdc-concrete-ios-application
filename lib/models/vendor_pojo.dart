class Vendor {
  final int status;
  final String vendorName;
  final int? vendorId;
  final String vendorEmail;
  final String vendorLocation;
  final String contactPerson;
  final String vendorMobile;
  final int locId;
  final String checkAttempt;
  final String message;
  final List<PoList> poList;

  Vendor({
    required this.status,
    required this.vendorName,
    required this.vendorId,
    required this.vendorEmail,
    required this.vendorLocation,
    required this.contactPerson,
    required this.vendorMobile,
    required this.locId,
    required this.checkAttempt,
    required this.message,
    required this.poList,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      status: json["status"] ?? 0,
      message: json["message"] ?? '',
      vendorName: json["vendorname"] ?? '',
      vendorId: json["vendorid"] ?? '',
      vendorEmail: json["vendoremail"] ?? '',
      vendorLocation: json["vendorlocation"] ?? '',
      contactPerson: json["contactperson"] ?? '',
      vendorMobile: json["vendormobile"] ?? '',
      locId: json["locid"] ?? 0,
      checkAttempt: json["checkattempt"] ?? "",
      // poList: (json["polist"] as List).map((e) => PoList.fromJson(e)).toList(),
      poList:
          (json['polist'] as List<dynamic>?)
              ?.map((po) => PoList.fromJson(po))
              .toList() ??
          [],
    );
  }
}

class PoList {
  final int poNumberId;
  final String poNumber;
  final String lineId;
  final String itemName;
  final String shipTo;
  final String billTo;
  final String issueQty;
  final String availableQty;
  final String siteName;
  final String vEmail;
  final int createdId;
  final String needByDate;
  final String poCreationTime;
  final String unitprice;

  PoList({
    required this.poNumberId,
    required this.poNumber,
    required this.lineId,
    required this.itemName,
    required this.shipTo,
    required this.billTo,
    required this.issueQty,
    required this.availableQty,
    required this.siteName,
    required this.vEmail,
    required this.createdId,
    required this.needByDate,
    required this.poCreationTime,
    required this.unitprice,
  });

  factory PoList.fromJson(Map<String, dynamic> json) {
    return PoList(
      poNumberId: json["ponumberid"],
      poNumber: json["ponumber"],
      lineId: json["lineid"],
      itemName: json["itemname"],
      shipTo: json["shipto"],
      billTo: json["billto"],
      issueQty: json["isuueqty"],
      availableQty: json["availableqty"],
      siteName: json["sitename"],
      vEmail: json["vemail"],
      createdId: json["createdid"],
      needByDate: json["needbydt"],
      poCreationTime: json["pocreationtime"],
      unitprice: json["unit_price"],
    );
  }
}
