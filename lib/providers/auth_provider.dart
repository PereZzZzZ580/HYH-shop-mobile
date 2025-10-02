import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isAuth => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Simulate authentication with hardcoded users (in a real app, you'd connect to a backend)
  final Map<String, User> _users = {
    'test@example.com': User(
      id: 'user1',
      email: 'test@example.com',
      name: 'Usuario de Prueba',
    ),
  };

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you would make an API call here
    // For now, we'll simulate authentication with a hardcoded user
    // The password doesn't matter for this example
    if (_users.containsKey(email)) {
      _currentUser = _users[email]!;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Credenciales inválidas. Por favor intente de nuevo.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you would make an API call here
    // For now, we'll simulate registration
    // Check if user already exists
    if (_users.containsKey(email)) {
      _errorMessage = 'Ya existe una cuenta con este correo electrónico.';
      _isLoading = false;
      notifyListeners();
      return false;
    } else {
      // Add new user
      final newUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
      );
      
      _users[email] = newUser;
      _currentUser = newUser;
      _isLoading = false;
      notifyListeners();
      return true;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}