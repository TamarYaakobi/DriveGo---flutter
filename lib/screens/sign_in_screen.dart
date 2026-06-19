import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'sign_up_screen.dart'; // ניצור אותו מיד בשלב הבא

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // כותרת המותג מהאתר
              const Text(
                'Drive Go',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.goldPrimary,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'כניסת לקוחות',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 15),
              // הקו המוזהב מהאתר
              Container(
                width: 50,
                height: 2,
                color: AppTheme.goldPrimary,
              ),
              const SizedBox(height: 40),

              // שדה אימייל
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'כתובת אימייל',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.goldPrimary)),
                ),
              ),
              const SizedBox(height: 20),

              // שדה סיסמה
              TextFormField(
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'סיסמה סודית',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.goldPrimary)),
                ),
              ),
              const SizedBox(height: 35),

              // כפתור התחברות מוזהב
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: AppTheme.goldGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // לוגיקת התחברות בהמשך
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text(
                    'התחבר למערכת',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // מעבר להרשמה (דף נפרד)
              TextButton(
                onPressed: () {
                  // מעבר לדף הרשמה והחלפת הדף הנוכחי
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text(
                  'האימייל לא נמצא במערכת? עבור להרשמה מהירה ←',
                  style: TextStyle(color: AppTheme.goldPrimary, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}