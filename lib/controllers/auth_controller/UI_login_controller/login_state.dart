class LoginState {
  LoginState({this.buttonLoader = false, this.passwordObsecure = true});

  final bool buttonLoader;
  final bool passwordObsecure;

  LoginState copyWith({bool? buttonLoader, bool? passwordObsecure}) {
    return LoginState(
        buttonLoader: buttonLoader ?? this.buttonLoader, passwordObsecure: passwordObsecure ?? this.passwordObsecure);
  }
}
