import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mbtperfumes/customs/custom_body.dart';
import 'package:mbtperfumes/providers/cart_provider.dart';
import 'package:mbtperfumes/screens/cart/payments/paypal.dart';
import 'package:mbtperfumes/screens/shop/edit_product_view.dart';
import 'package:mbtperfumes/screens/shop/main_shop.dart';
import 'package:provider/provider.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

import '../../globals.dart';

class TitleValue extends StatefulWidget {
  final String title;
  final String value;
  const TitleValue({super.key,
    required this.title,
    required this.value
  });

  @override
  State<TitleValue> createState() => _TitleValueState();
}

class _TitleValueState extends State<TitleValue> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title),
          Text(widget.value)
        ],
      ),
    );
  }
}

class PaymentMethods {
  final int id;
  final String title;
  final String svgIcon;

  const PaymentMethods({
    required this.id,
    required this.title,
    required this.svgIcon
  });
}

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final ScrollController _scrollController = ScrollController();
  List<PaymentMethods> paymentMethods = [];
  int selectedPayment = -1;

  @override
  void initState() {
    super.initState();
    paymentMethods = [
      PaymentMethods(id: 0, title: 'Paypal', svgIcon: 'assets/svgs/payments/paypal.svg'),
      // PaymentMethods(id: 1, title: 'GCash'),
      // PaymentMethods(id: 2, title: 'Credit Card'),
    ];
  }

  void selectPaymentMethod(int selectedId) {
    setState(() {
      selectedPayment = selectedId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    double totalPrice = cartProvider.items.fold(0, (sum, item) => sum + item.totalPrice);

    return Scaffold(
      body: Stack(
        children: [
          CustomBody(
            appBar: SliverAppBar(
              backgroundColor: Colors.transparent,
              scrolledUnderElevation: 0,
              title: Text('My Cart'),
            ),
            isGradient: false,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                margin: EdgeInsets.only(top: screenHeight * 0.03),
                constraints: BoxConstraints(minHeight: screenHeight),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05
                      ),
                      margin: EdgeInsets.only(
                        top: screenHeight * 0.02,
                        bottom: screenHeight * 0.01
                      ),
                      // color: Colors.green,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cart Items',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.05,
                            ),
                          ),
                          InkWell(
                            onTap: () => Get.to(() => const MainShop()),
                            child: Text('Add items',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth * 0.04
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: ListView.builder(
                        itemCount: cartProvider.items.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final cart = cartProvider.items[index];
                          final product = cartProvider.prodRefOfCartItems.where((prod) => prod.id == cart.productId).first;
                          return InkWell(
                            onTap: () => Get.to(() => EditCartItem(product: product, cart: cart)),
                            child: Container(
                              margin: EdgeInsets.only(
                                left: screenWidth * 0.05,
                                right: screenWidth * 0.05,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.015,
                                horizontal: screenWidth * 0.04,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade200,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: screenWidth * 0.13,
                                        height: screenWidth * 0.13,
                                        margin: EdgeInsets.only(right: screenWidth * 0.04),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(7),
                                          child: Image.network(product.images?[0] ?? '', fit: BoxFit.cover),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: screenWidth * 0.038,
                                            ),
                                          ),
                                          Text(
                                            "${product.perfumeType} - ${cart.size} ml",
                                            style: TextStyle(
                                              color: const Color(0xFF808080),
                                              fontSize: screenWidth * 0.032,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('₱ ${cart.totalPrice}'),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.02,
                                          vertical: screenHeight * 0.005,
                                        ),
                                        child: Text(cart.quantity.toString()),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Column(
                        children: [
                          TitleValue(title: 'Subtotal', value: '₱${totalPrice.toStringAsFixed(2)}'),
                          TitleValue(title: 'Delivery Fee', value: '₱0.00'),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      width: screenWidth,
                      height: screenHeight * 0.02,
                      color: const Color(0xFFF8F8FF),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Method',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.05,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          ListView.builder(
                            itemCount: paymentMethods.length,
                            shrinkWrap: true,
                            controller: _scrollController,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final payment = paymentMethods[index];
                              return InkWell(
                                onTap: () => selectPaymentMethod(payment.id),
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.018,
                                    horizontal: screenWidth * 0.04,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selectedPayment == payment.id
                                        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    border: selectedPayment == payment.id
                                        ? Border.all(
                                      color: Theme.of(context).colorScheme.primary,
                                      width: 2,
                                    )
                                        : Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(payment.svgIcon,
                                        width: screenWidth * 0.07,
                                      ),
                                      SizedBox(width: screenWidth * 0.03),
                                      Text(
                                        payment.title,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.037,
                                          color: selectedPayment == payment.id ?
                                              Colors.red.shade900 : Colors.black,
                                          fontWeight: selectedPayment == payment.id ?
                                              FontWeight.w600 : FontWeight.w400
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.2)
                  ],
                ),
              )
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: screenWidth * 0.06,
                right: screenWidth * 0.06,
                top: screenWidth * 0.04,
                bottom: screenHeight * 0.045,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade100,
                    offset: Offset(0, -1),
                    spreadRadius: 15,
                    blurRadius: 30
                  )
                ],
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15)
                )
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(fontSize: screenWidth * 0.04),
                      ),
                      Text(
                        '₱${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: screenWidth * 0.04),
                      )
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    width: screenWidth,
                    height: screenHeight * 0.06,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: cartProvider.items.isNotEmpty ? () {
                        if (selectedPayment == 0) {
                          Get.to(() => PaypalPayment());
                        }
                      } : null,
                      child: Text(
                        "Place Order",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

