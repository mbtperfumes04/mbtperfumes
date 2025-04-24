import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mbtperfumes/customs/custom_body.dart';
import 'package:mbtperfumes/globals.dart';
import 'package:mbtperfumes/main.dart';
import 'package:mbtperfumes/models/product_model.dart';
import 'package:mbtperfumes/screens/auth/login_signup.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';

import '../../providers/cart_provider.dart';

class ProductView extends StatefulWidget {
  final ProductModel product;

  const ProductView({
    super.key,
    required this.product
  });

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  List<int> sizesButton = [];

  int selectedSize = 0;
  int initialQty = 1;

  bool isLoading = false;

  Widget infoBox({
    required Widget child
  }) => Expanded(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xfffbf0ef)
      ),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.022,
      ),
      child: child ,
    ),
  );

  @override
  void initState() {
    super.initState();

    sizesButton = widget.product.perfumeType == 'Basic' ? [10, 50, 85] : [150];

    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    if (cartProvider.items.any((item) => item.productId == widget.product.id)) {

    }
  }


  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          SlidingUpPanel(
            panelBuilder: () {
              return null;
            },
            minHeight: screenHeight * 0.53,
            maxHeight: screenHeight * 0.85,
            body: Column(
             children: [
               Container(
                 decoration: BoxDecoration(
                   color: Colors.red
                 ),
                 child: Container(
                   width: screenWidth,
                   height: screenHeight * 0.5,
                   decoration: BoxDecoration(
                       color: Colors.red,
                       image: DecorationImage(
                           image: NetworkImage(widget.product.images?[0] ?? ''),
                           fit: BoxFit.cover
                       )
                   ),
                 ),
               ),
             ],
           ),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30)
            ),
            backdropOpacity: 0.8,
            backdropColor: Colors.black,
             header: Container(
               child: Column(
                 children: [
                   Container(
                      width: screenWidth,
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.05,
                        right: screenWidth * 0.05,
                        top: screenHeight * 0.02
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            infoBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(widget.product.perfumeType == 'Basic' ? '10, 50, 85': "150",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w300
                                    ),
                                  ),
                                  Text('ml',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600
                                    ),)
                                ],
                              )
                            ),
                            SizedBox(width: screenWidth * 0.05),
                            infoBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('10%',
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.045,
                                          fontWeight: FontWeight.w300
                                      ),
                                    ),
                                    Text('Oil Con.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600
                                      ),),
                                  ],
                                )
                            ),
                            SizedBox(width: screenWidth * 0.05),
                            infoBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('4.3',
                                          style: TextStyle(
                                              fontSize: screenWidth * 0.045,
                                              fontWeight: FontWeight.w300
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.01),
                                        Icon(Icons.star,
                                          size: screenWidth * 0.04,
                                          color: Colors.orange,
                                        )
                                      ],
                                    ),
                                    Text('ratings',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600
                                    ),),
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                   Container(
                     width: screenWidth,
                     padding: EdgeInsets.only(
                       left: screenWidth * 0.05,
                       right: screenWidth * 0.05,
                       top: screenHeight * 0.04
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Expanded(
                           child: Text(widget.product.name,
                           maxLines: 2,
                           overflow: TextOverflow.ellipsis,
                           style: TextStyle(
                             fontSize: screenWidth * 0.055,
                             fontWeight: FontWeight.w600
                           ),),
                         ),
                         Text('₱${widget.product.price}',
                           style: TextStyle(
                               fontSize: screenWidth * 0.055,
                               fontWeight: FontWeight.w600
                           ),),
                       ],
                     ),
                   ),
                   Container(
                     width: screenWidth,
                     padding: EdgeInsets.symmetric(
                       horizontal: screenWidth * 0.05,
                       vertical: screenHeight * 0.015
                     ),
                     alignment: Alignment.topLeft,
                     child: Text(widget.product.desc,
                     style: TextStyle(
                       fontSize: screenWidth * 0.04,
                       letterSpacing: 0.5,
                       color: const Color(0xff808080)
                     ),),
                   ),
                   Container(
                     width: screenWidth,
                     margin: EdgeInsets.only(
                       top: screenHeight * 0.02
                     ),
                     decoration: BoxDecoration(
                       border: Border(
                         top: BorderSide(
                           color: Colors.grey,
                           width: 0.2
                         )
                       )
                     ),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         SizedBox(height: screenHeight * 0.02),
                         Padding(
                           padding: EdgeInsets.symmetric(
                             horizontal: screenWidth * 0.05
                           ),
                           child: Text('Choose your preferred bottle size',
                             style: TextStyle(
                               color: const Color(0xFF808080)
                             ),
                           ),
                         ),
                         SizedBox(height: screenHeight * 0.01),
                         Container(
                           height: screenHeight * 0.05,
                           width: screenWidth,
                           child: ListView.builder(
                             itemCount: sizesButton.length,
                             shrinkWrap: true,
                             scrollDirection: Axis.horizontal,
                             itemBuilder: (context, index) {
                               final size = sizesButton[index];

                               return InkWell(
                                 onTap: () {
                                   setState(() {
                                     selectedSize = index;
                                   });
                                 },
                                 child: Container(
                                   decoration: BoxDecoration(
                                     color: selectedSize == index ? Colors.black : Colors.grey.shade200,
                                     borderRadius: BorderRadius.circular(30)
                                   ),
                                   padding: EdgeInsets.symmetric(
                                     horizontal: screenWidth * 0.05
                                   ),
                                   margin: EdgeInsets.only(
                                     left: index == 0 ? screenWidth * 0.05 : screenWidth * 0.03
                                   ),
                                   alignment: Alignment.center,
                                   child: Text('$size ml',
                                     style: TextStyle(
                                       color: selectedSize == index ? Colors.white : Colors.black,
                                       fontSize: screenWidth * 0.035,
                                       fontWeight: selectedSize == index ? FontWeight.w600 : FontWeight.w300
                                     ),
                                   ),
                                 ),
                               );
                             },
                           ),
                         )
                       ],
                     )
                   ),

                 ],
               ),
             ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: screenHeight * 0.08,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white
                      ),
                        padding: EdgeInsets.all(screenWidth * 0.025),
                        child: Icon(Icons.arrow_back)
                    
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                bottom: screenHeight * 0.05
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: .5
                          ),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.015
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: (){
                              if (initialQty > 1){
                                setState(() {
                                  initialQty--;
                                });
                              }
                            },
                            child: Icon(Icons.remove,
                              size: screenWidth * 0.07,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04
                            ),
                            child: Text(initialQty.toString(),
                              style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.w300
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              setState(() {
                                initialQty++;
                              });
                            },
                            child: Icon(Icons.add,
                              size: screenWidth * 0.07,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final user = supabase.auth.currentUser;

                          if (user == null) {
                            Get.to(() => LoginSignup());
                            return;
                          }

                          final selectedMl = sizesButton[selectedSize];
                          final totalPrice = widget.product.price * initialQty;

                          setState(() => isLoading = true);

                          try {
                            await cartProvider.addItem(
                                productId: widget.product.id ?? '',
                                quantity: initialQty,
                                totalPrice: totalPrice,
                                userId: user.id,
                                size: selectedMl,
                                product: widget.product
                            );

                            Get.snackbar('Success', 'Added to cart!',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green.shade600,
                              colorText: Colors.white,
                            );
                          } catch (e) {
                            print(e);
                            Get.snackbar('Error', 'Failed to add to cart',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red.shade600,
                              colorText: Colors.white,
                            );
                          } finally {
                            setState(() => isLoading = false);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined,
                                size: screenWidth * 0.04,
                                color: Colors.white,
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Text('Add to cart',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.04
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ),
            ),
          )
        ],
      ),
    );
  }
}
