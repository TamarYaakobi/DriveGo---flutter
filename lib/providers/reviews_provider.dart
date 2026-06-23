import 'package:drive_go/models/review_model.dart';
import 'package:drive_go/services/car_service.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class ReviewsProvider extends ChangeNotifier {
  final CarService _carService = CarService();

  List<Review> _reviews = [];
  Map<String, UserModel> _usersData = {};
  bool _isLoading = false;

  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;

  String getReviewerName(String userId) {
    final user = _usersData[userId];
    if (user == null) return "משתמש רשום";

    final fullName = "${user.firstName} ${user.lastName}".trim();
    return fullName.isEmpty ? "משתמש רשום" : fullName;
  }

  double get averageRating {
    if (_reviews.isEmpty) return 0.0;
    double sum = _reviews.fold(0.0, (acc, review) => acc + review.rating);
    return sum / _reviews.length;
  }

  Future<void> loadReviews(String carId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _reviews = await _carService.getReviewsByCarId(carId);

      final uniqueUserIds = _reviews.map((r) => r.userId).toSet().toList();
      _usersData = await _carService.getUsersByIds(uniqueUserIds);
    } catch (e) {
      debugPrint("Error loading reviews: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addNewReview(Review review) async {
    bool alreadyReviewed = _reviews.any((r) => r.userId == review.userId);
    if (alreadyReviewed) {
      return false; 
    }

    try {
      await _carService.addReview(review);
      await loadReviews(review.carId); 
      return true;
    } catch (e) {
      debugPrint("Error adding review: $e");
      return false;
    }
  }

  Future<void> removeReview(String reviewId, String carId) async {
    try {
      await _carService.deleteReview(reviewId);
      await loadReviews(carId);
    } catch (e) {
      debugPrint("Error deleting review: $e");
    }
  }
}
