import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _api = ApiService();
  final StorageService _storage = StorageService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    // Normaliza o email para evitar sensibilidade a maiúsculas/minúsculas
    final normalizedEmail = email.trim().toLowerCase();

    // Monta o body como string url-encoded (garante que o servidor receba exatamente os campos)
    final formBody = 'username=${Uri.encodeQueryComponent(normalizedEmail)}&password=${Uri.encodeQueryComponent(password)}';

    // Cria um Dio local sem interceptors para evitar alterações por ApiService
    final Dio dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Content-Type': Headers.formUrlEncodedContentType,
        'Accept': 'application/json',
      },
      connectTimeout: ApiConstants.connectionTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
    ));

    // ignore: avoid_print
    print('➡️ LOGIN (isolated Dio) POST ${ApiConstants.baseUrl}${ApiConstants.login}');
    // ignore: avoid_print
    print('➡️ LOGIN BODY: $formBody');

    try {
      final response = await dio.post(
        ApiConstants.login,
        data: formBody,
      );

      // ignore: avoid_print
      print('⬅️ LOGIN RESPONSE: ${response.statusCode} | ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final token = responseData['access_token'] as String;

        // Salvar token
        await _storage.saveToken(token);

        return responseData;
      } else {
        throw Exception('Falha no login: status=${response.statusCode}, body=${response.data}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('❌ Erro ao fazer login (isolated Dio): $e');
      rethrow;
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
