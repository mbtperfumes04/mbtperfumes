import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbtperfumes/admin/screens/admin_hub.dart';
import 'package:mbtperfumes/customs/custom_body.dart';
import 'package:mbtperfumes/globals.dart';
import 'package:mbtperfumes/screens/hub.dart';

class AdminStart extends StatefulWidget {
  const AdminStart({super.key});

  @override
  State<AdminStart> createState() => _AdminStartState();
}

class _AdminStartState extends State<AdminStart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        children: [
          Container(
            height: screenHeight,
            width: screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Container(
                  margin: EdgeInsets.only(
                    bottom: screenHeight * 0.08
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Who's Shopping Right Now?",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.1
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text("Choose your role to continue — whether you're managing or just browsing the scents.",
                        style: TextStyle(
                          fontSize: screenWidth * 0.038,
                          color: const Color(0xff808080)
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.035),
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Get.offAll(() => const AdminHub()),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xffad2d2f),
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.02
                                  ),
                                  elevation: 0
                                ),
                                child: Text('As Admin',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.038,
                                  fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.05),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.offAll(() => const Hub());
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.02
                                    ),
                                  elevation: 0
                                ),
                                child: Text('As Customer',
                                  style: TextStyle(
                                      color: Color(0xffad2d2f),
                                      fontSize: screenWidth * 0.038,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          )
        ],
      ),
    );
  }
}
