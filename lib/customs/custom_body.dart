import 'package:flutter/material.dart';
import '../globals.dart';

class CustomBody extends StatefulWidget {
  final List<Widget> children;
  final SliverAppBar? appBar;

  const CustomBody({
    super.key,
    required this.children,
    this.appBar
  });

  @override
  State<CustomBody> createState() => _CustomBodyState();
}

class _CustomBodyState extends State<CustomBody> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight,
      width: screenWidth,
      padding: EdgeInsets.only(
        bottom: screenHeight * 0.03
      ),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFFE6BDA4), // Warm beige
            Color(0xFFF3D6C3), // Soft peach
            Color(0xFFFFE6D0), // Light blush
            Color(0xFFFFF2E5), // Soft cream (adds glow)
            Color(0xFFFDEDE2), // Faint pinkish-white for aura effect
          ],
          center: Alignment(0.0, -0.4), // Higher up to make the aura glow near the top
          radius: 1.8, // Makes the gradient cover more area smoothly
          stops: [0.1, 0.3, 0.5, 0.7, 1.0], // Gradual transition
        ),
      ),
      child: CustomScrollView(
        controller: scrollController,
        key: GlobalKey(),
        slivers: [
          widget.appBar ?? SliverToBoxAdapter(),
          SliverToBoxAdapter(
            child: Column(
              children: widget.children,
            ),
          )
        ],
      )
    );
  }
}
