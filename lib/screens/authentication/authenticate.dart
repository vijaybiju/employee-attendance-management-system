import 'package:employee_attendance_management/screens/authentication/login.dart';
import 'package:employee_attendance_management/screens/authentication/register.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn == true) {
      return SignIn(
        toggleView: toggleView,
      );
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
