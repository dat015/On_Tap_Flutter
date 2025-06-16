// import 'package:sqflite/sqflite.dart';

// class UserRepo {
//   late Database db;

//   UserRepo() {
//     _initDb();
//   }

//   Future<void> _initDb() async {
//     db = await openDatabase('on_tap.db');
//   }

//   Future<void> insertUser(Map<String, dynamic> user) async {
//     await db.insert('users', user);
//   }
// }