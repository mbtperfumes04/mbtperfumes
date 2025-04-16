class ProductFields {
  static const String table = 'products';
  static const String id = 'id';
  static const String name = 'name';
  static const String desc = "desc";
  static const String images = "images";
  static const String price = "price";
  static const String stocks = "stocks";
  static const String createdAt = "created_at";
  static const String updatedAt = "updated_at";
  static const String categoryId = "category_id";
  static const String perfumeType = "perfume_type";
  static const String isActive = "is_active";
}

class ProductModel {
  final String? id;
  final String name;
  final String desc;
  final List<String>? images;
  final double price;
  final int? stocks;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? categoryId;
  final String perfumeType;
  final bool isActive;

  const ProductModel({
    this.id,
    required this.name,
    required this.desc,
    this.images,
    required this.price,
    this.stocks,
    required this.createdAt,
    this.updatedAt,
    this.categoryId,
    required this.perfumeType,
    required this.isActive
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
    id: map[ProductFields.id] ?? '',
    name: map[ProductFields.name] ?? '',
    desc: map[ProductFields.desc] ?? '',
    images: map[ProductFields.images] != null
        ? List<String>.from(map[ProductFields.images])
        : [],
    price: (map[ProductFields.price] ?? 0).toDouble(),
    stocks: map[ProductFields.stocks],
    createdAt: DateTime.tryParse(map[ProductFields.createdAt] ?? '') ?? DateTime.now(),
    updatedAt: map[ProductFields.updatedAt] != null
        ? DateTime.tryParse(map[ProductFields.updatedAt])
        : null,
    categoryId: map[ProductFields.categoryId],
    perfumeType: map[ProductFields.perfumeType] ?? '',
    isActive: map[ProductFields.isActive] ?? false
  );

  Map<String, dynamic> toMap() => {
    ProductFields.id: id,
    ProductFields.name: name,
    ProductFields.desc: desc,
    ProductFields.images: images,
    ProductFields.price: price,
    ProductFields.stocks: stocks,
    ProductFields.createdAt: createdAt.toIso8601String(),
    ProductFields.updatedAt: updatedAt?.toIso8601String(),
    ProductFields.categoryId: categoryId,
    ProductFields.perfumeType: perfumeType,
    ProductFields.isActive: isActive
  };

  ProductModel copyWith({
    String? id,
    String? name,
    String? desc,
    List<String>? images,
    double? price,
    int? stocks,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? subcategoryId,
    String? perfumeType,
    bool? isActive
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      images: images ?? this.images,
      price: price ?? this.price,
      stocks: stocks ?? this.stocks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      categoryId: subcategoryId ?? this.categoryId,
      perfumeType: perfumeType ?? this.perfumeType,
      isActive: isActive ?? this.isActive
    );
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, desc: $desc, images: $images, price: $price, stocks: $stocks, createdAt: $createdAt, updatedAt: $updatedAt, subcategoryId: $categoryId, perfumeType: $perfumeType, isActive: $isActive)';
  }
}
