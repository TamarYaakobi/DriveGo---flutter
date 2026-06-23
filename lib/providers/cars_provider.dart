import 'package:flutter/material.dart';
import '../models/car_model.dart';
import '../services/car_service.dart';

class CarsProvider extends ChangeNotifier {
  final CarService _carService = CarService();

  List<Car> _cars = [];
  bool _isLoading = false;
  
  double? selectedYear;
  double? selectedSeats;
  String? currentCategoryId;

  double minYearBound = 2010;
  double maxYearBound = 2026;
  double minSeatsBound = 2;
  double maxSeatsBound = 8;

  List<Car> get cars => _cars;
  bool get isLoading => _isLoading;

  Future<void> loadCars({String? categoryId}) async {
    _isLoading = true;
    currentCategoryId = categoryId;
    notifyListeners();

    try {
      _cars = await _carService.getCars(
        categoryId: currentCategoryId,
        minYear: selectedYear?.toInt(),
        minSeats: selectedSeats?.toInt(),
      );
      
    } catch (e) {
      debugPrint("Error fetching cars: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateFilters(double? year, double? seats) {
    selectedYear = year;
    selectedSeats = seats;
    loadCars(categoryId: currentCategoryId);
  }

  void clearFilters() {
    selectedYear = null;
    selectedSeats = null;
    loadCars(categoryId: currentCategoryId);
  }
}