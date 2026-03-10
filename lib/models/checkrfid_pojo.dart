class CheckRfid {
  final String status;
  final String secondcheck;
  final String rfid;
  final String rfid1;
  final String rfid2;

  CheckRfid({
    required this.status,
    required this.secondcheck,
    required this.rfid,
    required this.rfid1,
    required this.rfid2,
  });

  factory CheckRfid.fromJson(Map<String, dynamic> json) {
    return CheckRfid(
      status: json['status'] ?? '',
      secondcheck: json['secondcheck'] ?? '',
      rfid: json['rfid'] ?? '',
      rfid1: json['rfid1'] ?? '',
      rfid2: json['rfid2'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'secondcheck': secondcheck,
      'rfid': rfid,
      'rfid1': rfid1,
      'rfid2': rfid2,
    };
  }
}
