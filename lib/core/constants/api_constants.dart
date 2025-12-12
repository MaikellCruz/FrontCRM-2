class ApiConstants {
  // Base URL - CONFIGURE AQUI O ENDEREÇO DO SEU BACKEND
  //static const String baseUrl = 'http://localhost:8000';
  static const String baseUrl = 'http://192.168.3.13:8000';

  // Auth Endpoints
  static const String login = '/auth/login';

  // User Endpoints
  static const String users = '/users';
  static String userById(int id) => '/users/$id';

  // Client Endpoints
  static const String clients = '/clients';
  static String clientById(int id) => '/clients/$id';

  // Orcamento Endpoints
  static const String orcamentos = '/orcamentos';
  static String orcamentoById(int id) => '/orcamentos/$id';

  // Category Endpoints
  static const String categories = '/categorias';
  static String categoryById(int id) => '/categorias/$id';

  // Role Endpoints
  static const String roles = '/roles';
  static String roleById(int id) => '/roles/$id';

  // Headers
  static Map<String, String> headers({String? token}) {
    final Map<String, String> defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      defaultHeaders['Authorization'] = 'Bearer $token';
    }

    return defaultHeaders;
  }

  // Timeout
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
