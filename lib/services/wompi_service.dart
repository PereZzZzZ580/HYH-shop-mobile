import 'package:dio/dio.dart';
import 'environment.dart';

class WompiService {
  static String get _baseUrl => Environment.wompiBaseUrl; // Using environment variable
  static String get _privateKey => Environment.wompiPrivateKey; // Using environment variable

  static Future<String?> createPayment({
    required double amount,
    String currency = 'COP',
    required String customerId,
    required String customerEmail,
    required String customerName,
    String? customerPhone,
    String? customerAddress,
  }) async {
    try {
      final dio = Dio();
      
      // Headers - Wompi uses the private key for authentication
      dio.options.headers['Authorization'] = 'Bearer $_privateKey';
      dio.options.headers['Content-Type'] = 'application/json';
      
      // Format phone number for Wompi API (must be in international format)
      String formattedPhone = customerPhone ?? '+573001234567';
      if (customerPhone != null) {
        // Ensure phone number is in international format (e.g. +573001234567)
        formattedPhone = customerPhone.startsWith('+') ? customerPhone : '+57${customerPhone.replaceAll(RegExp(r'[^\d]'), '').substring(customerPhone.length > 10 ? customerPhone.length - 10 : 0)}';
      }
      
      // Create the payment intent/transaction
      final response = await dio.post(
        '$_baseUrl/transactions',
        data: {
          'amount_in_cents': (amount * 100).round(), // Convert to cents
          'currency': currency,
          'reference': 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(4)}', // Unique reference with max 255 chars
          'customer': {
            'name': customerName,
            'email': customerEmail,
            'phone_number': formattedPhone, // Required format
          },
          'shipping_address': customerAddress != null && customerAddress.isNotEmpty
            ? {
                'address_line_1': customerAddress.length >= 4 ? customerAddress : 'Carrera 12 #15-34', // At least 4 chars required
                'city': 'Medellín', // Should be obtained from user
                'country': 'CO',
                'full_name': customerName,
                'phone_number': formattedPhone, // Same phone number
                'region': 'ANT', // Required - using Antioquia as example
              } 
            : null,
          'payment_method': {
            'type': 'ON_PAGE_REDIRECT',
          },
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final transaction = data['data'];
        
        print('Wompi transaction response: $transaction'); // For debugging
        
        // Different Wompi response formats might exist
        // Check for redirect URL or payment link
        if (transaction['checkout_url'] != null) {
          return transaction['checkout_url'];
        } else if (transaction['redirect_url'] != null) {
          return transaction['redirect_url'];
        } else if (transaction['secure_payment_url'] != null) {
          return transaction['secure_payment_url'];
        } else if (transaction['id'] != null) {
          // Create a payment page URL based on the transaction ID
          // This is a fallback approach for sandbox environment
          String wompiEnv = Environment.wompiBaseUrl.contains('production') ? 'production' : 'sandbox';
          String domain = 'checkout.wompi.co'; // Both sandbox and production use the same checkout domain
          return 'https://$domain/l/${transaction['id']}';
        }
      }
      
      return null;
    } catch (e) {
      // Log error in development, but handle gracefully in production
      print('Error creating Wompi payment: $e');
      // Capture DioError details if needed
      if (e is DioException) {
        print('DioError details: ${e.response?.data}');
        print('DioError status code: ${e.response?.statusCode}');
      }
      return null;
    }
  }

  static Future<bool> verifyPayment(String transactionId) async {
    try {
      final dio = Dio();
      
      // Headers
      dio.options.headers['Authorization'] = 'Bearer $_privateKey';
      dio.options.headers['Content-Type'] = 'application/json';
      
      final response = await dio.get('$_baseUrl/transactions/$transactionId');
      
      if (response.statusCode == 200) {
        final data = response.data;
        final status = data['data']['status'];
        // Wompi transaction statuses: PENDING, APPROVED, DECLINED, CHARGEBACK, CANCELLED
        return status == 'APPROVED';
      }
      
      return false;
    } catch (e) {
      // Log error in development, but handle gracefully in production
      // print('Error verifying Wompi payment: $e');
      if (e is DioException) {
        // print('DioError: ${e.response?.data}');
      }
      return false;
    }
  }
}