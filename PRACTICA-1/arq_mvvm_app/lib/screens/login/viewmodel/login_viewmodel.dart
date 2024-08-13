import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService authService;
  LoginViewModel({required this.authService});
  bool _isLoading = false;
  String? _error;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final isSuccess = await authService.login(username, password);
      _isLoading = false;
      notifyListeners();
      return isSuccess;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}