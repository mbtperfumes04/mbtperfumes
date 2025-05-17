import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbtperfumes/customs/custom_body.dart';
import 'package:mbtperfumes/globals.dart';
import 'package:provider/provider.dart';

import '../../providers/order_provider.dart';
import '../../providers/product_provider.dart';

class PreviewOrder extends StatefulWidget {
  final String orderId;

  const PreviewOrder({
    super.key,
    required this.orderId
  });

  @override
  State<PreviewOrder> createState() => _PreviewOrderState();
}

class _PreviewOrderState extends State<PreviewOrder> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    final order = orderProvider.orders.firstWhere((ord) => ord.id == widget.orderId);

    final status = order.orderStatus.toLowerCase();

    final color = switch (order.orderStatus.toLowerCase()) {
      'pending' => Colors.grey,
      'to receive' => Colors.orange.shade600,
      'completed' => Colors.green,
      _ => Colors.black,
    };

    final icon = switch (order.orderStatus.toLowerCase()) {
      'pending' => Icons.pending_actions_sharp,
      'to receive' => Icons.delivery_dining,
      'completed' => Icons.check_circle,
      _ => Icons.more_horiz,
    };

    final title = switch (order.orderStatus.toLowerCase()) {
      'pending' => 'Order is placed',
      'to receive' => 'Order is out for delivery',
      'completed' => 'Order has been delivered',
      _ => '',
    };



    final validOrderItems = orderProvider.orderItems.where((oi) => oi.orderId == order.id).toList();

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            CustomBody(
              appBar: SliverAppBar(
                title: Text('Order Details'),
              ),
              children: [
                Container(
                  width: screenWidth * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)
                  ),
                  margin: EdgeInsets.only(
                    top: screenHeight * 0.023
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16)
                          )
                        ),
                        height: screenHeight * 0.045,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05
                        ),
                        child: Text('Your Order is ${order.orderStatus}',
                          style: TextStyle(
                            fontSize: screenSize * 0.0125,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                          ),
                        )
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.02
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(icon),
                            SizedBox(width: screenWidth * 0.03),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title,
                                  style: TextStyle(
                                    fontSize: screenSize * 0.012
                                  ),
                                ),
                                if(order.updatedAt != null || order.createdAt != null)
                                Text(DateFormat('MMMM d, y - h:mm a').format(DateTime.parse(
                                  order.orderStatus.toLowerCase() == 'pending' ? order.createdAt.toString() : order.updatedAt.toString()
                                )),
                                  style: TextStyle(
                                    fontSize: screenSize * 0.01,
                                    color: const Color(0xFF808080)
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: screenWidth * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)
                  ),
                  margin: EdgeInsets.only(
                      top: screenHeight * 0.023
                  ),
                  child: Column(
                    children: [
                      ListView.builder(
                        itemCount: validOrderItems.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.0,
                        ),
                        itemBuilder: (context, index) {
                          final orderItem = validOrderItems[index];
                          final product = productProvider.products.firstWhere(
                                (prod) => prod.id == orderItem.productId);

                          if (product == null) return SizedBox(); // Skip rendering if no product found

                          return Container(
                            margin: EdgeInsets.only(
                              top: screenHeight * 0.02,
                              bottom: index == (validOrderItems.length - 1) ? screenHeight * 0.02 : 0,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: screenWidth * 0.2,
                                  height: screenWidth * 0.2,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(product.images?[0] ?? ''),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.035),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: screenSize * 0.012,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '₱ ${product.price}',
                                            style: TextStyle(
                                              fontSize: screenSize * 0.01,
                                              color: const Color(0xFF808080),
                                            ),
                                          ),
                                          Text(
                                            'x${orderItem.quantity}',
                                            style: TextStyle(
                                              fontSize: screenSize * 0.01,
                                              color: const Color(0xFF808080),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: screenHeight * 0.015),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            '₱ ${orderItem.itemAmount}',
                                            style: TextStyle(
                                              fontSize: screenSize * 0.011,
                                              color: const Color(0xFF808080),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Divider(color: const Color(0xFF808080), thickness: 0.2, height: 1,),
                      SizedBox(height: screenHeight * 0.01),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03
                        ),
                        child: RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Order Total: ',
                                    style: TextStyle(
                                        color: const Color(0xFF808080),
                                        fontSize: screenSize * 0.012
                                    )
                                ),
                                TextSpan(
                                    text: '₱ ${order.amount}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: screenSize * 0.013
                                    )
                                )
                              ],
                              style: TextStyle(
                                  fontFamily: 'Poppins'
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                    ],
                  ),
                )
              ],
            ),
            if(status == 'to receive')
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                    bottom: screenHeight * 0.04,
                    top: screenHeight * 0.016
                  ),
                  child: Container(
                    height: screenHeight * 0.056,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isProcessing = true;
                        });

                        if (status == 'to receive') {
                          await orderProvider.updateOrder(order.copyWith(
                            orderStatus: 'Completed',
                            updatedAt: DateTime.now()
                          ));
                        }

                        setState(() {
                          isProcessing = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white
                      ),
                      child: isProcessing ? CupertinoActivityIndicator(
                        color: Colors.white,
                      ) : Text('Order Received',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: screenSize * 0.013
                        ),
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
