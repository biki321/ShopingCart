import 'package:flutter/material.dart';
import 'package:flutterui/screens/payment_screen.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Widget appBar(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {}),
      elevation: 0.0,
      expandedHeight: 130,
      floating: true,
      backgroundColor: Color.fromARGB(200, 57, 183, 252),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.minimize,
                    color: Colors.white,
                  ),
                  SizedBox(height: 3.0),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemCount(int intially_num_of_item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.remove),
          iconSize: 20.0,
          onPressed: () {},
        ),
        Text(
          "$intially_num_of_item",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        IconButton(
          iconSize: 20.0,
          icon: Icon(Icons.add),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget item(String path, String shoe_name, String shoe_brand,
      String shoes_price, int num_of_item) {
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        //mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 70,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage(
                    path,
                  ),
                  fit: BoxFit.contain),
            ),
          ),
          SizedBox(
            width: 3.0,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "$shoe_brand",
                style: TextStyle(
                  //fontFamily: 'Montserrat',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 2.0,
              ),
              Text(
                "$shoe_name",
                style: TextStyle(
                  //fontFamily: 'Montserrat',
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          Spacer(
            flex: 1,
          ),

          //add more number f item or remove
          itemCount(num_of_item),
          SizedBox(
            width: 5,
          ),
          Text(
            "$shoes_price",
            style: TextStyle(
              //fontFamily: 'Montserrat',
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          //AppBar
          appBar(context),

          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(
                  left: 10.0, right: 15.0, bottom: 15.0, top: 0.0),
              child: Text(
                'Cart',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SliverFixedExtentList(
              delegate: SliverChildListDelegate.fixed([
                item(
                    'assets/shoes/addidas/Drogo_M_Walking_Shoes_For_Men/shoes_blue1.png',
                    'Drogo_M',
                    'Addidas',
                    '\$160',
                    1),
                item(
                    'assets/shoes/nike/REVOLUTION_5_Running_Shoes_For_Men/shoes_black&white3.png',
                    'REVOLUTION_5',
                    'Nike',
                    '\$190',
                    1),
                item(
                    'assets/shoes/nike/REVOLUTION_5_Running_Shoes_For_Men/shoes_black3.png',
                    'REVOLUTION_5',
                    'Nike',
                    '\$160',
                    1),
                item(
                    'assets/shoes/nike/Runallday_Running_Shoes_For_Men/shoes_blue4.png',
                    'Runallday',
                    'Nike',
                    '\$260',
                    1),
                item(
                    'assets/shoes/addidas/Drogo_M_Walking_Shoes_For_Men/shoes_blue1.png',
                    'Drogo_M',
                    'Addidas',
                    '\$140',
                    1),
                item(
                    'assets/shoes/addidas/Drogo_M_Walking_Shoes_For_Men/shoes_blue1.png',
                    'Drogo_M',
                    'Addidas',
                    '\$160',
                    1),
              ]),
              itemExtent: 80),

          SliverPadding(
            padding: EdgeInsets.all(10.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 30),
                  TotalPrice(
                    total_price: '560',
                  ),
                  SizedBox(height: 3),
                  Discount(
                    discount: '120',
                  ),
                  SizedBox(height: 25),
                  NextButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TotalPrice extends StatelessWidget {
  final String total_price;
  const TotalPrice({@required this.total_price});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          'Total:',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        Spacer(),
        Text(
          '\$$total_price',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 25,
            fontWeight: FontWeight.w200,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class Discount extends StatelessWidget {
  final String discount;
  const Discount({@required this.discount});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          'Discount:',
          style: TextStyle(
            //fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        Spacer(),
        Text(
          '\$$discount',
          style: TextStyle(
            //fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black38,
          ),
        ),
      ],
    );
  }
}

class NextButton extends StatelessWidget {
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => PaymentPage()));
        },
        child: Container(
          height: 45,
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(20), right: Radius.circular(20)),
            color: Colors.deepOrange,
          ),
          child: Center(
            child: Text(
              'Next',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 18,
              ),
            ),
          ),
        ));
  }
}
