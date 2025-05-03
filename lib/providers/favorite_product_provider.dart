import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../controllers/favorite_product_controller.dart';
import '../controllers/product_controller.dart';
import '../main.dart';
import '../models/favorite_product_model.dart';
import '../models/product_model.dart';

class FavoriteProductProvider with ChangeNotifier {
  final FavoriteProductController _favoriteController = FavoriteProductController();
  final ProductController _productController = ProductController();

  List<FavoriteProductModel> _favorites = [];
  List<ProductModel> _favoriteProducts = [];
  bool _isLoading = false;

  List<FavoriteProductModel> get favorites => _favorites;
  List<ProductModel> get favoriteProducts => _favoriteProducts;
  bool get isLoading => _isLoading;

  FavoriteProductProvider() {
    initData();
  }

  Future<void> initData() async {
    if(supabase.auth.currentUser == null) return;

    await fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    final String userId = supabase.auth.currentUser?.id ?? '';

    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await _favoriteController.fetchFavorites(userId: userId);

      final productIds = _favorites.map((item) => item.productId).toList();
      _favoriteProducts = await _productController.fetchProductsByIds(productIds);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFavorite({
    required String productId,
    required ProductModel product,
  }) async {
    final String userId = supabase.auth.currentUser?.id ?? '';
    final newFavorite = FavoriteProductModel(
      id: const Uuid().v4(),
      productId: productId,
      userId: userId,
      createdAt: DateTime.now(),
    );

    await _favoriteController.addFavorite(newFavorite);
    _favorites.add(newFavorite);
    _favoriteProducts.add(product);
    notifyListeners();
  }

  Future<void> removeFavorite(String id) async {
    await _favoriteController.deleteFavorite(id);
    print('Deleted');
    _favorites.removeWhere((fav) => fav.id == id);
    _favoriteProducts.removeWhere((prod) =>
    !_favorites.any((fav) => fav.productId == prod.id));
    notifyListeners();
  }

  Future<void> clearFavorites() async {
    final String userId = supabase.auth.currentUser?.id ?? '';
    await _favoriteController.clearFavorites(userId: userId);
    _favorites.clear();
    _favoriteProducts.clear();
    notifyListeners();
  }

  bool isProductFavorite(String productId) {
    return _favorites.any((fav) => fav.productId == productId);
  }
}
