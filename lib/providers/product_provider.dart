import 'package:flutter/cupertino.dart';
import 'package:mbtperfumes/controllers/product_controller.dart';
import 'package:mbtperfumes/models/product_model.dart';

class ProductProvider with ChangeNotifier {
  final ProductController productController = ProductController();
  List<ProductModel> _products = [];

  List<ProductModel> get products => _products;

  ProductProvider() {
    initData();
  }

  Future<void> initData() async {
    await fetchProducts();
}

  Future<void> fetchProducts() async {
    _products = await productController.fetchProducts();
    print('fetching products: ${products.length}');
    notifyListeners();
  }
}