// class GymResultModel {
//   String? name;
//   String? summary;
//   String? exercise;
//   String? set;
//   String? rep;
//   String? caloriesBurnPerSet;
//   List<String>? targetMuscles;
//   List<String>? instructions;

//   GymResultModel(
//       {this.name,
//       this.summary,
//       this.exercise,
//       this.set,
//       this.rep,
//       this.caloriesBurnPerSet,
//       this.targetMuscles,
//       this.instructions});

//   GymResultModel.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     summary = json['summary'];
//     exercise = json['exercise'];
//     set = json['set'];
//     rep = json['rep'];
//     caloriesBurnPerSet = json['calories_burn_per_set'];
//     targetMuscles = json['target_muscles'].cast<String>();
//     instructions = json['instructions'].cast<String>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['summary'] = this.summary;
//     data['exercise'] = this.exercise;
//     data['set'] = this.set;
//     data['rep'] = this.rep;
//     data['calories_burn_per_set'] = this.caloriesBurnPerSet;
//     data['target_muscles'] = this.targetMuscles;
//     data['instructions'] = this.instructions;
//     return data;
//   }
// }
class GymResultModel {
  String? name;
  String? summary;
  List<String>? exercise; // Change exercise type to List<String>
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

  // Updated fromJson method
  GymResultModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    summary = json['summary'];

    // Convert 'exercise' to List<String> safely
    exercise = json['exercise'] != null
        ? List<String>.from(
            json['exercise'] is List ? json['exercise'] : [json['exercise']])
        : [];

    set = json['set'];
    rep = json['rep'];
    caloriesBurnPerSet = json['calories_burn_per_set'];

    // Convert 'target_muscles' to List<String> safely
    targetMuscles = json['target_muscles'] != null
        ? List<String>.from(json['target_muscles'] is List
            ? json['target_muscles']
            : [json['target_muscles']])
        : [];

    // Convert 'instructions' to List<String> safely
    instructions = json['instructions'] != null
        ? List<String>.from(json['instructions'] is List
            ? json['instructions']
            : [json['instructions']])
        : [];
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
