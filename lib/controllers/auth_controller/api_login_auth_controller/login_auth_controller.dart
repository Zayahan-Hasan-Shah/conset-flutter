import 'package:conset/models/login_model.dart';
import 'package:conset/services/auth_services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class LoginAuthNotifier extends StateNotifier<LoginModel?> {
  LoginAuthNotifier() : super(null);

  Future<LoginModel?> loginAuth(String email, String password) async {
    try {
      final response = await AuthService().loginService(email, password);
      if (response != null) {
        state = response;
        return response;
      } else {
        state = null;
      }
    } catch (e) {
      print("Login failed: $e");
      rethrow;
    }
    return null;
  }
}

final loginAuthProvider = StateNotifierProvider<LoginAuthNotifier, LoginModel?>((ref) {
  return LoginAuthNotifier();
});
