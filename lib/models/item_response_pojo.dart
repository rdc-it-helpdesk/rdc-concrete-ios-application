class ItemResponse {
  final String? sitecode;
  final List<Item>? items;

  ItemResponse({
    required this.sitecode,
    required this.items,
  });

  factory ItemResponse.fromJson(Map<String, dynamic> json) {
    return ItemResponse(
      sitecode: json["sitecode"] as String?,
      items: (json["items"] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Item {
  final String? itemcode;
  final String? description;
  final String? uom;

  Item({
    required this.itemcode,
    required this.description,
    required this.uom,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemcode: json["itemcode"] as String?,
      description: json["description"] as String?,
      uom: json["uom"] as String?,
    );
  }

  @override
  String toString() {
    return itemcode ?? '';
  }
}