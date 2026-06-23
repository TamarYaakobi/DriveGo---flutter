import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class CarApiService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<String>> getModelsForMakeAndYear(String make, int year) async {
    final url = Uri.parse(
      'https://vpic.nhtsa.dot.gov/api/vehicles/GetModelsForMakeYear/make/$make/modelyear/$year?format=json',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['Results'] as List;
        return results.map((item) => item['Model_Name'] as String).toList();
      }
    } catch (e) {
      print("Error fetching from Car API: $e");
    }
    return [];
  }

  Future<String> uploadCarImage(File imageFile, String carName) async {
    try {
      final safeFileName = carName
          .replaceAll(RegExp(r'[^\w\s\-]'), '')
          .trim()
          .replaceAll(' ', '_');
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      final Reference storageRef = _storage
          .ref()
          .child('cars')
          .child('${safeFileName}_$timestamp.jpg');

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked_at': DateTime.now().toIso8601String()},
      );

      UploadTask uploadTask = storageRef.putFile(imageFile, metadata);

      TaskSnapshot snapshot = await uploadTask;

      print("Upload state: ${snapshot.state}");
      print("Full path: ${snapshot.ref.fullPath}");

      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("שגיאה מפורטת ב-Upload Image: $e");
      throw Exception("נכשלה העלאת התמונה לשרת: $e");
    }
  }

  Future<void> saveCarToFirestore({
    required String name,
    required int year,
    required int seats,
    required String imageUrl,
    required String companyId,
    required String categoryId,
    required String description,
  }) async {
    await _db.collection('cars').add({
      'name': name,
      'year': year,
      'seats': seats,
      'imageUrl': imageUrl,
      'companyId': companyId,
      'categoryId': categoryId,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
