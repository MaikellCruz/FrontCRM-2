import '../../core/constants/api_constants.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';

class CategoryRepository {
  final ApiService _api = ApiService();

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final response = await _api.get(ApiConstants.categories);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao buscar categorias');
      }
    } catch (e) {
      throw Exception('Erro ao buscar categorias: $e');
    }
  }

  Future<CategoryModel> getCategoryById(int id) async {
    try {
      final response = await _api.get(ApiConstants.categoryById(id));
      
      if (response.statusCode == 200) {
        return CategoryModel.fromJson(response.data);
      } else {
        throw Exception('Falha ao buscar categoria');
      }
    } catch (e) {
      throw Exception('Erro ao buscar categoria: $e');
    }
  }

  Future<CategoryModel> createCategory(CategoryCreateModel category) async {
    try {
      final response = await _api.post(
        ApiConstants.categories,
        data: category.toJson(),
      );
      
      if (response.statusCode == 201) {
        return CategoryModel.fromJson(response.data);
      } else {
        throw Exception('Falha ao criar categoria');
      }
    } catch (e) {
      throw Exception('Erro ao criar categoria: $e');
    }
  }

  Future<CategoryModel> updateCategory(
    int id,
    CategoryUpdateModel category,
  ) async {
    try {
      final response = await _api.put(
        ApiConstants.categoryById(id),
        data: category.toJson(),
      );
      
      if (response.statusCode == 200) {
        return CategoryModel.fromJson(response.data);
      } else {
        throw Exception('Falha ao atualizar categoria');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar categoria: $e');
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      final response = await _api.delete(ApiConstants.categoryById(id));
      
      if (response.statusCode != 200) {
        throw Exception('Falha ao deletar categoria');
      }
    } catch (e) {
      throw Exception('Erro ao deletar categoria: $e');
    }
  }
}
