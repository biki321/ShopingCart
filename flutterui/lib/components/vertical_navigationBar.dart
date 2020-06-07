import 'package:flutter/material.dart';

class VerticalNavBar extends StatelessWidget {
  static Widget sizedBox() {
    return SizedBox(height: 25);
  }

  static Widget text(String category) {
    return RotatedBox(
      quarterTurns: 1,
      child: Text(
        category,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      //color: Colors.blueGrey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          text('women'),
          sizedBox(),
          text('men'),
          sizedBox(),
          text('kids'),
          sizedBox(),
          text('Customized'),
         
        ],
      ),
    );
  }
}
