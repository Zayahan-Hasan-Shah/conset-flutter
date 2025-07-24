import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'login_state.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(LoginState(passwordObsecure: true, buttonLoader: false));

  void setPasswordObsecureState(bool? value) {
    state = state.copyWith(passwordObsecure: value);
  }

  void setLoginButtonLoaderState(bool? value) {
    state = state.copyWith(buttonLoader: value);
  }

  bool get passwordObsecure {
    return state.passwordObsecure;
  }

  bool get buttonLoader {
    return state.buttonLoader;
  }
}

final loginNotifierProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) => LoginNotifier());
