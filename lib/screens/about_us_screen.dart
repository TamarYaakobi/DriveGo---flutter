import 'package:flutter/material.dart';
import '../widgets/custom_nav_bar.dart';
import '../theme/app_theme.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      // משתמשים בבר העליון המשותף והלוגו שכבר בנית!
      appBar: const CustomNavBar(), 
      drawer: const CustomDrawer(),
      body: Directionality(
        textDirection: TextDirection.rtl, // תמיכה מלאה בעברית
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ================= SECTION 1: HERO SECTION =================
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.35, // 35% מגובה המסך
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.pexels.com/photos/3802510/pexels-photo-3802510.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                    ),
                    fit: BoxFit.cover,
                    opacity: 0.4,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withOpacity(0.2), AppTheme.bgDark],
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'הסיפור שלנו',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Drive Go — מגדירים מחדש את חווית הנסיעה',
                        style: TextStyle(
                          color: AppTheme.goldPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ================= SECTION 2: OUR STORY =================
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'מאז ועד היום',
                      style: TextStyle(
                        color: AppTheme.goldPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'איך הכל התחיל?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // קו הזהב היוקרתי מה-SCSS
                    Container(
                      width: 50,
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF3E5AB), AppTheme.goldPrimary, Color(0xFFAA7C11)],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'חברת Drive Go נולדה מתוך תשוקה אמיתית להגה, לעיצוב עוצר נשימה ולחוויית נהיגה אקסקלוסיבית. הבנו שלפעמים נסיעה היא לא רק הגעה מיעד א\' ליעד ב\' – היא הדרך, הריגוש והזיכרון שנשאר איתך.',
                      style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.6),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'הקמנו את החברה במטרה להנגיש את רכבי העילית והספורט המובילים בעולם, תוך שמירה על סטנדרט שירות אירופאי קפדני, דיסקרטיות מלאה וחווית לקוח חסרת פשרות.',
                      style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.6),
                    ),
                    const SizedBox(height: 30),
                    // תמונת פנים הרכב היוקרתית עם פינות מעוגלות וצל
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.2)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://images.pexels.com/photos/3136673/pexels-photo-3136673.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ================= SECTION 3: VALUES =================
              Container(
                width: double.infinity,
                color: Colors.white.withOpacity(0.02),
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                child: Column(
                  children: [
                    const Text(
                      'הערכים שמובילים אותנו',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(width: 60, height: 3, color: AppTheme.goldPrimary),
                    const SizedBox(height: 30),
                    
                    _buildValueCard('01', 'איכות ללא פשרות', 'כל רכב בצי שלנו עובר בדיקות קפדניות, טיפולים שוטפים והכנה ברמת מצב תצוגה לפני שהוא מגיע אליך.'),
                    _buildValueCard('02', 'שירות בגובה העיניים', 'ליווי אישי ומסור מרגע ההתעניינות ועד להחזרת המפתח. היוקרה היא במוצר, המשפחתיות היא בשירות.'),
                    _buildValueCard('03', 'שקיפות ואמינות', 'בלי אותיות קטנות ובלי הפתעות. הכל ברור, מתומחר בצורה הוגנת ומותאם בדיוק לצרכים והשאיפות שלך.'),
                  ],
                ),
              ),

              // ================= SECTION 4: CTA BUTTON =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const NetworkImage(
                      'https://images.pexels.com/photos/3311574/pexels-photo-3311574.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                    ),
                    fit: BoxFit.cover,
                    opacity: 0.15,
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.darken),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'הגה החלומות שלך במרחק קליק אחד',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'נבחרת רכבי הפרימיום שלנו מחכה לעורר בך השראה.',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                    const SizedBox(height: 30),
                    
                    // כפתור הזהב המעוצב
                    _buildGoldButton(
                      text: 'לצפייה בצי הרכבים שלנו',
                      onPressed: () {
                        // ניווט חזרה או לדף הרכבים
                        Navigator.pop(context);
                      },
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

  // ווידג'ט עזר פנימי לבניית כרטיסי הערכים
  Widget _buildValueCard(String number, String title, String description) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [Color(0xFFF3E5AB), AppTheme.goldPrimary],
                ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  // ווידג'ט עזר לכפתור הזהב היוקרתי
  Widget _buildGoldButton({required String text, required VoidCallback onPressed}) {
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
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }
}