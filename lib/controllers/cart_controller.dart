import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cart_model.dart';

class CartController {
  final SupabaseClient _client = Supabase.instance.client;
  final String table = CartFields.table;

  // CREATE
  Future<void> addCartItem(CartItemModel item) async {
    try {
      await _client.from(table).insert(item.toMap());
    } catch (e) {
      print('Error adding cart item: $e');
      rethrow;
    }
  }

  // READ
  Future<List<CartItemModel>> fetchCartItems({String? userId}) async {
    final response = await _client
        .from(table)
        .select()
        .eq(CartFields.userId, userId ?? '');

    print(response);

    return (response as List)
        .map((item) => CartItemModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  // READ
  Future<CartItemModel?> getCartItemById(String id) async {
    final response = await _client
        .from(table)
        .select()
        .eq(CartFields.id, id)
        .maybeSingle();

    if (response != null) {
      return CartItemModel.fromMap(response);
    }
    return null;
  }

  // UPDATE
  Future<void> updateCartItem(CartItemModel item) async {
    try {
      await _client
          .from(table)
          .update(item.toMap())
          .eq(CartFields.id, item.id.toString());
      print('Updated: ${item.toMap()}');
    } catch (e) {
      print('Error updating cart item: $e');
      rethrow;
    }
  }

  // DELETE
  Future<void> deleteCartItem(String id) async {
    try {
      await _client.from(table).delete().eq(CartFields.id, id);
    } catch (e) {
      print('Error deleting cart item: $e');
      rethrow;
    }
  }

  Future<void> clearCart({required String userId}) async {
    try {
      await _client.from(table).delete().eq(CartFields.userId, userId);
    } catch (e) {
      print('Error clearing cart: $e');
      rethrow;
    }
  }
}
