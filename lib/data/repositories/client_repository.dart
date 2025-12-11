import '../../core/constants/api_constants.dart';
import '../models/client_model.dart';
import '../services/api_service.dart';

class ClientRepository {
  final ApiService _api = ApiService();

  Future<List<ClientModel>> getAllClients() async {
    try {
      final response = await _api.get(ApiConstants.clients);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => ClientModel.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao buscar clientes');
      }
    } catch (e) {
      throw Exception('Erro ao buscar clientes: $e');
    }
  }

  Future<ClientModel> getClientById(int id) async {
    try {
      final response = await _api.get(ApiConstants.clientById(id));
      
      if (response.statusCode == 200) {
        return ClientModel.fromJson(response.data);
      } else {
        throw Exception('Falha ao buscar cliente');
      }
    } catch (e) {
      throw Exception('Erro ao buscar cliente: $e');
    }
  }

  Future<ClientModel> createClient(ClientCreateModel client) async {
    try {
      final response = await _api.post(
        ApiConstants.clients,
        data: client.toJson(),
      );
      
      if (response.statusCode == 201) {
        return ClientModel.fromJson(response.data);
      } else {
        throw Exception('Falha ao criar cliente');
      }
    } catch (e) {
      throw Exception('Erro ao criar cliente: $e');
    }
  }

  Future<ClientModel> updateClient(int id, ClientUpdateModel client) async {
    try {
      final response = await _api.put(
        ApiConstants.clientById(id),
        data: client.toJson(),
      );
      
      if (response.statusCode == 200) {
        return ClientModel.fromJson(response.data);
      } else {
        throw Exception('Falha ao atualizar cliente');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar cliente: $e');
    }
  }

  Future<void> deleteClient(int id) async {
    try {
      final response = await _api.delete(ApiConstants.clientById(id));
      
      if (response.statusCode != 200) {
        throw Exception('Falha ao deletar cliente');
      }
    } catch (e) {
      throw Exception('Erro ao deletar cliente: $e');
    }
  }
}
