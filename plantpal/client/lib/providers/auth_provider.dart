import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  final _storage = const FlutterSecureStorage();

  bool _isLoggedIn = false;
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      print("→ Попытка логина: $email");
      final response = await _api.post('/auth/login', {
        'email': email,
        'password': password,
      });

      final token = response.data['access_token'];
      await _storage.write(key: 'token', value: token);

      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      print("✓ Логин успешен");
      return true;
    } catch (e) {
      print('✖ Login error: $e');
      _errorMessage = 'Ошибка входа';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _api.post('/auth/register', {
        'email': email,
        'password': password,
      });

      final token = response.data['access_token'];
      await _storage.write(key: 'token', value: token);

      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Ошибка регистрации';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    _isLoggedIn = false;
    notifyListeners();
  }

  // Этот метод был нужен в app.dart
  Future<void> checkLoginStatus() async {
    final token = await _storage.read(key: 'token');
    _isLoggedIn = token != null;
    notifyListeners();
  }
}
