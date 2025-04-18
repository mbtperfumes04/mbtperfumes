import 'package:flutter/material.dart';
import '../globals.dart';

class CustomBody extends StatefulWidget {
  final List<Widget> children;
  final SliverAppBar? appBar;
  final bool isGradient; // NEW

  const CustomBody({
    super.key,
    required this.children,
    this.appBar,
    this.isGradient = true, // default true
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
      decoration: widget.isGradient
          ? BoxDecoration(
        gradient: RadialGradient(
          colors: const [
            Color(0xFFE6BDA4),
            Color(0xFFF3D6C3),
            Color(0xFFFFE6D0),
            Color(0xFFFFF2E5),
            Color(0xFFFDEDE2),
          ],
          center: const Alignment(0.0, -0.4),
          radius: 1.8,
          stops: const [0.1, 0.3, 0.5, 0.7, 1.0],
        ),
      )
          : const BoxDecoration(
        color: Color(0xFFF6F0DE),
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
      ),
    );
  }
}
