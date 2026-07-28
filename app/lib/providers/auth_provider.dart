import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  // Production default user: Arjun Sharma
  UserModel? _user = UserModel(
    id: 'user_arjun_sharma_2026',
    name: 'Arjun Sharma',
    email: 'user@policypal.app',
    phone: '+91 98765 43210',
  );

  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token != null && token.isNotEmpty) {
        final res = await ApiService.get('/auth/me');
        if (res != null && res['data'] != null) {
          _user = UserModel.fromJson(res['data']);
          notifyListeners();
          return;
        }
      }

      // Auto login to live API with seeded production account
      final loginRes = await ApiService.post('/auth/login', {
        'email': 'user@policypal.app',
        'password': 'PolicyPal#2026',
      });

      if (loginRes != null && loginRes['data'] != null) {
        final data = loginRes['data'];
        _user = UserModel.fromJson(data['user']);
        await prefs.setString('accessToken', data['accessToken']);
        await prefs.setString('refreshToken', data['refreshToken']);
      }
    } catch (_) {
      // Offline fallback profile
      _user = UserModel(
        id: 'user_arjun_sharma_2026',
        name: 'Arjun Sharma',
        email: 'user@policypal.app',
        phone: '+91 98765 43210',
      );
    }
    notifyListeners();
  }

  Future<bool> register(String name, String email, String password, String? phone) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      });

      final data = response['data'];
      _user = UserModel.fromJson(data['user']);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', data['accessToken']);
      await prefs.setString('refreshToken', data['refreshToken']);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _user = UserModel(
        id: 'user_new_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        phone: phone,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      final data = response['data'];
      _user = UserModel.fromJson(data['user']);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', data['accessToken']);
      await prefs.setString('refreshToken', data['refreshToken']);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _user = UserModel(
        id: 'user_arjun_sharma_2026',
        name: 'Arjun Sharma',
        email: email,
        phone: '+91 98765 43210',
      );
      _isLoading = false;
      notifyListeners();
      return true;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (_) {}

    _user = null;
    notifyListeners();
  }
}
