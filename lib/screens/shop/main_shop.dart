import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:mbtperfumes/customs/custom_body.dart';
import 'package:mbtperfumes/customs/widgets/custom_product_card.dart';
import 'package:mbtperfumes/globals.dart';
import 'package:mbtperfumes/providers/product_provider.dart';
import 'package:mbtperfumes/screens/cart/cart.dart';
import 'package:mbtperfumes/screens/shop/product_view.dart';
import 'package:provider/provider.dart';
import 'package:segmented_button_slide/segmented_button_slide.dart';

class MainShop extends StatefulWidget {

  const MainShop({
    super.key
  });

  @override
  State<MainShop> createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  final menus = ValueNotifier('basic');

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          CustomBody(
            appBar: SliverAppBar(
              backgroundColor: const Color(0xFFf9efef),
              scrolledUnderElevation: 0,
              title: Text(('Shop')),
              centerTitle: true,
              actions: [
                InkWell(
                    onTap: () {
                      print('Filtering');
                    },
                    child: Icon(Icons.filter_list_rounded)),
                SizedBox(width: screenWidth * 0.05)
              ],
            ),
            children: [
              Container(
                width: screenWidth,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)
                ),
                margin: EdgeInsets.only(
                    left: screenWidth * 0.03,
                    right: screenWidth * 0.03,
                    top: screenHeight * 0.02
                ),
                child: AdvancedSegment(
                  controller: menus, // 👈 Pass the controller here
                  segments: { // Map<String, String>
                    'basic': 'Basic',
                    'premium': 'Premium',
                  },
                  activeStyle: TextStyle( // TextStyle
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.038,
                      fontFamily: 'Poppins'
                  ),
                  inactiveStyle: TextStyle( // TextStyle
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: screenWidth * 0.035,
                      fontFamily: 'Poppins'
                  ),
                  sliderDecoration: BoxDecoration(
                      color: const Color(0xffad2d2f),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  backgroundColor: Colors.transparent, // Color
                  sliderColor: Colors.white, // Color
                  sliderOffset: 4.0, // Double
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)), // BorderRadius
                  itemPadding: EdgeInsets.symmetric( // EdgeInsets
                    horizontal: 15,
                    vertical: screenHeight * 0.015,
                  ),
                  animationDuration: Duration(milliseconds: 250),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.03,
                      right: screenWidth * 0.03,
                      top: screenHeight * 0.03
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: menus,
                    builder: (context, menuVal, child) {
                      return StaggeredGrid.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: screenHeight * 0.02,
                          crossAxisSpacing: screenWidth * 0.04,
                          children: productProvider.products.where((prod) {
                            bool isSelected = prod.perfumeType.toLowerCase() == menuVal.toLowerCase();

                            return isSelected;
                          }).toList().asMap().entries.map((entry) {
                            final index = entry.key;
                            final product = entry.value;

                            return InkWell(
                              onTap: () => Get.to(() => ProductView(product: product)),
                              child: PerfumeCard(
                                  name: product.name,
                                  price: product.price,
                                  imagePath: product.images?.first ?? '',
                                  bgColor: Colors.white
                              ),
                            );
                          }).toList()
                      );
                    },
                  )
              )
            ],
          ),
          Positioned(
            bottom: screenHeight * 0.06,
            right: screenWidth * 0.06,
            child: InkWell(
              onTap: () => Get.to(() => const Cart()),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle
                ),
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Icon(Icons.shopping_cart,
                  color: Colors.white,
                  size: screenWidth * 0.07,
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}
