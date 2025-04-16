import 'package:flutter/material.dart';

import '../../globals.dart';

class PerfumeCard extends StatefulWidget {
  final String name;
  final double price;
  final double? oldPrice;
  final String imagePath;
  final Color bgColor;

  const PerfumeCard({
    super.key,
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
                    child: Image.network(widget.imagePath,
                      fit: BoxFit.cover,
                    ),
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
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text('₱${widget.oldPrice}',
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                      fontSize: screenWidth * 0.03,
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
            child: Container(
              padding: EdgeInsets.all(screenSize * 0.005),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white
              ),
              alignment: Alignment.center,
              child: Icon(Icons.favorite,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }
}
