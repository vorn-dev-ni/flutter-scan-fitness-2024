// ignore_for_file: public_member_api_docs, sort_constructors_first
class SimilarFoods {
  late final String name;
  late final String calories;
  late final String sugar;
  late final double rating;
  SimilarFoods({
    required this.name,
    required this.calories,
    required this.sugar,
    required this.rating,
  });

  @override
  String toString() {
    return 'SimilarFoods(name: $name, calories: $calories, sugar: $sugar, rating: $rating)';
  }
}
