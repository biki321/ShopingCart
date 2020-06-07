import 'package:flutter/material.dart';
import 'package:flutterui/screens/payment_screen.dart';

class BottomBarProductPage extends StatefulWidget {
  @override
  _BottomBarProductPageState createState() => _BottomBarProductPageState();
}

class _BottomBarProductPageState extends State<BottomBarProductPage> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            IconButton(
              color: Colors.deepOrange,
              icon: Icon(Icons.favorite_border),
              onPressed: () {},
            ),
            SizedBox(
              width: 10.0,
            ),
            Flexible(
              flex: 2,
              child: FlatButton(
                  onPressed: null,
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.deepOrange,
                    ),
                    child: Center(
                      child: Text(
                        'Add to cart',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  )),
            ),
            SizedBox(
              width: 10.0,
            ),
            Flexible(
              flex: 1,
              child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => PaymentPage()));
                  },
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.deepOrange, width: 3.0),
                    ),
                    child: Center(
                      child: Text(
                        'Buy',
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
