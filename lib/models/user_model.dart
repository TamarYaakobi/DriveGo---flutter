class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String idNumber;
  final String password;
  final bool isAdmin;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.idNumber,
    required this.password,
    this.isAdmin = false,
  });

  // יצירת אובייקט משתמש מתוך נתונים שחזרו מ-Firestore
  factory UserModel.fromMap(String documentId, Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? documentId, // לוקח את ה-id מתוך השדות או מה-Document ID
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      idNumber: map['idNumber'] ?? '',
      password: map['password'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
    );
  }

  // המרה ל-Map במידה ונרצה לעדכן או לשמור נתונים בעתיד
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'idNumber': idNumber,
      'password': password,
      'isAdmin': isAdmin,
    };
  }
}