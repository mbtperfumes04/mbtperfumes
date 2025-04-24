import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';
import '../models/order_item_model.dart';

class OrderController {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Map<String, dynamic>?> placeOrder({
    required OrderModel order,
    required List<OrderItemModel> items,
  }) async {
    final orderTable = OrderFields.table;
    final itemTable = OrderItemFields.table;

    try {
      final orderInsert = await _client
          .from(orderTable)
          .insert(order.toMap())
          .select()
          .single();

      final String orderId = orderInsert['id'];

      final itemsWithOrderId = items
          .map((item) => item.copyWith(orderId: orderId).toMap())
          .toList();

      final itemInserts = await _client
          .from(itemTable)
          .insert(itemsWithOrderId)
          .select();

      await _client.from('cart').delete().eq('user_id', _client.auth.currentUser?.id ?? '');

      final createdOrder = OrderModel.fromMap(orderInsert);
      final createdItems = (itemInserts as List)
          .map((e) => OrderItemModel.fromMap(e as Map<String, dynamic>))
          .toList();

      return {
        'order': createdOrder,
        'items': createdItems,
      };
    } catch (e) {
      print('Error placing order: $e');
      rethrow;
    }
  }


  Future<List<OrderModel>> fetchOrdersByUser(String userId) async {
    final res = await _client
        .from(OrderFields.table)
        .select()
        .eq(OrderFields.userId, userId)
        .order(OrderFields.createdAt, ascending: false);

    return (res as List)
        .map((e) => OrderModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<OrderItemModel>> fetchItemsByOrderId(String orderId) async {
    final res = await _client
        .from(OrderItemFields.table)
        .select()
        .eq(OrderItemFields.orderId, orderId);

    return (res as List)
        .map((e) => OrderItemModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
