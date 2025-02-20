import 'package:flutter/material.dart';

import '../globals.dart';

class CustomBody extends StatefulWidget {
  final List<Widget> children;
  const CustomBody({super.key, required this.children});

  @override
  State<CustomBody> createState() => _CustomBodyState();
}

class _CustomBodyState extends State<CustomBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight,
      width: screenWidth,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                const Color(0xffF6F0DE),
                const Color(0xffA69186)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
          )
      ),
      child: Column(
        children: widget.children,
      ),
    );
  }
}
