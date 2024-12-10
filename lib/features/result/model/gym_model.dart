class GymResultModel {
  String? name;
  String? summary;
  String? exercise;
  String? set;
  String? rep;
  String? caloriesBurnPerSet;
  List<String>? targetMuscles;
  List<String>? instructions;

  GymResultModel(
      {this.name,
      this.summary,
      this.exercise,
      this.set,
      this.rep,
      this.caloriesBurnPerSet,
      this.targetMuscles,
      this.instructions});

  GymResultModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    summary = json['summary'];
    exercise = json['exercise'];
    set = json['set'];
    rep = json['rep'];
    caloriesBurnPerSet = json['calories_burn_per_set'];
    targetMuscles = json['target_muscles'].cast<String>();
    instructions = json['instructions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['summary'] = this.summary;
    data['exercise'] = this.exercise;
    data['set'] = this.set;
    data['rep'] = this.rep;
    data['calories_burn_per_set'] = this.caloriesBurnPerSet;
    data['target_muscles'] = this.targetMuscles;
    data['instructions'] = this.instructions;
    return data;
  }
}
