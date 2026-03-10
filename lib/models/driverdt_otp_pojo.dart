class DriverDT {
  final int status;
  final  String drivername;
  final int driverid;
  final int completecounter;
  final int activecounter;
  final int pendingcounter;
  final int cancelcounter;
  final List<Complete>? complete;
  final List<Cancel>? cancel;
  final List<Active>? active;
  final List<Pending>? pending;

  DriverDT({
    required this.status,
    required this.drivername,
    required this.driverid,
    required this.completecounter,
    required this.activecounter,
    required this.pendingcounter,
    required this.cancelcounter,
    this.complete,
    this.cancel,
    this.active,
    this.pending,
  });

  factory DriverDT.fromJson(Map<String, dynamic> json) {
    // var completeList = json['complete'] as List? ?? [];
    // var cancelList = json['cancel'] as List? ?? [];
    // var activeList = json['active'] as List? ?? [];
    // var pendingList = json['pending'] as List? ?? [];

    return DriverDT(
      status: json['status']?? 0,
      drivername: json['drivername']?? '',
      driverid: json['driverid'] ?? 0, // Ensure this is an int
      completecounter: json['completecounter']?? 0,
      activecounter: json['activecounter']?? 0,
      pendingcounter: json['pendingcounter']?? 0,
      cancelcounter: json['cancelcounter']?? 0,
      complete:
          (json['complete'] as List<dynamic>?)
              ?.map((item) => Complete.fromJson(item))
              .toList() ??
          [],
      cancel:
          (json['cancel'] as List<dynamic>?)
              ?.map((item) => Cancel.fromJson(item))
              .toList() ??
          [],
      active:
          (json['active'] as List<dynamic>?)
              ?.map((item) => Active.fromJson(item))
              .toList() ??
          [],
      pending:
          (json['pending'] as List<dynamic>?)
              ?.map((item) => Pending.fromJson(item))
              .toList() ??
          [],
      // complete: completeList.map((i) => Complete.fromJson(i)).toList(),
      // cancel: cancelList.map((i) => Cancel.fromJson(i)).toList(),
      // active: activeList.map((i) => Active.fromJson(i)).toList(),
      // pending: pendingList.map((i) => Pending.fromJson(i)).toList(),
    );
  }


}

class Active {
  int orderid;
  String vendormobile;
  String drivermobile;
  String ponumber;
  String vendorname;
  String grossweight;
  String tareweight;
  String itemname;
  String actiontime;
  String challanno;
  String sitename;
  String vehiclenumber;
  String creationtime;
  String vendoremail;

  Active({
    required this.orderid,
    required this.vendormobile,
    required this.drivermobile,
    required this.ponumber,
    required this.vendorname,
    required this.grossweight,
    required this.tareweight,
    required this.itemname,
    required this.actiontime,
    required this.challanno,
    required this.sitename,
    required this.vehiclenumber,
    required this.creationtime,
    required this.vendoremail,
  });

  factory Active.fromJson(Map<String, dynamic> json) {
    return Active(
      orderid: json['orderid'] ?? 0,
      vendormobile: json['vendormobile'] ?? '',
      drivermobile: json['drivermobile'] ?? '',
      ponumber: json['ponumber'] ?? '',
      vendorname: json['vendorname'] ?? '',
      grossweight: json['grossweight']?.toString() ?? '',
      tareweight: json['tareweight'] ?.toString() ??'',
      itemname: json['itemname'] ?? '',
      actiontime: json['actiontime'] ?? '',
      challanno: json['challanno'] ?? '',
      sitename: json['sitename'] ?? '',
      vehiclenumber: json['vehiclenumber'] ?? '',
      creationtime: json['creationtime'] ?? '',
      vendoremail: json['vendoremail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderid': orderid,
      'vendormobile': vendormobile,
      'drivermobile': drivermobile,
      'ponumber': ponumber,
      'vendorname': vendorname,
      'grossweight': grossweight,
      'tareweight': tareweight,
      'itemname': itemname,
      'actiontime': actiontime,
      'challanno': challanno,
      'sitename': sitename,
      'vehiclenumber': vehiclenumber,
      'creationtime': creationtime,
      'vendoremail': vendoremail,
    };
  }
}

class Cancel {
  String vendormobile;
  String drivermobile;
  int orderid;
  String ponumber;
  String vendorname;
  String grossweight;
  String tareweight;
  String itemname;
  String actiontime;
  String challanno;
  String sitename;
  String vehiclenumber;
  String creationtime;
  String vendoremail;

  Cancel({
    required this.vendormobile,
    required this.drivermobile,
    required this.orderid,
    required this.ponumber,
    required this.vendorname,
    required this.grossweight,
    required this.tareweight,
    required this.itemname,
    required this.actiontime,
    required this.challanno,
    required this.sitename,
    required this.vehiclenumber,
    required this.creationtime,
    required this.vendoremail,
  });

  factory Cancel.fromJson(Map<String, dynamic> json) {
    return Cancel(
      vendormobile: json['vendormobile'] ?? '',
      drivermobile: json['drivermobile'] ?? '',
      orderid: json['orderid'] ?? 0,
      ponumber: json['ponumber'] ?? '',
      vendorname: json['vendorname'] ?? '',
      grossweight: json['grossweight'] ?.toString() ?? '',
      tareweight: json['tareweight'] ?.toString() ?? '',
      itemname: json['itemname'] ?? '',
      actiontime: json['actiontime'] ?? '',
      challanno: json['challanno'] ?? '',
      sitename: json['sitename'] ?? '',
      vehiclenumber: json['vehiclenumber'] ?? '',
      creationtime: json['creationtime'] ?? '',
      vendoremail: json['vendoremail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendormobile': vendormobile,
      'drivermobile': drivermobile,
      'orderid': orderid,
      'ponumber': ponumber,
      'vendorname': vendorname,
      'grossweight': grossweight,
      'tareweight': tareweight,
      'itemname': itemname,
      'actiontime': actiontime,
      'challanno': challanno,
      'sitename': sitename,
      'vehiclenumber': vehiclenumber,
      'creationtime': creationtime,
      'vendoremail': vendoremail,
    };
  }
}

class Complete {
  int orderid;
  String ponumber;
  String vendorname;
  String grossweight;
  String tareweight;
  String actiontime;
  String itemname;
  String netweight;
  String challanno;
  String sitename;
  String vehiclenumber;
  String creationtime;
  String vendoremail;
  String rdcnetweight;

  Complete({
    required this.orderid,
    required this.ponumber,
    required this.vendorname,
    required this.grossweight,
    required this.tareweight,
    required this.actiontime,
    required this.itemname,
    required this.netweight,
    required this.challanno,
    required this.sitename,
    required this.vehiclenumber,
    required this.creationtime,
    required this.vendoremail,
    required this.rdcnetweight,
  });

  factory Complete.fromJson(Map<String, dynamic> json) {
    return Complete(
      orderid: json['orderid'] ?? 0, // Default to 0 if not present
      ponumber: json['ponumber'] ?? '',
      vendorname: json['vendorname'] ?? '',
      grossweight: json['grossweight'] ?.toString() ?? '',
      tareweight: json['tareweight'] ?.toString() ??'',
      actiontime: json['actiontime'] ?? '',
      itemname: json['itemname'] ?? '',
      netweight: json['netweight'] ?? '',
      challanno: json['challanno'] ?? '',
      sitename: json['sitename'] ?? '',
      vehiclenumber: json['vehiclenumber'] ?? '',
      creationtime: json['creationtime'] ?? '',
      vendoremail: json['vendoremail'] ?? '',
      rdcnetweight: json['rdcnetweight'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderid': orderid,
      'ponumber': ponumber,
      'vendorname': vendorname,
      'grossweight': grossweight,
      'tareweight': tareweight,
      'actiontime': actiontime,
      'itemname': itemname,
      'netweight': netweight,
      'challanno': challanno,
      'sitename': sitename,
      'vehiclenumber': vehiclenumber,
      'creationtime': creationtime,
      'vendoremail': vendoremail,
      'rdcnetweight': rdcnetweight,
    };
  }
}

class Pending {
  int orderid;
  String ponumber;
  String vendormobile;
  String drivermobile;
  String vendorname;
  String grossweight;
  String tareweight;
  String itemname;
  String netweight;
  String actiontime;
  String challanno;
  String sitename;
  String vehiclenumber;
  String creationtime;
  String vendoremail;

  Pending({
    required this.orderid,
    required this.ponumber,
    required this.vendormobile,
    required this.drivermobile,
    required this.vendorname,
    required this.grossweight,
    required this.tareweight,
    required this.itemname,
    required this.netweight,
    required this.actiontime,
    required this.challanno,
    required this.sitename,
    required this.vehiclenumber,
    required this.creationtime,
    required this.vendoremail,
  });

  factory Pending.fromJson(Map<String, dynamic> json) {
    return Pending(
      orderid: json['orderid'] ?? 0,
      ponumber: json['ponumber'] ?? '',
      vendormobile: json['vendormobile'] ?? '',
      drivermobile: json['drivermobile'] ?? '',
      vendorname: json['vendorname'] ?? '',
      grossweight: json['grossweight'] ?.toString() ?? '',
      tareweight: json['tareweight'] ?.toString() ?? '',
      itemname: json['itemname'] ?? '',
      netweight: json['netweight'] ?? '',
      actiontime: json['actiontime'] ?? '',
      challanno: json['challanno'] ?? '',
      sitename: json['sitename'] ?? '',
      vehiclenumber: json['vehiclenumber'] ?? '',
      creationtime: json['creationtime'] ?? '',
      vendoremail: json['vendoremail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderid': orderid,
      'ponumber': ponumber,
      'vendormobile': vendormobile,
      'drivermobile': drivermobile,
      'vendorname': vendorname,
      'grossweight': grossweight,
      'tareweight': tareweight,
      'itemname': itemname,
      'netweight': netweight,
      'actiontime': actiontime,
      'challanno': challanno,
      'sitename': sitename,
      'vehiclenumber': vehiclenumber,
      'creationtime': creationtime,
      'vendoremail': vendoremail,
    };
  }
}
