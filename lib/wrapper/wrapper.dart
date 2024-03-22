import 'package:employee_attendance_management/screens/authentication/authenticate.dart';
import 'package:employee_attendance_management/screens/home/employeeNavigator.dart';
import 'package:employee_attendance_management/services/helperFunctions.dart';
import 'package:employee_attendance_management/utils/constants.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isUserLoggedIn = false;
  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getEmployeeUidFromSharedPreference().then((value) {
      if (value != null) {
        setState(() {
          debugPrint("Employee logged in status: ${value.toString()}");
          Constants.employeeUid = value;
          isUserLoggedIn = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isUserLoggedIn
        ? const EmployeeNavigatorScreen()
        : const Authenticate();
  }
}
