class OrderItemFields {
  static const String table = 'order_items';
  static const String id = 'id';
  static const String orderId = 'order_id';
  static const String productId = 'product_id';
  static const String quantity = 'quantity';
  static const String itemAmount = 'item_amount';
  static const String size = 'size';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class OrderItemModel {
  final String? id;
  final String orderId;
  final String productId;
  final int quantity;
  final double itemAmount;
  final String size;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const OrderItemModel({
    this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.itemAmount,
    required this.size,
    required this.createdAt,
    this.updatedAt,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) => OrderItemModel(
    id: map[OrderItemFields.id],
    orderId: map[OrderItemFields.orderId],
    productId: map[OrderItemFields.productId],
    quantity: (map[OrderItemFields.quantity] ?? 0).toInt(),
    itemAmount: (map[OrderItemFields.itemAmount] ?? 0).toDouble(),
    size: map[OrderItemFields.size],
    createdAt: DateTime.parse(map[OrderItemFields.createdAt]),
    updatedAt: map[OrderItemFields.updatedAt] != null ? DateTime.parse(map[OrderItemFields.updatedAt]) : null,
  );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      OrderItemFields.orderId: orderId,
      OrderItemFields.productId: productId,
      OrderItemFields.quantity: quantity,
      OrderItemFields.itemAmount: itemAmount,
      OrderItemFields.size: size,
      OrderItemFields.createdAt: createdAt.toIso8601String(),
      OrderItemFields.updatedAt: updatedAt?.toIso8601String(),
    };

    if (id != null) {
      map[OrderItemFields.id] = id;
    }

    return map;
  }


  OrderItemModel copyWith({
    String? id,
    String? orderId,
    String? productId,
    int? quantity,
    double? itemAmount,
    double? amount,
    String? size,
    DateTime? createdAt,
    DateTime? updatedAt
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      itemAmount: amount ?? this.itemAmount,
      size: size ?? this.size,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt
    );
  }

}
