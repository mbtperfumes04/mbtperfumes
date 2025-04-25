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

      // Compose a custom HTML email
      final String htmlContent = '''
        <div style="font-family: Arial, sans-serif;">
          <h2>Thank you for your order!</h2>
          <p><strong>Order ID:</strong> ${order.id ?? 'N/A'}</p>
          <p><strong>Status:</strong> ${order.orderStatus}</p>
          <p><strong>Total Amount:</strong> \$${order.amount.toStringAsFixed(2)}</p>
          <p><strong>Order Date:</strong> ${order.createdAt.toLocal()}</p>

          <h3>Items:</h3>
          <ul>
            ${orderItems.map((item) => '''
              <li>
                <strong>Product ID:</strong> ${item.productId}<br/>
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
        from: 'support@mbtperfumes.com',
        to: ['qskvcueto@tip.edu.ph'],
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
