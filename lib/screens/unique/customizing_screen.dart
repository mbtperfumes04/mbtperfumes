import 'package:flutter/material.dart';
import 'package:mbtperfumes/customs/custom_body.dart';
import 'package:mbtperfumes/globals.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class CustomizingScreen extends StatefulWidget {
  const CustomizingScreen({super.key});

  @override
  State<CustomizingScreen> createState() => _CustomizingScreenState();
}

class _CustomizingScreenState extends State<CustomizingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        isGradient: false,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: screenHeight * 0.1
            ),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.23
            ),
            child: StepProgressIndicator(
              totalSteps: 3,
              currentStep: 1,
              padding: screenWidth * 0.01,
              selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 1),
              unselectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              roundedEdges: Radius.circular(30),

              size: screenHeight * 0.008,
            ),
          ),
        ],
      ),
    );
  }
}
