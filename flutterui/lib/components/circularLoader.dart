import 'package:flutter/material.dart';

class CircularLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 33,
        height: 33,
        child: CircularProgressIndicator(
          //backgroundColor: Colors.orangeAccent,          
          strokeWidth: 5.0,
        ),
      ),
    );
  }
}
