// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProfileState {
  String fullName;
  String email;
  String imageUrl;
  ProfileState({this.fullName = "", this.email = "", this.imageUrl = ""});

  ProfileState copyWith({
    String? fullName,
    String? email,
    String? imageUrl,
  }) {
    return ProfileState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
