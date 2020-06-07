import 'package:flutter/material.dart';

class SliverAppBarForProductDetailsPage extends StatefulWidget {
  final Color color;
  final String name;
  final String price;
  final String path;
  final bool instock;
  final String brand_name;

  const SliverAppBarForProductDetailsPage(
      {Key key,
      @required this.color,
      @required this.name,
      @required this.price,
      @required this.path,
      @required this.instock, 
      @required this.brand_name})
      : super(key: key);
  @override
  _SliverAppBarForProductDetailsPageState createState() => _SliverAppBarForProductDetailsPageState();
}

class _SliverAppBarForProductDetailsPageState extends State<SliverAppBarForProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
            floating: false,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            backgroundColor: widget.color,
            elevation: 0.0,
            expandedHeight: MediaQuery.of(context).size.height * 0.58,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.asset(
                    widget.path,
                    fit: BoxFit.contain,
                  ),
                  Positioned(
                    bottom: 5.0,
                    left: 5.0,
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${widget.instock ? 'instock' : 'out of stock'}",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${widget.brand_name}",
                            style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.name,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 27,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "\$${widget.price}",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 22,
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}