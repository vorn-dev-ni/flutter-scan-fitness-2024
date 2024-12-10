// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoginState {
  String email;
  String password;
  LoginState({
    this.email = "",
    this.password = "",
  });

  LoginState copyWith({
    String? email,
    String? password,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
