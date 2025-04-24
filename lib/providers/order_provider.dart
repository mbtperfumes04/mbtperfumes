import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbtperfumes/controllers/order_controller.dart';
import 'package:mbtperfumes/main.dart';
import 'package:mbtperfumes/models/order_model.dart';
import 'package:mbtperfumes/models/order_item_model.dart';
import 'package:mbtperfumes/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class OrderProvider with ChangeNotifier {
  final OrderController _orderController = OrderController();

  List<OrderModel> _orders = [];
  List<OrderItemModel> _orderItems = [];

  List<OrderModel> get orders => _orders;

  List<OrderItemModel> getItemsForOrder(String orderId) {
    return _orderItems.where((item) => item.orderId == orderId).toList();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchOrders(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _orders = await _orderController.fetchOrdersByUser(userId);
      _orderItems = [];

      for (var order in _orders) {
        final items = await _orderController.fetchItemsByOrderId(order.id ?? '');
        _orderItems.addAll(items);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> placeOrder({
    required OrderModel order,
    required List<OrderItemModel> items,
  }) async {
    final orderMap = await _orderController.placeOrder(order: order, items: items);

    if (orderMap != null) {
      // Extract the created models
      final OrderModel createdOrder = orderMap['order'] as OrderModel;
      final List<OrderItemModel> createdItems = orderMap['items'] as List<OrderItemModel>;

      _orders.add(createdOrder);
      _orderItems.addAll(createdItems);

      await fetchOrders(createdOrder.userId);

      final cartProvider = Provider.of<CartProvider>(Get.context as BuildContext, listen: false);
      await cartProvider.clearCart(supabase.auth.currentUser?.id ?? '');

      return orderMap;
    }

    throw Exception('Failed to place order');
  }

}
