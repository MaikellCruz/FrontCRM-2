import 'package:flutter/foundation.dart';
import '../data/models/client_model.dart';
import '../data/repositories/client_repository.dart';

class ClientProvider with ChangeNotifier {
  final ClientRepository _repository = ClientRepository();
  
  List<ClientModel> _clients = [];
  ClientModel? _selectedClient;
  bool _isLoading = false;
  String? _errorMessage;

  List<ClientModel> get clients => _clients;
  ClientModel? get selectedClient => _selectedClient;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> getAllClients() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _clients = await _repository.getAllClients();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getClientById(int id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _selectedClient = await _repository.getClientById(id);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createClient(ClientCreateModel client) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final newClient = await _repository.createClient(client);
      _clients.add(newClient);
      
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

  Future<bool> updateClient(int id, ClientUpdateModel client) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final updatedClient = await _repository.updateClient(id, client);
      
      final index = _clients.indexWhere((c) => c.id == id);
      if (index != -1) {
        _clients[index] = updatedClient;
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

  Future<bool> deleteClient(int id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.deleteClient(id);
      _clients.removeWhere((c) => c.id == id);
      
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

  void clearSelectedClient() {
    _selectedClient = null;
    notifyListeners();
  }
}
