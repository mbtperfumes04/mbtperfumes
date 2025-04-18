  import 'package:mbtperfumes/main.dart';
  import 'package:mbtperfumes/models/category_model.dart';

  class CategoryController {
    Future<List<CategoryModel>> fetchCategories() async {
      try {
        print('Fetching categories...');
        final data = await supabase
            .from('category')
            .select('*')
            .eq('is_active', true);

        print(data);
  
        return (data as List)
            .map((item) => CategoryModel.fromMap(item))
            .toList();
      } catch (e) {
        print('Exception: $e');
      }

      return [];
    }
  }
