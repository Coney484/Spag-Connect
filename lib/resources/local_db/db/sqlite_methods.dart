import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:spag_connect/models/log.dart';
import 'package:spag_connect/resources/local_db/interface/log_interface.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteMethods implements LogInterface {
  Database _db;

  String databaseName = "";

  String tableName = "Call_Logs";

  // columns

  String id = 'log_id';
  String callerName = 'caller_name';
  String callerPic = 'callerPic';
  String receiverName = 'receiver_name';
  String receiverPic = 'reeiver_pic';
  String callStatus = 'call_status';
  String timeStamp = 'timestamp';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    print("db was null, now awaiting it");
    _db = await init();
    return _db;
  }

  @override
  openDb(dbName) => (databaseName = dbName);

  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();

    String path = join(dir.path, databaseName);

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);

    return db;
  }

  _onCreate(Database db, int version) async {
    String createTableQuery =
        "CREATE TABLE $tableName ($id INTEGER PRIMARY KEY, $callerName TEXT, $callerPic TEXT, $receiverName TEXT, $receiverPic TEXT, $callStatus TEXT, $timeStamp TEXT)";

    await db.execute(createTableQuery);
    print("Table Created");
  }

  @override
  addLogs(Log log) async {
    var dbClient = await db;

    await dbClient.insert(tableName, log.toMap(log));
  }

  @override
  deleteLog(int logId) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableName, where: '$id = ?', whereArgs: [logId + 1]);
  }

  @override
  Future<List<Log>> getLogs() async {
    try {
      var dbClient = await db;

      List<Map> maps = await dbClient.query(
        tableName,
        columns: [
          id,
          callerName,
          callerPic,
          receiverName,
          receiverPic,
          callStatus,
          timeStamp,
        ],
      );
      List<Log> logList = [];

      if (maps.isNotEmpty) {
        for (Map map in maps) {
          logList.add(Log.fromMap(map));
        }
      }

      return logList;
    } catch (e) {
      print(e);

      return null;
    }
  }

  @override
  close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
