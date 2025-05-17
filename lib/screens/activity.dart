import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mbtperfumes/customs/custom_body.dart';
import 'package:mbtperfumes/globals.dart';
import 'package:mbtperfumes/models/order_model.dart';
import 'package:mbtperfumes/providers/order_provider.dart';
import 'package:mbtperfumes/providers/product_provider.dart';
import 'package:mbtperfumes/screens/order/preview_order.dart';
import 'package:provider/provider.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  int selectedButton = 1;
  String expandedOrder = '';

  List<Map<String, dynamic>> buttons = [
    {'id': 1, 'title': 'All'},
    {'id': 2, 'title': 'Pending'},
    {'id': 3, 'title': 'To Receive'},
    {'id': 4, 'title': 'Completed'},
  ];

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    List filteredOrders;

    final selectedFilter = buttons.firstWhere((b) => b['id'] == selectedButton)['title'].toString().toLowerCase();

    if (selectedFilter == 'all') {
      filteredOrders = orderProvider.orders;
    } else {
      filteredOrders = orderProvider.orders
          .where((order) => order.orderStatus.toString().toLowerCase() == selectedFilter)
          .toList();
    }

    return Scaffold(
      body: Container(
        child: CustomBody(
          appBar: SliverAppBar(
            toolbarHeight: screenHeight * 0.04,
            bottom: PreferredSize(
              preferredSize: Size(screenWidth, screenHeight * 0.05),
              child: Container(
                height: screenHeight * 0.05,
                width: screenWidth,
                child: ListView.builder(
                  itemCount: buttons.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final button = buttons[index];
                    final isSelected = button['id'] == selectedButton;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedButton = button['id'];
                        });
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                        margin: EdgeInsets.only(
                          left: index == 0 ? screenWidth * 0.05 : 0,
                          right: index == (buttons.length - 1) ? screenWidth * 0.05 : screenWidth * 0.03,
                        ),
                        child: Text(
                          button['title'],
                          style: TextStyle(
                            fontSize: screenSize * 0.012,
                            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            title: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Activity',
                    style: TextStyle(fontSize: screenSize * 0.016),
                  ),
                ],
              ),
            ),
          ),
          children: filteredOrders.asMap().entries.map((key) {
            final index = key.key;
            final order = key.value as OrderModel;
            final orderItems = orderProvider.orderItems.where((oi) => oi.orderId == order.id).toList();

            final formattedDate = order.createdAt != null
                ? DateFormat('MMMM d, y - h:mm a').format(DateTime.parse(order.createdAt.toString()))
                : 'Unknown Date';

            return Container(
              margin: EdgeInsets.only(
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                top: screenHeight * 0.02,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.01,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                              width: screenWidth * 0.4,
                              child: Text(DateFormat('MMMM d, y - h:mm a').format(order.createdAt),
                                maxLines: 1,
                                style: TextStyle(
                                  color: const Color(0xFF808080)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(order.orderStatus,
                        style: TextStyle(
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Container(
                    height: expandedOrder == order.id ? null : screenHeight * 0.12,
                    child: Stack(
                      children: [
                        ListView.builder(
                          itemCount: orderItems.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final orderItem = orderItems[index];
                            final product = productProvider.products
                                .firstWhere((prod) => prod.id == orderItem.productId);

                            return Container(
                              margin: EdgeInsets.only(
                                  top: screenHeight * 0.01
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          width: screenWidth * 0.13,
                                          height: screenWidth * 0.13,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(product.images?[0] ?? '')
                                              ),
                                              borderRadius: BorderRadius.circular(10)
                                          )
                                      ),
                                      SizedBox(width: screenWidth * 0.03),
                                      Container(
                                        width: screenWidth * 0.5,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(product.name,
                                              style: TextStyle(
                                                  fontSize: screenSize * 0.0115,
                                                  fontWeight: FontWeight.w500
                                              ),
                                            ),
                                            Text('Unit Price: ₱ ${product.price}',
                                              style: TextStyle(
                                                  fontSize: screenSize * 0.01,
                                                  fontWeight: FontWeight.w300
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text('x${orderItem.quantity}',
                                          style: TextStyle(
                                            color: const Color(0xFF808080),
                                            fontWeight: FontWeight.w300,
                                            fontSize: screenSize * 0.01
                                          ),
                                        ),
                                        Text('₱ ${orderItem.itemAmount}',
                                          style: TextStyle(

                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        if(expandedOrder != order.id && orderItems.length > 1)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: screenHeight * 0.05,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.white,
                                    Colors.white.withOpacity(0.0),
                                  ],
                                ),
                              ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      expandedOrder = order.id ?? '';
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400.withValues(alpha: 0.9),
                                      borderRadius: BorderRadius.circular(30)
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.03,
                                      vertical: screenHeight * 0.003
                                    ),
                                    child: Text('View more',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenSize * 0.009,
                                        fontWeight: FontWeight.w600
                                      ),
                                    )
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    alignment: Alignment.topRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Total ${orderItems.length} ${orderItems.length > 1 ? 'items' : 'item'}: ',
                                style: TextStyle(
                                  color: const Color(0xFF808080)
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
                        SizedBox(height: screenHeight * 0.005),
                        ElevatedButton(
                          onPressed: () => Get.to(() => PreviewOrder(orderId: order.id ?? '')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white
                          ),
                          child: Text('View Details',
                            style: TextStyle(
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
