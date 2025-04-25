import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:mbtperfumes/controllers/custom_order_controller.dart';
import 'package:mbtperfumes/models/custom_order_model.dart';
import 'package:mbtperfumes/models/custom_order_item_model.dart';
import 'package:mbtperfumes/providers/cart_provider.dart';
import 'package:mbtperfumes/main.dart';

class CustomOrderProvider with ChangeNotifier {
  final CustomOrderController _customOrderController = CustomOrderController();

  List<CustomOrderModel> _customOrders = [];
  List<CustomOrderItemModel> _customOrderItems = [];

  List<CustomOrderModel> get customOrders => _customOrders;

  List<CustomOrderItemModel> getItemsForCustomOrder(String customOrderId) {
    return _customOrderItems.where((item) => item.customOrderId == customOrderId).toList();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchCustomOrders(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _customOrders = await _customOrderController.fetchCustomOrdersByUser(userId);
      _customOrderItems = [];

      for (var order in _customOrders) {
        final items = await _customOrderController.fetchItemsByCustomOrderId(order.id ?? '');
        _customOrderItems.addAll(items);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> placeCustomOrder({
    required CustomOrderModel customOrder,
    required List<CustomOrderItemModel> items,
  }) async {
    final orderMap = await _customOrderController.placeCustomOrder(
      customOrder: customOrder,
      items: items,
    );

    if (orderMap != null) {
      final CustomOrderModel createdOrder = orderMap['custom_order'] as CustomOrderModel;
      final List<CustomOrderItemModel> createdItems = orderMap['items'] as List<CustomOrderItemModel>;

      _customOrders.add(createdOrder);
      _customOrderItems.addAll(createdItems);

      await fetchCustomOrders(createdOrder.userId);

      final cartProvider = Provider.of<CartProvider>(Get.context as BuildContext, listen: false);
      await cartProvider.clearCart(supabase.auth.currentUser?.id ?? '');

      return orderMap;
    }

    throw Exception('Failed to place custom order');
  }
}
