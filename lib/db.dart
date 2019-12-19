// This file was generated with 'yamlt'
// Datetime: Dec 19, 2019 10:49:27 PM
// Template: db_template.t
//     YAML: db_data.yaml

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> _database() async {
  final Database db = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE DBEntry(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
      );
      await db.execute(
        'CREATE TABLE Vehicle(id INTEGER PRIMARY KEY, brand TEXT, model TEXT, wheels INTEGER)',
      );
    },
    version: 1,
  );
  return db;
}

Future<Database> database = _database();

Future<void> insertDBEntry(DBEntry item) async {
  final Database db = await database;

  await db.insert(
    'DBEntry',
    item.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<int> newDBEntry(String name, int age, ) async {
  final Database db = await database;

  return db.insert(
    'DBEntry',
    {
        'name': name,
        'age': age,
    },
  );
}

Future<List<DBEntry>> allDBEntry() async {
  final Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query('DBEntry');

  return List.generate(maps.length, (i) {
    return DBEntry(
      id: maps[i]['id'],
      name: maps[i]['name'],
      age: maps[i]['age'],
    );
  });
}

Future<void> updateDBEntry(DBEntry item) async {
  final db = await database;

  await db.update(
    'DBEntry',
    item.toMap(),
    where: "id = ?",
    whereArgs: [item.id],
  );
}

Future<void> deleteDBEntry(int id) async {
  final db = await database;

  await db.delete(
    'DBEntry',
    where: "id = ?",
    whereArgs: [id],
  );
}
Future<void> insertVehicle(Vehicle item) async {
  final Database db = await database;

  await db.insert(
    'Vehicle',
    item.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<int> newVehicle(String brand, String model, int wheels, ) async {
  final Database db = await database;

  return db.insert(
    'Vehicle',
    {
        'brand': brand,
        'model': model,
        'wheels': wheels,
    },
  );
}

Future<List<Vehicle>> allVehicle() async {
  final Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query('Vehicle');

  return List.generate(maps.length, (i) {
    return Vehicle(
      id: maps[i]['id'],
      brand: maps[i]['brand'],
      model: maps[i]['model'],
      wheels: maps[i]['wheels'],
    );
  });
}

Future<void> updateVehicle(Vehicle item) async {
  final db = await database;

  await db.update(
    'Vehicle',
    item.toMap(),
    where: "id = ?",
    whereArgs: [item.id],
  );
}

Future<void> deleteVehicle(int id) async {
  final db = await database;

  await db.delete(
    'Vehicle',
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

class DBEntry {
  final int id;
  final String name;
  final int age;

  DBEntry({this.id, this.name, this.age});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }
}

class Vehicle {
  final int id;
  final String brand;
  final String model;
  final int wheels;

  Vehicle({this.id, this.brand, this.model, this.wheels});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'wheels': wheels,
    };
  }
}

