import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/payment_model.dart';

class PaymentController {
  final SupabaseClient _client = Supabase.instance.client;
  final String table = PaymentFields.table;

  Future<void> createPayment(PaymentModel payment) async {
    try {
      await _client.from(table).insert(payment.toMap());
    } catch (e) {
      print('Error creating payment: $e');
      rethrow;
    }
  }

  Future<List<PaymentModel>> getPaymentsByOrder(String orderId) async {
    final response = await _client
        .from(table)
        .select()
        .eq(PaymentFields.orderId, orderId)
        .order(PaymentFields.createdAt, ascending: false);

    return (response as List)
        .map((e) => PaymentModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<PaymentModel?> getPaymentById(String id) async {
    final response = await _client
        .from(table)
        .select()
        .eq(PaymentFields.id, id)
        .maybeSingle();

    if (response != null) {
      return PaymentModel.fromMap(response);
    }
    return null;
  }

  Future<void> updatePayment(PaymentModel payment) async {
    try {
      await _client
          .from(table)
          .update(payment.toMap())
          .eq(PaymentFields.id, payment.id.toString());
    } catch (e) {
      print('Error updating payment: $e');
      rethrow;
    }
  }

  Future<void> deletePayment(String id) async {
    try {
      await _client.from(table).delete().eq(PaymentFields.id, id);
    } catch (e) {
      print('Error deleting payment: $e');
      rethrow;
    }
  }
}
