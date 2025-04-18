import 'package:flutter/material.dart';
import 'package:mbtperfumes/customs/custom_body.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        appBar: SliverAppBar(
          backgroundColor: const Color(0xFFf9efef),
          scrolledUnderElevation: 0,
          title: Text('My Cart'),
        ),
        children: [

        ],
      ),
    );
  }
}
