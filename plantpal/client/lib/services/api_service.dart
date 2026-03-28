import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  ApiService() {
    // Для работы из браузера используем localhost:8000
    _dio.options.baseUrl = 'http://localhost:8000';

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        print('→ REQUEST: ${options.method} ${options.uri}'); // для отладки
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('← RESPONSE ${response.statusCode}: ${response.requestOptions.uri}');
        handler.next(response);
      },
      onError: (error, handler) {
        print('✖ ERROR: ${error.response?.statusCode} - ${error.message}');
        print('URL: ${error.requestOptions.uri}');
        handler.next(error);
      },
    ));
  }

  Future<Response> post(String path, dynamic data) => _dio.post(path, data: data);
  Future<Response> get(String path) => _dio.get(path);
}
