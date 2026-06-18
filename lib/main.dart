import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  // 1. מוודאים שכל תשתית פלאטר אותחלה כראוי
  WidgetsFlutterBinding.ensureInitialized();

  // 2. מאתחלים את פיירבייס עם הקובץ שנוצר לך אוטומטית
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 3. מפעילים את פונקציית העלאת הנתונים החד-פעמית
  await uploadJsonData();

  // 4. מריצים את האפליקציה
  runApp(const DriveGoApp());
}

/// פונקציה לקריאת קובץ db.json והעלאת כל הנתונים ל-Cloud Firestore
Future<void> uploadJsonData() async {
  try {
    print('🔄 מתחיל לקרוא את קובץ ה-JSON...');

    // קריאת הקובץ מתוך תיקיית ה-assets כטקסט
    String jsonString = await rootBundle.loadString('assets/data/db.json');

    // פיענוח מחרוזת הטקסט למבנה נתונים של Map (מפתח וערך)
    Map<String, dynamic> fullData = jsonDecode(jsonString);

    // רשימת הקולקציות שאנחנו רוצים להעלות מהקובץ
    List<String> collectionsToUpload = [
      'users',
      'categories',
      'companies',
      'cars',
      'reviews',
    ];

    final firestore = FirebaseFirestore.instance;

    for (String collectionName in collectionsToUpload) {
      if (fullData.containsKey(collectionName) &&
          fullData[collectionName] is List) {
        List<dynamic> list = fullData[collectionName];
        print('📦 מעלה ${list.length} מסמכים לקולקציית "$collectionName"...');

        for (var item in list) {
          if (item is Map<String, dynamic>) {
            // שומרים את ה-id המקורי של ה-JSON בתוך השדות ליתר ביטחון,
            // ונותנים לפיירבייס לייצר ID רנדומלי משלו למסמך
            await firestore.collection(collectionName).add(item);
          }
        }
        print('✅ קולקציית "$collectionName" הועלתה בהצלחה!');
      }
    }

    print('🎉 כל הנתונים הועלו ל-Firestore בהצלחה מרובה!');
  } catch (e) {
    print('❌ שגיאה במהלך העלאת הנתונים: $e');
  }
}

class DriveGoApp extends StatelessWidget {
  const DriveGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drive Go',
      // עיצוב ראשוני כהה ויוקרתי (זהב ושחור) בהתאם לאתר שלך
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F11),
        primaryColor: const Color(0xFFD4AF37),
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'DriveGo Data Uploaded! 🚀',
            style: TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
