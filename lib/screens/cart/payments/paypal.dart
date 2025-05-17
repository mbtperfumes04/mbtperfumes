import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:get/get.dart';
import 'package:mbtperfumes/controllers/order_purchase_controller.dart';
import 'package:mbtperfumes/main.dart';
import 'package:mbtperfumes/models/order_item_model.dart';
import 'package:mbtperfumes/models/order_model.dart';
import 'package:mbtperfumes/providers/order_provider.dart';
import 'package:mbtperfumes/screens/cart/success_order.dart';
import 'package:provider/provider.dart';
import 'package:resend/resend.dart';

import '../../../providers/cart_provider.dart';

class PaypalPayment extends StatefulWidget {
  const PaypalPayment({super.key,
  });

  @override
  State<PaypalPayment> createState() => _PaypalPaymentState();
}

class _PaypalPaymentState extends State<PaypalPayment> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    final paypalItems = cartProvider.items.map((cart) {
      final product = cartProvider.prodRefOfCartItems.firstWhere((p) => p.id == cart.productId);
      return {
        "name": product.name,
        "quantity": cart.quantity,
        "price": (cart.totalPrice / cart.quantity).toStringAsFixed(2),
        "currency": "PHP"
      };
    }).toList();

    final totalAmount = cartProvider.items.fold(0.0, (sum, item) => sum + item.totalPrice);

    final orderProvider = Provider.of<OrderProvider>(context);

    return PaypalCheckoutView(
        sandboxMode: true,
        onSuccess: (Map params) async {
          print("onSuccess: $params");

          OrderModel order = OrderModel(
              userId: supabase.auth.currentUser?.id ?? '',
              amount: totalAmount,
              orderStatus: 'Pending',
              createdAt: DateTime.now()
          );

          List<OrderItemModel> items = cartProvider.items.map((item) {
            return OrderItemModel(
                orderId: '',
                productId: item.productId,
                quantity: item.quantity,
                itemAmount: item.totalPrice,
                size: item.size,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now()
            );
          }).toList();

          final result = await orderProvider.placeOrder(order: order, items: items);

          if(result.isNotEmpty) {
            final purchaseEmailStatus = await OrderPurchaseController().sendEmail(order: result['order'], orderItems: result['items']);
            
            if(purchaseEmailStatus) {
              Get.offAll(() => const SuccessOrder());
            }
          }

          Get.back();
        },
        onError: (error) {
          print("onError: $error");
          Navigator.pop(context);
        },
        onCancel: () {
          print('cancelled:');
        },
        transactions: [
          {
            "amount": {
              "total": totalAmount.toStringAsFixed(2),
              "currency": "PHP",
              "details": {
                "subtotal": totalAmount.toStringAsFixed(2),
                "shipping": '0',
                "shipping_discount": 0
              }
            },
            "description": "Purchase from MBT Perfumes",
            "item_list": {
              "items": paypalItems,
            }
          }
        ],
        note: "Contact us for any questions on your order.",
        clientId: "Aa1lFsA3apMJIX2eS3t22n9ivwfLBaVylt-o3iJRd3mZxaLI_TKbJBXk5BA-arIkKgYmtW5Q3EaAvHD9",
        secretKey: "EO1pkJGgt8U3-_FstzjO8NZD-AIxMqk7g1Ls7h8SGeuwBHV0fudqPkwqMS5lHjem-CbPkRsAlPyekG-D"
    );
  }
}
