import'package:http/http.dart' as http;
import 'dart:convert';

class FoodApi{
  final int barcode;
  final String nameComponent;
  final double calories;


  const FoodApi({required this.barcode, required this.nameComponent, required this.calories});

  factory FoodApi.fromJson(Map<String, dynamic> json){
    return FoodApi(
      barcode: json['barcode'],
      nameComponent: json['product']['product_name'],
      calories: json['calories'],
    );
  }
  Future<FoodApi> fetchFoodApi(int barcode) async {
    var uri = Uri.https('world.openfoodfacts.org', "/api/v2/product/$barcode");

    // Define headers
    Map<String, String> requestHeaders = {
      'User-Agent': 'FitMate - Android - Version 1.0'
    };

    var response = await http.get(uri, headers: requestHeaders);

    if (response.statusCode == 200) {
      // Parse the response body as JSON
      Map<String, dynamic> json = jsonDecode(response.body);
      // Create a FoodApi object from the JSON
      FoodApi foodApi = FoodApi.fromJson(json);
      print(foodApi.nameComponent);
      return foodApi;
    } else {
      print(response.statusCode);
      print("I am here");
      throw Exception('Failed to load FoodApi');
    }}
}