import 'package:frontend/features/home/models/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskLocalRepository {
  String tableName = "tasks";
  String id = "id";
  String uid = "uid";
  String title = "title";
  String description = "description";
  String hexColor = "hexColor";
  String dueAt = "dueAt";
  String createdAt = "createdAt";
  String updatedAt = "updatedAt";
  String isSynced = "isSynced";

  Future<Database> openDb() async {
    String path = join(await getDatabasesPath(), "task.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async => await db.execute('''
    CREATE TABLE $tableName(

    $id Text NOT NULL,
    $title Text NOT NULL,
    $description Text NOT NULL,
    $uid Text NOT NULL,
    $hexColor Text NOT NULL,
    $dueAt Text NOT NULL,
    $createdAt Text NOT NULL,
    $updatedAt Text NOT NULL,
    $isSynced int NOT NULL
    );
'''),
    );
  }

  Future<void> insertTask(TaskModel task) async {
    Database db = await openDb();
    await db.delete(tableName, where: 'id = ?', whereArgs: [task.id]);
    await db.insert(tableName, task.toMap());
  }

  Future<void> insertTasks(List<TaskModel> listOfTask) async {
    Database db = await openDb();
    final batch = db.batch();
    for (var task in listOfTask) {
      batch.insert(tableName, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }

  Future<List<TaskModel>> getTasks() async {
    Database db = await openDb();
    final result = await db.query(tableName);
    List<TaskModel> listOfTask = [];

    for (final task in result) {
      listOfTask.add(TaskModel.fromMap(task));
    }

    return listOfTask;
  }

  Future<List<TaskModel>> getUnsyncedTasks() async {
    Database db = await openDb();
    final result =
        await db.query(tableName, where: "isSynced = ?", whereArgs: [0]);
    List<TaskModel> listOfTask = [];
    if (result.isNotEmpty) {
      for (final task in result) {
        listOfTask.add(TaskModel.fromMap(task));
      }
    }
    return listOfTask;
  }

  Future<void> updateRow(String id, int newVal) async {
    Database db = await openDb();
    db.update(tableName, {'isSynced': newVal},
        where: "id = ?", whereArgs: [id]);
  }
}
