import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbtperfumes/customs/custom_body.dart';
import 'package:mbtperfumes/globals.dart';
import 'package:mbtperfumes/screens/hub.dart';
import 'package:provider/provider.dart';

import '../../customs/reusables/custom_option_sheet.dart';
import '../../main.dart';
import '../../providers/admin/admin_provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    final todaySales = adminProvider.orders.where((order) {
      DateTime today = DateTime.now();
      DateTime orderDate = order.createdAt;

      bool isSameMonth = today.month == orderDate.month;
      bool isSameDay = today.day == orderDate.day;
      bool isSameYear = today.year == orderDate.year;
      return isSameMonth && isSameDay && isSameYear;
    });

    final pendingOrders = adminProvider.orders.where((order) {
      bool isPending = order.orderStatus.toLowerCase() == 'pending';
      return isPending;
    });

    final completedOrders = adminProvider.orders.where((order) {
      bool isCompleted = order.orderStatus.toLowerCase() == 'completed';
      return isCompleted;
    });

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
                    showCustomOptionSheet(
                      context: context,
                      options: [
                        if (supabase.auth.currentUser?.userMetadata?['role'] != 'Customer')
                          OptionItem(
                            icon: Icons.person,
                            title: 'Go to User Panel',
                            onTap: () async {

                              Get.offAll(() => const Hub());
                            },
                          ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05
            ),
            margin: EdgeInsets.only(
              top: screenHeight * 0.03
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 0,
                  child: Container(
                    width: screenWidth * 0.43,
                    decoration: BoxDecoration(
                      color: Color(0xffad2d2f),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.025),
                          child: Icon(Icons.monetization_on_outlined,
                          color: Color(0xffad2d2f),
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.05),
                        Text('₱ ${todaySales.fold(0.0, (sum, order) => sum + order.amount)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.045
                          ),
                        ),
                        Text("Today's Sales",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: screenWidth * 0.035
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Container(
                    width: screenWidth * 0.43,
                    decoration: BoxDecoration(
                      color: Color(0xff988478),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.025),
                          child: Icon(Icons.list_alt_sharp,
                          color: Color(0xff988478),
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.05),
                        Text(pendingOrders.length.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.045
                          ),
                        ),
                        Text("Pending Orders",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: screenWidth * 0.035
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05
            ),
            margin: EdgeInsets.only(
                top: screenHeight * 0.03
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 0,
                  child: Container(
                    width: screenWidth * 0.43,
                    decoration: BoxDecoration(
                      color: Color(0xffb4a69b),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.025),
                          child: Icon(Icons.show_chart,
                          color: Color(0xffb4a69b),
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.05),
                        Text('₱ ${adminProvider.orders.fold(0.0, (sum, order) => sum + order.amount)}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.045
                          ),
                        ),
                        Text("Overall Sales",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: screenWidth * 0.035
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Container(
                    width: screenWidth * 0.43,
                    decoration: BoxDecoration(
                      color: Color(0xffa42419),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.025),
                          child: Icon(Icons.check_circle_outline,
                            color: Color(0xffa42419),
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.05),
                        Text(completedOrders.length.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.045
                          ),
                        ),
                        Text("Completed Orders",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: screenWidth * 0.035
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05
            ),
            margin: EdgeInsets.only(
                top: screenHeight * 0.01
            ),
            child: Row(
              children: [
                Text('Order Overview',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
