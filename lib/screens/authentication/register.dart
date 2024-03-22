import 'package:employee_attendance_management/screens/home/employeeNavigator.dart';
import 'package:employee_attendance_management/services/authServices.dart';
import 'package:employee_attendance_management/services/helperFunctions.dart';
import 'package:employee_attendance_management/utils/constants.dart';
import 'package:employee_attendance_management/utils/initialLoading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required this.toggleView});
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email = '';
  String password = '';
  String name = '';
  String error = '';
  bool isLoading = false;
  String position = '';
  final AuthServices _authServices = AuthServices();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const InitialLoading()
        : Scaffold(
            appBar: AppBar(
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Employee Attendance Management',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Spacer(),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? 'Please enter your name' : null,
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Name',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
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
                      validator: (val) =>
                          val!.isEmpty ? 'Please enter an email' : null,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Email',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
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
                      validator: (val) => val!.length < 6
                          ? 'Password must be atleast 6 characters'
                          : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Password',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
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
                      validator: (val) =>
                          val!.isEmpty ? 'Please enter your postion' : null,
                      onChanged: (val) {
                        setState(() {
                          position = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your position',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
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
                    Text(
                      error,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          dynamic result = await _authServices
                              .createEmployeeWithEmailAndPassword(
                                  name, email, password, position);
                          if (result == null) {
                            setState(() {
                              error = 'Enter a valid email ID ';
                              isLoading = false;
                            });
                          } else {
                            final String employeeUid = result.user.uid ?? "";
                            await HelperFunctions
                                .setEmployeeUidToSharedPreference(employeeUid);
                            Constants.employeeUid = employeeUid;
                            print('Registered Successfully!!');
                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EmployeeNavigatorScreen(),
                                  ),
                                  (route) => false);
                            }
                          }
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
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? '),
                        TextButton(
                            onPressed: () {
                              widget.toggleView();
                            },
                            child: const Text(
                              'Sign In',
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
