import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_go/models/review_model.dart';
import 'package:drive_go/models/user_model.dart';
import 'package:flutter/material.dart';
import '../models/car_model.dart';

class CarService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. שליפת כל הקטגוריות
  Future<List<Map<String, dynamic>>> getCategories() async {
    var snapshot = await _db.collection('categories').get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  // 2. שליפת כל החברות
  Future<List<Map<String, dynamic>>> getCompanies() async {
    var snapshot = await _db.collection('companies').get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  // 3. שליפת רכבים לפי קטגוריה וסינונים (החלפת ה-useEffect והפילטרים מריאקט)
  Future<List<Car>> getCars({
    String? categoryId,
    int? minYear,
    int? minSeats,
  }) async {
    Query query = _db.collection('cars');

    if (categoryId != null && categoryId.isNotEmpty) {
      query = query.where('categoryId', isEqualTo: categoryId);
    }
    if (minYear != null) {
      query = query.where('year', isGreaterThanOrEqualTo: minYear);
    }
    if (minSeats != null) {
      query = query.where('seats', isGreaterThanOrEqualTo: minSeats);
    }

    var snapshot = await query.get();
    return snapshot.docs.map((doc) => Car.fromFirestore(doc)).toList();
  }

  // 4. מחיקת רכב
  Future<void> deleteCar(String carId) async {
    await _db.collection('cars').doc(carId).delete();
  }

  // // 5. שליפת חוות דעת עבור רכב ספציפי
  // Future<List<Review>> getReviewsByCarId(String carId) async {
  //   var snapshot = await _db
  //       .collection('reviews')
  //       .where('carId', isEqualTo: carId)
  //       .get();

  //   // doc כאן הוא מסוג DocumentSnapshot, ולכן זה יעבוד פיקס!
  //   return snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
  // }

  Future<List<Review>> getReviewsByCarId(String carId) async {
    var snapshot = await _db
        .collection('reviews')
        .where('carId', isEqualTo: carId)
        .get();

    return snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
  }

  // 6. הוספת חוות דעת חדשה
  Future<void> addReview(Review review) async {
    await _db.collection('reviews').add(review.toFirestore());
  }

  // 7. מחיקת חוות דעת
  Future<void> deleteReview(String reviewId) async {
    await _db.collection('reviews').doc(reviewId).delete();
  }

  Future<Map<String, UserModel>> getUsersByIds(List<String> userIds) async {
    if (userIds.isEmpty) return {};

    // טוענים את כל המשתמשים פעם אחת - בטוח יותר מ-whereIn לפי documentId,
    // כי 'id' הפנימי לא בהכרח תואם ל-doc.id (בדיוק כמו שראינו ב-cars)
    final snapshot = await _db.collection('users').get();

    final Map<String, UserModel> result = {};
    for (var doc in snapshot.docs) {
      final user = UserModel.fromMap(doc.id, doc.data());
      result[doc.id] = user; // מפתח לפי doc.id האמיתי
      result[user.id] =
          user; // מפתח לפי השדה 'id' הפנימי (גיבוי, למקרה שהוא שונה)
    }

    return result;
  }
}
