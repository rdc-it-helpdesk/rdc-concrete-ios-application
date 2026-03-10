import 'package:rdc_concrete/models/purchase_order_pojo.dart';

class POResponse {
  final int? page;
  final List<PurchaseOrder>? poDetails;

  POResponse({
    required this.page,
    required this.poDetails,
  });

  factory POResponse.fromJson(Map<String, dynamic> json) {
    return POResponse(
      page: json["page"] as int?,
      poDetails: (json["po_details"] as List<dynamic>?)
          ?.map((e) => PurchaseOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}