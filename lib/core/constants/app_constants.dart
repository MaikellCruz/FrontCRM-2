class AppConstants {
  // App Info
  static const String appName = 'CRM System';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String roleKey = 'user_role';
  
  // Validation
  static const int minPasswordLength = 8;
  static const int minNameLength = 3;
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Image
  static const int maxImageSizeInBytes = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png'];
  
  // Date Format
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  
  // Messages
  static const String networkError = 'Erro de conexão. Verifique sua internet.';
  static const String genericError = 'Ocorreu um erro. Tente novamente.';
  static const String unauthorized = 'Sessão expirada. Faça login novamente.';
  static const String notFound = 'Recurso não encontrado.';
  static const String successSave = 'Salvo com sucesso!';
  static const String successDelete = 'Excluído com sucesso!';
  static const String confirmDelete = 'Tem certeza que deseja excluir?';
}
