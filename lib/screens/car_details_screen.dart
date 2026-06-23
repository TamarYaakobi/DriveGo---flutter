import 'package:drive_go/widgets/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/review_model.dart';
import '../providers/reviews_provider.dart';
import '../providers/auth_provider.dart'; 
import '../theme/app_theme.dart';
import '../widgets/custom_nav_bar.dart';

class CarDetailsScreen extends StatefulWidget {
  final dynamic car;

  const CarDetailsScreen({super.key, required this.car});

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _ratingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReviewsProvider>(
        context,
        listen: false,
      ).loadReviews(widget.car.id);
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  void _handleNewReviewClick(
    ReviewsProvider reviewsProvider,
    AuthProvider authProvider,
  ) {
    if (authProvider.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("רק משתמשים רשומים יכולים להוסיף חוות דעת"),
        ),
      );
      return;
    }

    final user = authProvider.user!;

    if (user.isAdmin == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("מנהל מערכת אינו יכול להוסיף חוות דעת")),
      );
      return;
    }

    bool alreadyReviewed = reviewsProvider.reviews.any(
      (r) => r.userId == user.id,
    );
    if (alreadyReviewed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("אינך יכול להוסיף חוות דעת נוספת לרכב זה"),
        ),
      );
      return;
    }

    _showAddReviewDialog(reviewsProvider, user);
  }

  void _showAddReviewDialog(ReviewsProvider provider, dynamic user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1E),
        title: const Text(
          "הוסף חוות דעת",
          style: TextStyle(color: Colors.white),
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'הכנס חוות דעת',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'שדה חובה' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ratingController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'נקד אותנו (1-5)',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'שדה חובה';
                  final numVal = double.tryParse(val);
                  if (numVal == null || numVal < 1 || numVal > 5)
                    return 'דירוג בין 1 ל-5 בלבד';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ביטול", style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.goldPrimary,
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final review = Review(
                  carId: widget.car.id,
                  userId: user.id,
                  description: _descriptionController.text,
                  rating: double.parse(_ratingController.text),
                );

                bool success = await provider.addNewReview(review);
                Navigator.pop(context);

                if (success) {
                  _descriptionController.clear();
                  _ratingController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("חוות הדעת נוספה בהצלחה")),
                  );
                }
              }
            },
            child: const Text("שלח", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviewsProvider = Provider.of<ReviewsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: const CustomNavBar(),
      drawer: const CustomDrawer(),
      backgroundColor: AppTheme.bgDark,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: Colors.black,
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [FavoriteButton(car: widget.car, size: 26)],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.car.name ?? "פרטי הרכב",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Image.network(
                  widget.car.imageUrl ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[900],
                      child: const Icon(
                        Icons.directions_car,
                        color: Colors.white54,
                        size: 60,
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "חוות דעת ודירוגים",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _handleNewReviewClick(
                            reviewsProvider,
                            authProvider,
                          ),
                          icon: const Icon(
                            Icons.add,
                            color: AppTheme.goldPrimary,
                          ),
                          label: const Text(
                            "הוסף ביקורת",
                            style: TextStyle(color: AppTheme.goldPrimary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Text(
                          "דירוג ממוצע: ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          "${reviewsProvider.averageRating.toStringAsFixed(1)} (${reviewsProvider.reviews.length} ביקורות)",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    reviewsProvider.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.goldPrimary,
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: reviewsProvider.reviews.length,
                            itemBuilder: (context, index) {
                              final review = reviewsProvider.reviews[index];
                              return Container(
                                padding: const EdgeInsets.all(15),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A1A1E),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          reviewsProvider.getReviewerName(
                                            review.userId,
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${review.rating} ",
                                              style: const TextStyle(
                                                color: Colors.amber,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 14,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      review.description,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),

                                    if (user != null &&
                                        user.id == review.userId)
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.redAccent,
                                            size: 20,
                                          ),
                                          onPressed: () =>
                                              reviewsProvider.removeReview(
                                                review.id!,
                                                widget.car.id,
                                              ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
