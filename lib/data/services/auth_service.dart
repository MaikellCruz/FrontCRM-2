import 'dart:convert';
import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _api = ApiService();
  final StorageService _storage = StorageService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _api.post(
        ApiConstants.login,
        data: {
          'username': email, // OAuth2PasswordRequestForm usa 'username'
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final token = data['access_token'] as String;
        
        // Salvar token
        await _storage.saveToken(token);
        
        return data;
      } else {
        throw Exception('Falha no login');
      }
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  Future<void> logout() async {
    await _storage.clearUserData();
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<String?> getToken() async {
    return await _storage.getToken();
  }

  Future<void> saveUserData(UserModel user) async {
    final userData = jsonEncode(user.toJson());
    await _storage.saveUserData(userData);
    await _storage.saveUserRole(user.role.name);
  }

  Future<UserModel?> getUserData() async {
    final userData = _storage.getUserData();
    if (userData != null && userData.isNotEmpty) {
      try {
        final json = jsonDecode(userData) as Map<String, dynamic>;
        return UserModel.fromJson(json);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  String? getUserRole() {
    return _storage.getUserRole();
  }
}
