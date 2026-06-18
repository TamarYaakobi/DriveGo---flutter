import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_theme.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // מפתח לניהול הטופס והולידציות (מקביל ל-Formik)
  final _formKey = GlobalKey<FormState>();

  // קונטרולרים לשמירת הערכים מהשדות
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _adminPasswordController = TextEditingController();

  bool _isAdmin = false;
  bool _isLoading = false;

  // הגדרת סיסמת מנהל קבועה (כמו ה-VITE_ADMIN_PASSWORD שלך)
  final String _correctAdminPassword = "SECRET_ADMIN_PASS_2026"; 

  @override
  void dispose() {
    // שחרור זיכרון
    _firstNameController.dispose();
    _lastNameController.dispose();
    _idNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _adminPasswordController.dispose();
    super.dispose();
  }

  // פונקציית ההרשמה מול Firebase
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1. יצירת המשתמש ב-Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. שמירת הנתונים הנוספים ב-Cloud Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'idNumber': _idNumberController.text.trim(),
        'email': _emailController.text.trim(),
        'isAdmin': _isAdmin,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('נרשם בהצלחה!'), backgroundColor: Colors.green),
        );
        Navigator.pushReplacementNamed(context, '/'); // חזרה לדף הראשי
      }
    } on FirebaseAuthException catch (e) {
      String errorMsg = 'ההרשמה נכשלה';
      if (e.code == 'email-already-in-use') {
        errorMsg = 'המשתמש כבר רשום במערכת';
      } else if (e.code == 'weak-password') {
        errorMsg = 'הסיסמה חלשה מדי';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('שגיאה בלתי צפויה קוראת במערכת'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey, // קישור המפתח לטופס
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Drive Go',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: AppTheme.goldPrimary),
                ),
                const SizedBox(height: 5),
                const Text('יצירת חשבון יוקרה', style: TextStyle(fontSize: 18, color: Colors.white70)),
                const SizedBox(height: 15),
                Container(width: 50, height: 2, color: AppTheme.goldPrimary),
                const SizedBox(height: 30),

                // שורה של שם פרטי ושם משפחה (Flex / Row כמו ב-React)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(labelText: 'שם פרטי', labelStyle: TextStyle(color: Colors.grey)),
                        validator: (v) => (v == null || v.trim().length < 2) ? 'לפחות 2 תווים' : null,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(labelText: 'שם משפחה', labelStyle: TextStyle(color: Colors.grey)),
                        validator: (v) => (v == null || v.trim().length < 2) ? 'לפחות 2 תווים' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // תעודת זהות
                TextFormField(
                  controller: _idNumberController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  maxLength: 9,
                  decoration: const InputDecoration(labelText: 'תעודת זהות', labelStyle: TextStyle(color: Colors.grey), counterText: ""),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'שדה חובה';
                    if (v.length != 9) return 'תעודת זהות חייבת להכיל 9 ספרות';
                    if (!RegExp(r'^\d+$').hasMatch(v)) return 'ספרות בלבד';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // אימייל
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'אימייל', labelStyle: TextStyle(color: Colors.grey)),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'שדה חובה';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'אימייל לא תקין';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // סיסמה
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'סיסמה', labelStyle: TextStyle(color: Colors.grey)),
                  validator: (v) => (v == null || v.length < 8) ? 'הסיסמה חייבת להכיל לפחות 8 תווים' : null,
                ),
                const SizedBox(height: 20),

                // תיבת סימון מנהל מערכת (Checkbox)
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.white54),
                  child: CheckboxListTile(
                    title: const Text('משתמש מנהל מערכת', style: TextStyle(color: Colors.white, fontSize: 15)),
                    value: _isAdmin,
                    activeColor: AppTheme.goldPrimary,
                    checkColor: Colors.black,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool? value) {
                      setState(() {
                        _isAdmin = value ?? false;
                        if (!_isAdmin) _adminPasswordController.clear();
                      });
                    },
                  ),
                ),

                // שדה סיסמת מנהל מותנה (מופיע רק אם ה-Checkbox מסומן)
                if (_isAdmin) ...[
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _adminPasswordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'הכנס סיסמת מנהל סודית',
                      labelStyle: TextStyle(color: AppTheme.goldPrimary),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                    ),
                    validator: (v) {
                      if (_isAdmin) {
                        if (v == null || v.isEmpty) return 'שדה חובה עבור מנהל';
                        if (v != _correctAdminPassword) return 'סיסמת מנהל שגויה';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 35),

                // כפתור שליחה עם מצב טעינה
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(gradient: AppTheme.goldGradient, borderRadius: BorderRadius.circular(10)),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text('הרשם והצטרף לחוויה', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
                  },
                  child: const Text('כבר יש לך חשבון? לחץ להתחברות לקוחות', style: TextStyle(color: AppTheme.goldPrimary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}