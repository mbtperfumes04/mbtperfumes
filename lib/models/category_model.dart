class CategoryFields {
  static const String table = 'categories';
  static const String id = 'id';
  static const String name = 'name';
  static const String isActive = 'is_active';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class CategoryModel {
  final String id;
  final String name;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) => CategoryModel(
    id: map[CategoryFields.id] ?? '',
    name: map[CategoryFields.name] ?? '',
    isActive: map[CategoryFields.isActive] == true || map[CategoryFields.isActive] == 1,
    createdAt: DateTime.tryParse(map[CategoryFields.createdAt] ?? '') ?? DateTime.now(),
    updatedAt: map[CategoryFields.updatedAt] != null
        ? DateTime.tryParse(map[CategoryFields.updatedAt])
        : null,
  );

  Map<String, dynamic> toMap() => {
    CategoryFields.id: id,
    CategoryFields.name: name,
    CategoryFields.isActive: isActive ? 1 : 0,
    CategoryFields.createdAt: createdAt.toIso8601String(),
    CategoryFields.updatedAt: updatedAt?.toIso8601String(),
  };

  CategoryModel copyWith({
    String? id,
    String? name,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
