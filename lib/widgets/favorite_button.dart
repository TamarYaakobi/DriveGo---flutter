import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/car_model.dart';
import '../providers/favorites_provider.dart';
import '../theme/app_theme.dart';

class FavoriteButton extends StatelessWidget {
  final Car car;
  final double size;

  const FavoriteButton({super.key, required this.car, this.size = 22});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFav = favoritesProvider.isFavorite(car.id);

    return IconButton(
      icon: Icon(
        isFav ? Icons.favorite : Icons.favorite_border,
        color: isFav ? AppTheme.goldPrimary : Colors.white70,
        size: size,
      ),
      onPressed: () => favoritesProvider.toggleFavorite(car),
    );
  }
}