import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  // API configuration
  static String get apiUrl => dotenv.env['API_URL'] ?? 'https://api.hyhshop.com';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  
  // Wompi configuration
  static String get wompiPublicKey => dotenv.env['WOMPI_PUBLIC_KEY'] ?? 'pub_test_xxxxxxxxxx';
  static String get wompiPrivateKey => dotenv.env['WOMPI_PRIVATE_KEY'] ?? 'prv_test_xxxxxxxxxx';
  static String get wompiIntegritySecret => dotenv.env['WOMPI_INTEGRITY_SECRET'] ?? 'integrity_test_secret';
  static String get wompiRedirectUrl => dotenv.env['WOMPI_REDIRECT_URL'] ?? 'https://hyhshop.com/pagos/wompi';
  static String get wompiBaseUrl {
    final baseUrl = dotenv.env['WOMPI_BASE_URL'];
    if (baseUrl != null && baseUrl.isNotEmpty) {
      return baseUrl;
    }

    String env = dotenv.env['WOMPI_ENV'] ?? 'sandbox';
    return env == 'production'
        ? 'https://production.wompi.co/v1'
        : 'https://sandbox.wompi.co/v1';
  }
  
  // Environment type
  static String get environment => dotenv.env['ENV'] ?? 'production';
  static bool get isDebug => environment == 'debug';
  static bool get isProduction => environment == 'production';
  
  // App configuration
  static String get appName => dotenv.env['APP_NAME'] ?? 'HyH Shop Barbería';
}