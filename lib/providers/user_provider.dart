import 'package:flutter/foundation.dart';
import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _repository = UserRepository();
  
  List<UserModel> _users = [];
  UserModel? _selectedUser;
  bool _isLoading = false;
  String? _errorMessage;

  List<UserModel> get users => _users;
  UserModel? get selectedUser => _selectedUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get all users
  Future<void> getAllUsers() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _users = await _repository.getAllUsers();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get user by ID
  Future<void> getUserById(int id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _selectedUser = await _repository.getUserById(id);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create user
  Future<bool> createUser(UserCreateModel user) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final newUser = await _repository.createUser(user);
      _users.add(newUser);
      
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

  // Update user
  Future<bool> updateUser(int id, UserUpdateModel user) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final updatedUser = await _repository.updateUser(id, user);
      
      final index = _users.indexWhere((u) => u.id == id);
      if (index != -1) {
        _users[index] = updatedUser;
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

  // Delete user
  Future<bool> deleteUser(int id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.deleteUser(id);
      _users.removeWhere((u) => u.id == id);
      
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

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear selected user
  void clearSelectedUser() {
    _selectedUser = null;
    notifyListeners();
  }
}
