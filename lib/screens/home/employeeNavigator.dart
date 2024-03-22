import 'package:employee_attendance_management/screens/employee_attendance/employeeAttandance.dart';
import 'package:employee_attendance_management/screens/employee_details/employeeDetails.dart';
import 'package:employee_attendance_management/screens/home/employeeHomeScreen.dart';
import 'package:flutter/material.dart';

class EmployeeNavigatorScreen extends StatefulWidget {
  const EmployeeNavigatorScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeNavigatorScreen> createState() =>
      _EmployeeNavigatorScreenState();
}

class _EmployeeNavigatorScreenState extends State<EmployeeNavigatorScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = <Widget>[
      const EmployeeHomeScreen(),
      const EmployeeAttendance(),
      const EmployeeDetails(),
    ];

    void _onItemTapped(int index) {
      debugPrint("Tapped index: $index");
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Attendance Management"),
        centerTitle: true,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
