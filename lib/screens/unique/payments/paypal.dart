import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:get/get.dart';
import 'package:mbtperfumes/controllers/order_purchase_controller.dart';
import 'package:mbtperfumes/main.dart';
import 'package:mbtperfumes/models/custom_order_item_model.dart';
import 'package:mbtperfumes/models/order_item_model.dart';
import 'package:mbtperfumes/models/order_model.dart';
import 'package:mbtperfumes/providers/order_provider.dart';
import 'package:mbtperfumes/screens/cart/success_order.dart';
import 'package:provider/provider.dart';
import 'package:resend/resend.dart';

import '../../../controllers/custom_order_purchase_controller.dart';
import '../../../models/custom_order_model.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/custom_order_provider.dart';
import '../../../providers/custom_product_provider.dart';
import '../success_custom_order.dart';

class PaypalPayment extends StatefulWidget {
  const PaypalPayment({super.key,
  });

  @override
  State<PaypalPayment> createState() => _PaypalPaymentState();
}

class _PaypalPaymentState extends State<PaypalPayment> {
  @override
  Widget build(BuildContext context) {
    final customProductProvider = Provider.of<CustomProductProvider>(context);

    final paypalItems = customProductProvider.selectedSizes.map((cp) {
      return {
        "name": cp.size,
        "quantity": cp.quantity,
        "price": ((cp.size * 8) * cp.quantity).toStringAsFixed(2),
        "currency": "PHP"
      };
    }).toList();

    final totalAmount = customProductProvider.selectedSizes.fold(
        0.0, (sum, cp) => sum + (cp.size * 8) * cp.quantity);

    final customOrderProvider = Provider.of<CustomOrderProvider>(context);

    return PaypalCheckoutView(
        sandboxMode: true,
        onSuccess: (Map params) async {
          print("onSuccess: $params");

          List<String> topNote = customProductProvider.selectedScents
              .where((scent) => scent.noteType.toLowerCase() == 'top')
              .map((scent) => scent.id)
              .toList();

          List<String> middleNote = customProductProvider.selectedScents
              .where((scent) => scent.noteType.toLowerCase() == 'middle')
              .map((scent) => scent.id)
              .toList();

          List<String> baseNote = customProductProvider.selectedScents
              .where((scent) => scent.noteType.toLowerCase() == 'base')
              .map((scent) => scent.id)
              .toList();

          CustomOrderModel order = CustomOrderModel(
              userId: supabase.auth.currentUser?.id ?? '',
              amount: totalAmount,
              orderStatus: 'Pending',
              createdAt: DateTime.now(),
              topNote: topNote,
              middleNote: middleNote,
              baseNote: baseNote,
              name: customProductProvider.customName
          );

          List<CustomOrderItemModel> items = customProductProvider.selectedSizes.map((item) {
            return CustomOrderItemModel(
                customOrderId: '',
                quantity: item.quantity,
                itemAmount: double.tryParse(((item.size * 8) * item.quantity).toStringAsFixed(2)) ?? 0,
                size: double.tryParse(item.size.toStringAsFixed(2)) ?? 0.0,
                createdAt: DateTime.now()
            );
          }).toList();

          final result = await customOrderProvider.placeCustomOrder(customOrder: order, items: items);

          if(result.isNotEmpty) {
            final purchaseEmailStatus = await CustomOrderPurchaseController().sendEmail(
                order: result['custom_order'], orderItems: result['items']);

            if(purchaseEmailStatus) {
              Get.offAll(() => const SuccessCustomOrder());
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
