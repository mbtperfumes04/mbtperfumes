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

  Future<List<ProductModel>> fetchProductsByIds(List<String> productIds) async {
    if (productIds.isEmpty) return [];

    try {
      final data = await supabase
          .from('products')
          .select('*')
          .inFilter('id', productIds)
          .eq('is_active', true); // Optional: only fetch active products

      return (data as List)
          .map((item) => ProductModel.fromMap(item))
          .toList();
    } catch (e) {
      print('Error fetching products by IDs: $e');
      return [];
    }
  }

  Future<ProductModel?> fetchProductById(String id) async {
    try {
      final data = await supabase
          .from('products')
          .select('*')
          .eq('id', id)
          .maybeSingle();

      if (data != null) {
        return ProductModel.fromMap(data);
      }
    } catch (e) {
      print('Error fetching product by ID: $e');
    }
    return null;
  }
}