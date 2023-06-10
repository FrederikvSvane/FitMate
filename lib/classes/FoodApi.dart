import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sqflite/sqflite.dart';

class FoodApi {
  final int? id;
  final String barcode;
  late final String nameComponent;
  late final double calories;
  late final double proteins;
  String? mealType;
  String? date;

  FoodApi({this.id, required this.barcode, required this.nameComponent, required this.calories, required this.proteins,this.mealType,this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id, // SQLite will automatically assign this if it's null.
      'barcode': barcode,
      'nameComponent': nameComponent,
      'calories': calories,
      'proteins': proteins,
      'mealType': mealType,
      'date': date,
    };
  }

  static Future<List<FoodApi>> getAllMeals(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('meals');
    return List.generate(maps.length, (i) {
      return FoodApi(
        id: maps[i]['id'],
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

      String barcodeData = json['code'];
      String nameComponentData = json['product']['product_name'] ?? '';
      double caloriesData = (json['product']['nutriments']['energy-kcal_100g'] ?? 0).toDouble();
      double proteinsData = (json['product']['nutriments']['proteins_100g'] ?? 0).toDouble();

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

