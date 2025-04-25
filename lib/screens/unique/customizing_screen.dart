import 'package:flutter/material.dart';
import 'package:mbtperfumes/customs/custom_body.dart';
import 'package:mbtperfumes/globals.dart';
import 'package:mbtperfumes/providers/custom_product_provider.dart';
import 'package:mbtperfumes/providers/notes_scent_provider.dart';
import 'package:mbtperfumes/screens/unique/partials/stage_4.dart';
import 'package:mbtperfumes/screens/unique/partials/stage_1.dart';
import 'package:mbtperfumes/screens/unique/partials/stage_2.dart';
import 'package:mbtperfumes/screens/unique/partials/stage_3.dart';
import 'package:mbtperfumes/screens/unique/partials/stage_5.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class CustomizingScreen extends StatefulWidget {
  const CustomizingScreen({super.key});

  @override
  State<CustomizingScreen> createState() => _CustomizingScreenState();
}

class _CustomizingScreenState extends State<CustomizingScreen> {
  final PageController _pageController = PageController();
  int selectedStage = 0;

  late CustomProductProvider _customProductProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _customProductProvider = Provider.of<CustomProductProvider>(
      context,
      listen: false,
    );
  }

  @override
  void dispose() {
    print('Quitting');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _customProductProvider.clearScents();
      _customProductProvider.clearSizes();
      _customProductProvider.clearCustomName();
      _customProductProvider.clearPaymentMethods();
    });
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final customProductProvider = Provider.of<CustomProductProvider>(context, listen: false);

      if (customProductProvider.availablePaymentMethods.isEmpty) {
        customProductProvider.initData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final notesScentProvider = Provider.of<NotesScentsProvider>(context);
    final customProductProvider = Provider.of<CustomProductProvider>(context);

    final hasAllNoteTypes = ['Top','Middle','Base']
        .every((type) => customProductProvider.selectedScents
        .any((scent) => scent.noteType == type));

    final hasSizeSelected = customProductProvider.selectedSizes.isNotEmpty;
    final hasCustomName = customProductProvider.customName.isNotEmpty;

    final hasSelectedPaymentMethod = customProductProvider.selectedPaymentMethod.isNotEmpty;

    bool isStageValid() {
      switch (selectedStage) {
        case 0: return hasAllNoteTypes;
        case 1: return hasSizeSelected;
        case 2: return hasCustomName;
        case 4: return hasSelectedPaymentMethod;
        default: return true;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: screenHeight,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: screenHeight * 0.1
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.18
                  ),
                  child: StepProgressIndicator(
                    totalSteps: 5,
                    currentStep: selectedStage +  1,
                    onTap: (val) {
                      return () {

                        if(val > selectedStage) {
                          return;
                        }

                        setState(() {
                          selectedStage = val;
                        });

                        _pageController.animateToPage(
                            selectedStage,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut
                        );
                      };
                    },
                    padding: screenWidth * 0.01,
                    selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 1),
                    unselectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    roundedEdges: Radius.circular(30),
                    size: screenHeight * 0.008,
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (val) {
                      setState(() {
                        selectedStage = val;
                      });
                    },
                    children: [
                      const CustomStage1(),
                      const CustomStage2(),
                      const CustomStage3(),
                      const CustomStage4(),
                      const CustomStage5()
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              bottom: screenHeight * 0.06,
              left: screenWidth * 0.08,
              right: screenWidth * 0.08,
              child: ElevatedButton(
                onPressed: isStageValid() ? () async {
                  if(selectedStage != 4) {

                    setState(() {
                      selectedStage++;
                    });

                    _pageController.animateToPage(
                        selectedStage,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut
                    );

                    return;
                  }
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.017
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(selectedStage == 4 ? 'Pay Now' : 'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.043,
                        fontWeight: FontWeight.w600
                      ),
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
