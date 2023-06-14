import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_fitness_app/DB/DBHelper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    // Initialize sqflite for desktop embedding.
    sqfliteFfiInit();
    // Use sqflite in FFI mode (force native implementation).
    databaseFactory = databaseFactoryFfi;

    // Initialize your database
    await DBHelper.getDatabase();
  });

  group('DBHelper', () {
    test('insert and retrieve meal', () async {
      final mealData = {
        'barcode': 1234567890,
        'nameComponent': 'Test Meal',
        'calories': 500.0,
        'proteins': 20.0,
        'mealType': 'Breakfast',
        'date': DateTime.now().toString(),
      };
      await DBHelper.insertMeal(mealData);

      final allMeals = await DBHelper.getAllMeals();
      expect(allMeals, isNotEmpty);
      expect(allMeals.first['nameComponent'], equals('Test Meal'));
    });

    test('remove meal', () async {
      final mealData = {
        'barcode': 1234567891,
        'nameComponent': 'Test Meal 2',
        'calories': 600.0,
        'proteins': 30.0,
        'mealType': 'Lunch',
        'date': DateTime.now().toString(),
      };
      await DBHelper.insertMeal(mealData);

      final meal = await DBHelper.getLatestMeal();
      expect(meal?.nameComponent, equals('Test Meal 2'));

      if (meal != null) {
        await DBHelper.removeMeal(meal.id!);
      }

      final allMeals = await DBHelper.getAllMeals();
      expect(allMeals.where((m) => m['nameComponent'] == 'Test Meal 2'), isEmpty);
    });

    test('get meal by id', () async {
      final mealData = {
        'barcode': 1234567892,
        'nameComponent': 'Test Meal 3',
        'calories': 700.0,
        'proteins': 40.0,
        'mealType': 'Dinner',
        'date': DateTime.now().toString(),
      };
      await DBHelper.insertMeal(mealData);

      final latestMeal = await DBHelper.getLatestMeal();
      expect(latestMeal?.nameComponent, equals('Test Meal 3'));

      if (latestMeal != null) {
        final fetchedMeal = await DBHelper.getMealById(latestMeal.id!);
        expect(fetchedMeal.first['nameComponent'], equals('Test Meal 3'));
      }
    });
  });
}
