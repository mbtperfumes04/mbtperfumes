import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbtperfumes/customs/custom_body.dart';
import 'package:mbtperfumes/globals.dart';
import 'package:provider/provider.dart';

import '../../providers/admin/admin_provider.dart';

class AdminOrders extends StatefulWidget {
  const AdminOrders({super.key});

  @override
  State<AdminOrders> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  String updatingOrder = '';

  List<Map<String, dynamic>> buttons = [
    {
      'id': 1,
      'title': 'All'
    },
    {
      'id': 2,
      'title': 'Pending'
    },{
      'id': 3,
      'title': 'To Receive'
    },{
      'id': 4,
      'title': 'Completed'
    }

  ];

  int selectedButtonId = 1;

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    final filteredOrders = adminProvider.orders.where((order) {
      switch (selectedButtonId) {
        case 2:
          return order.orderStatus.toLowerCase() == 'pending';
        case 3:
          return order.orderStatus.toLowerCase() == 'to receive';
        case 4:
          return order.orderStatus.toLowerCase() == 'completed';
        default:
          return true;
      }
    }).toList();

    return Scaffold(
      body: CustomBody(
        isGradient: false,
        customBG: Color(0xfff6f6ef),
        appBar: SliverAppBar(
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Admin Panel'),
                IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () {

                  },
                )
              ],
            ),
          ),
        ),
        children: [
          Container(
            height: screenHeight * 0.05,
            width: screenWidth,
            margin: EdgeInsets.only(
              top: screenHeight * 0.015,
              bottom: screenHeight * 0.02
            ),
            child: ListView.builder(
              itemCount: buttons.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final button = buttons[index];
                final isSelected = button['id'] == selectedButtonId;

                return Container(
                  margin: EdgeInsets.only(
                    left: index == 0 ? screenWidth * 0.05 : 0,
                    right: index == (buttons.length -1) ? screenWidth * 0.05 : screenWidth * 0.03
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
                      foregroundColor:
                      isSelected ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedButtonId = button['id'];
                      });
                    },
                    child: Text(button['title']),
                  ),
                );
              },
            ),
          ),
          Container(
            child: ListView.builder(
              itemCount: filteredOrders.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // ✅ Prevents nested scrolling conflict
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];

                final user = adminProvider.users.firstWhereOrNull(
                      (u) => u.id == order.userId,
                );

                return Container(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            child: Center(
                              child: Icon(
                                Icons.account_circle,
                                color: Colors.grey,
                                size: screenSize * 0.04,
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.035),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user?.username ?? '',
                                  style: TextStyle(
                                    fontSize: screenSize * 0.013,
                                    fontWeight: FontWeight.w600
                                  )
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Text('₱ ${order.amount}',
                                style: TextStyle(
                                  fontSize: screenSize * 0.011,
                                  color: const Color(0xFF808080)
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: updatingOrder == order.id ?
                            Padding(
                              padding: EdgeInsets.only(
                                right: screenWidth * 0.05
                              ),
                              child: CupertinoActivityIndicator(),
                            ) :
                            Container(
                              height: screenHeight * 0.05,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(

                                  value: order.orderStatus,
                                  isDense: true,
                                  dropdownColor: Colors.white,
                                  icon: Visibility(
                                    visible: false,
                                    child: Icon(Icons.arrow_drop_down_outlined),
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  selectedItemBuilder: (BuildContext context) {
                                    return ['Pending', 'To Receive', 'Completed'].map((status) {
                                      return Container(
                                        height: screenHeight * 0.035,
                                        decoration: BoxDecoration(
                                            color: order.orderStatus.toLowerCase() == 'pending' ?
                                            Colors.grey : order.orderStatus.toLowerCase() == 'to receive' ?
                                            Colors.orange.shade700 : Colors.green,
                                            borderRadius: BorderRadius.circular(30)
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.02
                                        ),
                                        margin: EdgeInsets.only(
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              status,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Poppins'
                                              ),
                                            ),
                                            SizedBox(width: screenWidth * 0.01),
                                            Icon(Icons.arrow_drop_down_outlined, color: Colors.white),
                                          ],
                                        ),
                                      );
                                    }).toList();
                                  },
                                  onChanged: (newStatus) async {
                                    if (newStatus != null) {
                                      final updatedOrder = order.copyWith(
                                        orderStatus: newStatus,
                                        updatedAt: DateTime.now(),
                                      );

                                      setState(() {
                                        updatingOrder = order.id ?? '';
                                      });

                                      await adminProvider.updateOrder(updatedOrder);

                                      setState(() {
                                        updatingOrder = '';
                                      });
                                    }
                                  },
                                  items: ['Pending', 'To Receive', 'Completed'].map((status) {
                                    return DropdownMenuItem<String>(
                                      value: status,
                                      child: Text(
                                        status,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                                                    ),
                      )
                    ],
                  ),
                );

              },
            ),
          )

        ],
      )
    );
  }
}
