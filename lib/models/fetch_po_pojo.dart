class Fetchsitepolist {
  final int mappedCounter;
  final String upToDate;
  final int unmappedCounter;
  final List<Mapped> mapped;
  final List<Unmapped> unmapped;

  Fetchsitepolist({
    required this.mappedCounter,
    required this.upToDate,
    required this.unmappedCounter,
    required this.mapped,
    required this.unmapped,
  });

  factory Fetchsitepolist.fromJson(Map<String, dynamic> json) {
    var mappedList = json['mapped'] as List;
    var unmappedList = json['unmapped'] as List;

    return Fetchsitepolist(
      mappedCounter: json['mappedcounter'],
      upToDate: json['uptodate'],
      unmappedCounter: json['unmappedcounter'],
      mapped: mappedList.map((i) => Mapped.fromJson(i)).toList(),
      unmapped: unmappedList.map((i) => Unmapped.fromJson(i)).toList(),
    );
  }
}

class Mapped {
  final int ponumberId;
  final String ponumber;
  final String lineId;
  final String itemName;
  final String shipTo;
  final String billTo;
  final String issueQty;
  final String availableQty;
  final String vendorEmail;
  final String contactPerson;
  final String siteName;
  final int createdId;
  final String needByDt;
  final int vendorId;
  final String poCreationTime;
  final String uom;
  final String isMapped;
  final String mobile;
  final String vendorName;
  final int vendorSysId;

  Mapped({
    required this.ponumberId,
    required this.ponumber,
    required this.lineId,
    required this.itemName,
    required this.shipTo,
    required this.billTo,
    required this.issueQty,
    required this.availableQty,
    required this.vendorEmail,
    required this.contactPerson,
    required this.siteName,
    required this.createdId,
    required this.needByDt,
    required this.vendorId,
    required this.poCreationTime,
    required this.uom,
    required this.isMapped,
    required this.mobile,
    required this.vendorName,
    required this.vendorSysId,
  });

  factory Mapped.fromJson(Map<String, dynamic> json) {
    return Mapped(
      ponumberId: json['ponumberid'],
      ponumber: json['ponumber'],
      lineId: json['lineid'],
      itemName: json['itemname'],
      shipTo: json['shipto'],
      billTo: json['billto'],
      issueQty: json['isuueqty'],
      availableQty: json['availableqty'],
      vendorEmail: json['vendoremail'],
      contactPerson: json['contactperson'],
      siteName: json['sitename'],
      createdId: json['createdid'],
      needByDt: json['needbydt'],
      vendorId: json['vendorid'],
      poCreationTime: json['pocreationtime'],
      uom: json['UOM'],
      isMapped: json['ismapped'],
      mobile: json['mobile'],
      vendorName: json['vendorname'],
      vendorSysId: json['vendorsysid'],
    );
  }
}

class Unmapped {
  final int ponumberId;
  final String ponumber;
  final String lineId;
  final String itemName;
  final String shipTo;
  final String billTo;
  final String issueQty;
  final String availableQty;
  final String vendorEmail;
  final String? contactPerson; // Made nullable
  final String siteName;
  final int createdId;
  final String needByDt;
  final int vendorId;
  final String poCreationTime;
  final String uom;
  final String isMapped;
  final String vendorName;

  Unmapped({
    required this.ponumberId,
    required this.ponumber,
    required this.lineId,
    required this.itemName,
    required this.shipTo,
    required this.billTo,
    required this.issueQty,
    required this.availableQty,
    required this.vendorEmail,
    this.contactPerson, // Nullable
    required this.siteName,
    required this.createdId,
    required this.needByDt,
    required this.vendorId,
    required this.poCreationTime,
    required this.uom,
    required this.isMapped,
    required this.vendorName,
  });

  factory Unmapped.fromJson(Map<String, dynamic> json) {
    return Unmapped(
      ponumberId: json['ponumberid'] ?? 0,
      ponumber: json['ponumber'] ?? '',
      lineId: json['lineid'] ?? '',
      itemName: json['itemname'] ?? '',
      shipTo: json['shipto'] ?? '',
      billTo: json['billto'] ?? '',
      issueQty: json['isuueqty'] ?? '',
      availableQty: json['availableqty'] ?? '',
      vendorEmail: json['vendoremail'] ?? '',
      contactPerson: json['contactperson'], // Nullable
      siteName: json['sitename'] ?? '',
      createdId: json['createdid'] ?? 0,
      needByDt: json['needbydt'] ?? '',
      vendorId: json['vendorid'] ?? 0,
      poCreationTime: json['pocreationtime'] ?? '',
      uom: json['UOM'] ?? '',
      isMapped: json['ismapped'] ?? '',
      vendorName: json['vendorname'] ?? '',
    );
  }
}

// class Unmapped {
//   final int ponumberId;
//   final String ponumber;
//   final String lineId;
//   final String itemName;
//   final String shipTo;
//   final String billTo;
//   final String issueQty;
//   final String availableQty;
//   final String vendorEmail;
//   final String contactPerson;
//   final String siteName;
//   final int createdId;
//   final String needByDt;
//   final int vendorId;
//   final String poCreationTime;
//   final String uom;
//   final String isMapped;
//   final String vendorName;
//
//   Unmapped({
//     required this.ponumberId,
//     required this.ponumber,
//     required this.lineId,
//     required this.itemName,
//     required this.shipTo,
//     required this.billTo,
//     required this.issueQty,
//     required this.availableQty,
//     required this.vendorEmail,
//     required this.contactPerson,
//     required this.siteName,
//     required this.createdId,
//     required this.needByDt,
//     required this.vendorId,
//     required this.poCreationTime,
//     required this.uom,
//     required this.isMapped,
//     required this.vendorName,
//   });
//
//   factory Unmapped.fromJson(Map<String, dynamic> json) {
//     return Unmapped(
//       ponumberId: json['ponumberid'],
//       ponumber: json['ponumber'],
//       lineId: json['lineid'],
//       itemName: json['itemname'],
//       shipTo: json['shipto'],
//       billTo: json['billto'],
//       issueQty: json['isuueqty'],
//       availableQty: json['availableqty'],
//       vendorEmail: json['vendoremail'],
//       contactPerson: json['contactperson'],
//       siteName: json['sitename'],
//       createdId: json['createdid'],
//       needByDt: json['needbydt'],
//       vendorId: json['vendorid'],
//       poCreationTime: json['pocreationtime'],
//       uom: json['UOM'],
//       isMapped: json['ismapped'],
//       vendorName: json['vendorname'],
//     );
//   }
// }
