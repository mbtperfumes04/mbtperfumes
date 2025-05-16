class OrderFields {
  static const String table = 'orders';
  static const String id = 'id';
  static const String userId = 'user_id';
  static const String note = 'note';
  static const String amount = 'amount';
  static const String orderStatus = 'order_status';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class OrderModel {
  final String? id;
  final String userId;
  final String? note;
  final double amount;
  final String orderStatus;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const OrderModel({
    this.id,
    required this.userId,
    this.note,
    required this.amount,
    required this.orderStatus,
    required this.createdAt,
    this.updatedAt,
  });

  OrderModel copyWith({
    String? id,
    String? userId,
    String? note,
    double? amount,
    String? orderStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      note: note ?? this.note,
      amount: amount ?? this.amount,
      orderStatus: orderStatus ?? this.orderStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) => OrderModel(
    id: map[OrderFields.id],
    userId: map[OrderFields.userId],
    note: map[OrderFields.note],
    amount: (map[OrderFields.amount] ?? 0).toDouble(),
    orderStatus: map[OrderFields.orderStatus] ?? '',
    createdAt: DateTime.parse(map[OrderFields.createdAt]),
    updatedAt: map[OrderFields.updatedAt] != null ? DateTime.parse(map[OrderFields.updatedAt]) : null,
  );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      OrderFields.userId: userId,
      OrderFields.note: note,
      OrderFields.amount: amount,
      OrderFields.orderStatus: orderStatus,
      OrderFields.createdAt: createdAt.toIso8601String(),
      OrderFields.updatedAt: updatedAt?.toIso8601String(),
    };

    if (id != null) {
      map[OrderFields.id] = id;
    }

    return map;
  }
}
