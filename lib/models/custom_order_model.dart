class CustomOrderFields {
  static const String table = 'custom_order';
  static const String id = 'id';
  static const String userId = 'user_id';
  static const String name = 'name';
  static const String note = 'note';
  static const String amount = 'amount';
  static const String orderStatus = 'order_status';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class CustomOrderModel {
  final String? id;
  final String userId;
  final String name;
  final String? note;
  final double amount;
  final String orderStatus;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const CustomOrderModel({
    this.id,
    required this.userId,
    required this.name,
    this.note,
    required this.amount,
    required this.orderStatus,
    required this.createdAt,
    this.updatedAt,
  });

  factory CustomOrderModel.fromMap(Map<String, dynamic> map) => CustomOrderModel(
    id: map[CustomOrderFields.id],
    userId: map[CustomOrderFields.userId],
    name: map[CustomOrderFields.name],
    note: map[CustomOrderFields.note],
    amount: (map[CustomOrderFields.amount] ?? 0).toDouble(),
    orderStatus: map[CustomOrderFields.orderStatus] ?? '',
    createdAt: DateTime.parse(map[CustomOrderFields.createdAt]),
    updatedAt: map[CustomOrderFields.updatedAt] != null ? DateTime.parse(map[CustomOrderFields.updatedAt]) : null,
  );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      CustomOrderFields.userId: userId,
      CustomOrderFields.name: name,
      CustomOrderFields.note: note,
      CustomOrderFields.amount: amount,
      CustomOrderFields.orderStatus: orderStatus,
      CustomOrderFields.createdAt: createdAt.toIso8601String(),
      CustomOrderFields.updatedAt: updatedAt?.toIso8601String(),
    };

    if (id != null) {
      map[CustomOrderFields.id] = id;
    }

    return map;
  }
}
