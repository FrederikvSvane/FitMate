import 'package:flutter/foundation.dart';
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

  static Future<void> insertMockData() async {
    if (kDebugMode) {
      // Insert some mock data for testing.
      for (var i = 0; i < 30; i++) {
        for (var j = 0; j < 4; j++) {
          final mealData = {
            'barcode': 1234567890 + i * 10 + j,
            'nameComponent': 'Mock Meal ${i * 4 + j}',
            'calories': 500.0 + (i * 10 + j),
            'proteins': 20.0 + (i + j),
            'mealType': j == 0
                ? 'Breakfast'
                : j == 1
                ? 'Lunch'
                : j == 2
                ? 'Dinner'
                : 'Snacks',
            'date': DateTime.now().subtract(Duration(days: i)).toString(),
          };
          await insertMeal(mealData);
        }
      }
    }
  }




  static Future<List<Map<String, dynamic>>> getAllMeals() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('meals');
    return maps;
  }

  //Remove meal from database
  static Future<void> removeMeal(int id) async {
    final db = await getDatabase();
    await db.delete(
      'meals',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  //Get meal by id
  static Future<List<Map<String, dynamic>>> getMealById(int id) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'meals',
      where: "id = ?",
      whereArgs: [id],
    );
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
