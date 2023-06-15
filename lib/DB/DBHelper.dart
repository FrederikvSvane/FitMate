import 'dart:math';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../main.dart';

class DBHelper {
  static Future<Database> getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'meal_database.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {



        await db.execute(
          'CREATE TABLE meals(id INTEGER PRIMARY KEY, barcode INTEGER, nameComponent TEXT, calories REAL, proteins REAL, mealType TEXT, date TEXT)');

        await db.execute(
            'CREATE TABLE weight(id INTEGER PRIMARY KEY,weight REAL,date TEXT)');
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
    if (isInDebugMode) {
      final db = await getDatabase();

      // Clear existing data from the 'meals' table
      await db.delete('meals');

      // Insert some mock data for testing.
      for (var i = 0; i < 30; i++) {
        for (var j = 0; j < 4; j++) {
          final mealData = {
            'barcode': 1234567890 + i * 10 + j,
            'nameComponent': 'Mock Meal ${i * 4 + j}',
            'calories': 500.0 + (i * 10 + j) + Random().nextInt(100),
            'proteins': 20.0 + (i + j) + Random().nextInt(10),
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
      for(int i=0; i<30; i++) {
        double tal = 100.0-i;
        insertWeight(tal, DateTime.now().subtract(Duration(days: i)));
      }
      print("Done inserting mock data.");

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

  static Future<Map<String, dynamic>?> getLatestMeal() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'meals',
      orderBy: 'id DESC',
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return maps[0];
    }
    return null; // Returns null if there are no entries in the database.
  }

  getDB() {
    return getDatabase();
  }

  static Future<List<Map<String, dynamic>>> getCaloriesForDateRange(
      DateTime before, DateTime after) async {
    final db = await getDatabase();

    List<Map<String, dynamic>> meals = await db.rawQuery('''
      SELECT date(date) as date, SUM(calories) as totalCalories 
      FROM meals 
      WHERE date(date) BETWEEN date(?) AND date(?)
      GROUP BY date(date)
    ''', [
      before.toIso8601String(),
      after.toIso8601String(),
    ]);

    return meals;
  }

  static Future<List<Map<String, dynamic>>> getProteinsForDateRange(
      DateTime before, DateTime after) async {
    final db = await getDatabase();

    List<Map<String, dynamic>> meals = await db.rawQuery('''
    SELECT date(date) as date, SUM(proteins) as totalProteins
    FROM meals 
    WHERE date(date) BETWEEN date(?) AND date(?)
    GROUP BY date(date)

  ''', [
      before.toIso8601String(),
      after.toIso8601String(),
    ]);

    return meals;
  }

  static Future<void> weightDB(Database db) async {
    await db.execute('''
        Create Table weight(
        id INTEGER KEY,
        weight REAL,
        date TEXT
        ''');
  }

  static Future<void> insertWeight(double weight, DateTime date) async {
    final db = await getDatabase();
    await db.insert(
      'weight',
      {
        'weight': weight,
        'date': date.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getAllWeights() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('weight');
    return maps;
  }

  static Future<List<Map<String, dynamic>>> getWeightsForDateRange(
      DateTime before, DateTime after) async {
    final db = await getDatabase();

    List<Map<String, dynamic>> weights = await db.rawQuery('''
      SELECT date, weight 
      FROM weight 
      WHERE date(date) BETWEEN date(?) AND date(?)
    ''', [
      before.toIso8601String(),
      after.toIso8601String(),
    ]);

    return weights;
  }
}
