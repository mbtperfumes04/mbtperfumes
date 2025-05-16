import 'package:mbtperfumes/main.dart';
import 'package:mbtperfumes/models/order_item_model.dart';
import 'package:mbtperfumes/models/order_model.dart';
import 'package:mbtperfumes/models/user_model.dart';

class AdminController {

  Future<List<ProfileModel>> fetchUsers() async {
    try {
      final data = await supabase
          .from('profiles')
          .select('*');

      if (data != null && data is List) {
        return data.map((user) => ProfileModel.fromMap(user)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Fetching Orders: $e');
      return[];
    }
  }

  Future<List<OrderModel>> fetchOrders() async {
    try {
      final data = await supabase
          .from('orders')
          .select('*');

      if (data != null && data is List) {
        return data.map((order) => OrderModel.fromMap(order)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }
  
  Future<List<OrderItemModel>> fetchOrderItems() async {
    try {
      final data = await supabase
          .from('order_items')
          .select('*');

      if (data != null && data is List) {
        return data.map((orderItems) => OrderItemModel.fromMap(orderItems)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<bool> updateOrder(OrderModel toUpdate) async {
    try {
      final data = await supabase
      .from('orders')
      .update(toUpdate.toMap())
      .eq('id', toUpdate.id ?? '').select();

      print(toUpdate.id);

      return true;
    } catch (e) {
      print('Error Exception: $e');
      return false;
    }
  }


}