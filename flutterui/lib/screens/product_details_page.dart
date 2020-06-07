import 'package:flutter/material.dart';
import 'package:flutterui/components/bottom_bar_product_details_page.dart';
import 'package:flutterui/components/hori_shoes_scroll_bar.dart';
import 'package:flutterui/components/hori_shoes_size_scroll.dart';
import 'package:flutterui/components/sliverappbar_for_product_details_page.dart';

class ProductDetails extends StatefulWidget {
  final Color color;
  final String name;
  final String price;
  final String path;
  final bool instock;
  final String brand_name;

  const ProductDetails(
      {Key key,
      @required this.color,
      @required this.name,
      @required this.price,
      @required this.path,
      @required this.instock,
      @required this.brand_name,
      })
      : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBarForProductDetailsPage(
              color: widget.color,
              name: widget.name,
              price: widget.price,
              path: widget.path,
              instock: widget.instock,
              brand_name: widget.brand_name),
          SliverToBoxAdapter(            
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Text(
              'Color',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 15,
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),
            ),
            ),
            ),

            //Horizontal Scroll Bar for different colored shoes
            ShoesScrollBar(),
           SliverToBoxAdapter(            
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Text(
              'Size',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 15,
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),
            ),
            ),
            ),
             //Horizontal Scroll Bar for different sizes of shoes
            SizeScrollBar(),
            SliverPadding(
              padding: EdgeInsets.all(20),
            ),
            //bottom bar with add to cart bottom
            BottomBarProductPage(),
        ],
      ),
    );
  }
}
