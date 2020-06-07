import 'package:flutter/material.dart';

Widget sizedBox() => SizedBox(width: 20);

List<Widget> brands_logos_list = [
  Container(
    //color: Colors.red,
    width: 80,
    height: 80,
    child: Image.asset(
      'assets/logo/adidas_logo.png',
      fit: BoxFit.contain,
    ),
  ),
  sizedBox(),
  Container(
    //color: Colors.red,
    width: 80,
    height: 80,
    child: Padding(padding: EdgeInsets.all(10),
    child: Image.asset(
      'assets/logo/nike_logo.png',
      fit: BoxFit.contain,
    ),),

  ),
  sizedBox(),
  Container(
    //color: Colors.red,
    width: 80,
    height: 80,
    child: Padding(padding: EdgeInsets.all(10),
    child: Image.asset(
      'assets/logo/reebok_logo.png',
      fit: BoxFit.contain,
    ),),
  ),
  sizedBox(),
  Container(
    //color: Colors.red,
    width: 80,
    height: 80,
    child: Padding(padding: EdgeInsets.all(10),
    child: Image.asset(
      'assets/logo/skechers_logo.png',
      fit: BoxFit.contain,
    ),),
  ),
  sizedBox(),
  Container(
    //color: Colors.red,
    width: 80,
    height: 80,
   child: Padding(padding: EdgeInsets.all(10),
    child: Image.asset(
      'assets/logo/puma_logo.png',
      fit: BoxFit.contain,
    ),),
  ),
  sizedBox(),
];
