import 'package:sugarfy/sql_helper.dart';

class LogCalculator {
  late List<Map<String, dynamic>> _logs = [];

  LogCalculator() {
    setLogs();
  }

  void setLogs() async {
    _logs = await SQLHelper.index();
  }

  List<Map<String, dynamic>> getLogs() {
    return _logs;
  }

  int consumedToday() {
    int sum = 0;
    for (var log in _logs) {
      // if (DateTime.now().difference(log["createdAt"]).inDays < 1) {
      print(log["grammage"]);
      sum += int.parse(log["grammage"]);
      // }
    }
    return sum;
  }
}
