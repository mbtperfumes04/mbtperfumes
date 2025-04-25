import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:mbtperfumes/main.dart';
import 'package:mbtperfumes/models/user_model.dart';
import 'package:mbtperfumes/providers/category_provider.dart';
import 'package:mbtperfumes/providers/product_provider.dart';
import 'package:mbtperfumes/screens/cart/cart.dart';
import 'package:mbtperfumes/screens/unique/customizing_screen.dart';
import 'package:mbtperfumes/screens/shop/main_shop.dart';
import 'package:mbtperfumes/screens/shop/product_view.dart';
import 'package:provider/provider.dart';

import '../customs/custom_body.dart';
import '../customs/widgets/custom_product_card.dart';
import '../globals.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserModel? user;
  String selectedMenu = '';

  @override
  void initState() {
    super.initState();

    fetchUsername();

  }

  void fetchUsername () async {
  }
  
  Widget filterProducts(){
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.01,
            vertical: screenWidth * 0.01
          ),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(25)
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02
                ),
                child: Text('Filter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.038
                ),),
              ),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.01),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle
                ),
                child: Icon(Icons.filter_list_sharp,
                color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPerfumeCard({
    required String name,
    required double price,
    required double oldPrice,
    required String imagePath,
    required Color bgColor,
    bool isTaller = false,
  }) {
    return Container(
      height: screenHeight * 0.32,
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: bgColor,
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
                    child: Image.asset('assets/images/perfumes/perf1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(name,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.035
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              Row(
                children: [
                  Text('₱$price',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text('₱$oldPrice',
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

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      body: CustomBody(
        appBar: SliverAppBar(
          backgroundColor: const Color(0xFFf9efef),
          scrolledUnderElevation: 0,
          toolbarHeight: screenHeight * 0.12,
          snap: true,
          floating: true,
          pinned: false,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          right: screenWidth * 0.03
                      ),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: supabase.auth.currentUser != null && supabase.auth.currentUser?.userMetadata?['avatar'] != null ?
                                NetworkImage(supabase.auth.currentUser?.userMetadata?['avatar']) :
                                AssetImage('assets/images/general/profilepic2.jpeg'),
                              fit: BoxFit.cover
                          ),
                          borderRadius: BorderRadius.circular(100)
                      ),
                      width: screenWidth * 0.16,
                      height: screenWidth * 0.16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hi, ${supabase.auth.currentUser?.userMetadata!['username'] ?? 'User'}!',
                          style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.003,),
                        Text('Welcome',
                          style: TextStyle(
                              color: const Color(0xff808080),
                              fontSize: screenWidth * 0.035
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => Get.to(() => const Cart()),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                    ),
                    padding: EdgeInsets.all(screenWidth * 0.032),
                    child: Icon(Icons.shopping_cart_outlined,
                    size: screenWidth * 0.06,
                      color: const Color(0xFF4C4B4B),
                    ),
                  ),
                )
              ],
            )
          ),
        ),
        children: [
          SizedBox(height: screenHeight * 0.03),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.014
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search,
                          size: screenWidth * 0.06,
                          color: const Color(0xff808080),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text('Find your perfume',
                          style: TextStyle(
                            color: const Color(0xff808080),
                            fontSize: screenWidth * 0.038
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.032),
                  margin: EdgeInsets.only(
                    left: screenWidth * 0.02
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle
                  ),
                  child: Icon(Icons.favorite_outline_sharp,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          Container(
            width: screenWidth,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(25)
            ),
            margin: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.transparent,
                            Colors.black,
                          ],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.asset('assets/images/general/Banner.png'),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenWidth * 0.04
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Customize Your Perfume\nWith Your Desired Nodes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.05,
                        height: 1.2,
                        fontWeight: FontWeight.w600
                      ),),
                      SizedBox( height: screenHeight * 0.02),
                      Text('Create your own unique \nperfume. Find your signature \nscent today.',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: screenWidth * 0.035
                        ),
                      ),
                      SizedBox( height: screenHeight * 0.02),
                      ElevatedButton(
                        onPressed: () => Get.to(() => const CustomizingScreen()),
                        style: ElevatedButton.styleFrom(

                        ),
                        child: Text('Buy Now',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600
                          ),),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          Container(
            height: screenHeight * 0.057,
            width: screenWidth,
            child: ListView.builder(
              itemCount: categoryProvider.categories.length + 1, // Add 1 for "All"
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final isAll = index == 0;
                final menuId = isAll ? '' : categoryProvider.categories[index - 1].id;
                final menuName = isAll ? 'All ' : categoryProvider.categories[index - 1].name;

                return GestureDetector(
                  onTap: () {
                    // Set selectedMenu to 0 for "All", otherwise to the menu id
                    setState(() {
                      selectedMenu = menuId;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedMenu == menuId ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    margin: EdgeInsets.only(
                      left: index == 0 ? screenWidth * 0.04 : 0,
                      right: screenWidth * 0.04,
                    ),
                    child: Text(
                      menuName,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: selectedMenu == menuId ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),

          ),
          SizedBox(height: screenHeight * 0.03),
          Container(
              padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04
              ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Popular Perfumes',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: screenWidth * 0.038
                  ),),
                InkWell(
                  onTap: () => Get.to(() => const MainShop()),
                  child: Text('See All',
                    style: TextStyle(
                     fontWeight: FontWeight.w500,
                     fontSize: screenWidth * 0.038,
                     color: Color(0xff808080)
                    ),),
                )
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04
            ),
            child: StaggeredGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: screenHeight * 0.02,
              crossAxisSpacing: screenWidth * 0.04,
              children: [
                filterProducts(),
                ...productProvider.products.where((prod) {
                  bool isSelected = selectedMenu == '' ? true : prod.categoryId == selectedMenu;

                  return isSelected;
                }).take(10).toList().asMap().entries.map((entry) {
                  final index = entry.key;
                  final product = entry.value;

                  return InkWell(
                    onTap: () => Get.to(() => ProductView(product: product)),
                    child: PerfumeCard(
                        product: product,
                        name: product.name,
                        price: product.price,
                        imagePath: product.images != null && product.images!.isNotEmpty
                            ? product.images!.first
                            : null,
                        bgColor: Colors.white
                    ),
                  );
                }).toList()
                // Add more items...
              ],
            )

          )
        ],
      )
    );
  }
}

        // Category Button Widget
Widget _buildCategoryButton(String text, {bool isSelected = false}) {
          return Container(
            alignment: Alignment.center,
            height: 45,
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );

}

class Menu {
  final int id;
  final String title;

  const Menu({
    required this.id,
    required this.title
});
}


