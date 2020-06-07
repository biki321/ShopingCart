import 'package:flutter/material.dart';

class ShoesScrollBar extends StatefulWidget {
  @override
  _ShoesScrollBarState createState() => _ShoesScrollBarState();
}

class _ShoesScrollBarState extends State<ShoesScrollBar> {
  Widget card(String path) {
    return InkWell(
      focusColor: Colors.grey,
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Image.asset(
          path,
          fit: BoxFit.contain,
          width: 100,
        ),
      ),
    );
  }

  Widget get sizedBox => SizedBox(
        width: 10,
      );

  List<Widget> get list => <Widget>[
        card(
            'assets/shoes/addidas/Drogo_M_Walking_Shoes_For_Men/shoes_black1.png'),
        sizedBox,
        card(
            'assets/shoes/addidas/Drogo_M_Walking_Shoes_For_Men/shoes_blue1.png'),
        sizedBox,
        card(
            'assets/shoes/addidas/Drogo_M_Walking_Shoes_For_Men/shoes_grey1.png'),
        sizedBox,
        card(
            'assets/shoes/addidas/Drogo_M_Walking_Shoes_For_Men/shoes_techink1.png'),
        sizedBox,
      ];

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 80,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: list,
        ),
      ),
    );
  }
}
