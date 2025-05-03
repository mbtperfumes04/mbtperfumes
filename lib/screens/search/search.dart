import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mbtperfumes/customs/custom_body.dart';
import 'package:mbtperfumes/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mbtperfumes/screens/shop/product_view.dart';
import 'package:provider/provider.dart';
import '../../globals.dart';
import '../../main.dart';
import '../../providers/search_provider.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  bool isSearching = false;
  List<ProductModel> searchList = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _widthAnimation = Tween<double>(begin: 0, end: screenWidth * 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  void deleteData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchSearch() async {

    if(_searchController.text.trim().isEmpty) {
      setState(() {
        searchList.clear();
      });

      return;
    };
    setState(() {
      isSearching = true;
    });
    String search = _searchController.text.trim();

    final data = await supabase
        .from('products')
        .select('*')
        .ilike('name', '%$search%')
        .order('name', ascending: true);

    print(data);

    searchList = data.map((item) => ProductModel.fromMap(item)).toList();

    print(searchList.length);

    setState(() {
      isSearching = false;
    });

  }

  Widget emptySearch() {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    if(supabase.auth.currentUser == null) {
      return Container();
    }

    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05
        ),
        child: searchProvider.recentSearches.isNotEmpty ?
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              Text('Previous Searches',
                style: TextStyle(
                    fontSize: screenSize * 0.011,
                    fontWeight: FontWeight.w500
                ),
              ),
              ListView.builder(
                itemCount: searchProvider.recentSearches.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final searchItem = searchProvider.recentSearches[index];

                  return ListTile(
                    title: Text(searchItem['name'] ?? ''),
                    leading: const Icon(Icons.search),
                    onTap: () {
                      _searchController.text = searchItem['name'] ?? '';
                      fetchSearch();
                    },
                  );
                },
              )
            ],
          ) :
          Container(
            child: Column(
              children: [

              ],
            ),
          )
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      body: CustomBody(
        isGradient: false,
        customBG: const Color(0xFFFAFAFA),
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: _widthAnimation.value,
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.08,
                      bottom: screenHeight * 0.015
                  ),
                  decoration: BoxDecoration(
                    // color: const Color(0xFFf9efef),
                  ),
                child: Row(
                  children: [
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => Get.back()
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: screenHeight * 0.055,
                            margin: EdgeInsets.only(right: screenWidth * 0.06),
                            padding: EdgeInsets.only(
                              left: screenWidth * 0.04,
                              right: screenWidth * 0.12
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: TextFormField(
                              controller: _searchController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                fontSize: screenWidth * 0.036,
                              ),
                              onChanged: (val) async {
                                setState(() {

                                });

                                await fetchSearch();
                              },
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search perfumes',
                                hintStyle: TextStyle(
                                  color: Color(0xff808080),
                                ),
                                isDense: true
                              ),
                            ),
                          ),
                          if(_searchController.text.isNotEmpty)
                          Positioned(
                            right: screenWidth * 0.1,
                            top: 0,
                            bottom: 0,
                            child: InkWell(
                              onTap: () => setState(() {
                                _searchController.clear();
                              }),
                              child: Icon(Icons.clear)
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Container(
            child: _searchController.text.trim().isNotEmpty ?
             Column(
               children: [
                 Container(
                   alignment: Alignment.centerLeft,
                   padding: EdgeInsets.symmetric(
                       horizontal: screenWidth * 0.06
                   ),
                   child: Text('Search for "${_searchController.text.trim()}"',
                     textAlign: TextAlign.left,
                     maxLines: 1,
                     overflow: TextOverflow.ellipsis,
                     style: TextStyle(
                       fontSize: screenWidth * 0.035,
                       fontWeight: FontWeight.w300,
                       color: Color(0xffad2d2f),
                     ),
                   ),
                 ),
                 Container(
                   child: _searchController.text.trim().isNotEmpty ?
                   Container(
                       child: isSearching ? Container(
                         margin: EdgeInsets.only(
                             top: screenHeight * 0.1
                         ),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             SizedBox(
                               width: screenWidth * 0.09,
                               child: LoadingIndicator(
                                 indicatorType: Indicator.ballPulseSync,
                               ),
                             ),
                             Text('Searching...',
                               style: TextStyle(
                                   fontSize: screenSize * 0.008,
                                   fontWeight: FontWeight.w300,
                                   color: Theme.of(context).colorScheme.primary
                               ),
                             )
                           ],
                         ),
                       ) : Container(
                           child: searchList.isNotEmpty ?
                           Container(
                             margin: EdgeInsets.only(top: screenHeight * 0.01),
                             height: screenHeight * 0.8,
                             color: Colors.transparent,
                             child: Stack(
                               children: [
                                 ListView.builder(
                                   itemCount: searchList.length,
                                   padding: EdgeInsets.zero,
                                   itemBuilder: (context, index) {
                                     final product = searchList[index];
                                     return InkWell(
                                       onTap: () async {

                                         if(supabase.auth.currentUser != null) {
                                           await searchProvider.addRecentSearch(product.id ?? '', product.name ?? '');
                                         }

                                         Get.to(() => ProductView(product: product),
                                           transition: Transition.rightToLeft,
                                           duration: Duration(milliseconds: 500),
                                         );
                                       },
                                       child: Container(
                                         margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                                         padding: EdgeInsets.symmetric(
                                           vertical: screenHeight * 0.017,
                                           horizontal: screenWidth * 0.03,
                                         ),
                                         decoration: BoxDecoration(
                                           border: index != searchList.length - 1
                                               ? Border(
                                             bottom: BorderSide(
                                               color: Colors.black.withOpacity(0.1),
                                             ),
                                           )
                                               : null,
                                         ),
                                         child: Row(
                                           children: [
                                             Icon(Icons.search),
                                             SizedBox(width: screenWidth * 0.03),
                                             Text(
                                               product.name,
                                               style: TextStyle(fontSize: screenSize * 0.013),
                                             ),
                                           ],
                                         ),
                                       ),
                                     );
                                   },
                                 ),
                                 // Fade effect at the bottom
                                 Positioned(
                                   bottom: 0,
                                   left: 0,
                                   right: 0,
                                   child: IgnorePointer( // Prevents it from blocking touches
                                     child: Container(
                                       height: screenHeight * 0.1, // Adjust height as needed
                                       decoration: BoxDecoration(
                                         gradient: LinearGradient(
                                           begin: Alignment.topCenter,
                                           end: Alignment.bottomCenter,
                                           colors: [
                                             Colors.white.withOpacity(0.0),
                                             Colors.white, // Match your background
                                           ],
                                         ),
                                       ),
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                           )
                               : Container(
                             margin: EdgeInsets.only(
                                 top: screenHeight * 0.1
                             ),
                             child: Column(
                               children: [
                                 Stack(
                                   children: [
                                     Icon(Icons.search, size: screenWidth * 0.17),
                                     Positioned(
                                       top: 0,
                                       right: 0,
                                       child: Container(
                                         decoration: BoxDecoration(
                                           shape: BoxShape.circle,
                                           color: const Color(0xffad2d2f),
                                         ),
                                         padding: EdgeInsets.all(screenWidth * 0.01),
                                         child: Icon(Icons.clear,
                                             size: screenWidth * 0.06,
                                             color: Colors.white
                                         ),
                                       ),
                                     ),
                                   ],
                                 ),
                                 SizedBox(height: screenHeight * 0.015),
                                 Text('Oops nothing found',
                                   style: TextStyle(
                                       fontSize: screenSize * 0.013,
                                       fontWeight: FontWeight.w600
                                   ),
                                 ),
                                 SizedBox(height: screenHeight * 0.01),
                                 Padding(
                                   padding: EdgeInsets.symmetric(
                                       horizontal: screenWidth * 0.15
                                   ),
                                   child: Text('Try searching for something else or try again later',
                                     textAlign: TextAlign.center,
                                     style: TextStyle(
                                         fontSize: screenSize * 0.01,
                                         fontWeight: FontWeight.w300
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                           )
                       )
                   ) :
                   SizedBox.shrink(),
                 )
               ],
             ) : emptySearch()
          )
        ],
      ),
    );
  }
}
