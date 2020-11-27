import 'package:spag_connect/models/log.dart';

abstract class LogInterface {
  openDb(dbName);

  init();

  addLogs(Log log);

  //returns a list of logs

  Future<List<Log>> getLogs();

  deleteLog(int logId);

  close();
}
