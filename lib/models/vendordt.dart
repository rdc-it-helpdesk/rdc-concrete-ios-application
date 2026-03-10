//
// class Vendordt {
//   final int status; // Change to int
//   final String vendorname;
//   final int vendorid; // Change to int
//   final String vendoremail;
//   final String vendorlocation;
//   final String contactperson;
//   final String vendormobile;
//   final List<PO> po;
//
//   Vendordt({
//     required this.status,
//     required this.vendorname,
//     required this.vendorid,
//     required this.vendoremail,
//     required this.vendorlocation,
//     required this.contactperson,
//     required this.vendormobile,
//     required this.po,
//   });
//
//   factory Vendordt.fromJson(Map<String, dynamic> json) {
//     var poList = json['po'] as List;
//     List<PO> poItems = poList.map((i) => PO.fromJson(i)).toList();
//
//     return Vendordt(
//       status: json['status'], // Add status
//       vendorname: json['vendorname'],
//       vendorid: json['vendorid'], // Change to int
//       vendoremail: json['vendoremail'],
//       vendorlocation: json['vendorlocation'],
//       contactperson: json['contactperson'],
//       vendormobile: json['vendormobile'],
//       po: poItems,
//     );
//   }
// }
// class PO {
//   final String vemail;
//   final int ponumberid; // Change to int
//   final String ponumber;
//   final String lineid;
//   final String itemname;
//   final String shipto;
//   final String billto;
//   final String isuueqty;
//   final String availableqty;
//   final String sitename;
//   final int createdid; // Change to int
//   final String needbydt;
//   final String pocreationtime;
//   final String unitPrice;
//
//   PO({
//     required this.vemail,
//     required this.ponumberid, // Change to int
//     required this.ponumber,
//     required this.lineid,
//     required this.itemname,
//     required this.shipto,
//     required this.billto,
//     required this.isuueqty,
//     required this.availableqty,
//     required this.sitename,
//     required this.createdid, // Change to int
//     required this.needbydt,
//     required this.pocreationtime,
//     required this.unitPrice,
//   });
//
//   factory PO.fromJson(Map<String, dynamic> json) {
//     return PO(
//       vemail: json['vemail'],
//       ponumberid: json['ponumberid'], // Change to int
//       ponumber: json['ponumber'],
//       lineid: json['lineid'],
//       itemname: json['itemname'],
//       shipto: json['shipto'],
//       billto: json['billto'],
//       isuueqty: json['isuueqty'],
//       availableqty: json['availableqty'],
//       sitename: json['sitename'],
//       createdid: json['createdid'], // Change to int
//       needbydt: json['needbydt'],
//       pocreationtime: json['pocreationtime'],
//       unitPrice: json['unit_price'].toString(), // Ensure it's a string
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'vemail': vemail,
//       'ponumberid': ponumberid,
//       'ponumber': ponumber,
//       'lineid': lineid,
//       'itemname': itemname,
//       'shipto': shipto,
//       'billto': billto,
//       'isuueqty': isuueqty,
//       'availableqty': availableqty,
//       'sitename': sitename,
//       'createdid': createdid,
//       'needbydt': needbydt,
//       'pocreationtime': pocreationtime,
//       'unit_price': unitPrice,
//     };
//   }
// }
// class Vendordt {
//   final int status;
//   final String vendorname;
//   final int vendorid;
//   final String vendoremail;
//   final String vendorlocation;
//   final String contactperson;
//   final String vendormobile;
//   final String checkAttempt;
//   final String message;
//   final String locid;
//   final List<PO> po;
//
//   Vendordt({
//     required this.status,
//     required this.vendorid,
//     required this.vendorname,
//     required this.checkAttempt,
//     required this.message,
//     required this.locid,
//     required this.vendoremail,
//     required this.vendorlocation,
//     required this.contactperson,
//     required this.vendormobile,
//     required this.po,
//   });
//
//   // factory Vendordt.fromJson(Map<String, dynamic> json) {
//   //   var poList = json['po'] as List;
//   //   List<PO> poItems = poList.map((i) => PO.fromJson(i)).toList();
//   //
//   //   return Vendordt(
//   //     status: json['status'],
//   //     vendorname: json['vendorname'],
//   //     vendorid: json['vendorid'],
//   //     vendoremail: json['vendoremail'],
//   //     vendorlocation: json['vendorlocation'],
//   //     contactperson: json['contactperson'],
//   //     vendormobile: json['vendormobile'],
//   //     po: poItems,
//   //   );
//   // }
//   factory Vendordt.fromJson(Map<String, dynamic> json) {
//     var poList = json['po'] as List;
//     print('PO List: $poList'); // Debugging line
//
//     List<PO> poItems = [];
//     try {
//       poItems = poList.map((item) {
//         print('Current item: $item'); // Debugging line
//         if (item is Map<String, dynamic>) {
//           return PO.fromJson(item);
//         } else {
//           throw Exception('Invalid PO item: $item');
//         }
//       }).toList();
//     } catch (e) {
//       print('Error parsing PO items: $e');
//       throw e; // Rethrow or handle as needed
//     }
//
//     return Vendordt(
//       status: json['status'],
//       locid: json['locid'],
//       message: json['message'],
//       checkAttempt: json['checkAttempt'],
//       vendorname: json['vendorname'],
//       vendorid: json['vendorid'],
//       vendoremail: json['vendoremail'],
//       vendorlocation: json['vendorlocation'],
//       contactperson: json['contactperson'],
//       vendormobile: json['vendormobile'],
//       po: poItems,
//     );
//   }
// }
// class PO {
//   final String vemail;
//   final int ponumberid;
//   final String ponumber;
//   final String lineid;
//   final String itemname;
//   final String shipto;
//   final String billto;
//   final String isuueqty;
//   final String availableqty;
//   final String sitename;
//   final int createdid;
//   final String needbydt;
//   final String pocreationtime;
//   final String unitPrice;
//
//   PO({
//     required this.vemail,
//     required this.ponumberid,
//     required this.ponumber,
//     required this.lineid,
//     required this.itemname,
//     required this.shipto,
//     required this.billto,
//     required this.isuueqty,
//     required this.availableqty,
//     required this.sitename,
//     required this.createdid,
//     required this.needbydt,
//     required this.pocreationtime,
//     required this.unitPrice,
//   });
//
//   factory PO.fromJson(Map<String, dynamic> json) {
//     return PO(
//       vemail: json['vemail'],
//       ponumberid: json['ponumberid'],
//       ponumber: json['ponumber'],
//       lineid: json['lineid'],
//       itemname: json['itemname'],
//       shipto: json['shipto'],
//       billto: json['billto'],
//       isuueqty: json['isuueqty'],
//       availableqty: json['availableqty'],
//       sitename: json['sitename'],
//       createdid: json['createdid'],
//       needbydt: json['needbydt'],
//       pocreationtime: json['pocreationtime'],
//       unitPrice: json['unit_price'].toString(), // Ensure this is correct
//     );
//   }
// }
// class Vendordt {
//   final int status;
//   final String vendorname;
//   final int vendorid;
//   final String vendoremail;
//   final String vendorlocation;
//   final String contactperson;
//   final String vendormobile;
//   final String checkAttempt;
//   final String message;
//   final int locid; // Change to int
//   final List<PO> po;
//
//   Vendordt({
//     required this.status,
//     required this.vendorid,
//     required this.vendorname,
//     required this.checkAttempt,
//     required this.message,
//     required this.locid, // Change to int
//     required this.vendoremail,
//     required this.vendorlocation,
//     required this.contactperson,
//     required this.vendormobile,
//     required this.po,
//   });
//
//   factory Vendordt.fromJson(Map<String, dynamic> json) {
//     var poList = json['polist'] as List? ?? []; // Handle null case
//     List<PO> poItems = poList.map((item) {
//       if (item is Map<String, dynamic>) {
//         return PO.fromJson(item);
//       } else {
//         throw Exception('Invalid PO item: $item');
//       }
//     }).toList();
//
//     return Vendordt(
//       status: json['status'],
//       locid: json['locid'], // Ensure this is an int
//       message: json['message'] ?? '', // Handle null case
//       checkAttempt: json['checkattempt'] ?? '', // Handle null case
//       vendorname: json['vendorname']?? '',
//       vendorid: json['vendorid']?? '', // Ensure this is an int
//       vendoremail: json['vendoremail']?? '',
//       vendorlocation: json['vendorlocation']?? '',
//       contactperson: json['contactperson']?? '',
//       vendormobile: json['vendormobile']?? '',
//       po: poItems,
//     );
//   }
// }
//
// class PO {
//   final String vemail;
//   final int ponumberid; // Ensure this is an int
//   final String ponumber;
//   final String lineid;
//   final String itemname;
//   final String shipto;
//   final String billto;
//   final String isuueqty;
//   final String availableqty;
//   final String sitename;
//   final int createdid; // Ensure this is an int
//   final String needbydt;
//   final String pocreationtime;
//   final String unitPrice; // Ensure this is a String
//
//   PO({
//     required this.vemail,
//     required this.ponumberid, // Ensure this is an int
//     required this.ponumber,
//     required this.lineid,
//     required this.itemname,
//     required this.shipto,
//     required this.billto,
//     required this.isuueqty,
//     required this.availableqty,
//     required this.sitename,
//     required this.createdid, // Ensure this is an int
//     required this.needbydt,
//     required this.pocreationtime,
//     required this.unitPrice,
//   });
//
//   factory PO.fromJson(Map<String, dynamic> json) {
//     return PO(
//       vemail: json['vemail'],
//       ponumberid: json['ponumberid'], // Ensure this is an int
//       ponumber: json['ponumber'],
//       lineid: json['lineid'],
//       itemname: json['itemname'],
//       shipto: json['shipto'],
//       billto: json['billto'],
//       isuueqty: json['isuueqty'],
//       availableqty: json['availableqty'],
//       sitename: json['sitename'],
//       createdid: json['createdid'], // Ensure this is an int
//       needbydt: json['needbydt'],
//       pocreationtime: json['pocreationtime'],
//       unitPrice: json['unit_price']?.toString() ?? '0', // Ensure it's a string and handle null
//     );
//   }
// }

class Vendordt {
  final int status;
  final String vendorname;
  final int vendorid;
  final String vendoremail;
  final String vendorlocation;
  final String contactperson;
  final String vendormobile;
  final String checkAttempt;
  final String message;
  final int locid; // Ensure this is an int
  final List<PO> po;

  Vendordt({
    required this.status,
    required this.vendorid,
    required this.vendorname,
    required this.checkAttempt,
    required this.message,
    required this.locid,
    required this.vendoremail,
    required this.vendorlocation,
    required this.contactperson,
    required this.vendormobile,
    required this.po,
  });

  factory Vendordt.fromJson(Map<String, dynamic> json) {
    var poList = json['po'] as List? ?? []; // Handle null case
    List<PO> poItems =
        poList.map((item) {
          if (item is Map<String, dynamic>) {
            return PO.fromJson(item);
          } else {
            throw Exception('Invalid PO item: $item');
          }
        }).toList();

    return Vendordt(
      status: json['status'] as int, // Ensure this is an int
      locid: json['locid'] as int? ?? 0, // Provide a default value if null
      message: json['message'] ?? '', // Handle null case
      checkAttempt: json['checkattempt'] ?? '', // Handle null case
      vendorname: json['vendorname'] ?? '',
      vendorid:
          json['vendorid'] as int? ?? 0, // Provide a default value if null
      vendoremail: json['vendoremail'] ?? '',
      vendorlocation: json['vendorlocation'] ?? '',
      contactperson: json['contactperson'] ?? '',
      vendormobile: json['vendormobile'] ?? '',
      po: poItems,
    );
  }
}

class PO {
  final String vemail;
  final int ponumberid; // Ensure this is an int
  final String ponumber;
  final String lineid;
  final String itemname;
  final String shipto;
  final String billto;
  final String isuueqty;
  final String availableqty;
  final String sitename;
  final int createdid; // Ensure this is an int
  final String needbydt;
  final String pocreationtime;
  final String unitPrice; // Ensure this is a String

  PO({
    required this.vemail,
    required this.ponumberid,
    required this.ponumber,
    required this.lineid,
    required this.itemname,
    required this.shipto,
    required this.billto,
    required this.isuueqty,
    required this.availableqty,
    required this.sitename,
    required this.createdid,
    required this.needbydt,
    required this.pocreationtime,
    required this.unitPrice,
  });

  factory PO.fromJson(Map<String, dynamic> json) {
    return PO(
      vemail: json['vemail'] ?? '', // Provide a default value if null
      ponumberid:
          json['ponumberid'] as int? ?? 0, // Provide a default value if null
      ponumber: json['ponumber'] ?? '',
      lineid: json['lineid'] ?? '',
      itemname: json['itemname'] ?? '',
      shipto: json['shipto'] ?? '',
      billto: json['billto'] ?? '',
      isuueqty: json['isuueqty'] ?? '',
      availableqty: json['availableqty'] ?? '',
      sitename: json['sitename'] ?? '',
      createdid:
          json['createdid'] as int? ?? 0, // Provide a default value if null
      needbydt: json['needbydt'] ?? '',
      pocreationtime: json['pocreationtime'] ?? '',
      unitPrice:
          json['unit_price']?.toString() ??
          '0', // Ensure it's a string and handle null
    );
  }
}
