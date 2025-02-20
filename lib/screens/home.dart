import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../customs/custom_body.dart';
import '../globals.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
    removeSplash();

  }

  void removeSplash() async {
    await Future.delayed(Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.green
            ),
            padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              bottom: screenHeight * 0.02,
              top: screenHeight * 0.07
            ),
            margin: EdgeInsets.only(bottom: screenHeight * 0.014),
            child: Row(
              children: [
                Container(
                  height: screenSize * 0.05,
                  width: screenSize * 0.05,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/images/general/profilepic.jpeg'),
                      fit: BoxFit.cover
                    )
                  ),
                ),
                Column(
                  children: [
                    Text('test'),
                    Text('test2yhygygy')
                  ],
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
