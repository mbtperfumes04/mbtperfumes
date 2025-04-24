import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbtperfumes/models/product_model.dart';
import 'package:mbtperfumes/providers/favorite_product_provider.dart';
import 'package:provider/provider.dart';

import '../../globals.dart';

class PerfumeCard extends StatefulWidget {
  final ProductModel product;
  final String name;
  final double price;
  final double? oldPrice;
  final String? imagePath;
  final Color bgColor;

  const PerfumeCard({
    super.key,
    required this.product,
    required this.name,
    required this.price,
    this.oldPrice,
    required this.imagePath,
    required this.bgColor
  });

  @override
  State<PerfumeCard> createState() => _PerfumeCardState();
}

class _PerfumeCardState extends State<PerfumeCard> {
  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProductProvider>(context);

    return Container(
      height: screenHeight * 0.32,
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: screenWidth,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: widget.imagePath != null ? Image.network(widget.imagePath ?? '',
                      fit: BoxFit.cover,
                    ) : Container(
                      color: Colors.grey.shade200,
                      padding: EdgeInsets.all(screenWidth * 0.15),
                      child: SvgPicture.asset('assets/svgs/products/perfume.svg',
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            const Color(0xFF808080), BlendMode.srcIn),
                      ),
                    )
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(widget.name,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.035
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              Row(
                children: [
                  Text('₱${widget.price}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF808080),
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                  if(widget.oldPrice != null)
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.02
                      ),
                      child: Text('₱${widget.oldPrice}',
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: screenWidth * 0.03,
                        ),
                      ),
                    )
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.025),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Icon(Icons.shopping_bag_outlined,
                    size: screenWidth * 0.05,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: screenWidth * 0.015,
            right: screenWidth * 0.015,
            child: InkWell(
              onTap: () async {
                if (favoriteProvider.favorites.any(
                        (favorite) => favorite.productId == widget.product.id
                )) {
                  print('1');

                  final favoriteId = favoriteProvider.favorites.where((fav) => fav.productId == widget.product.id).firstOrNull;

                  if(favoriteId != null) {
                    favoriteProvider.removeFavorite(favoriteId.id ?? '');
                  }
                } else {
                  favoriteProvider.addFavorite(productId: widget.product.id.toString(), product: widget.product);
                }
              },
              child: Container(
                padding: EdgeInsets.all(screenSize * 0.005),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white
                ),
                alignment: Alignment.center,
                child: Icon(Icons.favorite,
                  color: favoriteProvider.favorites.any(
                          (favorite) => favorite.productId == widget.product.id
                  ) ? Colors.red : Colors.grey,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
