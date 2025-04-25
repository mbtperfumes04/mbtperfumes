import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../globals.dart';
import '../../../providers/custom_product_provider.dart';

class CustomStage4 extends StatefulWidget {
  const CustomStage4({super.key});

  @override
  State<CustomStage4> createState() => _CustomStage4State();
}

class _CustomStage4State extends State<CustomStage4> {
  @override
  Widget build(BuildContext context) {
    final customProductProvider = Provider.of<CustomProductProvider>(context);


    String topNotes = customProductProvider.selectedScents
        .where((scent) => scent.noteType == 'Top')
        .map((scent) => scent.scent.name)
        .join(', ');

    String middleNotes = customProductProvider.selectedScents
        .where((scent) => scent.noteType == 'Middle')
        .map((scent) => scent.scent.name)
        .join(', ');

    String baseNotes = customProductProvider.selectedScents
        .where((scent) => scent.noteType == 'Base')
        .map((scent) => scent.scent.name)
        .join(', ');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: screenHeight,
        child: ListView(
          children: [
            Column(
              children: [
                Text(
                  'Almost Finish!',
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Text(
                    "Review your custom order and if you're done, you many now proceed to payment section.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.033,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF808080),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            Container(
              child: Stack(
                children: [
                  Container(
                    width: screenWidth,
                    // color: Colors.red,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.05
                    ),
                    child: SvgPicture.asset('assets/svgs/products/perfume-custom.svg',
                      width: screenWidth * 0.5,
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.05,
                    bottom: screenWidth * 0.05,
                    right: 0,
                    top: 0,
                    child: Row(
                      children: [
                        Container(
                          width: screenWidth * 0.9,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          offset: Offset(0, 0),
                                          blurRadius: 5,
                                          spreadRadius: 3
                                      )
                                    ]
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.03,
                                    vertical: screenHeight * 0.01
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(topNotes,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    Text('Top Note',
                                      style: TextStyle(
                                          color: const Color(0xFF808080),
                                          fontSize: screenWidth * 0.03,
                                          fontWeight: FontWeight.w400
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          offset: Offset(0, 0),
                                          blurRadius: 5,
                                          spreadRadius: 3
                                        )
                                      ]
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.03,
                                      vertical: screenHeight * 0.01
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(middleNotes,
                                          style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontSize: screenWidth * 0.04,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        Text('Middle Note',
                                          style: TextStyle(
                                              color: const Color(0xFF808080),
                                              fontSize: screenWidth * 0.03,
                                              fontWeight: FontWeight.w400
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          offset: Offset(0, 0),
                                          blurRadius: 5,
                                          spreadRadius: 3
                                      )
                                    ]
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.03,
                                    vertical: screenHeight * 0.01
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(baseNotes,
                                      style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontSize: screenWidth * 0.04,
                                          fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    Text('Base Note',
                                      style: TextStyle(
                                          color: const Color(0xFF808080),
                                          fontSize: screenWidth * 0.03,
                                          fontWeight: FontWeight.w400
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              child: Column(
                children: [
                  Text(customProductProvider.customName,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.055
                    ),
                  ),
                  Text('Perfume Name',
                    style: TextStyle(
                        color: const Color(0xFF808080),
                        fontWeight: FontWeight.w300,
                        fontSize: screenWidth * 0.03
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Container(
              child: Column(
                children: [
                  Container(
                    height: screenHeight * 0.13,
                    margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                    child: ListView.builder(
                      itemCount: customProductProvider.selectedSizes.length,
                      scrollDirection: Axis.horizontal,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final sizeQty = customProductProvider.selectedSizes[index];

                        bool isLast = customProductProvider.selectedSizes.length == (index + 1);

                        return Container(
                          margin: EdgeInsets.only(
                            left: index == 0 ? screenWidth * 0.35 : screenWidth * 0.03,
                            right: isLast ? screenWidth * 0.05 : 0
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(15)
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.025,
                            vertical: screenHeight * 0.015
                          ),
                          constraints: BoxConstraints(
                            minWidth: screenWidth * 0.3
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    Text('${sizeQty.size} ml',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: screenWidth * 0.05
                                      ),
                                    ),
                                    Text('Qty: ${sizeQty.quantity}',
                                      style: TextStyle(
                                          color: const Color(0xFF808080),
                                          fontWeight: FontWeight.w300,
                                          fontSize: screenWidth * 0.033
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(30)
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.03
                                ),
                                child: Text('₱${((sizeQty.size * 8) * sizeQty.quantity).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600
                                  ),
                                )
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Text('Quantities / Sizes',
                    style: TextStyle(
                        color: const Color(0xFF808080),
                        fontWeight: FontWeight.w300,
                        fontSize: screenWidth * 0.03
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.13),
          ],
        ),
      ),
    );
  }
}
