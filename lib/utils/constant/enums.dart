enum Gender { men, women }

enum Option { s, m, l }

enum ActivityTag { gym, food }

enum StatusSnackbar { success, failed }

enum NutritionFactsType { calories, fat, protein, sugar, carbohydrate }

enum AppConfigState {
  banner_tag('banner_tag'),
  social_login('social_login');

  final String value;
  const AppConfigState(this.value);
}

enum Flavor {
  dev('dev'),
  production('prod'),
  staging('staging');

  final String value;
  const Flavor(this.value);
}
