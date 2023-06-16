import 'dart:math';

import 'package:intl/intl.dart';
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
            'CREATE TABLE meals(id INTEGER PRIMARY KEY, barcode INTEGER, nameComponent TEXT, calories REAL, proteins REAL, mealType TEXT, date TEXT)',
          );
          await db.execute(
            'CREATE TABLE exercises(id INTEGER PRIMARY KEY, name TEXT, sets INTEGER, reps INTEGER, weight REAL, date TEXT)',
          );
          await db.execute(
            'CREATE TABLE workouts(id INTEGER PRIMARY KEY, workoutName TEXT, name TEXT, sets INTEGER, date TEXT)',
          );
          await db.execute(
              'CREATE TABLE weight(weight REAL,date TEXT PRIMARY KEY)');
        }
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
      await db.delete('weight');

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
        double tal = 100.0-i + Random().nextInt(10);
        DateTime now = DateTime.now();
        DateTime dateOnly = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));

        // Format dateOnly to a string that only contains the date
        String formattedDate = DateFormat('yyyy-MM-dd').format(dateOnly);

        insertWeight(tal, formattedDate);
      }
      print("Done inserting mock data.");

      // DateTime now = DateTime.now();
      // DateTime dateOnly = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 50));
      // DateTime dateOnly1 = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 49));
      // DateTime dateOnly2 = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 47));
      //
      // // Format dateOnly to a string that only contains the date
      // String formattedDate = DateFormat('yyyy-MM-dd').format(dateOnly);
      // String formattedDate1 = DateFormat('yyyy-MM-dd').format(dateOnly1);
      // String formattedDate2 = DateFormat('yyyy-MM-dd').format(dateOnly2);
      //
      // insertWeight(65.2, formattedDate);
      // insertWeight(60, formattedDate1);
      // insertWeight(55, formattedDate2);

    }
  }

  // Function to get most recent weight
  static Future<Map<String, dynamic>> getMostRecentWeight(DateTime time) async {
    final db = await getDatabase();

    // Start from today's date
    DateTime now = time;
    DateTime date = DateTime(now.year, now.month, now.day);

    while (true) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);

      // Get the weight for this date
      List<Map<String, dynamic>> maps = await db.query(
        'weight',
        where: 'date = ?',
        whereArgs: [formattedDate],
      );

      // If a weight was found, return it
      if (maps.isNotEmpty) {
        return {'weight': maps[0]['weight'], 'date': maps[0]['date']};
      }

      // Subtract one day and try again
      date = date.subtract(const Duration(days: 1));
    }
  }


  static Future<void> insertExercise(Map<String, dynamic> exerciseData) async {
    final db = await getDatabase();
    await db.insert(
      'exercises',
      exerciseData,
      conflictAlgorithm: ConflictAlgorithm.replace,
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


  static Future<List<Map<String, dynamic>>> getExercises() async {
    final db = await getDatabase();

    // Execute the query
    final List<Map<String, dynamic>> maps = await db.query('exercises');
    await db.delete('exercises');
    return maps;
  }

  static Future<List<Map<String, dynamic>>> getWorkouts() async {
    final db = await getDatabase();

    // Execute the query
    final List<Map<String, dynamic>> maps = await db.query('workouts');
    await db.delete('workouts');
    return maps;
  }

  static Future<void> weightDB(Database db) async {
    await db.execute('''
        Create Table weight(
        id INTEGER KEY,
        weight REAL,
        date TEXT
        ''');
  }

  static Future<void> insertWeight(double weight, String date) async {
    final db = await getDatabase();
    await db.insert(
      'weight',
      {
        'weight': weight,
        'date': date, // directly use the date string
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
