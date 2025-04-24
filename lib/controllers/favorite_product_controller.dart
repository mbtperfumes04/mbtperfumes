import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/favorite_product_model.dart';

class FavoriteProductController {
  final SupabaseClient _client = Supabase.instance.client;
  final String table = FavoriteProductFields.table;

  // CREATE
  Future<void> addFavorite(FavoriteProductModel item) async {
    try {
      await _client.from(table).insert(item.toMap());
    } catch (e) {
      print('Error adding favorite product: $e');
      rethrow;
    }
  }

  // READ
  Future<List<FavoriteProductModel>> fetchFavorites({required String userId}) async {
    final response = await _client
        .from(table)
        .select()
        .eq(FavoriteProductFields.userId, userId);

    return (response as List)
        .map((item) => FavoriteProductModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  // READ (Single)
  Future<FavoriteProductModel?> getFavoriteById(String id) async {
    final response = await _client
        .from(table)
        .select()
        .eq(FavoriteProductFields.id, id)
        .maybeSingle();

    if (response != null) {
      return FavoriteProductModel.fromMap(response);
    }
    return null;
  }

  // DELETE
  Future<void> deleteFavorite(String id) async {
    try {
      await _client.from(table).delete().eq(FavoriteProductFields.id, id);
    } catch (e) {
      print('Error deleting favorite product: $e');
      rethrow;
    }
  }

  // Optional: Clear all favorites for a user
  Future<void> clearFavorites({required String userId}) async {
    try {
      await _client.from(table).delete().eq(FavoriteProductFields.userId, userId);
    } catch (e) {
      print('Error clearing favorites: $e');
      rethrow;
    }
  }
}
