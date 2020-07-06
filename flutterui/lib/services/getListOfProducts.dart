import 'dart:convert';
import 'dart:async';
import 'package:flutterui/constants/NetworkRelated.dart';
import 'package:flutterui/model/products/productsModel.dart';
import 'package:http/http.dart' as http;

Future<List<Product>> fetchproducts(String brandName, int productsListLength,
    limitOfNoOfProductsPerApiCall) async {
  if (productsListLength % limitOfNoOfProductsPerApiCall != 0) return [];

  double pageNo = (productsListLength / limitOfNoOfProductsPerApiCall) + 1;

  try {
    final response = await http.get(
        "$SERVER_IP/api/products/brand/$brandName/NoOfDoc/$limitOfNoOfProductsPerApiCall/pageNo/$pageNo");
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["products"] as List;

      return data.map((rawProduct) {
        return Product.fromJson(rawProduct);
      }).toList();
    } else {
      throw Exception('error fetching products');
    }
  } catch (err) {
    throw err;
  }
}
