import 'package:flutter/material.dart';
import 'package:mbtperfumes/controllers/product_controller.dart';
import 'package:mbtperfumes/models/product_model.dart';
import '../controllers/cart_controller.dart';
import '../main.dart';
import '../models/cart_model.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final CartController _cartController = CartController();
  final ProductController _productController = ProductController();

  List<CartItemModel> _items = [];
  List<ProductModel> _prodRefOfCartItems = [];
  bool _isLoading = false;

  List<CartItemModel> get items => _items;
  List<ProductModel> get prodRefOfCartItems => _prodRefOfCartItems;

  CartProvider() {
    fetchCart();
  }

  bool get isLoading => _isLoading;

  Future<void> fetchCart() async {

    String userId = supabase.auth.currentUser?.id ?? '';

    _isLoading = true;
    notifyListeners();

    try {
      _items = await _cartController.fetchCartItems(userId: userId);

      // Extract product IDs from cart
      final productIds = _items.map((item) => item.productId).toList();

      print('cart items value: ${items.length}');

      // Fetch product references in one go
      _prodRefOfCartItems = await _productController.fetchProductsByIds(productIds);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> addItem({
    required String productId,
    required int quantity,
    required double totalPrice,
    required String userId,
    required int size, // NEW: include size
    required ProductModel product
  }) async {
    final newItem = CartItemModel(
      id: const Uuid().v4(),
      productId: productId,
      quantity: quantity,
      totalPrice: totalPrice,
      createdAt: DateTime.now(),
      userId: userId,
      updatedAt: null,
      size: size.toString(), // NEW: set size
    );

    await _cartController.addCartItem(newItem);
    _items.add(newItem);
    // Fetch the product reference for the new item
      _prodRefOfCartItems.add(product);

    notifyListeners();
  }

  Future<void> removeItem(String id) async {
    await _cartController.deleteCartItem(id);
    _items.removeWhere((item) => item.id == id);
    _prodRefOfCartItems.removeWhere((prod) =>
    !_items.any((cartItem) => cartItem.productId == prod.id)); // Remove orphaned refs
    notifyListeners();

  }

  Future<void> updateItem(CartItemModel updatedItem) async {
    await _cartController.updateCartItem(updatedItem);

    final index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _items[index] = updatedItem;

      final product = await _productController.fetchProductById(updatedItem.productId);
      if (product != null) {
        final prodIndex = _prodRefOfCartItems.indexWhere((p) => p.id == product.id);
        if (prodIndex != -1) {
          _prodRefOfCartItems[prodIndex] = product;
        } else {
          _prodRefOfCartItems.add(product);
        }
      }

      notifyListeners();
    }
  }


  Future<void> clearCart(String userId) async {
    await _cartController.clearCart(userId: userId);
    _items.clear();
    _prodRefOfCartItems.clear();
    notifyListeners();
  }

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get totalQuantity {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }
}
