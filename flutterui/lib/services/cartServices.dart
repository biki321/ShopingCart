import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutterui/constants/NetworkRelated.dart';
import 'package:flutterui/services/authentication.dart';
import 'package:http/http.dart' as http;

Future<http.Response> fetchCartDetails() async {
  try {
    var jwt = await readJwt();
    //if (jwt == null) return "logout";

    final response = await http.get(
      "$SERVER_IP/api/cart/",
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        'Authorization': jwt,
      },
    );
    print(jsonDecode(response.body)["products"]);
    return response;
  } catch (error) {
    throw error;
  }
}

Future<http.Response> addToCart(
    String productId, String nestedId, int size, int quantity) async {
  try {
    var jwt = await readJwt();  

    final response = await http.post(
      "$SERVER_IP/api/cart/addToCart/product_id/$productId/nested_id/$nestedId/size/$size/quantity/$quantity",
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        'Authorization': jwt,
      },
    );
    return response;
  } catch (error) {
    throw error;
  }
}

Future<http.Response> addOrRemoveItemInCart(String productId, String nestedId,
    int size, int quantity, String idOfCartItem) async {
  try {
    var jwt = await readJwt();
    //if (jwt == null) return "logout";

    final response = await http.post(
      "$SERVER_IP/api/cart/addOrRemove/product_id/$productId/nested_id/$nestedId/size/$size/quantity/$quantity/id_of_cart_item/$idOfCartItem",
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        'Authorization': jwt,
      },
    );
    return response;
  } catch (error) {
    throw error;
  }
}

Future<http.Response> deleteItemInCart(String idOfCartItem) async {
  try {
    var jwt = await readJwt();
    //if (jwt == null) return "logout";

    final response = await http.delete(
      "$SERVER_IP/api/cart/deleteItem/id_of_cart_item/$idOfCartItem",
          headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        'Authorization': jwt,
      },
    );
    return response;
  } catch (error) {
    throw error;
  }
}
