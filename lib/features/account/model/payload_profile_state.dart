class PayloadProfileState {
  String fullName;
  String email;
  PayloadProfileState({this.fullName = "", this.email = ""});

  PayloadProfileState copyWith({String? fullName, String? email}) {
    return PayloadProfileState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
    );
  }
}
