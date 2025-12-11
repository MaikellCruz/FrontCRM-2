import '../../core/constants/app_constants.dart';

class Validators {
  // Email Validator
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    
    return null;
  }

  // Password Validator
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    
    if (value.length < AppConstants.minPasswordLength) {
      return 'Senha deve ter no mínimo ${AppConstants.minPasswordLength} caracteres';
    }
    
    return null;
  }

  // Required Field Validator
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Campo'} é obrigatório';
    }
    return null;
  }

  // Name Validator
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }
    
    if (value.length < AppConstants.minNameLength) {
      return 'Nome deve ter no mínimo ${AppConstants.minNameLength} caracteres';
    }
    
    return null;
  }

  // Phone Validator
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }
    
    final phoneRegex = RegExp(r'^\d{10,11}$');
    
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[^\d]'), ''))) {
      return 'Telefone inválido';
    }
    
    return null;
  }

  // Number Validator
  static String? number(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Campo'} é obrigatório';
    }
    
    if (double.tryParse(value) == null) {
      return '${fieldName ?? 'Campo'} deve ser um número válido';
    }
    
    return null;
  }

  // Positive Number Validator
  static String? positiveNumber(String? value, {String? fieldName}) {
    final numberError = number(value, fieldName: fieldName);
    if (numberError != null) return numberError;
    
    if (double.parse(value!) <= 0) {
      return '${fieldName ?? 'Campo'} deve ser maior que zero';
    }
    
    return null;
  }

  // Confirm Password Validator
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }
    
    if (value != password) {
      return 'As senhas não coincidem';
    }
    
    return null;
  }
}
