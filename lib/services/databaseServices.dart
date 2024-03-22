import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class DatabaseServices {
  CollectionReference employeesCollection =
      FirebaseFirestore.instance.collection("employees");

  Future createEmployee(
      String employeeUid, String name, String email, String position) async {
    try {
      return await employeesCollection.doc(employeeUid).set({
        "name": name,
        "email": email,
        "position": position,
      });
    } catch (e) {
      debugPrint("Error while inserting employee to db: $e");
      return null;
    }
  }

  Future<DocumentSnapshot?> getEmployeeDetails(String employeeUid) async {
    return await employeesCollection.doc(employeeUid).get();
  }

  Future markAttendanceOfAnEmployee({
    required Timestamp date,
    required String checkIn,
    required String checkOut,
    required String employeeUid,
    required String attendanceDocId,
    required int month,
  }) async {
    try {
      return await employeesCollection
          .doc(employeeUid)
          .collection("records")
          .doc(attendanceDocId)
          .set({
        "date": date,
        "checkIn": checkIn,
        "checkOut": checkOut,
        "month": month,
      });
    } catch (e) {
      debugPrint("Error while inserting employee attendance to db: $e");
      return null;
    }
  }

  Future getTodaysAttendanceOfAnEmployee(
      String employeeUid, String attendanceDocId) async {
    try {
      return await employeesCollection
          .doc(employeeUid)
          .collection("records")
          .doc(attendanceDocId)
          .get();
    } catch (e) {
      debugPrint("Error while fetching employee todays attendance: $e");
      return null;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>?>
      fetchEmployeesCurrentMonthWorkedDays(
          int currentMonth, String employeeUid) async {
    try {
      return await employeesCollection
          .doc(employeeUid)
          .collection("records")
          .where("month", isEqualTo: currentMonth)
          .get();
    } catch (e) {
      debugPrint("Error while fetching employee current month attendance: $e");
      return null;
    }
  }
}
