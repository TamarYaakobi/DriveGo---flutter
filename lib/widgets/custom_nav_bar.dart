import 'package:drive_go/screens/about_us_screen.dart';
import 'package:drive_go/screens/add_car_screen.dart';
import 'package:drive_go/screens/cars_screen.dart';
import 'package:drive_go/screens/favorites_screen.dart';
import 'package:drive_go/screens/sign_in_screen.dart';
import 'package:drive_go/screens/home_screen.dart';
import 'package:drive_go/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart'; 
import '../theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomNavBar({super.key}); 

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final String displayTitle = user != null
        ? 'שלום, ${user.firstName}'
        : 'שלום, אורח';

    return AppBar(
      backgroundColor: AppTheme.bgDark,
      elevation: 2,
      shadowColor: AppTheme.goldPrimary.withOpacity(0.2),

      title: Image.asset(
        'assets/images/logo.png',
        height: 40,
        fit: BoxFit.contain,
      ),
      centerTitle: true,

      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: Text(
              displayTitle,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ),
      ],
      iconTheme: const IconThemeData(color: AppTheme.goldPrimary),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Drawer(
      child: Container(
        color: AppTheme.bgDark,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.goldPrimary.withOpacity(0.3),
                    ),
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 90,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _createDrawerItem(Icons.home, 'דף הבית', () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    }),

                    if (user != null)
                      _createDrawerItem(Icons.favorite, 'מועדפים', () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FavoritesScreen(),
                          ),
                        );
                      }),

                    const Divider(color: Colors.white24),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        'קטגוריות רכבים',
                        style: TextStyle(
                          color: AppTheme.goldPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _createDrawerItem(
                      Icons.directions_car,
                      'כל הרכבים',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CarsScreen(
                            categoryId: null,
                            categoryName: 'כל הרכבים',
                          ),
                        ),
                      ),
                    ),
                    _createDrawerItem(
                      Icons.auto_awesome,
                      'רכבי אספנות',
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
                    _createDrawerItem(
                      Icons.star,
                      'רכבי יוקרה',
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
                    _createDrawerItem(
                      Icons.local_activity,
                      'רכבי אטרקציות',
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

                    const Divider(color: Colors.white24),
                    _createDrawerItem(Icons.info, 'עלינו', () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutUsScreen(),
                        ),
                      );
                    }),
                    _createDrawerItem(Icons.contact_phone, 'צור קשר', () {
                      Navigator.pop(context);
                      _showContactBottomSheet(context);
                    }),

                    const Divider(color: Colors.white24),

                    if (user == null) ...[
                      _createDrawerItem(
                        Icons.login,
                        'כניסה',
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        ),
                      ),
                      _createDrawerItem(
                        Icons.person_add,
                        'הרשמה',
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        ),
                      ),
                    ] else ...[
                      if (user != null && user.isAdmin == true) ...[
                        const Divider(
                          color: AppTheme.goldPrimary,
                          thickness: 0.3,
                        ),
                        _createDrawerItem(
                          Icons.add_business,
                          'הוספת רכב חדש (אדמין)',
                          () {
                            Navigator.pop(context); 
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddCarScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                      _createDrawerItem(Icons.logout, 'התנתקות', () async {
                        await authProvider.signOut();
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createDrawerItem(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.goldPrimary),
      title: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap,
    );
  }

  void _showContactBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Drive Go — זמינים עבורך',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'נשמח לעמוד לשירותך בכל שאלה או בקשה',
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
                const SizedBox(height: 25),
                _buildActionContactRow(
                  icon: Icons.phone,
                  title: 'חייג אלינו',
                  subtitle: '050-303-5052',
                  urlScheme: 'tel:0503035052',
                ),
                const Divider(color: Colors.white12, height: 20),
                _buildActionContactRow(
                  icon: Icons.email,
                  title: 'שלח אימייל',
                  subtitle: 'info@drivego.co.il',
                  urlScheme: 'mailto:info@drivego.co.il',
                ),
                const Divider(color: Colors.white12, height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.access_time,
                        color: AppTheme.goldPrimary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'שעות פעילות',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'א׳-ה׳ 09:00 - 18:00',
                          style: TextStyle(color: Colors.white38, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionContactRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required String urlScheme,
  }) {
    return InkWell(
      onTap: () async {
        final Uri url = Uri.parse(urlScheme);
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.goldPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppTheme.goldPrimary, size: 22),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white24,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
