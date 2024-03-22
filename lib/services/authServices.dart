import 'package:employee_attendance_management/services/databaseServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseServices _databaseServices = DatabaseServices();

  Future<UserCredential?> createEmployeeWithEmailAndPassword(
      String name, String email, String password, String position) async {
    try {
      final userResponse = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      debugPrint("User response: ${userResponse.user}");
      final employeeUid = userResponse.user?.uid;
      if (employeeUid != null) {
        final databaseResponse = await _databaseServices.createEmployee(
            employeeUid, name, email, position);
      }
      return userResponse;
    } catch (e) {
      debugPrint("Error while creating employee: $e");
      return null;
    }
  }

  Future<UserCredential?> signInEmployeeWithEmailAndPassword(
      String email, String password) async {
    try {
      final userResponse = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      debugPrint("User response in login: ${userResponse.user!.uid}");
      return userResponse;
    } catch (e) {
      debugPrint("Error while signing in employee: $e");
      return null;
    }
  }

  Future logOutEmployee() async {
    return await _auth.signOut();
  }
}
