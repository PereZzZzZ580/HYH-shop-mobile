import 'package:dio/dio.dart';
import 'database_config.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: DatabaseConfig.apiUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
  static String? _authToken;

  static void _ensureBaseUrl() {
    final targetBase = DatabaseConfig.apiUrl;
    if (_dio.options.baseUrl != targetBase) {
      _dio.options.baseUrl = targetBase;
    }
  }

  static void setAuthToken(String? token) {
    _authToken = token;
  }

  static String? get authToken => _authToken;

  static Options _optionsWithHeaders([Map<String, String>? extraHeaders]) {
    final headers = Map<String, String>.from(DatabaseConfig.headers);
    if (_authToken != null && _authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    if (extraHeaders != null && extraHeaders.isNotEmpty) {
      headers.addAll(extraHeaders);
    }
    return Options(headers: headers);
  }

  static Future<Response> get(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      _ensureBaseUrl();
      return await _dio.get(
        path,
        queryParameters: query,
        options: _optionsWithHeaders(headers),
      );
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Error en la solicitud GET');
    }
  }

  static Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      _ensureBaseUrl();
      return await _dio.post(
        path,
        data: data,
        queryParameters: query,
        options: _optionsWithHeaders(headers),
      );
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Error en la solicitud POST');
    }
  }

  static Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  }) async {
    try {
      _ensureBaseUrl();
      return await _dio.patch(
        path,
        data: data,
        options: _optionsWithHeaders(headers),
      );
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Error en la solicitud PATCH');
    }
  }

  // Get products from backend
  static Future<Response> getProducts({Map<String, dynamic>? query}) async {
    try {
      return await get('/products', query: query);
    } on DioException catch (e) {
      throw Exception('Error fetching products: ${e.message}');
    }
  }

  // Get a specific product by slug
  static Future<Response> getProductBySlug(String slug) async {
    try {
      return await get('/products/$slug');
    } on DioException catch (e) {
      throw Exception('Error fetching product: ${e.message}');
    }
  }

  // Create an order
  static Future<Response> createOrder(Map<String, dynamic> orderData) async {
    try {
      return await post('/orders', data: orderData);
    } on DioException catch (e) {
      throw Exception('Error creating order: ${e.message}');
    }
  }

  // Get orders for a specific user
  static Future<Response> getUserOrders(String userId) async {
    try {
      return await get('/users/$userId/orders');
    } on DioException catch (e) {
      throw Exception('Error fetching user orders: ${e.message}');
    }
  }

  // Update order status
  static Future<Response> updateOrderStatus(String orderId, String status) async {
    try {
      return await patch('/orders/$orderId', data: {'status': status});
    } on DioException catch (e) {
      throw Exception('Error updating order status: ${e.message}');
    }
  }
}
