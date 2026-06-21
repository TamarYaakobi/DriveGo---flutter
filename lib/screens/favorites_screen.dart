import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_nav_bar.dart';
import '../widgets/favorite_button.dart';
import 'car_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavoritesProvider>(context, listen: false).loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<FavoritesProvider>(context).favorites;

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: const CustomNavBar(),
      drawer: const CustomDrawer(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: favorites.isEmpty
            ? const Center(
                child: Text(
                  "אין רכבים במועדפים עדיין",
                  style: TextStyle(color: Colors.white54),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final car = favorites[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          car.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(car.name, style: const TextStyle(color: Colors.white)),
                      subtitle: Text(
                        "שנת ${car.year} • ${car.seats} מקומות",
                        style: const TextStyle(color: Colors.white54),
                      ),
                      trailing: FavoriteButton(car: car),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CarDetailsScreen(car: car)),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}