import 'package:flutter/cupertino.dart';
import 'package:spag_connect/models/log.dart';
import 'package:spag_connect/resources/local_db/db/hive_methods.dart';
import 'package:spag_connect/resources/local_db/db/sqlite_methods.dart';

class LogRepository {
  static var dbObject;
  static bool isHive;

  static init({@required bool isHive}) {
    dbObject = isHive ? HiveMethods() : SqliteMethods();
    dbObject.init();
  }

  static addLogs(Log log) => dbObject.addLogs(log);

  static deleteLogs(int logId) => dbObject.deleteLogs(logId);

  static getLogs() => dbObject.getLogs();

  static close() => dbObject.close();
}
