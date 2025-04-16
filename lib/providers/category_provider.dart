import 'package:flutter/cupertino.dart';
import 'package:mbtperfumes/controllers/category_controller.dart';
import 'package:mbtperfumes/models/category_model.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryController categoryController = CategoryController();
  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  CategoryProvider() {
    initData();
  }

  Future<void> initData() async {
    await fetchCategories();
  }

  Future<void> fetchCategories() async {
    _categories = await categoryController.fetchCategories();
    print('fetching categories: ${categories.length}');
    notifyListeners();
  }
}