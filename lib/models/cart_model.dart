class CartFields {
  static const String table = 'cart';
  static const String id = 'id';
  static const String productId = 'product_id';
  static const String quantity = 'quantity';
  static const String totalPrice = 'amount'; // changed from total_price to amount
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
  static const String userId = 'user_id';
  static const String size = 'sizes'; // changed to match enum field name
}

class CartItemModel {
  final String? id;
  final String productId;
  final int quantity;
  final double totalPrice;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? userId;
  final String size; // Enum represented as string (ML, L, XL, etc.)

  const CartItemModel({
    this.id,
    required this.productId,
    required this.quantity,
    required this.totalPrice,
    required this.createdAt,
    this.updatedAt,
    this.userId,
    required this.size,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) => CartItemModel(
    id: map[CartFields.id],
    productId: map[CartFields.productId] ?? '',
    quantity: (map[CartFields.quantity] ?? 0).toInt(),
    totalPrice: (map[CartFields.totalPrice] ?? 0).toDouble(),
    createdAt: DateTime.tryParse(map[CartFields.createdAt] ?? '') ?? DateTime.now(),
    updatedAt: map[CartFields.updatedAt] != null
        ? DateTime.tryParse(map[CartFields.updatedAt])
        : null,
    userId: map[CartFields.userId],
    size: map[CartFields.size] ?? 'ML', // default to 'ML' if missing
  );

  Map<String, dynamic> toMap() => {
    CartFields.id: id,
    CartFields.productId: productId,
    CartFields.quantity: quantity,
    CartFields.totalPrice: totalPrice,
    CartFields.createdAt: createdAt.toIso8601String(),
    CartFields.updatedAt: updatedAt?.toIso8601String(),
    CartFields.userId: userId,
    CartFields.size: size,
  };

  CartItemModel copyWith({
    String? id,
    String? productId,
    int? quantity,
    double? totalPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    String? size,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      size: size ?? this.size,
    );
  }

  @override
  String toString() {
    return 'CartItemModel(id: $id, productId: $productId, quantity: $quantity, totalPrice: $totalPrice, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, size: $size)';
  }
}
