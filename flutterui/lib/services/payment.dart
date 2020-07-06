import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io' show HttpHeaders;
import 'package:http/http.dart' as http;
import 'package:flutterui/constants/NetworkRelated.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'authentication.dart';

Future order() async {
  try {
    var jwt = await readJwt();
    final response = await http.get(
      "$SERVER_IP/api/cart/order",
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        'Authorization': jwt,
      },
    );

    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      return res;
    } else {
      throw Exception("order fail");
    }
  } catch (err) {
    throw err;
  }
}

Future<http.Response> pay(PaymentSuccessResponse response) async {
  var jwt = await readJwt();

  //we are sending the orderId,paymentId,signature returned after payment done by user
  //to our server for verification of the signature
  //after verification result in true then server will capturd the payment and then user will get
  //his/her item delivered
  //if verification result in false then user payment will be refunded after some days days
  // if paymwnt was not deducted
  try {
    var res = await http.post("$SERVER_IP/api/cart/payment",
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          'Authorization': jwt,
        },
        body: jsonEncode({
          "razorpay_order_id": response.orderId,
          "razorpay_payment_id": response.paymentId,
          "razorpay_signature": response.signature
        }));
    return res;
  } catch (error) {
    throw error;
  }
}
