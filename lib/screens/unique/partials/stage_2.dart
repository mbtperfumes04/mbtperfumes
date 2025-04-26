import 'package:flutter/material.dart';
import 'package:mbtperfumes/models/custom_product_model.dart';
import 'package:mbtperfumes/providers/custom_product_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../globals.dart';

class CustomStage2 extends StatefulWidget {
  const CustomStage2({super.key});

  @override
  State<CustomStage2> createState() => _CustomStage2State();
}

class _CustomStage2State extends State<CustomStage2> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final customProductProvider = Provider.of<CustomProductProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (customProductProvider.selectedSizes.isEmpty) {
        customProductProvider.addSize(CustomSizeItem(
          id: const Uuid().v4(),
          size: 10,
          quantity: 1,
        ));
      }
    });

    if (customProductProvider.selectedSizes.isEmpty) {
      return const SizedBox();
    }

    final selectedSizeItem = customProductProvider.selectedSizes[selectedIndex];


    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: screenHeight,
        child: ListView(
          children: [
            Column(
              children: [
                Text(
                  'Sizes Selection',
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Text(
                    "You may have multiple sizes that you want to order for this custom product.",
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
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(right: screenWidth * 0.04),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: screenHeight * 0.055,
                          child: ListView.builder(
                            itemCount: customProductProvider.selectedSizes.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final size = customProductProvider.selectedSizes[index];
                              final isSelected = selectedIndex == index;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                                  margin: EdgeInsets.only(
                                      left: index == 0 ? screenWidth * 0.05 : screenWidth * 0.03),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        margin: EdgeInsets.only(right: screenWidth * 0.02),
                                        width: screenWidth * 0.05,
                                        alignment: Alignment.center,
                                        child: Text(
                                          size.quantity.toString(),
                                          style: TextStyle(
                                            color: isSelected
                                                ? Theme.of(context).colorScheme.primary
                                                : Colors.grey.shade300,
                                            fontSize: screenWidth * 0.04,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${size.size} ml',
                                        style: TextStyle(
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          fontSize: screenWidth * 0.038,
                                          color: isSelected ? Colors.white : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              int tempSize = 0;
                              return AlertDialog(
                                title: const Text("Add Size"),
                                content: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(hintText: "Enter size in ml"),
                                  onChanged: (value) {
                                    tempSize = int.tryParse(value) ?? 10;
                                  },
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (tempSize > 0) {

                                        tempSize = tempSize < 10 ? 10 : tempSize;

                                        tempSize = tempSize > 150 ? 150 : tempSize;

                                        customProductProvider.addSize(CustomSizeItem(
                                          id: const Uuid().v4(),
                                          size: tempSize,
                                          quantity: 1,
                                        ));
                                        Navigator.pop(context);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.primary
                                    ),
                                    child: Text("Add",
                                      style: TextStyle(
                                        color: Colors.white
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          margin: EdgeInsets.only(left: screenWidth * 0.04),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: screenWidth * 0.07,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.05),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              int tempQuantity = selectedSizeItem.quantity;
                              return Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text("Enter Quantity"),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) {
                                        tempQuantity = int.tryParse(val) ?? tempQuantity;
                                      },
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (tempQuantity > 0) {
                                          final updated = selectedSizeItem.copyWith(
                                            quantity: tempQuantity,
                                          );
                                          customProductProvider.updateSize(updated);
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text("Update"),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          'Quantity: ${selectedSizeItem.quantity}',
                          style: TextStyle(fontSize: screenWidth * 0.04),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                selectedSizeItem.size.toString(),
                                style: TextStyle(
                                  fontSize: screenWidth * 0.2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'ml',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.032,
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            ],
                          ),
                          Positioned(
                            left: screenWidth * 0.15,
                            right: screenWidth * 0.15,
                            top: 0,
                            bottom: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    final updated = selectedSizeItem.copyWith(
                                      size: (selectedSizeItem.size - 10).clamp(10, 150),
                                    );
                                    customProductProvider.updateSize(updated);
                                  },
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary.withAlpha(100),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: EdgeInsets.all(screenWidth * 0.015),
                                    child: const Icon(Icons.remove, color: Colors.white),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: screenHeight * 0.11
                                  ),
                                  child: Text('Size',
                                    style: TextStyle(
                                      color: const Color(0xFF808080),
                                      fontSize: screenWidth * 0.037
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {

                                    int size = 0;
                                    if(selectedSizeItem.size > 140) {
                                      size = 150;
                                    } else {
                                      size = selectedSizeItem.size + 10;
                                    }

                                    final updated = selectedSizeItem.copyWith(
                                      size: size,
                                    );
                                    customProductProvider.updateSize(updated);
                                  },
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: EdgeInsets.all(screenWidth * 0.015),
                                    child: const Icon(Icons.add, color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  int tempQty = selectedSizeItem.quantity;

                                  showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        title: const Text("Edit Quantity"),
                                        content: TextField(
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(hintText: "Enter new quantity"),
                                          onChanged: (value) {
                                            tempQty = int.tryParse(value) ?? tempQty;
                                          },
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              if (tempQty > 0) {
                                                final updated = selectedSizeItem.copyWith(quantity: tempQty);
                                                customProductProvider.updateSize(updated);
                                                Navigator.pop(context);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context).colorScheme.primary,
                                            ),
                                            child: const Text("Update", style: TextStyle(color: Colors.white)),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.014
                                  ),
                                  margin: EdgeInsets.only(
                                    right: customProductProvider.selectedSizes.length > 1 ?
                                      screenWidth * 0.01 : 0
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Edit Quantity',
                                        style: TextStyle(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontSize: screenWidth * 0.034,
                                            fontWeight: FontWeight.w500
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if(customProductProvider.selectedSizes.length > 1)
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if(customProductProvider.selectedSizes.length == 1) {
                                    return;
                                  }

                                  customProductProvider.removeSize(selectedSizeItem.id);

                                  setState(() {
                                    if (selectedIndex > 0) {
                                      selectedIndex--;
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.014
                                  ),
                                  margin: EdgeInsets.only(left: screenWidth * 0.01),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Remove',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenWidth * 0.034,
                                            fontWeight: FontWeight.w500
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      Container(
                        child: Column(
                          children: [
                            Text('Current Pricing Rate:',
                              style: TextStyle(
                                color: const Color(0xFF808080)
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('₱$perMlPrice per ml',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
