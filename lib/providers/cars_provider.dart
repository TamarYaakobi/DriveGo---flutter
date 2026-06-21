import 'package:flutter/material.dart';
import '../models/car_model.dart'; // ודא שנתיב המודל נכון
import '../services/car_service.dart'; // נתיב הסרוויס שלך

class CarsProvider extends ChangeNotifier {
  final CarService _carService = CarService();

  List<Car> _cars = [];
  bool _isLoading = false;
  
  // פילטרים נוכחיים לסינון
  double? selectedYear;
  double? selectedSeats;
  String? currentCategoryId;

  // טווחים דינמיים (כמו ה-Ranges בריאקט)
  double minYearBound = 2010;
  double maxYearBound = 2026;
  double minSeatsBound = 2;
  double maxSeatsBound = 8;

  List<Car> get cars => _cars;
  bool get isLoading => _isLoading;

  // פונקציית טעינה ראשונית וסינון
  Future<void> loadCars({String? categoryId}) async {
    _isLoading = true;
    currentCategoryId = categoryId;
    notifyListeners();

    try {
      // שליפה מהסרוויס הקיים שלך לפי הפילטרים שנבחרו
      _cars = await _carService.getCars(
        categoryId: currentCategoryId,
        minYear: selectedYear?.toInt(),
        minSeats: selectedSeats?.toInt(),
      );
      
      // כאן ניתן לעדכן את הטווחים דינמית במידת הצורך (כמו getYearRange בריאקט)
      // לצורך הפשטות, הטווחים מוגדרים כברירת מחדל וניתן לשנותם מהדאטהבייס
    } catch (e) {
      debugPrint("Error fetching cars: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // עדכון פילטרים וטעינה מחדש
  void updateFilters(double? year, double? seats) {
    selectedYear = year;
    selectedSeats = seats;
    loadCars(categoryId: currentCategoryId);
  }

  // איפוס פילטרים
  void clearFilters() {
    selectedYear = null;
    selectedSeats = null;
    loadCars(categoryId: currentCategoryId);
  }
}