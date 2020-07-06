import 'dart:io' show HttpHeaders;

import 'package:flutterui/constants/NetworkRelated.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show jsonEncode;

final storage = FlutterSecureStorage();

Future<http.Response> attemptLogIn(String email, String password) async {
  var res = await http.post("$SERVER_IP/api/users/login",
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
      body: jsonEncode({"email": email, "password": password}));

  return res;
}

Future<http.Response> attemptSignUp(
    String name, String email, String password) async {
  try {
    var res = await http.post('$SERVER_IP/api/users/register',
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}));
    return res;
  } catch (error) {
    print('error at attemptSignUp');
    throw error;
  }
}

void storejwt(String jwt) {
  if (jwt != null) {
    storage.write(key: "jwt", value: jwt);
  }
}

Future<String> readJwt() async {
  var jwt = await storage.read(key: "jwt");
  return jwt;
}
