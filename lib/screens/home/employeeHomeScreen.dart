import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_management/services/databaseServices.dart';
import 'package:employee_attendance_management/services/helperFunctions.dart';
import 'package:employee_attendance_management/utils/constants.dart';
import 'package:employee_attendance_management/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({Key? key}) : super(key: key);

  @override
  _EmployeeHomeScreenState createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  String checkIn = "--/--";
  String checkOut = "--/--";
  String location = " ";
  String scanResult = " ";
  String officeCode = " ";
  String employeeName = "";

  Color primary = Colors.blue;
  final DatabaseServices _databaseServices = DatabaseServices();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getEmployeeData();
    _getEmployeesTodaysAttendance();
  }

  _getEmployeeData() async {
    setState(() {
      isLoading = true;
    });
    debugPrint("constants employee uid: ${Constants.employeeUid}");
    final DocumentSnapshot<Object?>? employeeSnapshot =
        await _databaseServices.getEmployeeDetails(Constants.employeeUid);
    if (employeeSnapshot != null && employeeSnapshot.exists) {
      String name = employeeSnapshot.get('name');
      debugPrint("Employee name: $name");
      setState(() {
        employeeName = name;
        isLoading = false;
      });
    } else {
      debugPrint("Employee snapshot is null or does not exist");
    }
  }

  _getEmployeesTodaysAttendance() async {
    setState(() {
      isLoading = true;
    });
    String attendanceDocId = DateFormat('dd MMMM yyyy').format(DateTime.now());
    debugPrint("Attendance doc: $attendanceDocId");
    if (Constants.employeeUid.isNotEmpty) {
      final DocumentSnapshot<Object?>? employeeTodaysAttendanceSnapshot =
          await _databaseServices.getTodaysAttendanceOfAnEmployee(
              Constants.employeeUid, attendanceDocId);
      if (employeeTodaysAttendanceSnapshot != null) {
        debugPrint(
            "Employees todays attendance: ${employeeTodaysAttendanceSnapshot.data()}");
        String checkInFetched = employeeTodaysAttendanceSnapshot.get('checkIn');
        String checkOutFetched =
            employeeTodaysAttendanceSnapshot.get('checkOut');
        setState(() {
          checkIn = checkInFetched;
          checkOut = checkOutFetched;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SizedBox(
      height: screenHeight,
      width: screenWidth,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: isLoading
            ? const LoadingWidget()
            : Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Welcome, $employeeName",
                      style: TextStyle(
                        fontFamily: "NexaBold",
                        fontSize: screenWidth / 18,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 32),
                    child: Text(
                      "Today's Status",
                      style: TextStyle(
                        fontFamily: "NexaBold",
                        fontSize: screenWidth / 18,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 32),
                    height: 150,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(2, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Check In",
                                style: TextStyle(
                                  fontFamily: "NexaRegular",
                                  fontSize: screenWidth / 20,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                checkIn,
                                style: TextStyle(
                                  fontFamily: "NexaBold",
                                  fontSize: screenWidth / 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Check Out",
                                style: TextStyle(
                                  fontFamily: "NexaRegular",
                                  fontSize: screenWidth / 20,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                checkOut,
                                style: TextStyle(
                                  fontFamily: "NexaBold",
                                  fontSize: screenWidth / 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          text: DateTime.now().day.toString(),
                          style: TextStyle(
                            color: primary,
                            fontSize: screenWidth / 18,
                            fontFamily: "NexaBold",
                          ),
                          children: [
                            TextSpan(
                              text: DateFormat(' MMMM yyyy').format(
                                DateTime.now(),
                              ),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth / 20,
                                fontFamily: "NexaBold",
                              ),
                            ),
                          ],
                        ),
                      )),
                  StreamBuilder(
                    stream: Stream.periodic(const Duration(seconds: 1)),
                    builder: (context, snapshot) {
                      return Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          DateFormat('hh:mm:ss a').format(DateTime.now()),
                          style: TextStyle(
                            fontFamily: "NexaRegular",
                            fontSize: screenWidth / 20,
                            color: Colors.black54,
                          ),
                        ),
                      );
                    },
                  ),
                  checkOut == "--/--"
                      ? Container(
                          margin: const EdgeInsets.only(top: 24, bottom: 12),
                          child: Builder(
                            builder: (context) {
                              final GlobalKey<SlideActionState> key =
                                  GlobalKey();

                              return SlideAction(
                                text: checkIn == "--/--"
                                    ? "Slide to Check In"
                                    : "Slide to Check Out",
                                reversed: checkIn == "--/--" ? false : true,
                                textStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: screenWidth / 20,
                                  fontFamily: "NexaRegular",
                                ),
                                outerColor: Colors.white,
                                innerColor: primary,
                                key: key,
                                onSubmit: () async {
                                  debugPrint("Slided to check in");
                                  debugPrint("Slided to check in");
                                  final String? employeeUid =
                                      await HelperFunctions
                                          .getEmployeeUidFromSharedPreference();

                                  DateTime now = DateTime.now();
                                  String currentTime =
                                      DateFormat('hh:mm a').format(now);
                                  String attendanceDocId =
                                      DateFormat('dd MMMM yyyy')
                                          .format(DateTime.now());
                                  int currentMonth = DateTime.now().month;

                                  if (checkIn == "--/--") {
                                    setState(() {
                                      checkIn = currentTime;
                                    });
                                    if (employeeUid != null) {
                                      await _databaseServices
                                          .markAttendanceOfAnEmployee(
                                        attendanceDocId: attendanceDocId,
                                        date: Timestamp.now(),
                                        checkIn: checkIn,
                                        checkOut: checkOut,
                                        employeeUid: employeeUid,
                                        month: currentMonth,
                                      );
                                    }
                                  } else {
                                    setState(() {
                                      checkOut = currentTime;
                                    });
                                    if (employeeUid != null) {
                                      await _databaseServices
                                          .markAttendanceOfAnEmployee(
                                        attendanceDocId: attendanceDocId,
                                        date: Timestamp.now(),
                                        checkIn: checkIn,
                                        checkOut: checkOut,
                                        employeeUid: employeeUid,
                                        month: currentMonth,
                                      );
                                    }
                                  }
                                },
                              );
                            },
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.only(top: 32, bottom: 32),
                          child: Text(
                            "You have completed this day!",
                            style: TextStyle(
                              fontFamily: "NexaRegular",
                              fontSize: screenWidth / 20,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                ],
              ),
      ),
    ));
  }
}
