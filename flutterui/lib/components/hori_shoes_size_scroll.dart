import 'package:flutter/material.dart';

class SizeScrollBar extends StatefulWidget {
  @override
  _SizeScrollBarState createState() => _SizeScrollBarState();
}

class _SizeScrollBarState extends State<SizeScrollBar> {
  Widget card(String size) {
    return InkWell(
      focusColor: Colors.grey,
      child: Card(
        elevation: 0.0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey[200],
          ),
          width: 50,
          child: Center(
            child: Text(
              size,
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get sizedBox => SizedBox(
        width: 8.0,
      );
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 50,
        child: ListView(
          padding: EdgeInsets.only(left:10.0),
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            card('6'),
            sizedBox,
            card('7'),
            sizedBox,
            card('8'),
            sizedBox,
            card('9'),
            sizedBox,
            card('10'),
          ],
        ),
      ),
    );
  }
}
