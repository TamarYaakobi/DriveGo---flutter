import 'package:drive_go/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart'; // <-- 1. חובה לייבא את חבילת הפרובידר
import './theme/app_theme.dart';
import './screens/home_screen.dart';
import './providers/car_provider.dart'; // <-- 2. מייבאים את הפרובידר שיצרנו מקודם
import 'firebase_options.dart';
import 'dart:io';

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    sslEnabled: true,
    host: 'firestore.googleapis.com',
  );

  // 3. עוטפים את כל האפליקציה ב-MultiProvider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CarProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const DriveGoApp(),
    ),
  );
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
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
