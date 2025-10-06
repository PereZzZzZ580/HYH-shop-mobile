import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

import 'environment.dart';

class WompiService {
  static String get _publicKey => Environment.wompiPublicKey;
  static String get _integritySecret => Environment.wompiIntegritySecret;
  static String get _redirectUrl => Environment.wompiRedirectUrl;
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
      final amountInCents = (amount * 100).round();
      final reference = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

      final signaturePayload = '$reference$amountInCents$currency$_integritySecret';
      final signatureBytes = utf8.encode(signaturePayload);
      final signature = sha256.convert(signatureBytes).toString();

      final params = <String, String>{
        'public-key': _publicKey,
        'currency': currency,
        'amount-in-cents': amountInCents.toString(),
        'reference': reference,
        'signature:integrity': signature,
        'redirect-url': _redirectUrl,
        'customer-data:email': customerEmail,
        'customer-data:full-name': customerName,
        'customer-data:legal-id': customerId,
      };

      if (customerPhone != null && customerPhone.isNotEmpty) {
        final digits = customerPhone.replaceAll(RegExp(r'[^0-9+]'), '');
        String normalizedPhone = digits;

        if (!normalizedPhone.startsWith('+')) {
          final numeric = normalizedPhone.replaceAll(RegExp(r'[^0-9]'), '');
          if (numeric.length == 10) {
            normalizedPhone = '+57$numeric';
          } else {
            normalizedPhone = '+$numeric';
          }
        }

        params['customer-data:phone-number'] = normalizedPhone;
      }

      if (customerAddress != null && customerAddress.isNotEmpty) {
        params['customer-data:address-line-1'] = customerAddress;
      }

      final uri = Uri.https('checkout.wompi.co', '/p/', params);
      return uri.toString();
    } catch (e) {
      // Log error in development, but handle gracefully in production
      print('Error creating Wompi payment: $e');
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