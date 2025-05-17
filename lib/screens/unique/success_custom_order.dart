import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbtperfumes/customs/custom_body.dart';
import 'package:mbtperfumes/globals.dart';
import 'package:mbtperfumes/screens/hub.dart';

class SuccessCustomOrder extends StatefulWidget {
  const SuccessCustomOrder({super.key});

  @override
  State<SuccessCustomOrder> createState() => _SuccessCustomOrderState();
}

class _SuccessCustomOrderState extends State<SuccessCustomOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomBody(
            isGradient: false,
            // customBG: Colors.white,
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: screenHeight * 0.2
                ),
                child: Image.asset('assets/images/general/success-img.png',
                  width: screenWidth * 0.6,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: screenHeight * 0.05
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.07
                ),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text('Order Placed',
                      style: TextStyle(
                          fontSize: screenSize * 0.02,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text('Your order has been placed, you will receive an email shortly!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: screenSize * 0.012,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFF808080)
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Positioned(
            bottom: screenHeight * 0.045,
            left: screenWidth * 0.06,
            right: screenWidth * 0.06,
            child: Container(
              height: screenHeight * 0.058,
              child: ElevatedButton(
                onPressed: () => Get.offAll(() => const Hub(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 300)
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white
                ),
                child: Text('Continue',
                  style: TextStyle(
                      fontSize: screenSize * 0.013,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
