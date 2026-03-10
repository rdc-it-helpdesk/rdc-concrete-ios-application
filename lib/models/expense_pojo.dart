class Expense {
  final int? id;
  final String? itemName;
  final String? itemCode;
  final String? price;
  final String? uom;
  final String? qty;
  final String? taxCategory;
  final String? invoicefilelocation;

  Expense({
    required this.id,
    required this.itemName,
    required this.itemCode,
    required this.price,
    required this.uom,
    required this.qty,
    required this.taxCategory,
    required this.invoicefilelocation,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json["id"] as int?,
      itemName: json["item_name"] as String?,
      itemCode: json["item_code"] as String?,
      price: json["price"] as String?,
      uom: json["uom"] as String?,
      qty: json["qty"] as String?,
      taxCategory: json["tax_category"] as String?,
      invoicefilelocation: json["invoicefilelocation"] as String?,
    );
  }
}