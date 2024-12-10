class RegisterState {
  String fullName;
  String email;
  String password;
  String confirmPassword;

  RegisterState({
    this.fullName = "",
    this.email = "",
    this.password = "",
    this.confirmPassword = "",
  });

  RegisterState copyWith({
    String? fullName,
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    return RegisterState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}
