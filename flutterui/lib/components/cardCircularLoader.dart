import 'package:flutter/material.dart';
import 'package:flutterui/components/circularLoader.dart';

Widget cardCircularLoader() {
  return Card(
    elevation: 5.0,
    child: Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: CircularLoader(),
    ),
  );
}
