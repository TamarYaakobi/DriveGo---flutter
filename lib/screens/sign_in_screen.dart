import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drive_go/screens/sign_up_screen.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../services/prefs_service.dart'; // ייבוא של שירות ה-Preferences

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _login() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('יש למלא אימייל וסיסמה')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // ביצוע ההתחברות דרך ה-AuthProvider שלכם
    final error = await authProvider.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (error == null) {
      // אם האימות הצליח, נשמור את מצב ההתחברות מקומית במכשיר
      await PrefsService.saveBool('is_logged_in', true);
      await PrefsService.saveString('user_email', _emailController.text.trim());

      setState(() {
        _isLoading = false;
      });

      // חזרה למסך הראשון (דף הבית)
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: AppTheme.bgDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

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

              Container(width: 50, height: 2, color: AppTheme.goldPrimary),

              const SizedBox(height: 40),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'כתובת אימייל',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.goldPrimary),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'סיסמה',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.goldPrimary),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.goldGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text(
                            'התחבר למערכת',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                ),
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