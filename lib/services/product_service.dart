import 'package:dio/dio.dart';
import '../models/product.dart';
import 'api_service.dart';

class ProductService {
  // Fetch all products from backend
  static Future<List<Product>> fetchProducts() async {
    try {
      final response = await ApiService.getProducts();
      if (response.statusCode == 200) {
        final List<dynamic> productsData = response.data;
        return productsData.map((data) => Product.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching products: ${e.message}');
    }
  }

  // Fetch a specific product by ID
  static Future<Product> fetchProductById(String id) async {
    try {
      final response = await ApiService.getProductById(id);
      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      } else {
        throw Exception('Failed to load product');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching product: ${e.message}');
    }
  }
}