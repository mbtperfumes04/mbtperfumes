import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbtperfumes/globals.dart';
import 'package:mbtperfumes/screens/activity.dart';
import 'package:mbtperfumes/screens/home.dart';
import 'package:mbtperfumes/screens/shop/account.dart';

class Hub extends StatefulWidget {
  const Hub({super.key});

  @override
  State<Hub> createState() => _HubState();
}

class _HubState extends State<Hub> {
  PageController pageController = PageController();
  int selectedIndex = 0;

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
                const Home(),
                const Activity(),
                const Account()
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFf9efef)
            ),
            padding: EdgeInsets.only(
              left: screenWidth * 0.08,
              right: screenWidth * 0.08,
              top: screenHeight * 0.045,
              bottom: screenHeight * 0.03
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                navItem(
                  id: 0,
                  title: 'Home',
                  svg: 'home',
                  alignment: Alignment.centerLeft
                ),
                navItem(
                    id: 1,
                    title: 'Activity',
                    svg: 'activity',
                  alignment: Alignment.center
                ),
                navItem(
                    id: 2,
                    title: 'Account',
                    svg: 'account',
                  alignment: Alignment.centerRight
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
