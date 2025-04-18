import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cart_model.dart';

class CartController {
  final SupabaseClient _client = Supabase.instance.client;
  final String table = CartFields.table;

  Future<void> addCartItem(CartItemModel item) async {
    await _client.from(table).insert(item.toMap());
  }

  Future<List<CartItemModel>> fetchCartItems({String? userId}) async {
    final response = await _client
        .from(table)
        .select()
        .eq(CartFields.userId, userId ?? '');

    return (response as List)
        .map((item) => CartItemModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }

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

  Future<void> updateCartItem(CartItemModel item) async {
    await _client
        .from(table)
        .update(item.toMap())
        .eq(CartFields.id, item.id as String);
  }

  Future<void> deleteCartItem(String id) async {
    await _client.from(table).delete().eq(CartFields.id, id);
  }

  Future<void> clearCart({required String userId}) async {
    await _client
        .from(table)
        .delete()
        .eq(CartFields.userId, userId);
  }

}
