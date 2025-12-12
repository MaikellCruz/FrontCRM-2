import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../core/constants/api_constants.dart';
import 'storage_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late final Dio _dio;
  final Logger _logger = Logger();
  final StorageService _storage = StorageService();

  Future<void> init() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectionTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor para adicionar token automaticamente
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final token = await _storage.getToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            } else {
              // garante que header Authorization não exista quando token for nulo/vazio
              options.headers.remove('Authorization');
            }

            // Remove quaisquer headers com valor nulo para evitar envio de Null
            options.headers.removeWhere((key, value) => value == null);
          } catch (e, st) {
            _logger.w('Falha ao recuperar token para headers: $e');
            _logger.v(st);
          }

          _logger.d('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (error, handler) {
          _logger.e(
            'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
          );
          return handler.next(error);
        },
      ),
    );
  }

  // GET Request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST Request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final Response response;
      if (data == null) {
        response = await _dio.post(
          path,
          queryParameters: queryParameters,
          options: options,
        );
      } else {
        response = await _dio.post(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
        );
      }
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT Request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final Response response;
      if (data == null) {
        response = await _dio.put(
          path,
          queryParameters: queryParameters,
          options: options,
        );
      } else {
        response = await _dio.put(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
        );
      }
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE Request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final Response response;
      if (data == null) {
        response = await _dio.delete(
          path,
          queryParameters: queryParameters,
          options: options,
        );
      } else {
        response = await _dio.delete(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
        );
      }
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error Handler
  Exception _handleError(DioException error) {
    String errorMessage = 'Erro desconhecido';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Tempo de conexão esgotado';
        break;
      case DioExceptionType.badResponse:
        // Tenta extrair mensagem do corpo de resposta quando disponível
        final resp = error.response;
        final serverMessage = resp?.data != null ? ' | body: ${resp!.data}' : '';
        errorMessage = '${_handleStatusCode(resp?.statusCode)}$serverMessage';
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Requisição cancelada';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'Erro de conexão. Verifique sua internet.';
        break;
      default:
        errorMessage = 'Erro inesperado: ${error.message}';
    }

    _logger.e('API Error: $errorMessage');
    return Exception(errorMessage);
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Requisição inválida';
      case 401:
        return 'Não autorizado. Faça login novamente.';
      case 403:
        return 'Acesso negado';
      case 404:
        return 'Recurso não encontrado';
      case 500:
        return 'Erro interno do servidor';
      case 503:
        return 'Serviço indisponível';
      default:
        return 'Erro: $statusCode';
    }
  }
}
