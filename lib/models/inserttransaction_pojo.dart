// class InsertTransaction {
//   String? createdAt;
//   String? driverId;
//   String? vendorId;
//   String? poId;
//   String? gross;
//   String? tare;
//   String? net;
//   String? mrnNo;
//   String? chalanNo;
//   String? royaltiPass;
//   String? vehicleNumber;
//   String? moisturePer;
//   String? acceptBy;
//   String? receipt;
//   String? vehicleCondition;
//   String? moistureCheck;
//   String? vEmail;
//   String? chalanNoOne;
//   String? netWeightOne;
//   String? withinVoice;
//   String? withinVoice1;
//   String? invoiceNumberOne;
//   String? invoiceNumberTwo;
//
//
//   InsertTransaction({
//     this.createdAt,
//     this.driverId,
//     this.vendorId,
//     this.poId,
//     this.gross,
//     this.tare,
//     this.net,
//     this.mrnNo,
//     this.chalanNo,
//     this.royaltiPass,
//     this.vehicleNumber,
//     this.moisturePer,
//     this.acceptBy,
//     this.receipt,
//     this.vehicleCondition,
//     this.moistureCheck,
//     this.vEmail,
//     this.chalanNoOne,
//     this.netWeightOne,
//     this.withinVoice,
//     this.withinVoice1,
//     this.invoiceNumberOne,
//     this.invoiceNumberTwo,
//   });
//
//   // Convert a InsertTransaction object into a Map object
//   Map<String, dynamic> toJson() {
//     return {
//       'createdat': createdAt,
//       'driverid': driverId,
//       'vendorid': vendorId,
//       'poid': poId,
//       'GROSS': gross,
//       'TARE': tare,
//       'NET': net,
//       'MRNNO': mrnNo,
//       'CHALANNO': chalanNo,
//       'ROYALTIPASS': royaltiPass,
//       'VEHICLENUMBER': vehicleNumber,
//       'MOISTUREPER': moisturePer,
//       'ACCEPTBY': acceptBy,
//       'recipt': receipt,
//       'VEHICLECONDITION': vehicleCondition,
//       'MOISTURECHECK': moistureCheck,
//       'VEmail': vEmail,
//       'challannoone': chalanNoOne,
//       'netweightone': netWeightOne,
//       'withinvoice': withinVoice,
//       'withinvoice1': withinVoice1,
//       'invoicenumberone': invoiceNumberOne,
//       'invoicenumbertwo': invoiceNumberTwo,
//     };
//   }
//
//   // Convert a Map object into a InsertTransaction object
//   factory InsertTransaction.fromJson(Map<String, dynamic> json) {
//     return InsertTransaction(
//       createdAt: json['createdat'],
//       driverId: json['driverid'],
//       vendorId: json['vendorid'],
//       poId: json['poid'],
//       gross: json['GROSS'],
//       tare: json['TARE'],
//       net: json['NET'],
//       mrnNo: json['MRNNO'],
//       chalanNo: json['CHALANNO'],
//       royaltiPass: json['ROYALTIPASS'],
//       vehicleNumber: json['VEHICLENUMBER'],
//       moisturePer: json['MOISTUREPER'],
//       acceptBy: json['ACCEPTBY'],
//       receipt: json['recipt'],
//       vehicleCondition: json['VEHICLECONDITION'],
//       moistureCheck: json['MOISTURECHECK'],
//       vEmail: json['VEmail'],
//       chalanNoOne: json['challannoone'],
//       netWeightOne: json['netweightone'],
//       withinVoice: json['withinvoice'],
//       withinVoice1: json['withinvoice1'],
//       invoiceNumberOne: json['invoicenumberone'],
//       invoiceNumberTwo: json['invoicenumbertwo'],
//     );
//   }
// }


class InsertTransaction {
  String? createdAt;
  String? driverId;
  String? vendorId;
  String? poId;
  String? gross;
  String? tare;
  String? net;
  String? mrnNo;
  String? chalanNo;
  String? royaltiPass;
  String? vehicleNumber;
  String? moisturePer;
  String? acceptBy;
  String? receipt;
  String? vehicleCondition;
  String? moistureCheck;
  String? vEmail;
  String? chalanNoOne;
  String? netWeightOne;
  String? withinVoice;
  String? withinVoice1;
  String? invoiceNumberOne;
  String? invoiceNumberTwo;

  // Base64 of the two invoices (empty if not uploaded)
  final String invoiceBase64One;
  final String invoiceBase64Two;

  InsertTransaction({
    this.createdAt,
    this.driverId,
    this.vendorId,
    this.poId,
    this.gross,
    this.tare,
    this.net,
    this.mrnNo,
    this.chalanNo,
    this.royaltiPass,
    this.vehicleNumber,
    this.moisturePer,
    this.acceptBy,
    this.receipt,
    this.vehicleCondition,
    this.moistureCheck,
    this.vEmail,
    this.chalanNoOne,
    this.netWeightOne,
    this.withinVoice,
    this.withinVoice1,
    this.invoiceNumberOne,
    this.invoiceNumberTwo,
    this.invoiceBase64One = '',
    this.invoiceBase64Two = '',
  });

  // Convert to JSON map for API payload
  Map<String, dynamic> toJson() {
    return {
      'createdat': createdAt,
      'driverid': driverId,
      'vendorid': vendorId,
      'poid': poId,
      'GROSS': gross,
      'TARE': tare,
      'NET': net,
      'MRNNO': mrnNo,
      'CHALANNO': chalanNo,
      'ROYALTIPASS': royaltiPass,
      'VEHICLENUMBER': vehicleNumber,
      'MOISTUREPER': moisturePer,
      'ACCEPTBY': acceptBy,
      'recipt': receipt,
      'VEHICLECONDITION': vehicleCondition,
      'MOISTURECHECK': moistureCheck,
      'VEmail': vEmail,
      'challannoone': chalanNoOne,
      'netweightone': netWeightOne,
      'withinvoice': withinVoice,
      'withinvoice1': withinVoice1,
      'invoicenumberone': invoiceNumberOne,
      'invoicenumbertwo': invoiceNumberTwo,
      'invoiceBase64One': invoiceBase64One,     // ← Full Base64 of first PDF
      'invoiceBase64Two': invoiceBase64Two,     // ← Full Base64 of second PDF
    };
  }

  // Optional: Parse from server response (you may not need Base64 back)
  factory InsertTransaction.fromJson(Map<String, dynamic> json) {
    return InsertTransaction(
      createdAt: json['createdat'] as String?,
      driverId: json['driverid'] as String?,
      vendorId: json['vendorid'] as String?,
      poId: json['poid'] as String?,
      gross: json['GROSS'] as String?,
      tare: json['TARE'] as String?,
      net: json['NET'] as String?,
      mrnNo: json['MRNNO'] as String?,
      chalanNo: json['CHALANNO'] as String?,
      royaltiPass: json['ROYALTIPASS'] as String?,
      vehicleNumber: json['VEHICLENUMBER'] as String?,
      moisturePer: json['MOISTUREPER'] as String?,
      acceptBy: json['ACCEPTBY'] as String?,
      receipt: json['recipt'] as String?,
      vehicleCondition: json['VEHICLECONDITION'] as String?,
      moistureCheck: json['MOISTURECHECK'] as String?,
      vEmail: json['VEmail'] as String?,
      chalanNoOne: json['challannoone'] as String?,
      netWeightOne: json['netweightone'] as String?,
      withinVoice: json['withinvoice'] as String?,
      withinVoice1: json['withinvoice1'] as String?,
      invoiceNumberOne: json['invoicenumberone'] as String?,
      invoiceNumberTwo: json['invoicenumbertwo'] as String?,
      invoiceBase64One: json['invoiceBase64One'] as String? ?? '',
      invoiceBase64Two: json['invoiceBase64Two'] as String? ?? '',
    );
  }
}