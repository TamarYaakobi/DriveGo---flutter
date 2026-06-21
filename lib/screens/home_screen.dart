import 'package:drive_go/screens/cars_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_nav_bar.dart';
import '../theme/app_theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkInternet();
  }

  Future<void> _checkInternet() async {
    final result = await Connectivity().checkConnectivity();

    if (!mounted) return;

    if (result == ConnectivityResult.none) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FavoritesScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.bgDark,
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.goldPrimary),
        ),
      );
    }

    final user = authProvider.user;
    final bool isLoggedIn = user != null;

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: const CustomNavBar(),
      drawer: const CustomDrawer(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 50,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppTheme.bgDark.withOpacity(0.6), AppTheme.bgDark],
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.pexels.com/photos/112460/pexels-photo-112460.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                    ),
                    fit: BoxFit.cover,
                    opacity: 0.35,
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 90,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'אל תסתפק בנסיעה.\nתבחר בחוויה.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'חוויית הנהיגה האולטימטיבית מחכה לך עם צי הרכבים המובחר בישראל.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 35),
                    _buildGoldButton(
                      text: 'לצפייה בקולקציה',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CarsScreen(
                            categoryId: null,
                            categoryName: 'כל הרכבים',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    _buildSectionHeader('הסטנדרט שלנו'),
                    const SizedBox(height: 25),
                    _buildFeatureCard(
                      'חווית פרימיום',
                      'רכבים מוקפדים, נקיים ומתוחזקים ברמה הגבוהה ביותר בשוק.',
                    ),
                    _buildFeatureCard(
                      'זמינות מיידית',
                      'תהליך הזמנה דיגיטלי ומהיר ללא בירוקרטיה מיותרת.',
                    ),
                    _buildFeatureCard(
                      'ביטחון מלא',
                      'כיסוי ביטוחי מקיף ושירות לקוחות אישי הזמין עבורך 24/7.',
                    ),
                  ],
                ),
              ),

              Container(
                color: Colors.white.withOpacity(0.01),
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    _buildSectionHeader('הקטגוריות שלנו'),
                    const SizedBox(height: 25),
                    _buildCategoryCard(
                      'רכבי אטרקציות',
                      'https://www.asfir.co.il/cdn/shop/articles/front-bar-547006-_1__optimized.jpg?v=1771413066',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CarsScreen(
                            categoryId: "1",
                            categoryName: 'רכבי אטרקציות',
                          ),
                        ),
                      ),
                    ),
                    _buildCategoryCard(
                      'רכבי אספנות',
                      'https://images.pexels.com/photos/1592384/pexels-photo-1592384.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CarsScreen(
                            categoryId: "2",
                            categoryName: 'רכבי אספנות',
                          ),
                        ),
                      ),
                    ),
                    _buildCategoryCard(
                      'רכבי יוקרה',
                      'https://images.pexels.com/photos/112460/pexels-photo-112460.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CarsScreen(
                            categoryId: "3",
                            categoryName: 'רכבי יוקרה',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(35),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppTheme.bgDark, Colors.black],
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'מוכנים להתחיל את החוויה?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'הירשמו עכשיו וקבלו גישה מיידית לצי הרכבים האקסקלוסיבי שלנו.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!isLoggedIn) ...[
                          _buildGoldButton(
                            text: 'הרשמה מהירה',
                            onPressed: () =>
                                Navigator.pushNamed(context, '/sign_up_screen'),
                          ),
                          const SizedBox(width: 15),
                        ],
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'קראו עלינו',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 20),

                    _buildContactItem('050-303-5052', 'tel:0503035052'),
                    _buildContactItem(
                      'info@drivego.co.il',
                      'mailto:info@drivego.co.il',
                    ),
                    _buildContactItem("א׳-ה׳ 09:00 - 18:00", ''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Container(width: 45, height: 3, color: AppTheme.goldPrimary),
      ],
    );
  }

  Widget _buildFeatureCard(String title, String description) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.goldPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imageUrl, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        height: 160,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.85), Colors.transparent],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'גלה עוד ←',
                style: TextStyle(color: AppTheme.goldPrimary, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoldButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF3E5AB), AppTheme.goldPrimary, Color(0xFFAA7C11)],
        ),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: AppTheme.goldPrimary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(String text, String urlScheme, [String dummy = '']) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: urlScheme.isEmpty
            ? null
            : () async {
                final Uri url = Uri.parse(urlScheme);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                urlScheme.contains('tel')
                    ? Icons.phone
                    : urlScheme.contains('mailto')
                    ? Icons.email
                    : Icons.access_time,
                color: AppTheme.goldPrimary,
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
