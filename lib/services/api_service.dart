import 'package:dio/dio.dart';
import 'database_config.dart';

class ApiService {
  static final Dio _dio = Dio();

  // Get products from backend
  static Future<Response> getProducts() async {
    try {
      final response = await _dio.get(
        '${DatabaseConfig.apiUrl}/products',  // Ajustado para coincidir con tu backend
        options: Options(
          headers: DatabaseConfig.headers,
        ),
      );
      return response;
    } on DioException catch (e) {
      throw Exception('Error fetching products: ${e.message}');
    }
  }

  // Get a specific product by ID
  static Future<Response> getProductById(String id) async {
    try {
      final response = await _dio.get(
        '${DatabaseConfig.apiUrl}/products/$id',  // Ajustado para coincidir con tu backend
        options: Options(
          headers: DatabaseConfig.headers,
        ),
      );
      return response;
    } on DioException catch (e) {
      throw Exception('Error fetching product: ${e.message}');
    }
  }

  // Create an order
  static Future<Response> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await _dio.post(
        '${DatabaseConfig.apiUrl}/orders',  // Ajustado para coincidir con tu backend
        data: orderData,
        options: Options(
          headers: DatabaseConfig.headers,
        ),
      );
      return response;
    } on DioException catch (e) {
      throw Exception('Error creating order: ${e.message}');
    }
  }

  // Get orders for a specific user
  static Future<Response> getUserOrders(String userId) async {
    try {
      final response = await _dio.get(
        '${DatabaseConfig.apiUrl}/users/$userId/orders',  // Ajustado para coincidir con tu backend
        options: Options(
          headers: DatabaseConfig.headers,
        ),
      );
      return response;
    } on DioException catch (e) {
      throw Exception('Error fetching user orders: ${e.message}');
    }
  }

  // Update order status
  static Future<Response> updateOrderStatus(String orderId, String status) async {
    try {
      final response = await _dio.patch(
        '${DatabaseConfig.apiUrl}/orders/$orderId',  // Ajustado para coincidir con tu backend
        data: {'status': status},
        options: Options(
          headers: DatabaseConfig.headers,
        ),
      );
      return response;
    } on DioException catch (e) {
      throw Exception('Error updating order status: ${e.message}');
    }
  }
}