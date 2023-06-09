import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sqflite/sqflite.dart';

class FoodApi {
  final int barcode;
  final String nameComponent;
  final num calories;
  final num proteins;
  String? mealType;
  String? date;

  FoodApi({required this.barcode, required this.nameComponent, required this.calories, required this.proteins,this.mealType,this.date});

  Map<String, dynamic> toMap() {
    return {
      'barcode': barcode,
      'nameComponent': nameComponent,
      'calories': calories,
      'proteins': proteins,
    };
  }

  static Future<List<FoodApi>> getAllMeals(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('meals');
    return List.generate(maps.length, (i) {
      return FoodApi(
        barcode: maps[i]['barcode'],
        nameComponent: maps[i]['nameComponent'],
        calories: maps[i]['calories'],
        proteins: maps[i]['proteins'],
        mealType: maps[i]['mealType'],
        date: maps[i]['date'],
      );
    });
  }


  Future<void> insertMeal(Database db) async {
    // Insert the meal into the correct table.
    await db.insert(
      'meals',
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  static Future<FoodApi> fetchFoodApi(int barcode) async {
    var uri = Uri.https('world.openfoodfacts.org', "/api/2/product/$barcode.json");

    Map<String, String> requestHeaders = {
      'User-Agent': 'Your-App-Name - Android - Version 1.0'
    };



    var response = await http.get(uri, headers: requestHeaders);

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);

      if(json['product'] == null) {
        throw Exception('Product not found');
      }

      int barcodeData = int.parse(json['code']);
      String nameComponentData = json['product']['product_name'] ?? '';
      num caloriesData = json['product']['nutriments']['energy-kcal_100g'] ?? 0;
      num proteinsData =json['product']['nutriments']['proteins_100g'] ?? 0;

      FoodApi foodApi = FoodApi(
        barcode: barcodeData,
        nameComponent: nameComponentData,
        calories: caloriesData,
        proteins: proteinsData,
      );
      return foodApi;
    } else {
      throw Exception('Failed to load FoodApi');
    }
  }

  static Future<FoodApi?> getLatestMeal(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'meals',
      orderBy: 'id DESC',
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return FoodApi(
        barcode: maps[0]['barcode'],
        nameComponent: maps[0]['nameComponent'],
        calories: maps[0]['calories'],
        proteins: maps[0]['proteins'],
      );
    }
    return null; // Returns null if there are no entries in the database.
  }

  getBarcode() {
    return barcode;
  }
  getNameComponent() {
    return nameComponent;
  }
  getCalories() {
    return calories;
  }
  getProteins() {
    return proteins;
  }

}

