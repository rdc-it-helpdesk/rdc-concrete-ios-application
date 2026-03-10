class OrderInfo {
  final String? toAddress;
  final String? noOfPkg;
  final String? totalAmount;
  final String? partyName;
  final String? partyMobile;
  final List<Order>? orders;

  OrderInfo({
    required this.toAddress,
    required this.noOfPkg,
    required this.totalAmount,
    required this.partyName,
    required this.partyMobile,
    required this.orders,
  });

  factory OrderInfo.fromJson(Map<String, dynamic> json) {
    return OrderInfo(
      toAddress: json["to_address"] as String?,
      noOfPkg: json["no_of_pkg"] as String?,
      totalAmount: json["total_amount"] as String?,
      partyName: json["party_name"] as String?,
      partyMobile: json["party_mobile"] as String?,
      orders: (json["orders"] as List<dynamic>?)
          ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Order {
  final String? orderId;
  final String? formLocation;
  final String? volume;
  final String? boxType;
  final String? weight;
  final String? itemName;
  final String? acceptTime;
  final String? imageByte;

  Order({
    required this.orderId,
    required this.formLocation,
    required this.volume,
    required this.boxType,
    required this.weight,
    required this.itemName,
    required this.acceptTime,
    required this.imageByte,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json["order_id"] as String?,
      formLocation: json["form_location"] as String?,
      volume: json["volume"] as String?,
      boxType: json["box_type"] as String?,
      weight: json["weight"] as String?,
      itemName: json["item_name"] as String?,
      acceptTime: json["accept_time"] as String?,
      imageByte: json["image_byte"] as String?,
    );
  }
}