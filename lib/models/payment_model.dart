class PaymentFields {
  static const String table = 'payments';
  static const String id = 'id';
  static const String userId = 'user_id';
  static const String orderId = 'order_id';
  static const String paymentMethod = 'payment_method';
  static const String amount = 'amount';
  static const String status = 'status';
  static const String currency = 'currency';
  static const String metadata = 'metadata';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class PaymentModel {
  final String? id;
  final String userId;
  final String orderId;
  final String paymentMethod;
  final double amount;
  final bool status;
  final String currency;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const PaymentModel({
    this.id,
    required this.userId,
    required this.orderId,
    required this.paymentMethod,
    required this.amount,
    required this.status,
    required this.currency,
    this.metadata,
    required this.createdAt,
    this.updatedAt,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> map) => PaymentModel(
    id: map[PaymentFields.id],
    userId: map[PaymentFields.userId],
    orderId: map[PaymentFields.orderId],
    paymentMethod: map[PaymentFields.paymentMethod],
    amount: (map[PaymentFields.amount] ?? 0).toDouble(),
    status: map[PaymentFields.status] ?? false,
    currency: map[PaymentFields.currency],
    metadata: map[PaymentFields.metadata],
    createdAt: DateTime.parse(map[PaymentFields.createdAt]),
    updatedAt: map[PaymentFields.updatedAt] != null ? DateTime.parse(map[PaymentFields.updatedAt]) : null,
  );

  Map<String, dynamic> toMap() => {
    PaymentFields.id: id,
    PaymentFields.userId: userId,
    PaymentFields.orderId: orderId,
    PaymentFields.paymentMethod: paymentMethod,
    PaymentFields.amount: amount,
    PaymentFields.status: status,
    PaymentFields.currency: currency,
    PaymentFields.metadata: metadata,
    PaymentFields.createdAt: createdAt.toIso8601String(),
    PaymentFields.updatedAt: updatedAt?.toIso8601String(),
  };
}
