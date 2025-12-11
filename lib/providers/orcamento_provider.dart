import 'package:flutter/foundation.dart';
import '../data/models/orcamento_model.dart';
import '../data/repositories/orcamento_repository.dart';

class OrcamentoProvider with ChangeNotifier {
  final OrcamentoRepository _repository = OrcamentoRepository();
  
  List<OrcamentoModel> _orcamentos = [];
  OrcamentoModel? _selectedOrcamento;
  bool _isLoading = false;
  String? _errorMessage;

  List<OrcamentoModel> get orcamentos => _orcamentos;
  OrcamentoModel? get selectedOrcamento => _selectedOrcamento;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> getAllOrcamentos() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _orcamentos = await _repository.getAllOrcamentos();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getOrcamentoById(int id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _selectedOrcamento = await _repository.getOrcamentoById(id);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createOrcamento(OrcamentoCreateModel orcamento) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final newOrcamento = await _repository.createOrcamento(orcamento);
      _orcamentos.add(newOrcamento);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateOrcamento(int id, OrcamentoUpdateModel orcamento) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final updatedOrcamento = await _repository.updateOrcamento(id, orcamento);
      
      final index = _orcamentos.indexWhere((o) => o.id == id);
      if (index != -1) {
        _orcamentos[index] = updatedOrcamento;
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteOrcamento(int id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.deleteOrcamento(id);
      _orcamentos.removeWhere((o) => o.id == id);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSelectedOrcamento() {
    _selectedOrcamento = null;
    notifyListeners();
  }
}
