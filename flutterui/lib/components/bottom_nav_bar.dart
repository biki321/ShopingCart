import 'package:flutter/material.dart';
import 'package:flutterui/screens/cart_screen.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.deepOrangeAccent,
      elevation: 0.0,
      //iconSize: 17.0,
      unselectedFontSize: 12.0,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {},
          ),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(Icons.person),
            onPressed: () {},
          ),
          title: Text('Account'),
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => CartPage()));
            },
          ),
          title: Text('Cart'),
        ),
      ],
    );
  }
}
