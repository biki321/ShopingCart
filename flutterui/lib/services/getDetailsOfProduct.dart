import 'dart:convert';
import 'dart:async';
import 'package:flutterui/constants/NetworkRelated.dart';
import 'package:flutterui/model/productDetails/oneColoredItemWithAllSize.dart';
import 'package:flutterui/model/productDetails/oneColoredItemWithOneSize.dart';
import 'package:flutterui/model/productDetails/productDetails.dart';
import 'package:http/http.dart' as http;

Future<ProductDetails> fetchProductDetails(productid) async {
  try {
    final response =
        await http.get("$SERVER_IP/api/products/productid/$productid");
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body)["OneProduct"];
      return ProductDetails.fromJson(res);
    } else {
      throw Exception("can not fetch details");
    }
  } catch (err) {
    throw err;
  }
}

Future<OneColoredItemWithAllSize> fetchOneColoredItemWithAllSize(
    productid, nestedid) async {
  try {
    final response = await http
        .get("$SERVER_IP/api/products/productid/$productid/nestedid/$nestedid");
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body)["coloredProductWithAllSize"];
      return OneColoredItemWithAllSize.fromJson(res);
    } else {
      throw Exception("can not fetch details");
    }
  } catch (err) {
    throw err;
  }
}

Future<OneColoredItemWithOneSize> fetchOneColoredItemWithOneSize(
    productid, nestedid, size) async {
  try {
    final response = await http.get(
        "$SERVER_IP/api/products/productid/$productid/nestedid/$nestedid/size/$size");
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body)["coloredProductWithOneSize"];
      return OneColoredItemWithOneSize.fromJson(res);
    } else {
      throw Exception("can not fetch details");
    }
  } catch (err) {
    throw err;
  }
}
