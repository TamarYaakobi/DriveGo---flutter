import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  // שמירת מחרוזת (למשל: שם משתמש, אסימון גישה, או הגדרת שפה)
  static Future<void> saveString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // טעינת מחרוזת
  static Future<String?> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // שמירת ערך בוליאני (למשל: האם מצב כהה פעיל, האם המשתמש מחובר)
  static Future<void> saveBool(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // טעינת ערך בוליאני
  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }

  // מחיקת מפתח ספציפי
  static Future<void> remove(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // מחיקת כל הזיכרון המקומי (למשל בהתנתקות מהמערכת)
  static Future<void> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}