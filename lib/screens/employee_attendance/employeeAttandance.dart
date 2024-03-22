import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_management/services/databaseServices.dart';
import 'package:employee_attendance_management/utils/constants.dart';
import 'package:employee_attendance_management/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class EmployeeAttendance extends StatefulWidget {
  const EmployeeAttendance({super.key});

  @override
  State<EmployeeAttendance> createState() => _EmployeeAttendanceState();
}

class _EmployeeAttendanceState extends State<EmployeeAttendance> {
  final DatabaseServices _databaseServices = DatabaseServices();
  int totalWorkingDays = 0;
  int numberOfDaysWorked = 0;
  double percentage = 0;
  bool isLoading = false;
  int currentMonth = DateTime.now().month;
  @override
  void initState() {
    super.initState();
    _getEmployeesCurrentMonthAttendance();
  }

  int getTotalWorkingDays(int year, int month) {
    int totalDays = DateTime(year, month + 1, 0).day;
    int sundays = 0;

    for (int i = 1; i <= totalDays; i++) {
      DateTime date = DateTime(year, month, i);
      if (date.weekday == DateTime.sunday) {
        sundays++;
      }
    }

    return totalDays - sundays;
  }

  double calculatePercentageOfWorkingDays(
      int totalWorkingDays, int numberOfDaysWorked) {
    double percentage = (numberOfDaysWorked / totalWorkingDays) * 100;
    return percentage;
  }

  _getEmployeesCurrentMonthAttendance() async {
    setState(() {
      isLoading = true;
    });
    final QuerySnapshot<Map<String, dynamic>>? employeesCurrentMonthDocs =
        await _databaseServices.fetchEmployeesCurrentMonthWorkedDays(
      currentMonth,
      Constants.employeeUid,
    );
    debugPrint(
        "Employees current Month docs: ${employeesCurrentMonthDocs!.docs.length}");
    int currentYear = DateTime.now().year;
    int daysWorked = employeesCurrentMonthDocs.docs.length;
    int totalNumberOfDays = getTotalWorkingDays(currentYear, currentMonth);
    double percentageCalculated =
        calculatePercentageOfWorkingDays(totalNumberOfDays, daysWorked);
    setState(() {
      totalWorkingDays = totalNumberOfDays;
      numberOfDaysWorked = daysWorked;
      percentage = percentageCalculated;
      isLoading = false;
    });
  }

  final Map<int, String> monthMap = {
    1: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December',
  };

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingWidget()
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: DropdownButton<int>(
                        isExpanded: true,
                        underline: Container(),
                        value: currentMonth,
                        items: monthMap.entries
                            .map((entry) => DropdownMenuItem<int>(
                                  value: entry.key,
                                  child: Text(entry.value),
                                ))
                            .toList(),
                        onChanged: (int? selectedMonth) {
                          if (selectedMonth != null) {
                            // _getEmployeesCurrentMonthAttendance(selectedMonth);
                            debugPrint("Selected month: $selectedMonth");
                            setState(() {
                              currentMonth = selectedMonth;
                              _getEmployeesCurrentMonthAttendance();
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  monthMap[currentMonth] ?? "",
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Days worked: $numberOfDaysWorked/$totalWorkingDays",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            CircularPercentIndicator(
                              radius: 20.0,
                              lineWidth: 5.0,
                              percent: percentage / 100,
                              center: Text(
                                percentage.toStringAsFixed(1),
                              ),
                              progressColor: Colors.green,
                              circularStrokeCap: CircularStrokeCap.round,
                              animation: true,
                              animationDuration: 1000,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
