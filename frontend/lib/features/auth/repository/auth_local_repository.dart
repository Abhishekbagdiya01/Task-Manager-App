import 'package:frontend/features/auth/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AuthLocalRepository {
  String tableName = "users";
  String id = "id";
  String name = "name";
  String email = "email";
  String token = "token";
  String createdAt = "createdAt";
  String updateAt = "updateAt";
  Future<Database> openDb() async {
    String path = join(await getDatabasesPath(), "auth.db");
    return await openDatabase(path,
        version: 1, onCreate: (db, version) async => await db.execute('''
      CREATE TABLE $tableName (
          $id Text PRIMARY KEY ,
          $name Text NOT NULL,
          $email Text NOT NULL ,
          $token Text NOT NULL ,
          $createdAt Text NOT NULL ,
          $updateAt Text NOT NULL 
      )
      '''));
  }

  // INSERT USER TO THE DB
  Future<void> insertUser(UserModel userMode) async {
    final db = await openDb();
    db.insert(tableName, userMode.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<UserModel?> getUser() async {
    final db = await openDb();
    final data = await db.query(tableName, limit: 1);
    if (data.isNotEmpty) {
      return UserModel.fromMap(data.first);
    }
    return null;
  }
}
