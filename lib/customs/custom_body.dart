import 'package:flutter/material.dart';
import '../globals.dart';

class CustomBody extends StatefulWidget {
  final List<Widget> children;
  final SliverAppBar? appBar;
  final Color? customBG;
  final bool isGradient;
  final ScrollController? externalScrollController;
  final MainAxisAlignment? mainAxisAlignment;

  const CustomBody({
    super.key,
    required this.children,
    this.appBar,
    this.customBG,
    this.isGradient = true,
    this.externalScrollController,
    this.mainAxisAlignment
  });

  @override
  State<CustomBody> createState() => _CustomBodyState();
}

class _CustomBodyState extends State<CustomBody> {
  late final ScrollController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = ScrollController();
  }

  @override
  void dispose() {
    // Only dispose if it's not externally provided
    if (widget.externalScrollController == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController controller =
        widget.externalScrollController ?? _internalController;

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
          : BoxDecoration(
        color: widget.customBG ?? const Color(0xFFF6F0DE),
      ),
      child: CustomScrollView(
        controller: controller,
        slivers: [
          widget.appBar ?? const SliverToBoxAdapter(),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.start,
              children: widget.children,
            ),
          ),
        ],
      ),
    );
  }
}
