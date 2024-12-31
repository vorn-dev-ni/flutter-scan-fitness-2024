class FoodModelResult {
  int? rating;
  String? title;
  String? feature;
  String? comment;
  List<NutritionFacts>? nutritionFacts;
  bool? isHealthy;
  // List<SimilarRecommendations>? similarRecommendations;

  FoodModelResult({
    this.rating,
    this.title,
    this.feature,
    this.comment,
    this.nutritionFacts,
    this.isHealthy,
    // this.similarRecommendations
  });

  FoodModelResult.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    title = json['title'];
    feature = json['feature'];
    comment = json['comment'];
    if (json['nutrition_facts'] != null) {
      nutritionFacts = <NutritionFacts>[];
      json['nutrition_facts'].forEach((v) {
        nutritionFacts!.add(new NutritionFacts.fromJson(v));
      });
    }
    isHealthy = json['isHealthy'];
    // if (json['similar_recommendations'] != null) {
    //   similarRecommendations = <SimilarRecommendations>[];
    //   json['similar_recommendations'].forEach((v) {
    //     similarRecommendations!.add(new SimilarRecommendations.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating'] = this.rating;
    data['title'] = this.title;
    data['feature'] = this.feature;
    data['comment'] = this.comment;
    if (this.nutritionFacts != null) {
      data['nutrition_facts'] =
          this.nutritionFacts!.map((v) => v.toJson()).toList();
    }
    data['isHealthy'] = this.isHealthy;
    // if (this.similarRecommendations != null) {
    //   data['similar_recommendations'] =
    //       this.similarRecommendations!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class NutritionFacts {
  String? iconType;
  String? value;
  String? title;

  NutritionFacts({this.iconType, this.value, this.title});

  NutritionFacts.fromJson(Map<String, dynamic> json) {
    iconType = json['iconType'];
    value = json['value'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iconType'] = this.iconType;
    data['value'] = this.value;
    data['title'] = this.title;
    return data;
  }
}

class SimilarRecommendations {
  String? title;
  String? feature;
  List<NutritionFacts>? nutritionFacts;

  SimilarRecommendations({this.title, this.feature, this.nutritionFacts});

  SimilarRecommendations.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    feature = json['feature'];
    if (json['nutrition_facts'] != null) {
      nutritionFacts = <NutritionFacts>[];
      json['nutrition_facts'].forEach((v) {
        nutritionFacts!.add(new NutritionFacts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['feature'] = this.feature;
    if (this.nutritionFacts != null) {
      data['nutrition_facts'] =
          this.nutritionFacts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
