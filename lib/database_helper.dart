import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'image_model.dart';

class DatabaseHelper {
  static final _databaseName = 'my_database.db';
  static final _databaseVersion = 1;

  static final table = 'images';
  static final columnId = 'id';
  static final columnFilePath = 'file_path';
  static final columnFileName = 'file_name';
  static final columnDateAdded = 'date_added';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // open the database or create a new one if it doesn't exist
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnFilePath TEXT NOT NULL,
            $columnFileName TEXT NOT NULL,
            $columnDateAdded TEXT NOT NULL
          )
          ''');
  }

  // Helper methods

  // Insert an image into the database
  Future<int> insertImage(ImageModel image) async {
    Database db = await instance.database;
    return await db.insert(table, image.toMap());
  }

  // Get all images from the database
  Future<List<ImageModel>> getAllImages() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return ImageModel.fromMap(maps[i]);
    });
  }
}
