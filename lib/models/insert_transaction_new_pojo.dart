// models/insert_transaction_new.dart

class InsertTransactionNew {
  final String? billTo;
  final String? shipTo;
  final String? needBy;
  final int? vId;
  final String? apSegment1;
  final String? invoiceBase64;
  final String? invoiceNumber;
  final String? invoiceDate;
  final List<ItemMaterial>? items;

  InsertTransactionNew({
    required this.billTo,
    required this.shipTo,
    required this.needBy,
    required this.vId,
    required this.apSegment1,
    required this.invoiceBase64,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.items,
  });

  factory InsertTransactionNew.fromJson(Map<String, dynamic> json) {
    return InsertTransactionNew(
      billTo: json["bill_to"] as String?,
      shipTo: json["ship_to"] as String?,
      needBy: json["need_by"] as String?,
      vId: json["v_id"] as int?,
      apSegment1: json["AP_SEGMENT1"] as String?,
      invoiceBase64: json["invoice_base64"] as String?,
      invoiceNumber: json["invoice_number"] as String?,
      invoiceDate: json["invoice_date"] as String?,
      items: (json["items"] as List<dynamic>?)
          ?.map((e) => ItemMaterial.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // ADD THIS: Required for @Body POST
  Map<String, dynamic> toJson() {
    return {
      "bill_to": billTo,
      "ship_to": shipTo,
      "need_by": needBy,
      "v_id": vId,
      "AP_SEGMENT1": apSegment1,
      "invoice_base64": invoiceBase64,
      "invoice_number": invoiceNumber,
      "invoice_date": invoiceDate,
      "items": items?.map((e) => e.toJson()).toList(),
    }..removeWhere((key, value) => value == null); // Clean nulls
  }
}

class ItemMaterial {
  final String? itemCode;
  final String? itemName;
  final String? quantity;
  final String? unitPrice;
  final String? lineTotal;

  ItemMaterial({
    required this.itemCode,
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
  });

  factory ItemMaterial.fromJson(Map<String, dynamic> json) {
    return ItemMaterial(
      itemCode: json["item_code"] as String?,
      itemName: json["item_name"] as String?,
      quantity: json["quantity"] as String?,
      unitPrice: json["unit_price"] as String?,
      lineTotal: json["line_total"] as String?,
    );
  }

  // ADD THIS: Required for nested toJson()
  Map<String, dynamic> toJson() {
    return {
      "item_code": itemCode,
      "item_name": itemName,
      "quantity": quantity,
      "unit_price": unitPrice,
      "line_total": lineTotal,
    }..removeWhere((key, value) => value == null);
  }
}