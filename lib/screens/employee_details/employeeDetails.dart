import 'package:employee_attendance_management/services/authServices.dart';
import 'package:employee_attendance_management/services/databaseServices.dart';
import 'package:employee_attendance_management/services/helperFunctions.dart';
import 'package:employee_attendance_management/utils/constants.dart';
import 'package:employee_attendance_management/utils/loading.dart';
import 'package:employee_attendance_management/wrapper/wrapper.dart';
import 'package:flutter/material.dart';

class EmployeeDetails extends StatefulWidget {
  const EmployeeDetails({super.key});

  @override
  State<EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  final AuthServices _authServices = AuthServices();
  final DatabaseServices _databaseServices = DatabaseServices();
  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _employeeEmailController =
      TextEditingController();
  final TextEditingController _employeePositionController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getEmployeeDetails();
  }

  _getEmployeeDetails() async {
    setState(() {
      isLoading = true;
    });
    final fetchedEmployeeDetails =
        await _databaseServices.getEmployeeDetails(Constants.employeeUid);
    if (fetchedEmployeeDetails != null) {
      debugPrint("Fetched employee details: ${fetchedEmployeeDetails.data()}");
      final String fetchedEmployeeName = fetchedEmployeeDetails.get('name');
      final String fetchedEmployeeEmail = fetchedEmployeeDetails.get('email');
      final String fetchedEmployeePosition =
          fetchedEmployeeDetails.get('position');
      setState(() {
        _employeeNameController.text = fetchedEmployeeName;
        _employeeEmailController.text = fetchedEmployeeEmail;
        _employeePositionController.text = fetchedEmployeePosition;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingWidget()
        : SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage('assets/employee.png'),
                      backgroundColor: Colors.blue,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.black),
                      validator: (val) =>
                          val!.isEmpty ? 'Please enter your name' : null,
                      controller: _employeeNameController,
                      onChanged: (value) {
                        debugPrint("Enter name: $value");
                      },
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _employeeEmailController,
                      style: const TextStyle(color: Colors.black),
                      validator: (val) =>
                          val!.isEmpty ? 'Please enter your email' : null,
                      onChanged: (value) {
                        debugPrint("Entered email: $value");
                      },
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _employeePositionController,
                      style: const TextStyle(color: Colors.black),
                      validator: (val) =>
                          val!.isEmpty ? 'Please enter your position' : null,
                      onChanged: (value) {
                        debugPrint("Entered position: $value");
                      },
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Position',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          await _authServices.logOutEmployee();
                          await HelperFunctions
                              .clearEmployeeUidFromSharedPreference();
                          Constants.employeeUid = '';
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Wrapper(),
                              ),
                              (route) => false,
                            );
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Log out',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
