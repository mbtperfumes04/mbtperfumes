import 'package:resend/resend.dart';
import 'package:mbtperfumes/models/order_item_model.dart';
import 'package:mbtperfumes/models/order_model.dart';
import 'package:mbtperfumes/models/payment_model.dart';

import '../main.dart';
import '../models/custom_order_item_model.dart';
import '../models/custom_order_model.dart';

class CustomOrderPurchaseController {
  Future<bool> sendEmail({
    required CustomOrderModel order,
    required List<CustomOrderItemModel> orderItems,
    PaymentModel? payment,
  }) async {
    try {
      final resend = Resend.instance;

      String emailToSend = supabase.auth.currentUser?.email ?? '';

      if (emailToSend.isEmpty) {
        throw Exception("Empty email, can't send an email!");
      }

      // Compose a custom HTML email
      final String htmlContent = '''
        <div style="font-family: Arial, sans-serif;">
          <h2>Thank you for your order!</h2>
          <p><strong>Order ID:</strong> ${order.id ?? 'N/A'}</p>
          <p><strong>Status:</strong> ${order.orderStatus}</p>
          <p><strong>Total Amount:</strong> ₱${order.amount.toStringAsFixed(2)}</p>
          <p><strong>Order Date:</strong> ${order.createdAt.toLocal()}</p>

          <h3>Items:</h3>
          <ul>
            ${orderItems.map((item) => '''
              <li>
                <strong>Order ID:</strong> ${item.id}<br/>
                <strong>Quantity:</strong> ${item.quantity}<br/>
                <strong>Size:</strong> ${item.size}<br/>
                <strong>Price:</strong> ₱${item.itemAmount.toStringAsFixed(2)}
              </li>
            ''').join()}
          </ul>

          ${payment != null ? '''
            <h3>Payment Info:</h3>
            <p><strong>Method:</strong> ${payment.paymentMethod}</p>
            <p><strong>Reference:</strong> ${payment.id}</p>
          ''' : ''}
        </div>
      ''';

      await resend.sendEmail(
        from: 'sales@mbtperfumes.com',
        to: [emailToSend],
        subject: 'Your Order Confirmation - ID: ${order.id ?? ''}',
        html: htmlContent,
      );

      return true;
    } catch (e) {
      print('Error sending email: $e');
      return false;
    }
  }
}
