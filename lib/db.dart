import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db_entry.dart';

Future<Database> _database() async {
  final Database db = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE entries(id INTEGER PRIMARY KEY, name TEXT)',
      );
    },
    version: 1,
  );
  return db;
}

Future<Database> database = _database();

Future<void> insertEntry(DBEntry entry) async {
  final Database db = await database;

  await db.insert(
    'entries',
    entry.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<int> newEntry(String name) async {
  final Database db = await database;

  return db.insert(
    'entries',
    {'name': name},
  );
}

Future<List<DBEntry>> entries() async {
  final Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query('entries');

  return List.generate(maps.length, (i) {
    return DBEntry(
      id: maps[i]['id'],
      name: maps[i]['name'],
    );
  });
}

Future<void> updateEntry(DBEntry entry) async {
  final db = await database;

  await db.update(
    'entries',
    entry.toMap(),
    where: "id = ?",
    whereArgs: [entry.id],
  );
}

Future<void> deleteEntry(int id) async {
  final db = await database;

  await db.delete(
    'entries',
    where: "id = ?",
    whereArgs: [id],
  );
}

Future<void> deleteDatabase() async {
  try {
    final path = join(await getDatabasesPath(), 'database.db');
    await File(path).delete();
  } catch (e) {}
}

Future<void> newDatabase() async {
  final db = await database;
  await db.close();
  await deleteDatabase();
  database = _database();
}
