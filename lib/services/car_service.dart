import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future<List<Car>> getCars({String? categoryId, int? minYear, int? minSeats}) async {
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

  // 4. מחיקת רכב (לאדמין - כמו deleteCar בריאקט)
  Future<void> deleteCar(String carId) async {
    await _db.collection('cars').doc(carId).delete();
  }
}