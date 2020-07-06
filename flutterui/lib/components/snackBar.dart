import 'package:flutter/material.dart';

Widget snackBar(String msg, String error) {
  return SnackBar(
    duration: Duration(milliseconds: 1500),
    behavior: SnackBarBehavior.floating,
    backgroundColor: msg != ''
        ? Color.fromARGB(255, 4, 207, 220)//for success
        : Color.fromARGB(255, 242, 174, 158),//for error
    elevation: 3.0,
    content: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          msg != '' ? Icons.done : Icons.error,
          color: Colors.white,
        ),
        SizedBox(
          width: 5.0,
        ),
        Text(
          "${msg != '' ? msg : error}",
          style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(200, 255, 255, 255)),
        ),
      ],
    ),
  );
}
