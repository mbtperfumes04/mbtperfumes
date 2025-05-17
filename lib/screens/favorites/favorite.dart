import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbtperfumes/customs/custom_body.dart';
import 'package:mbtperfumes/globals.dart';
import 'package:mbtperfumes/main.dart';
import 'package:mbtperfumes/providers/favorite_product_provider.dart';
import 'package:mbtperfumes/providers/product_provider.dart';
import 'package:provider/provider.dart';

import '../shop/product_view.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  String processingId = '';
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final favoriteProvider = Provider.of<FavoriteProductProvider>(context);

    final productFavorites = productProvider.products.where((prod) => favoriteProvider.favorites.any((fav) => fav.productId == prod.id)).toList();


    return Scaffold(
      body: CustomBody(
        appBar: SliverAppBar(
          title: Text('Favorites'),
        ),
        children: productFavorites.isNotEmpty ? productFavorites.asMap().entries.map((entry) {
          final index = entry.key;
          final product = entry.value;

          return InkWell(
            onTap: processingId.isEmpty ? () => Get.to(() => ProductView(product: product)) : null,
            child: Container(
              margin: EdgeInsets.only(
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                top: screenHeight * 0.02
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12)
              ),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03,
                vertical: screenHeight * 0.012
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(product.images?[0] ?? '')
                            ),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        width: screenWidth * 0.14,
                        height: screenWidth * 0.14,
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Container(
                        width: screenWidth * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenSize * 0.012
                              ),
                            ),
                            Text('₱ ${product.price}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: screenSize * 0.01
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            if(processingId == product.id) return;
                            setState(() {
                              processingId = product.id.toString();
                            });

                            print('Set to: $processingId');

                            final favoriteId = favoriteProvider.favorites.where((fav) => fav.productId == product.id).firstOrNull;

                            if(favoriteId != null) {
                              await favoriteProvider.removeFavorite(favoriteId.id ?? '');
                            }

                            setState(() {
                              processingId = '';
                            });
                          },
                          child: processingId == product.id ? CupertinoActivityIndicator() :Icon(Icons.favorite,
                            color: Colors.red,
                            size: screenSize * 0.023,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList() : [

        ],
      ),
    );
  }
}
