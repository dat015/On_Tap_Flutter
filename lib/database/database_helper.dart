import 'package:on_tap_1/models/user.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final instance = DatabaseHelper._();
  static Database? _db;
  DatabaseHelper._();

  Future<Database> get database async => _db ??= await _initDB('on_tap.db');

  Future<Database> _initDB(String path) => openDatabase(
    path,
    version: 1,
    onCreate: (db, _) => db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phone TEXT NOT NULL,
        dateOfBirth TEXT,
        gender TEXT,
        password TEXT NOT NULL
      )
    '''),
  );

  Future<void> insertUser(User user) async =>
      (await database).insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

  Future<User?> getUserByEmail(String email) async {
    final maps = await (await database).query('users', where: 'email = ?', whereArgs: [email]);
    return maps.isNotEmpty ? User.fromMap(maps.first) : null;
  }

  Future<void> updateUser(User user) async =>
      (await database).update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);

  Future<void> close() async => (await database).close();
}
