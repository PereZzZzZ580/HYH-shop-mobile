class Environment {
  // API configuration
  static const String apiUrl = String.fromEnvironment('API_URL', defaultValue: 'https://api.hyhshop.com');
  static const String apiKey = String.fromEnvironment('API_KEY', defaultValue: '');
  
  // Wompi configuration
  static const String wompiPublicKey = String.fromEnvironment('WOMPI_PUBLIC_KEY', defaultValue: 'pub_test_xxxxxxxxxx');
  static const String wompiPrivateKey = String.fromEnvironment('WOMPI_PRIVATE_KEY', defaultValue: 'prv_test_xxxxxxxxxx');
  static const String wompiBaseUrl = String.fromEnvironment('WOMPI_BASE_URL', defaultValue: 'https://sandbox.wompi.co/v1');
  
  // Environment type
  static const String environment = String.fromEnvironment('ENV', defaultValue: 'production');
  static bool get isDebug => environment == 'debug';
  static bool get isProduction => environment == 'production';
  
  // App configuration
  static const String appName = String.fromEnvironment('APP_NAME', defaultValue: 'HyH Shop Barbería');
}