import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodApi {
  final int barcode;
  final String nameComponent;
  final num calories;
  final num proteins;

  FoodApi({required this.barcode, required this.nameComponent, required this.calories, required this.proteins});

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
}
