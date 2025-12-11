import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserRepository {
  final ApiService _api = ApiService();

  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _api.get(ApiConstants.users);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao buscar usuários');
      }
    } catch (e) {
      throw Exception('Erro ao buscar usuários: $e');
    }
  }

  Future<UserModel> getUserById(int id) async {
    try {
      final response = await _api.get(ApiConstants.userById(id));
      
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Falha ao buscar usuário');
      }
    } catch (e) {
      throw Exception('Erro ao buscar usuário: $e');
    }
  }

  Future<UserModel> createUser(UserCreateModel user) async {
    try {
      final response = await _api.post(
        ApiConstants.users,
        data: user.toJson(),
      );
      
      if (response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Falha ao criar usuário');
      }
    } catch (e) {
      throw Exception('Erro ao criar usuário: $e');
    }
  }

  Future<UserModel> updateUser(int id, UserUpdateModel user) async {
    try {
      final response = await _api.put(
        ApiConstants.userById(id),
        data: user.toJson(),
      );
      
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Falha ao atualizar usuário');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar usuário: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      final response = await _api.delete(ApiConstants.userById(id));
      
      if (response.statusCode != 200) {
        throw Exception('Falha ao deletar usuário');
      }
    } catch (e) {
      throw Exception('Erro ao deletar usuário: $e');
    }
  }
}
