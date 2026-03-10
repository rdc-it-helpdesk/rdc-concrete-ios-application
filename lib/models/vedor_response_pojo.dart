class VendorResponse {
  final String? status;
  final int? count;
  final List<Vendor>? data;

  VendorResponse({
    required this.status,
    required this.count,
    required this.data,
  });

  factory VendorResponse.fromJson(Map<String, dynamic> json) {
    return VendorResponse(
      status: json["status"] as String?,
      count: json["count"] as int?,
      data: (json["data"] as List<dynamic>?)
          ?.map((e) => Vendor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Vendor {
  final int? vendorId;
  final String? userFullname;
  final String? apSegment1;

  Vendor({
    required this.vendorId,
    required this.userFullname,
    required this.apSegment1,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      vendorId: json["vendor_id"] as int?,
      userFullname: json["user_fullname"] as String?,
      apSegment1: json["AP_SEGMENT1"] as String?,
    );
  }

  @override
  String toString() {
    return apSegment1 ?? '';
  }
}