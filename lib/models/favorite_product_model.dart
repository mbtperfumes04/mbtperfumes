class FavoriteProductFields {
  static const String table = 'favorite_products';
  static const String id = 'id';
  static const String productId = 'product_id';
  static const String userId = 'user_id';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class FavoriteProductModel {
  final String? id;
  final String productId;
  final String? userId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const FavoriteProductModel({
    this.id,
    required this.productId,
    this.userId,
    required this.createdAt,
    this.updatedAt,
  });

  factory FavoriteProductModel.fromMap(Map<String, dynamic> map) => FavoriteProductModel(
    id: map[FavoriteProductFields.id],
    productId: map[FavoriteProductFields.productId] ?? '',
    userId: map[FavoriteProductFields.userId],
    createdAt: DateTime.tryParse(map[FavoriteProductFields.createdAt] ?? '') ?? DateTime.now(),
    updatedAt: map[FavoriteProductFields.updatedAt] != null
        ? DateTime.tryParse(map[FavoriteProductFields.updatedAt])
        : null,
  );

  Map<String, dynamic> toMap() => {
    FavoriteProductFields.id: id,
    FavoriteProductFields.productId: productId,
    FavoriteProductFields.userId: userId,
    FavoriteProductFields.createdAt: createdAt.toIso8601String(),
    FavoriteProductFields.updatedAt: updatedAt?.toIso8601String(),
  };

  FavoriteProductModel copyWith({
    String? id,
    String? productId,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FavoriteProductModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'FavoriteProductModel(id: $id, productId: $productId, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
