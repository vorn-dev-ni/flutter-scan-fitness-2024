// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserHealth {
  String? steps;
  String? caloriesBurn;
  String? sleepduration;

  UserHealth({
    this.steps,
    this.caloriesBurn,
    this.sleepduration,
  });

  UserHealth copyWith({
    String? steps,
    String? caloriesBurn,
    String? sleepduration,
  }) {
    return UserHealth(
      steps: steps ?? this.steps,
      caloriesBurn: caloriesBurn ?? this.caloriesBurn,
      sleepduration: sleepduration ?? this.sleepduration,
    );
  }
}
