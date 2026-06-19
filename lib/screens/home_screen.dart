import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/custom_nav_bar.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // מאזינים בזמן אמת למצב החיבור של המשתמש
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        // בזמן טעינת מצב החיבור, נציג אנימציית טעינה מוזהבת
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppTheme.bgDark,
            body: Center(
              child: CircularProgressIndicator(color: AppTheme.goldPrimary),
            ),
          );
        }

        // בדיקה: האם המשתמש מחובר?
        bool isLoggedIn = authSnapshot.hasData && authSnapshot.data != null;

        if (!isLoggedIn) {
          // אם הוא אורח - נציג לו את דף הבית עם המיתוג "אורח"
          return _buildHomeScreenContent(context, 'אורח', false);
        }

        // אם הוא מחובר - נשלוף את ה-UID שלו ונביא את השם האמיתי מ-Firestore
        String uid = authSnapshot.data!.uid;

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .snapshots(),
          builder: (context, firestoreSnapshot) {
            String displayFirstName = 'בטעינה...';

            if (firestoreSnapshot.hasData && firestoreSnapshot.data!.exists) {
              var userData =
                  firestoreSnapshot.data!.data() as Map<String, dynamic>;
              displayFirstName = userData['firstName'] ?? 'משתמש';
            }

            // מציגים את דף הבית המלא עם השם האמיתי
            return _buildHomeScreenContent(context, displayFirstName, true);
          },
        );
      },
    );
  }

  // פונקציה מרכזית שבונה את תוכן דף הבית
  Widget _buildHomeScreenContent(
    BuildContext context,
    String name,
    bool isUserLoggedIn,
  ) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: CustomNavBar(userName: name), // הבר הדינמי שלנו
      drawer: const CustomDrawer(), // התפריט הצידי
      body: Directionality(
        textDirection: TextDirection.rtl, // תמיכה מלאה בעברית
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ================= SECTION 1: HERO SECTION =================
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
                    opacity: 0.35, // יוצר את ה-video-overlay הכהה מהריאקט
                  ),
                ),
                child: Column(
                  children: [
                    // --- כאן הוספנו את הלוגו בראש דף הבית ---
                    Image.asset(
                      'assets/images/logo.png',
                      height: 90, // גובה בול במידה הנכונה לראש הדף
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 25),

                    // כותרת ראשית חזקה ומעוצבת
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
                    // כותרת משנית במראה מאט עמום
                    const Text(
                      'חוויית הנהיגה האולטימטיבית מחכה לך עם צי הרכבים המובחר בישראל.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 35),
                    // כפתור ה-CTA המרכזי בעיצוב גרדיאנט זהב יוקרתי
                    _buildGoldButton(
                      text: 'לצפייה בקולקציה',
                      onPressed: () {
                        // כאן יבוא ניווט לדף הרכבים בהמשך
                      },
                    ),
                  ],
                ),
              ),

              // ================= SECTION 2: FEATURES (הסטנדרט שלנו) =================
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

              // ================= SECTION 3: CATEGORIES (הקטגוריות שלנו) =================
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
                    ),
                    _buildCategoryCard(
                      'רכבי אספנות',
                      'https://images.pexels.com/photos/1592384/pexels-photo-1592384.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                    ),
                    _buildCategoryCard(
                      'רכבי יוקרה',
                      'https://images.pexels.com/photos/112460/pexels-photo-112460.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                    ),
                  ],
                ),
              ),

              // ================= SECTION 4: FOOTER CTA & CONTACT =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(35),
                decoration: BoxDecoration(
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

                    // כפתורי פעולה תחתונים
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!isUserLoggedIn) ...[
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
                          onPressed: () {}, // דף עלינו
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

                    // פרטי קשר מובנים באפליקציה
                    // פרטי קשר מובנים באפליקציה עם קישור ישיר לפעולה
                    _buildContactItem(
                      Icons.phone,
                      '050-303-5052',
                      'tel:0503035052',
                    ),
                    _buildContactItem(
                      Icons.email,
                      'info@drivego.co.il',
                      'mailto:info@drivego.co.il',
                    ),

                    // שורת שעות הפעילות נשארת כטקסט רגיל ללא פעולה (פשוט מעבירים מחרוזת ריקה או לא לוחצים)
                    _buildContactItem(
                      Icons.access_time,
                      "א׳-ה׳ 09:00 - 18:00",
                      '',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ווידג'ט עזר לכותרות סקשנים עם קו זהב קטן מתחת
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

  // ווידג'ט עזר לכרטיסי התכונות (Features)
  Widget _buildFeatureCard(String title, String description) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1E), // תיקון: הצירוף הסיני הוסר בהצלחה!
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

  // ווידג'ט עזר לכרטיסי קטגוריות עם תמונת רקע וטקסט מעל
  Widget _buildCategoryCard(String title, String imageUrl) {
    return Container(
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
        // ה-Overlay הכהה כדי שהטקסט יבלוט
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
    );
  }

  // כפתור זהב יוקרתי שחוזר על עצמו
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

  // שורת פרטי קשר פשוטה ויפה לפוטר
  Widget _buildContactItem(IconData icon, String text, String urlScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        // הופך את השורה כולה ללחיצה עם אפקט מגע עדין
        onTap: () async {
          final Uri url = Uri.parse(urlScheme);
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          } else {
            // במקרה שאי אפשר לפתוח (למשל במחשב/סימולטור בלי חייגן)
            debugPrint('לא ניתן לפתוח את הקישור: $urlScheme');
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // שומר על המרכזיות של האלמנטים
            children: [
              Icon(icon, color: AppTheme.goldPrimary, size: 18),
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
