import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    return await _authService.login(email, password);
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  Future<bool> isAuthenticated() async {
    return await _authService.isAuthenticated();
  }

  Future<String?> getToken() async {
    return await _authService.getToken();
  }

  Future<void> saveUserData(UserModel user) async {
    await _authService.saveUserData(user);
  }

  Future<UserModel?> getUserData() async {
    return await _authService.getUserData();
  }

  String? getUserRole() {
    return _authService.getUserRole();
  }
}
