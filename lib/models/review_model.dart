import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String? id;
  final String carId;
  final String userId;
  final String description;
  final double rating;

  Review({
    this.id,
    required this.carId,
    required this.userId,
    required this.description,
    required this.rating,
  });

  // יצירת אובייקט מתוך Firestore Document
  factory Review.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Review(
      id: doc.id,
      carId: data['carId'] ?? '',
      userId: data['userId'] ?? '',
      description: data['description'] ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // המרה למפה לצורך שמירה ב-Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'carId': carId,
      'userId': userId,
      'description': description,
      'rating': rating,
    };
  }
}