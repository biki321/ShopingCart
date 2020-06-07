import 'dart:io' show HttpHeaders;

//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show ascii, base64, json, jsonEncode;

const SERVER_IP = "http://192.168.1.101:8000";
final storage = FlutterSecureStorage();

Future<http.Response> attemptLogIn(String email, String password) async {
  var res = await http.post("$SERVER_IP/api/users/login",
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
      body: jsonEncode({"email": email, "password": password}));
  //if (res.statusCode == 200) return res.body;
  return res;
}

Future<http.Response> attemptSignUp(String name, String email, String password) async {
  var res = await http.post('$SERVER_IP/api/userss/register',
      //var res = await http.post('$SERVER_IP/test',
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}));
  return res;
}

void storejwt(String jwt) {
  if (jwt != null) {
    storage.write(key: "jwt", value: jwt);
  }
}
