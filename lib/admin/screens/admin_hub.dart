import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbtperfumes/admin/screens/admin_dashboard.dart';
import 'package:mbtperfumes/admin/screens/admin_orders.dart';
import 'package:mbtperfumes/globals.dart';
import 'package:mbtperfumes/providers/admin/admin_provider.dart';
import 'package:mbtperfumes/screens/activity.dart';
import 'package:mbtperfumes/screens/home.dart';
import 'package:mbtperfumes/screens/account.dart';
import 'package:provider/provider.dart';

class AdminHub extends StatefulWidget {
  const AdminHub({super.key});

  @override
  State<AdminHub> createState() => _AdminHubState();
}

class _AdminHubState extends State<AdminHub> {
  PageController pageController = PageController();
  int selectedIndex = 0;
  bool isInitialized = false;

  Widget navItem({
    required int id,
    required String title,
    required String svg,
    required Alignment alignment
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {

          setState(() {
            selectedIndex = id;
          });

          pageController.jumpToPage(selectedIndex);
        },
        child: Container(
          // color: Colors.red,
          alignment: alignment,
          child: Column(
            children: [
              SvgPicture.asset('assets/svgs/general/$svg.svg',
                colorFilter: ColorFilter.mode(
                    selectedIndex == id ? Colors.black : Colors.grey,
                    BlendMode.srcIn
                ),
              ),
              Text(title,
                style: TextStyle(
                    fontSize: screenWidth * 0.03,
                    color: selectedIndex == id ? Colors.black : Colors.grey
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    initialize();
  }

  Future<void> initialize() async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    print('Initializing Admin Data');

    await adminProvider.initialize();

    print('Data Loaded');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (val) {
                setState(() {
                  selectedIndex = val;
                });
              },
              children: [
                const AdminDashboard(),
                const AdminOrders(),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white
            ),
            padding: EdgeInsets.only(
                left: screenWidth * 0.08,
                right: screenWidth * 0.08,
                top: screenHeight * 0.02,
                bottom: screenHeight * 0.03
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                navItem(
                    id: 0,
                    title: 'Home',
                    svg: 'home',
                    alignment: Alignment.center
                ),
                navItem(
                    id: 1,
                    title: 'Orders',
                    svg: 'activity',
                    alignment: Alignment.center
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
