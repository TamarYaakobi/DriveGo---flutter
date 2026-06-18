import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- הוספנו את הייבוא הזה
import './theme/app_theme.dart';
import './screens/home_screen.dart';
import 'firebase_options.dart';
import 'dart:io';

void main() async {
  // נטרול בדיקת תעודות אבטחה עבור בקשות HTTP רגילות באפליקציה
  HttpOverrides.global = MyHttpOverrides();
  
  WidgetsFlutterBinding.ensureInitialized();
  
  // איתחול ה-Firebase המקורי שלך
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // מעקף מיוחד עבור חסימות סינון (אתרוג / נטפר / רימון) מול Firestore
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    sslEnabled: true,
    host: 'firestore.googleapis.com', // מאלץ שימוש ב-HTTPS רגיל במקום gRPC
  );

  runApp(const DriveGoApp());
}

class DriveGoApp extends StatelessWidget {
  const DriveGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DriveGo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}