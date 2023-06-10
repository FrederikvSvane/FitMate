import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../classes/FoodApi.dart';

class DBHelper {
  static Future<Database> getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'meal_database.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE meals(id INTEGER PRIMARY KEY, barcode INTEGER, nameComponent TEXT, calories REAL, proteins REAL, mealType TEXT, date TEXT)',
        );
      },
    );
  }

  static Future<void> insertMeal(Map<String, dynamic> mealData) async {
    final db = await getDatabase();
    await db.insert(
      'meals',
      mealData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  static Future<List<Map<String, dynamic>>> getAllMeals() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('meals');
    return maps;
  }


  static Future<FoodApi?> getLatestMeal() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'meals',
      orderBy: 'id DESC',
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return FoodApi(
        id: maps[0]['id'],
        barcode: maps[0]['barcode'],
        nameComponent: maps[0]['nameComponent'],
        calories: maps[0]['calories'],
        proteins: maps[0]['proteins'],
        mealType: maps[0]['mealType'],
        date: maps[0]['date'],
      );
    }
    return null; // Returns null if there are no entries in the database.
  }

  getDB(){
  return getDatabase();
  }

}
