import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:interview/Authentication/Model/_authModel.dart';

class AuthProvider with ChangeNotifier {
  final Box<Student> _box = Hive.box<Student>("student");
  Student? _currentUser;

  Student? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  AuthProvider() {
    if (_box.keys.isNotEmpty) {
        final firstKey = _box.keys.first;
        _currentUser = _box.get(firstKey);
        notifyListeners();
    }
  }

  Future<String?> register(String studentId, String name, String password) async {
    if (studentId.isEmpty || name.isEmpty || password.isEmpty) {
      return 'All fields are required.';
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(studentId)) {
      return 'Please enter a valid email address.';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    if (_box.containsKey(studentId)) {
      return 'User with this email already exists.';
    }

    final newStudent = Student(studentId: studentId, name: name, password: password);
    await _box.put(studentId, newStudent);
    _currentUser = newStudent;
    notifyListeners();
    return null; // Indicates success
  }

  Future<String?> login(String studentId, String password) async {
    if (studentId.isEmpty || password.isEmpty) {
      return 'Email and password are required.';
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(studentId)) {
      return 'Please enter a valid email address.';
    }

    final student = _box.get(studentId);
    if (student == null) {
      return 'User not found.';
    }

    if (student.password != password) {
      return 'Incorrect password.';
    }

    _currentUser = student;
    notifyListeners();
    return null; // Indicates success
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }
}
