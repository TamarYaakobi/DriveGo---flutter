import 'package:drive_go/widgets/custom_nav_bar.dart';
import 'package:drive_go/widgets/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cars_provider.dart';
import '../theme/app_theme.dart';
import 'car_details_screen.dart';

class CarsScreen extends StatefulWidget {
  final String? categoryId;
  final String categoryName;

  const CarsScreen({
    super.key,
    this.categoryId,
    this.categoryName = 'כל הרכבים', 
  });
  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CarsProvider>(
        context,
        listen: false,
      ).loadCars(categoryId: widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final carsProvider = Provider.of<CarsProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: const CustomNavBar(), 
      drawer: const CustomDrawer(),

      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 16.0,
                left: 16.0,
                top: 16.0,
                bottom: 8.0,
              ),
              child: Text(
                widget
                    .categoryName, 
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF1A1A1E),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "משנת ייצור: ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Expanded(
                        child: Slider(
                          value:
                              carsProvider.selectedYear ??
                              carsProvider.minYearBound,
                          min: carsProvider.minYearBound,
                          max: carsProvider.maxYearBound,
                          divisions:
                              (carsProvider.maxYearBound -
                                      carsProvider.minYearBound)
                                  .toInt(),
                          activeColor: AppTheme.goldPrimary,
                          inactiveColor: Colors.white10,
                          label:
                              (carsProvider.selectedYear?.toInt() ??
                                      carsProvider.minYearBound.toInt())
                                  .toString(),
                          onChanged: (val) {
                            carsProvider.updateFilters(
                              val,
                              carsProvider.selectedSeats,
                            );
                          },
                        ),
                      ),
                      Text(
                        "${carsProvider.selectedYear?.toInt() ?? 'הכל'}",
                        style: const TextStyle(color: AppTheme.goldPrimary),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "מספר מושבים: ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Expanded(
                        child: Slider(
                          value:
                              carsProvider.selectedSeats ??
                              carsProvider.minSeatsBound,
                          min: carsProvider.minSeatsBound,
                          max: carsProvider.maxSeatsBound,
                          divisions:
                              (carsProvider.maxSeatsBound -
                                      carsProvider.minSeatsBound)
                                  .toInt(),
                          activeColor: AppTheme.goldPrimary,
                          inactiveColor: Colors.white10,
                          label:
                              (carsProvider.selectedSeats?.toInt() ??
                                      carsProvider.minSeatsBound.toInt())
                                  .toString(),
                          onChanged: (val) {
                            carsProvider.updateFilters(
                              carsProvider.selectedYear,
                              val,
                            );
                          },
                        ),
                      ),
                      Text(
                        "${carsProvider.selectedSeats?.toInt() ?? 'הכל'}",
                        style: const TextStyle(color: AppTheme.goldPrimary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: carsProvider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.goldPrimary,
                      ),
                    )
                  : carsProvider.cars.isEmpty
                  ? const Center(
                      child: Text(
                        "לא נמצאו רכבים העונים על הסינון",
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(15),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                      itemCount: carsProvider.cars.length,
                      itemBuilder: (context, index) {
                        final car = carsProvider.cars[index];
                        return _buildCarCard(context, car);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarCard(BuildContext context, dynamic car) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CarDetailsScreen(car: car)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      car.imageUrl ?? 'https://via.placeholder.com/150',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: FavoriteButton(car: car, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.name ?? 'שם הרכב',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "שנת ייצור: ${car.year}",
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  Text(
                    "מקומות ישיבה: ${car.seats}",
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.goldPrimary),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "פרטים נוספים",
                      style: TextStyle(
                        color: AppTheme.goldPrimary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
