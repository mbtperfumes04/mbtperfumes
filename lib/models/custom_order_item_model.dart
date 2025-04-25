class CustomOrderItemFields {
  static const String table = 'custom_order_items';
  static const String id = 'id';
  static const String customOrderId = 'custom_order_id';
  static const String size = 'size';
  static const String quantity = 'quantity';
  static const String itemAmount = 'item_amount';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class CustomOrderItemModel {
  final String? id;
  final String customOrderId;
  final double size;
  final int quantity;
  final double itemAmount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const CustomOrderItemModel({
    this.id,
    required this.customOrderId,
    required this.size,
    required this.quantity,
    required this.itemAmount,
    required this.createdAt,
    this.updatedAt,
  });

  factory CustomOrderItemModel.fromMap(Map<String, dynamic> map) => CustomOrderItemModel(
    id: map[CustomOrderItemFields.id],
    customOrderId: map[CustomOrderItemFields.customOrderId],
    size: (map[CustomOrderItemFields.size] ?? 0).toDouble(),
    quantity: (map[CustomOrderItemFields.quantity] ?? 0).toInt(),
    itemAmount: (map[CustomOrderItemFields.itemAmount] ?? 0).toDouble(),
    createdAt: DateTime.parse(map[CustomOrderItemFields.createdAt]),
    updatedAt: map[CustomOrderItemFields.updatedAt] != null ? DateTime.parse(map[CustomOrderItemFields.updatedAt]) : null,
  );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      CustomOrderItemFields.customOrderId: customOrderId,
      CustomOrderItemFields.size: size,
      CustomOrderItemFields.quantity: quantity,
      CustomOrderItemFields.itemAmount: itemAmount,
      CustomOrderItemFields.createdAt: createdAt.toIso8601String(),
      CustomOrderItemFields.updatedAt: updatedAt?.toIso8601String(),
    };

    if (id != null) {
      map[CustomOrderItemFields.id] = id;
    }

    return map;
  }

  CustomOrderItemModel copyWith({
    String? id,
    String? customOrderId,
    double? size,
    int? quantity,
    double? itemAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomOrderItemModel(
      id: id ?? this.id,
      customOrderId: customOrderId ?? this.customOrderId,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
      itemAmount: itemAmount ?? this.itemAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
