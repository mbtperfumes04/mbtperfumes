import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/custom_order_model.dart';
import '../models/custom_order_item_model.dart';

class CustomOrderController {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Map<String, dynamic>?> placeCustomOrder({
    required CustomOrderModel customOrder,
    required List<CustomOrderItemModel> items,
  }) async {
    final orderTable = CustomOrderFields.table;
    final itemTable = CustomOrderItemFields.table;

    try {
      final orderInsert = await _client
          .from(orderTable)
          .insert(customOrder.toMap())
          .select()
          .single();

      final String customOrderId = orderInsert['id'];

      final itemsWithOrderId = items
          .map((item) => item.copyWith(customOrderId: customOrderId).toMap())
          .toList();

      final itemInserts = await _client
          .from(itemTable)
          .insert(itemsWithOrderId)
          .select();

      final createdOrder = CustomOrderModel.fromMap(orderInsert);
      final createdItems = (itemInserts as List)
          .map((e) => CustomOrderItemModel.fromMap(e as Map<String, dynamic>))
          .toList();

      return {
        'custom_order': createdOrder,
        'items': createdItems,
      };
    } catch (e) {
      print('Error placing custom order: $e');
      rethrow;
    }
  }

  Future<List<CustomOrderModel>> fetchCustomOrdersByUser(String userId) async {
    final res = await _client
        .from(CustomOrderFields.table)
        .select()
        .eq(CustomOrderFields.userId, userId)
        .order(CustomOrderFields.createdAt, ascending: false);

    return (res as List)
        .map((e) => CustomOrderModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CustomOrderItemModel>> fetchItemsByCustomOrderId(String customOrderId) async {
    final res = await _client
        .from(CustomOrderItemFields.table)
        .select()
        .eq(CustomOrderItemFields.customOrderId, customOrderId);

    return (res as List)
        .map((e) => CustomOrderItemModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
