import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterui/components/bottom_nav_bar.dart';
import 'package:flutterui/components/brands_logos_list.dart';
import 'package:flutterui/components/list_of_product_card.dart';
import 'package:flutterui/components/vertical_navigationBar.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: true,
      right: true,
      top: true,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          // the logo of the app(company for example)
          title: Image.asset(
            'assets/logo/logo.png',
            fit: BoxFit.contain,
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 80.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 10),
                  //list of logos for the horizontal listview of brands

                  children: brands_logos_list,
                ),
              ),
              Expanded(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      VerticalNavBar(),
                      SizedBox(width: 5.0),
                      Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.70,
                        child: ListView.builder(
                          padding: EdgeInsets.only(right: 10.0),
                          itemCount: list_of_product_card.length,
                          itemBuilder: (context, index) {
                            return list_of_product_card[index];
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNav(),
      ),
    );
  }
}
