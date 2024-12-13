import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  final DateTime? createdAt; // Nullable DateTime
  final String tag;
  final String? imageUrl;
  final String title;
  final String userId;

  ActivityModel({
    this.createdAt, // Allow createdAt to be nullable
    required this.tag,
    this.imageUrl,
    required this.title,
    required this.userId,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      createdAt: json['created_at'] != null
          ? (json['created_at'] as Timestamp).toDate()
          : null, // Check if created_at exists and convert to DateTime
      tag: json['tag'] as String,
      imageUrl: json['imageUrl'] as String?,
      title: json['title'] as String,
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created_at': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : null, // If createdAt is null, store null
      'tag': tag,
      'imageUrl': imageUrl,
      'title': title,
      'userId': userId,
    };
  }
}
