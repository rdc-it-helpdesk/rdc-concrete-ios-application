class MaterialOfficerModel {
  final int status;
  final String message;
  final int completeCounter;
  final int activeCounter;
  final int cancelCounter;
  final List<ActiveMO> activeMO;
  final List<CanceledMO> canceledMO;
  final List<CompleteMo> completeMO;

  MaterialOfficerModel({
    required this.status,
    required this.message,
    required this.completeCounter,
    required this.activeCounter,
    required this.cancelCounter,
    required this.activeMO,
    required this.canceledMO,
    required this.completeMO,
  });

  factory MaterialOfficerModel.fromJson(Map<String, dynamic> json) {
    return MaterialOfficerModel(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      completeCounter: json['completecounter'] ?? 0,
      activeCounter: json['activecounter'] ?? 0,
      cancelCounter: json['cancelcounter'] ?? 0,
      activeMO:
          (json['activemo'] as List<dynamic>?)
              ?.map((i) => ActiveMO.fromJson(i))
              .toList() ??
          [],
      canceledMO:
          (json['canceledmo'] as List<dynamic>?)
              ?.map((i) => CanceledMO.fromJson(i))
              .toList() ??
          [],
      completeMO:
          (json['com0letemo'] as List<dynamic>?)
              ?.map((i) => CompleteMo.fromJson(i))
              .toList() ??
          [],
    );
  }
}

class ActiveMO {
  final int orderId;
  final String poNumber;
  final String vendorName;
  final String grossWeight;
  final String tareWeight;
  final String itemName;
  final String actionTime;
  final String netWeight;
  final String firstInvoice;
  final String challanNo;
  final String siteName;
  final String vehicleNumber;
  final String fileName;
  final String lastAction;
  final String driverName;
  final String moisture;
  final String receipt;
  final String uom;
  final String driverMobile;
  final String orderStatus;
  final String contact;
  final String net1;
  final String challanno1;

  ActiveMO({
    required this.orderId,
    required this.poNumber,
    required this.vendorName,
    required this.grossWeight,
    required this.tareWeight,
    required this.itemName,
    required this.actionTime,
    required this.netWeight,
    required this.firstInvoice,
    required this.challanNo,
    required this.siteName,
    required this.vehicleNumber,
    required this.fileName,
    required this.lastAction,
    required this.driverName,
    required this.moisture,
    required this.receipt,
    required this.uom,
    required this.driverMobile,
    required this.orderStatus,
    required this.contact,
    required this.net1,
    required this.challanno1,
  });

  factory ActiveMO.fromJson(Map<String, dynamic> json) {
    return ActiveMO(
      orderId: json['orderid'] ?? 0,
      poNumber: json['ponumber'] ?? '',
      vendorName: json['vendorname'] ?? '',
      grossWeight: json['grossweight']?.toString() ?? '',
      tareWeight: json['tareweight']?.toString() ?? '',
      itemName: json['itemname'] ?? '',
      actionTime: json['actiontime'] ?? '',
      netWeight: json['netweight']?.toString() ?? '',
      firstInvoice: json['firstinvoice'] ?? '',
      challanNo: json['challanno'] ?? '',
      siteName: json['sitename'] ?? '',
      vehicleNumber: json['vehiclenumber'] ?? '',
      fileName: json['filename'] ?? '',
      lastAction: json['lastaction'] ?? '',
      driverName: json['drivername'] ?? '',
      moisture: json['moisture']?.toString() ?? '',
      receipt: json['reciept'] ?? '',
      uom: json['uom'] ?? '',
      driverMobile: json['drivermobile'] ?? '',
      orderStatus: json['orderstatus'] ?? '',
      contact: json['contact'] ?? '',
      net1: json['NET1'] ?? '',
      challanno1: json['challan_no1'] ?? '',
    );
  }
}

class CanceledMO {
  final int orderId;
  final String poNumber;
  final String vendorName;
  final String grossWeight;
  final String tareWeight;
  final String itemName;
  final String actionTime;
  final String netWeight;
  final String challanNo;
  final String challanNo1;
  final String siteName;
  final String vehicleNumber;
  final String lastAction;
  final String driverName;
  final String moisture;
  final String receipt;
  final String uom;
  final String driverMobile;
  final String orderStatus;
  final String contact;
  final String? mrnno;
  final String? net1;

  CanceledMO({
    required this.orderId,
    required this.poNumber,
    required this.vendorName,
    required this.grossWeight,
    required this.tareWeight,
    required this.itemName,
    required this.actionTime,
    required this.netWeight,
    required this.challanNo,
    required this.challanNo1,
    required this.siteName,
    required this.vehicleNumber,
    required this.lastAction,
    required this.driverName,
    required this.moisture,
    required this.receipt,
    required this.uom,
    required this.driverMobile,
    required this.orderStatus,
    required this.contact,
    required this.mrnno,
    required this.net1,
  });

  factory CanceledMO.fromJson(Map<String, dynamic> json) {
    return CanceledMO(
      orderId: json['orderid'] ?? 0,
      poNumber: json['ponumber'] ?? '',
      vendorName: json['vendorname'] ?? '',
      grossWeight: json['grossweight']?.toString() ?? '',
      tareWeight: json['tareweight']?.toString() ?? '',
      itemName: json['itemname'] ?? '',
      actionTime: json['actiontime'] ?? '',
      netWeight: json['netweight']?.toString() ?? '',
      net1: json['net1']?.toString() ?? '',
      challanNo: json['challanno'] ?? '',
      challanNo1: json['challan_no1'] ?? '',
      siteName: json['sitename'] ?? '',
      vehicleNumber: json['vehiclenumber'] ?? '',
      lastAction: json['lastaction'] ?? '',
      driverName: json['drivername'] ?? '',
      moisture: json['moisture']?.toString() ?? '',
      receipt: json['reciept'] ?? '',
      uom: json['uom'] ?? '',
      driverMobile: json['drivermobile'] ?? '',
      orderStatus: json['orderstatus'] ?? '',
      contact: json['contact'] ?? '',
      mrnno: json['mrnno'] ?? '',
    );
  }
}

class CompleteMo {
  final int orderId;
  final String ponumber;
  final String vendorname;
  final int rdcgross;
  final int rdctare;
  final int rdcnet;
  final String itemname;
  final int netweight;
  final String mrnno;
  final String challanno;
  final String challanNo1;
  final String net1;
  final String sitename;
  final String vehiclenumber;
  final String lastaction;
  final String drivername;
  final String moisture;
  final String reciept;
  final String uom;
  final int acceptvy;
  final String drivermobile;
  final String contact;

  CompleteMo({
    required this.orderId,
    required this.ponumber,
    required this.vendorname,
    required this.rdcgross,
    required this.rdctare,
    required this.rdcnet,
    required this.itemname,
    required this.netweight,
    required this.mrnno,
    required this.challanno,
    required this.challanNo1,
    required this.net1,
    required this.sitename,
    required this.vehiclenumber,
    required this.lastaction,
    required this.drivername,
    required this.moisture,
    required this.reciept,
    required this.uom,
    required this.acceptvy,
    required this.drivermobile,
    required this.contact,
  });

  factory CompleteMo.fromJson(Map<String, dynamic> json) {
    return CompleteMo(
      orderId: json['orderid'] ?? 0,
      ponumber: json['ponumber'] ?? '',
      vendorname: json['vendorname'] ?? '',
      rdcgross: json['rdcgross'] ?? 0,
      rdctare: json['rdctare'] ?? 0,
      rdcnet: json['rdcnet'] ?? 0,
      itemname: json['itemname'] ?? '',
      netweight: json['netweight'] ?? 0,
      mrnno: json['mrnno'] ?? '',
      challanno: json['challanno'] ?? '',
      challanNo1: json['challan_no1'] ?? '',
      net1: json['net1'] ?? '',
      sitename: json['sitename'] ?? '',
      vehiclenumber: json['vehiclenumber'] ?? '',
      lastaction: json['lastaction'] ?? '',
      drivername: json['drivername'] ?? '',
      moisture: json['moisture']?.toString() ?? '',
      reciept: json['reciept'] ?? '',
      uom: json['uom'] ?? '',
      acceptvy: json['acceptvy'] ?? 0,
      drivermobile: json['drivermobile'] ?? '',
      contact: json['contact'] ?? '',
    );
  }
}

// class MaterialOfficerModel {
//   final int status;
//   final String message;
//   final int completeCounter;
//   final int activeCounter;
//   final int cancelCounter;
//   final List<ActiveMO> activeMO;
//   final List<CanceledMO> canceledMO;
//   final List<CompleteMo> completeMO;
//
//   MaterialOfficerModel({
//     required this.status,
//     required this.message,
//     required this.completeCounter,
//     required this.activeCounter,
//     required this.cancelCounter,
//     required this.activeMO,
//     required this.canceledMO,
//     required this.completeMO,
//   });
//
//   factory MaterialOfficerModel.fromJson(Map<String, dynamic> json) {
//     var activeMOList = json['activemo'] as List;
//     var canceledMOList = json['canceledmo'] as List;
//     var completeMOList = json['com0letemo'] as List;
//
//     return MaterialOfficerModel(
//       status: json['status'],
//       message: json['message'],
//       completeCounter: json['completecounter'],
//       activeCounter: json['activecounter'],
//       cancelCounter: json['cancelcounter'],
//       activeMO: activeMOList.map((i) => ActiveMO.fromJson(i)).toList(),
//       canceledMO: canceledMOList.map((i) => CanceledMO.fromJson(i)).toList(),
//       completeMO: completeMOList.map((i) => CompleteMo.fromJson(i)).toList(),
//       //completeMO: completeMOList.map((i) => CompleteMo.fromJson(i)).toList(),
//     //  completeMO: (json['com0letemo'] as List<dynamic>?)?.map((mompleteMo) => CompleteMo.fromJson(mompleteMo)).toList(),
//     );
//   }
// }
//
// class ActiveMO {
//   final int orderId;
//   final String poNumber;
//   final String vendorName;
//   final String grossWeight;
//   final String tareWeight;
//   final String itemName;
//   final String actionTime;
//   final String netWeight;
//   final String firstInvoice;
//   final String challanNo;
//   final String siteName;
//   final String vehicleNumber;
//   final String fileName;
//   final String lastAction;
//   final String driverName;
//   final String moisture;
//   final String receipt;
//   final String uom;
//   final String driverMobile;
//   final String orderStatus;
//   final String contact;
//
//   ActiveMO({
//     required this.orderId,
//     required this.poNumber,
//     required this.vendorName,
//     required this.grossWeight,
//     required this.tareWeight,
//     required this.itemName,
//     required this.actionTime,
//     required this.netWeight,
//     required this.firstInvoice,
//     required this.challanNo,
//     required this.siteName,
//     required this.vehicleNumber,
//     required this.fileName,
//     required this.lastAction,
//     required this.driverName,
//     required this.moisture,
//     required this.receipt,
//     required this.uom,
//     required this.driverMobile,
//     required this.orderStatus,
//     required this.contact,
//   });
//
//   factory ActiveMO.fromJson(Map<String, dynamic> json) {
//     return ActiveMO(
//       orderId: json['orderid'],
//       poNumber: json['ponumber'],
//       vendorName: json['vendorname'],
//       grossWeight: json['grossweight'],
//       tareWeight: json['tareweight'],
//       itemName: json['itemname'],
//       actionTime: json['actiontime'],
//       netWeight: json['netweight'],
//       firstInvoice: json['firstinvoice'],
//       challanNo: json['challanno'],
//       siteName: json['sitename'],
//       vehicleNumber: json['vehiclenumber'],
//       fileName: json['filename'],
//       lastAction: json['lastaction'],
//       driverName: json['drivername'],
//       moisture: json['moisture'],
//       receipt: json['reciept'],
//       uom: json['uom'],
//       driverMobile: json['drivermobile'],
//       orderStatus: json['orderstatus'],
//       contact: json['contact'],
//     );
//   }
// }
//
// class CanceledMO {
//   final int orderId;
//   final String poNumber;
//   final String vendorName;
//   final String grossWeight;
//   final String tareWeight;
//   final String itemName;
//   final String actionTime;
//   final String netWeight;
//   final String challanNo;
//   final String challan_no1;
//   final String siteName;
//   final String vehicleNumber;
//   final String lastAction;
//   final String driverName;
//   final String moisture;
//   final String receipt;
//   final String uom;
//   final String driverMobile;
//   final String orderStatus;
//   final String contact;
//
//   CanceledMO({
//     required this.orderId,
//     required this.poNumber,
//     required this.vendorName,
//     required this.grossWeight,
//     required this.tareWeight,
//     required this.itemName,
//     required this.actionTime,
//     required this.netWeight,
//     required this.challanNo,
//     required this.challan_no1,
//     required this.siteName,
//     required this.vehicleNumber,
//     required this.lastAction,
//     required this.driverName,
//     required this.moisture,
//     required this.receipt,
//     required this.uom,
//     required this.driverMobile,
//     required this.orderStatus,
//     required this.contact,
//   });
//
//   factory CanceledMO.fromJson(Map<String, dynamic> json) {
//     return CanceledMO(
//       orderId: json['orderid'],
//       poNumber: json['ponumber'],
//       vendorName: json['vendorname'],
//       grossWeight: json['grossweight'],
//       tareWeight: json['tareweight'],
//       itemName: json['itemname'],
//       actionTime: json['actiontime'],
//       netWeight: json['netweight'],
//       challanNo: json['challanno'],
//       challan_no1: json['challan_no1'],
//       siteName: json['sitename'],
//       vehicleNumber: json['vehiclenumber'],
//       lastAction: json['lastaction'],
//       driverName: json['drivername'],
//       moisture: json['moisture'],
//       receipt: json['reciept'],
//       uom: json['uom'],
//       driverMobile: json['drivermobile'],
//       orderStatus: json['orderstatus'],
//       contact: json['contact'],
//     );
//   }
// }
// class CompleteMo {
//   int orderId;
//   String ponumber;
//   String vendorname;
//   int rdcgross;
//   int rdctare;
//   int rdcnet;
//   String itemname;
//   int netweight;
//   String mrnno;
//   String challanno;
//   String  challan_no1;
//   String net1;
//   String sitename;
//   String vehiclenumber;
//   String lastaction;
//   String drivername;
//   String moisture;
//   String reciept;
//   String uom;
//   int acceptvy;
//   String drivermobile;
//
//   String contact;
//
//   CompleteMo({
//     required this.orderId,
//     required this.ponumber,
//     required this.vendorname,
//     required this.rdcgross,
//     required this.rdctare,
//     required this.rdcnet,
//     required this.itemname,
//     required this.netweight,
//     required this.mrnno,
//     required this.challanno,
//     required this. challan_no1,
//     required this.  net1,
//     required this.sitename,
//     required this.vehiclenumber,
//     required this.lastaction,
//     required this.drivername,
//     required this.moisture,
//     required this.reciept,
//     required this.uom,
//     required this.acceptvy,
//     required this.drivermobile,
//     required this.contact,
//   });
//
//   factory CompleteMo.fromJson(Map<String, dynamic> json) {
//     return CompleteMo(
//       orderId: json['orderid'] ?? 0,
//       ponumber: json['ponumber'] ?? "",
//       vendorname: json['vendorname'] ?? "",
//       rdcgross: json['rdcgross'] ?? 0,
//       rdctare: json['rdctare'] ?? 0,
//       rdcnet: json['rdcnet'] ?? 0,
//       itemname: json['itemname'] ?? "",
//       netweight: json['netweight']?? 0, // Handle int as String
//       mrnno: json['mrnno'] ?? "",
//       challanno: json['challanno'] ?? "",
//       challan_no1: json['challan_no1']?? "", // Converts null to an empty string
//       net1: json['net1'] ?? "",
//       sitename: json['sitename'] ?? "",
//       vehiclenumber: json['vehiclenumber'] ?? "",
//       lastaction: json['lastaction'] ?? "",
//       drivername: json['drivername'] ?? "",
//       moisture: json['moisture'].toString(), // Handle int as String
//       reciept: json['reciept'] ?? "",
//       uom: json['uom'] ?? "",
//       acceptvy: json['acceptvy'] ?? 0,
//       drivermobile: json['drivermobile'] ?? "",
//       contact: json['contact'] ?? "",
//     );
//   }
//
//
// }
//
