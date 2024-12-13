class GymResultModel {
  String? name;
  String? summary;
  List<String>? exercises;
  String? set;
  String? rep;
  String? caloriesBurnPerSet;
  List<String>? targetMuscles;
  List<String>? instructions;

  GymResultModel({
    this.name,
    this.summary,
    this.exercises,
    this.set,
    this.rep,
    this.caloriesBurnPerSet,
    this.targetMuscles,
    this.instructions,
  });

  // Improved fromJson method
  GymResultModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    summary = json['summary'];
    exercises =
        json['exercises'] is List ? List<String>.from(json['exercises']) : null;
    set = json['set'];
    rep = json['rep'];
    caloriesBurnPerSet = json['calories_burn_per_set'];
    targetMuscles = json['targetMuscles'] is List
        ? List<String>.from(json['targetMuscles'])
        : null;
    instructions = json['instructions'] is List
        ? List<String>.from(json['instructions'])
        : null;
  }

  // toJson method remains the same
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = this.name;
    data['summary'] = this.summary;
    data['exercises'] = this.exercises;
    data['set'] = this.set;
    data['rep'] = this.rep;
    data['calories_burn_per_set'] = this.caloriesBurnPerSet;
    data['targetMuscles'] = this.targetMuscles;
    data['instructions'] = this.instructions;
    return data;
  }
}
