import 'package:flutter/material.dart';
import '../models/car_model.dart';
import '../services/database_helper.dart';

class FavoritesProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Car> _favorites = [];
  List<Car> get favorites => _favorites;

  bool isFavorite(String carId) {
    return _favorites.any((car) => car.id == carId);
  }

  Future<void> loadFavorites() async {
    _favorites = await _dbHelper.getFavorites();
    notifyListeners();
  }

  Future<void> toggleFavorite(Car car) async {
    if (isFavorite(car.id)) {
      await _dbHelper.removeFavorite(car.id);
      _favorites.removeWhere((c) => c.id == car.id);
    } else {
      await _dbHelper.addFavorite(car);
      _favorites.add(car);
    }
    notifyListeners();
  }
}