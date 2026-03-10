import 'expense_pojo.dart';

class PurchaseOrder {
  final int? id;
  final String? shipTo;
  final String? billTo;
  final String? status;
  final String? contactPerson;
  final CreationDate? creationDateWrapper;
  final List<Expense>? expenseAndSpares;

  // Transient field (computed)
  DateTime? get creationDate {
    if (creationDateWrapper?.date == null) return null;
    try {
      return DateTime.parse(creationDateWrapper!.date!.replaceFirst(' ', 'T')); // Adjust format if needed
    } catch (e) {
      return null;
    }
  }

  PurchaseOrder({
    required this.id,
    required this.shipTo,
    required this.billTo,
    required this.status,
    required this.contactPerson,
    required this.creationDateWrapper,
    required this.expenseAndSpares,
  });

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) {
    return PurchaseOrder(
      id: json["ID"] as int?,
      shipTo: json["SHIP_TO"] as String?,
      billTo: json["BILL_TO"] as String?,
      status: json["Status"] as String?,
      contactPerson: json["CONTACT_PERSON"] as String?,
      creationDateWrapper: json["CREATION_DATE"] == null
          ? null
          : CreationDate.fromJson(json["CREATION_DATE"] as Map<String, dynamic>),
      expenseAndSpares: (json["expense_and_spares"] as List<dynamic>?)
          ?.map((e) => Expense.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CreationDate {
  final String? date;

  CreationDate({
    required this.date,
  });

  factory CreationDate.fromJson(Map<String, dynamic> json) {
    return CreationDate(
      date: json["date"] as String?,
    );
  }
}

