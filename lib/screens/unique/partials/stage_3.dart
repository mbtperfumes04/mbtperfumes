import 'package:flutter/material.dart';
import 'package:mbtperfumes/globals.dart';
import 'package:mbtperfumes/providers/custom_product_provider.dart';
import 'package:provider/provider.dart';

class CustomStage3 extends StatefulWidget {
  const CustomStage3({super.key});

  @override
  State<CustomStage3> createState() => _CustomStage3State();
}

class _CustomStage3State extends State<CustomStage3> {
  final TextEditingController _customName = TextEditingController();
  bool onInitialized = false;

  @override
  void initState() {
    super.initState();

    final customProductProvider =Provider.of<CustomProductProvider>(context, listen: false);

    _customName.text = customProductProvider.customName;
  }

  @override
  Widget build(BuildContext context) {
    final customProductProvider = Provider.of<CustomProductProvider>(context);



    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: screenHeight,
        child: ListView(
          children: [
            Column(
              children: [
                Text(
                  'Name Customization',
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Text(
                    "Every custom perfume deserves a name. \nChoose something bold, sweet, or mysterious to match your unique creation.",
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
            Center(
              child: Container(
                width: screenWidth * 0.8, // Adjust as needed (e.g. 90% of screen)
                height: screenHeight * 0.06,
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                ),
                child: TextFormField(
                  controller: _customName,
                  keyboardType: TextInputType.name,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                  ),
                  onChanged: (val) {
                    customProductProvider.setCustomName(val.trim());
                  },
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Name Your Perfume',
                    hintStyle: TextStyle(
                      color: Color(0xff808080),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
