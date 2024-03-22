import 'package:shared_preferences/shared_preferences.dart';

const String EMPLOYEE_UID_KEY = 'uid_key';

class HelperFunctions {
  static Future<bool> setEmployeeUidToSharedPreference(
      String employeeUid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(EMPLOYEE_UID_KEY, employeeUid);
  }

  static Future<String?> getEmployeeUidFromSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(EMPLOYEE_UID_KEY);
  }

  static Future<bool> clearEmployeeUidFromSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
