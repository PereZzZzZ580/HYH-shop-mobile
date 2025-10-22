import 'package:dio/dio.dart';
import '../models/product.dart';
import 'api_service.dart';

class ProductService {
  // Fetch all products from backend
  static Future<List<Product>> fetchProducts({int page = 1, int perPage = 20}) async {
    try {
      final response = await ApiService.getProducts(
        query: {
          'page': page,
          'perPage': perPage,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data;
        List<dynamic> items;
        if (data is Map<String, dynamic>) {
          final rawItems = data['items'];
          if (rawItems is List) {
            items = rawItems;
          } else {
            items = const [];
          }
        } else if (data is List) {
          items = data;
        } else {
          items = const [];
        }
        return items.map(_mapProduct).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching products: ${e.message}');
    }
  }

  // Fetch a specific product by ID
  static Future<Product> fetchProductBySlug(String slug) async {
    try {
      final response = await ApiService.getProductBySlug(slug);
      if (response.statusCode == 200) {
        final data = response.data;
        return _mapProduct(data);
      } else {
        throw Exception('Failed to load product');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching product: ${e.message}');
    }
  }

  static Product _mapProduct(dynamic raw) {
    if (raw is Product) return raw;
    if (raw is Map<String, dynamic>) {
      return Product.fromJson(raw);
    }
    if (raw is Map) {
      return Product.fromJson(Map<String, dynamic>.from(raw));
    }
    throw Exception('Invalid product payload received from API');
  }
}
