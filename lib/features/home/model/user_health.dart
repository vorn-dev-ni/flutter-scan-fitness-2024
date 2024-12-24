// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserHealth {
  String? steps;
  String? caloriesBurn;
  String? sleepduration;
  String? targetSteps;
  String? targetSleeps;
  String? targetCalories;
  UserHealth({
    this.steps,
    this.caloriesBurn,
    this.sleepduration,
    this.targetSteps,
    this.targetSleeps,
    this.targetCalories,
  });

  UserHealth copyWith({
    String? steps,
    String? caloriesBurn,
    String? sleepduration,
    String? targetSteps,
    String? targetSleeps,
    String? targetCalories,
  }) {
    return UserHealth(
      steps: steps ?? this.steps,
      caloriesBurn: caloriesBurn ?? this.caloriesBurn,
      sleepduration: sleepduration ?? this.sleepduration,
      targetSteps: targetSteps ?? this.targetSteps,
      targetSleeps: targetSleeps ?? this.targetSleeps,
      targetCalories: targetCalories ?? this.targetCalories,
    );
  }
}
