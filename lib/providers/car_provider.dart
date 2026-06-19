import 'package:flutter/material.dart';
import '../models/car_model.dart';
import '../services/car_service.dart';

class CarProvider with ChangeNotifier {
  final CarService _carService = CarService();

  List<Car> _cars = [];
  bool _isLoading = false;

  // גטרים כדי לגשת לנתונים מהמסכים
  List<Car> get cars => _cars;
  bool get isLoading => _isLoading;

  // פונקציה לשליפת הרכבים עם תמיכה בסינונים (כמו ה-fetchData בריאקט)
  Future<void> fetchAndSetCars({String? categoryId, int? minYear, int? minSeats}) async {
    _isLoading = true;
    notifyListeners(); // מעדכן את ה-UI שהתחילה טעינה

    try {
      _cars = await _carService.getCars(
        categoryId: categoryId,
        minYear: minYear,
        minSeats: minSeats,
      );
    } catch (error) {
      print("Error fetching cars: $error");
    } finally {
      _isLoading = false;
      notifyListeners(); // מעדכן את ה-UI שהטעינה הסתיימה והנתונים פה
    }
  }

  // פונקציה למחיקת רכב (לאדמין)
  Future<void> deleteCar(String carId) async {
    try {
      await _carService.deleteCar(carId);
      _cars.removeWhere((car) => car.id == carId);
      notifyListeners(); // מעדכן את המסך שהרכב נמחק מהרשימה
    } catch (error) {
      print("Error deleting car: $error");
    }
  }
}