import 'environment.dart';

class DatabaseConfig {
  // Configuración para la conexión a la base de datos
  // Este valor vendrá del archivo .env o de la configuración del sistema
  static String get apiUrl => Environment.apiUrl;
  static String get apiKey => Environment.apiKey;
  
  // Headers comunes para todas las peticiones
  static Map<String, String> get headers {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (apiKey.isNotEmpty) 'Authorization': 'Bearer $apiKey',
    };
  }
  
  // Get the full API URL
  static String get fullApiUrl => apiUrl;
}