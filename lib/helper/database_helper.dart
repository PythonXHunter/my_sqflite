import 'dart:typed_data';
import 'package:my_sqflite/image/new_image_model/image_data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static final _databaseName = 'my_database.db';
  static final _databaseVersion = 1;

  static final table = 'image_table';
  static final columnId = 'id';
  static final columnImageData = 'imageData';

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnImageData BLOB
      )
    ''');
  }

  Future<int> insertImage(ImageModel1 image) async {
    final db = await database;
    return await db.insert(table, image.toMap());
  }

  Future<List<ImageModel1>> getImages() async {
  final db = await database;
  final maps = await db.query(table);

  return List.generate(maps.length, (i) {
    final imageData = Uint8List.fromList((maps[i][columnImageData] as List<int>?) ?? []);
    return ImageModel1(
      id: maps[i][columnId] as int?,
      imageData: imageData,
    );
  });
}

  Future<int> deleteImage(int id) async {
    final db = await database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
    _database = null;
  }
}
