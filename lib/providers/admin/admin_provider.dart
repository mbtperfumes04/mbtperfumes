import 'package:flutter/widgets.dart';
import 'package:mbtperfumes/controllers/admin/admin_controller.dart';
import 'package:mbtperfumes/models/order_item_model.dart';
import 'package:mbtperfumes/models/order_model.dart';
import 'package:mbtperfumes/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminProvider with ChangeNotifier {
  final AdminController adminController = AdminController();

  List<OrderModel> _orders = [];
  List<OrderItemModel> _orderItems = [];
  List<ProfileModel> _users = [];

  List<OrderModel> get orders => _orders;
  List<OrderItemModel> get orderItems => orderItems;
  List<ProfileModel> get users => _users;


  Future<void> initialize() async {
    await getUsers();
    await getOrders();
  }

  Future<void> getUsers() async {
    _users = await adminController.fetchUsers();

    notifyListeners();
  }

  Future<void> getOrders() async {
    _orders = await adminController.fetchOrders();
    if (_orders.isNotEmpty) {
      _orderItems = await adminController.fetchOrderItems();
    }

    print('Orders Fetched: ${_orders.length}');
    notifyListeners();
  }

  Future<void> updateOrder(OrderModel toUpdate) async {
    bool status = await adminController.updateOrder(toUpdate);

    if (status) {
      int orderIndex = orders.indexWhere((order) => order.id == toUpdate.id);

      _orders[orderIndex] = toUpdate;

      notifyListeners();
    }
  }

}