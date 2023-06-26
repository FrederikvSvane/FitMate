import 'dart:math';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../main.dart';

class DBHelper {
  static Future<Database> getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'FitMate_DB.db');

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE meals(id INTEGER PRIMARY KEY, barcode INTEGER, nameComponent TEXT, calories REAL, proteins REAL, mealType TEXT, date TEXT)',
      );
      await db.execute(
        'CREATE TABLE exercises(id INTEGER PRIMARY KEY, name TEXT, sets TEXT, reps TEXT, weight TEXT, time TEXT, distance TEXT, date TEXT)',
      );
      await db.execute(
        'CREATE TABLE workouts(id INTEGER PRIMARY KEY, workoutName TEXT, exercises TEXT, type TEXT, sets TEXT, date TEXT)',
      );
      await db
          .execute('CREATE TABLE weight(weight REAL,date TEXT PRIMARY KEY)');
    });
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

      await db.delete('meals');
      await db.delete('weight');

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

      for (int i = 0; i < 30; i++) {
        double tal = 100.0 - i + Random().nextInt(10);
        DateTime now = DateTime.now();
        DateTime dateOnly =
            DateTime(now.year, now.month, now.day).subtract(Duration(days: i));

        String formattedDate = DateFormat('yyyy-MM-dd').format(dateOnly);

        insertWeight(tal, formattedDate);
      }
    }
  }

  static Future<Map<String, dynamic>> getMostRecentWeight(DateTime time) async {
    final db = await getDatabase();

    DateTime now = time;
    DateTime date = DateTime(now.year, now.month, now.day);

    while (true) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);

      List<Map<String, dynamic>> maps = await db.query(
        'weight',
        where: 'date = ?',
        whereArgs: [formattedDate],
      );

      if (maps.isNotEmpty) {
        return {'weight': maps[0]['weight'], 'date': maps[0]['date']};
      }

      date = date.subtract(const Duration(days: 1));
    }
  }

  static Future<void> insertExercise(Map<String, dynamic> exerciseData) async {
    final db = await getDatabase();
    await db.insert(
      'exercises',
      exerciseData,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  static Future<void> insertWorkout(Map<String, dynamic> workoutData) async {
    final db = await getDatabase();
    await db.insert(
      'workouts',
      workoutData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getAllMeals() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('meals');
    return maps;
  }

  static Future<void> removeMeal(int id) async {
    final db = await getDatabase();
    await db.delete(
      'meals',
      where: "id = ?",
      whereArgs: [id],
    );
  }

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
    return null;
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

  static Future<List<Map<String, dynamic>>> getExercises() async {
    final db = await getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('exercises');
    return maps;
  }

  static Future<List<Map<String, dynamic>>> getWorkouts() async {
    final db = await getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('workouts');
    return maps;
  }

  static Future<void> insertWeight(double weight, String date) async {
    final db = await getDatabase();
    await db.insert(
      'weight',
      {
        'weight': weight,
        'date': date,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getAllWeights() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('weight');
    return maps;
  }

  static Future<List<Map<String, dynamic>>?> getLatestWeight() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> weights = await db.query(
      'weight',
      orderBy: 'id DESC',
      limit: 1,
    );
    if (weights.isNotEmpty) {
      return weights;
    }
    return null;
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

  static Future<List<Map<String, dynamic>>> getExercisesForDate(DateTime date) async {
    final db = await getDatabase();

    DateTime startDate = DateTime(date.year, date.month, date.day);
    DateTime endDate = startDate.add(const Duration(days: 1));

    List<Map<String, dynamic>> exercises = await db.query(
      'exercises',
      where: 'date >= ? AND date < ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
    );

    return exercises;
  }




}
