import 'package:dio/dio.dart';
import 'environment.dart';

class WompiService {
  static const String _baseUrl = Environment.wompiBaseUrl; // Using environment variable
  static const String _privateKey = Environment.wompiPrivateKey; // Using environment variable

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
      
      // Headers - Wompi uses the public key for authentication in some cases
      dio.options.headers['Authorization'] = 'Bearer $_privateKey';
      dio.options.headers['Content-Type'] = 'application/json';
      
      // Create the payment intent/transaction
      final response = await dio.post(
        '$_baseUrl/transactions',
        data: {
          'amount_in_cents': (amount * 100).round(), // Convert to cents
          'currency': currency,
          'customer': {
            'customer_id': customerId,
            'email': customerEmail,
            'name': customerName,
            'phone_number': customerPhone ?? '',
          },
          'shipping_address': customerAddress != null 
            ? {
                'address': customerAddress,
                'city': 'Medellín', // Should be obtained from user
                'country': 'CO',
                'full_name': customerName,
              } 
            : null,
          'payment_source': {
            'type': 'ON_PAGE',
          },
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final transaction = data['data'];
        
        // Different Wompi response formats might exist
        // Check for redirect URL or payment link
        if (transaction['redirect_url'] != null) {
          return transaction['redirect_url'];
        } else if (transaction['checkout_url'] != null) {
          return transaction['checkout_url'];
        } else if (transaction['id'] != null) {
          // Create a payment page URL based on the transaction ID
          // This is a fallback approach
          return 'https://checkout.wompi.co/l/${transaction['id']}';
        }
      }
      
      return null;
    } catch (e) {
      // Log error in development, but handle gracefully in production
      // print('Error creating Wompi payment: $e');
      // Capture DioError details if needed
      if (e is DioException) {
        // print('DioError: ${e.response?.data}');
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