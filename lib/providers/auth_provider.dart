import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  UserModel? _user;
  bool _isLoading = true;

  // גטרים כדי לגשת לנתונים מהמסכים
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    // מאזין אוטומטית לשינויים במצב החיבור של המשתמש (התחבר/התנתק)
    _auth.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser == null) {
        _user = null;
        _isLoading = false;
        notifyListeners();
      } else {
        await fetchUserData(firebaseUser.uid);
      }
    });
  }

  // שליפת הנתונים המשלימים מה-Firestore (כמו שם פרטי והאם הוא אדמין)
  Future<void> fetchUserData(String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        _user = UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // מעדכן את כל המסכים שהמשתמש מוכן!
    }
  }

  // התנתקות מהמערכת
  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> signIn({
  required String email,
  required String password,
}) async {
  try {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    return null; 
  } on FirebaseAuthException catch (e) {
    return e.message;
  } catch (e) {
    return 'שגיאה לא צפויה';
  }
}
}