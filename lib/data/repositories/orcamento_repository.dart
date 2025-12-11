import '../../core/constants/api_constants.dart';
import '../models/orcamento_model.dart';
import '../services/api_service.dart';

class OrcamentoRepository {
  final ApiService _api = ApiService();

  Future<List<OrcamentoModel>> getAllOrcamentos() async {
    try {
      final response = await _api.get(ApiConstants.orcamentos);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => OrcamentoModel.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao buscar orçamentos');
      }
    } catch (e) {
      throw Exception('Erro ao buscar orçamentos: $e');
    }
  }

  Future<OrcamentoModel> getOrcamentoById(int id) async {
    try {
      final response = await _api.get(ApiConstants.orcamentoById(id));
      
      if (response.statusCode == 200) {
        return OrcamentoModel.fromJson(response.data);
      } else {
        throw Exception('Falha ao buscar orçamento');
      }
    } catch (e) {
      throw Exception('Erro ao buscar orçamento: $e');
    }
  }

  Future<OrcamentoModel> createOrcamento(OrcamentoCreateModel orcamento) async {
    try {
      final response = await _api.post(
        ApiConstants.orcamentos,
        data: orcamento.toJson(),
      );
      
      if (response.statusCode == 201) {
        return OrcamentoModel.fromJson(response.data);
      } else {
        throw Exception('Falha ao criar orçamento');
      }
    } catch (e) {
      throw Exception('Erro ao criar orçamento: $e');
    }
  }

  Future<OrcamentoModel> updateOrcamento(
    int id,
    OrcamentoUpdateModel orcamento,
  ) async {
    try {
      final response = await _api.put(
        ApiConstants.orcamentoById(id),
        data: orcamento.toJson(),
      );
      
      if (response.statusCode == 200) {
        return OrcamentoModel.fromJson(response.data);
      } else {
        throw Exception('Falha ao atualizar orçamento');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar orçamento: $e');
    }
  }

  Future<void> deleteOrcamento(int id) async {
    try {
      final response = await _api.delete(ApiConstants.orcamentoById(id));
      
      if (response.statusCode != 200) {
        throw Exception('Falha ao deletar orçamento');
      }
    } catch (e) {
      throw Exception('Erro ao deletar orçamento: $e');
    }
  }
}
