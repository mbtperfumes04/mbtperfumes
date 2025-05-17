import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mbtperfumes/main.dart';
import 'package:mbtperfumes/models/product_model.dart';
import 'package:mbtperfumes/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:resend/resend.dart';
import 'package:mbtperfumes/models/order_item_model.dart';
import 'package:mbtperfumes/models/order_model.dart';
import 'package:mbtperfumes/models/payment_model.dart';

class OrderPurchaseController {
  Future<bool> sendEmail({
    required OrderModel order,
    required List<OrderItemModel> orderItems,
    PaymentModel? payment,
  }) async {
    try {
      final resend = Resend.instance;

      final emailToSend = supabase.auth.currentUser?.email;
      final productProvider = Provider.of<ProductProvider>(Get.context as BuildContext, listen: false);
      if (emailToSend == null || emailToSend.isEmpty) {
        throw Exception("User email is empty, can't send the email!");
      }

      final String htmlContent = _buildHtmlContent(order, orderItems, productProvider.products, payment);

      await resend.sendEmail(
        from: 'sales@mbtperfumes.com',
        to: [emailToSend],
        subject: 'Your Order Confirmation - ID: ${order.id ?? 'N/A'}',
        html: htmlContent,
      );

      return true;
    } catch (e) {
      print('Error sending email: $e');
      return false;
    }
  }

  String _buildHtmlContent(OrderModel order, List<OrderItemModel> orderItems, List<ProductModel> products, PaymentModel? payment) {
    final deliveryDate = order.createdAt.add(Duration(days: 1));

    final itemWidgets = orderItems.map((item) {
      final product = products.firstWhere((prod) => prod.id == item.productId); // Fallback to minimal ProductModel if not found
      final imageUrl = product.images?.isNotEmpty == true ? product.images!.first : 'https://via.placeholder.com/80';

      return '''
      <div style="display: flex; align-items: center; border: 1px solid #eee; border-radius: 8px; padding: 16px; margin-bottom: 12px;">
        <img src="$imageUrl" alt="Product Image" style="width: 80px; height: 80px; border-radius: 8px; margin-right: 16px;" />
        <div>
          <p style="margin: 0;"><strong>${product.name}</strong></p>
          <p style="margin: 4px 0; color: #555;">Qty: ${item.quantity}</p>
          <p style="margin: 4px 0; color: #555;">₱${item.itemAmount.toStringAsFixed(2)}</p>
        </div>
      </div>
    ''';
    }).join('');

    return '''
  <div style="background-color: #fdf4ee; font-family: Arial, sans-serif; padding: 30px;">
    <div style="max-width: 600px; margin: auto; background-color: #fff; padding: 30px; border-radius: 12px;">
      <h1 style="text-align: center; color: #000;">Your order has been placed</h1>
      <p style="text-align: center; color: #555;">We’ve received your order and will notify you once it has been processed.</p>

      <div style="text-align: center; margin: 30px 0;">
        <a href="https://your-tracking-url.com" style="display: inline-block; background-color: #000; color: #fff; text-decoration: none; padding: 12px 24px; border-radius: 6px; font-weight: bold;">Track Order</a>
      </div>

      <table style="width: 100%; margin-bottom: 30px; text-align: center;">
        <tr>
          <td style="color: #000;"><strong>ORDER PLACED</strong><br/>${order.createdAt.toLocal().toString().split(' ')[0]}</td>
          <td style="color: #000;"><strong>ORDER SHIPPED</strong><br/>${order.createdAt.toLocal().toString().split(' ')[0]}</td>
          <td style="color: #aaa;"><strong>DELIVERY</strong><br/>${deliveryDate.toLocal().toString().split(' ')[0]}</td>
        </tr>
        <tr>
          <td>✔️</td>
          <td>✔️</td>
          <td>⚪</td>
        </tr>
      </table>

      <p><strong>Order #${order.id}</strong></p>

      $itemWidgets

      ${payment != null ? '''
      <div style="margin-top: 30px;">
        <h3 style="color: #000;">Payment</h3>
        <p><strong>Method:</strong> ${payment.paymentMethod}</p>
        <p><strong>Reference:</strong> ${payment.id}</p>
      </div>
      ''' : ''}

      <p style="text-align: center; margin-top: 40px; color: #888; font-size: 12px;">
        This is an automated email. Please do not reply.
      </p>
    </div>
  </div>
  ''';
  }

}
