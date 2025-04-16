import 'package:mbtperfumes/main.dart';
import 'package:mbtperfumes/models/product_model.dart';

class ProductController {
  Future<List<ProductModel>> fetchProducts() async {
    try {
      print('Fetching Products...');
      final data = await supabase
        .from('products')
        .select('*')
        .eq('is_active', true);

      print(data);

      return (data as List)
          .map((item) => ProductModel.fromMap(item))
          .toList();
    } catch (e){
      print('Exception: $e');
    }

    return [];
  }
}