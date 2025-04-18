import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_model.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final CartController _cartController = CartController();

  List<CartItemModel> _items = [];
  bool _isLoading = false;

  List<CartItemModel> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> fetchCart(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await _cartController.fetchCartItems(userId: userId);
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
    notifyListeners();
  }

  Future<void> removeItem(String id) async {
    await _cartController.deleteCartItem(id);
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  Future<void> updateItem(CartItemModel updatedItem) async {
    await _cartController.updateCartItem(updatedItem);
    final index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _items[index] = updatedItem;
      notifyListeners();
    }
  }

  Future<void> clearCart(String userId) async {
    await _cartController.clearCart(userId: userId);
    _items.clear();
    notifyListeners();
  }

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get totalQuantity {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }
}
