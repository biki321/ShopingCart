import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final bool isActive;
  final String category;

  const CategoryButton({Key key, this.isActive, this.category})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0)),
      ),
      elevation: isActive ? 5.0 : 0.0,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? Color.fromARGB(255, 245, 81, 21) : null,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0)),
        ),
        height: 83,
        width: 60,
        child: RotatedBox(
          quarterTurns: 3,
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color:
                    isActive ? Colors.white : Color.fromARGB(255, 148, 148, 148),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VerticalNavBar extends StatelessWidget {
  static Widget sizedBox() {
    return SizedBox(height: 10);
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
          CategoryButton(
            isActive: true,
            category: 'men',
          ),
          CategoryButton(
            isActive: false,
            category: 'women',
          ),
          CategoryButton(
            isActive: false,
            category: 'kids',
          ),
          CategoryButton(
            isActive: false,
            category: 'customized',
          ),
        ],
      ),
    );
  }
}
