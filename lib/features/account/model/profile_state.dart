// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProfileState {
  String fullName;
  String email;
  String imageUrl;
  String? gender;
  String? dob;
  ProfileState({
    this.fullName = "",
    this.email = "",
    this.imageUrl = "",
    this.gender = "",
    this.dob = "",
  });

  ProfileState copyWith({
    String? fullName,
    String? email,
    String? imageUrl,
    String? gender,
    String? dob,
  }) {
    return ProfileState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
    );
  }
}
