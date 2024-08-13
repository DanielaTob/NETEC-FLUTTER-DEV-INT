import 'dart:async';

class AuthService {
  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    return username == "user" && password == "password";
  }
}