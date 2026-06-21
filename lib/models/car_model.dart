import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  final String id;
  final String name;
  final int year;
  final int seats;
  final String imageUrl;
  final String companyId;
  final String categoryId;
  final String description;

  Car({
    required this.id,
    required this.name,
    required this.year,
    required this.seats,
    required this.imageUrl,
    required this.companyId,
    required this.categoryId,
    required this.description,
  });

  // שליפה מתוך Firebase Firestore
  factory Car.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Car(
      id: doc.id,
      name: data['name'] ?? '',
      year: data['year'] ?? 2020,
      seats: data['seats'] ?? 4,
      imageUrl: data['imageUrl'] ?? '',
      companyId: data['companyId'] ?? '',
      categoryId: data['categoryId'] ?? '',
      description: data['description'] ?? '',
    );
  }

  // המרה ל-Map עבור שמירה ב-SQLite (כשמישהו לוחץ על הלב/מועדפים)
  Map<String, dynamic> toSQLiteMap() {
    return {
      'id': id,
      'name': name,
      'year': year,
      'seats': seats,
      'imageUrl': imageUrl,
      'companyId': companyId,
      'categoryId': categoryId,
      'description': description,
    };
  }
  
  factory Car.fromSQLiteMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'] as String,
      name: map['name'] as String,
      year: map['year'] as int,
      seats: map['seats'] as int,
      imageUrl: map['imageUrl'] as String,
      companyId: map['companyId'] as String,
      categoryId: map['categoryId'] as String,
      description: map['description'] as String,
    );
  }
}
