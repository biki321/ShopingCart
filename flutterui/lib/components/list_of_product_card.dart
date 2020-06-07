import 'package:flutter/material.dart';
import 'package:flutterui/screens/product_details_page.dart';

class ProductCard extends StatelessWidget {
  final Color color;
  final String name;
  final String price;
  final String path;
  final bool instock;
  final String brand_name;

  const ProductCard(
      {Key key,
      @required this.color,
      @required this.name,
      @required this.price,
      @required this.path, 
      @required this.instock, 
      @required this.brand_name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetails(
                      color: color,
                      name: name,
                      path: path,
                      price: price,
                      instock: instock,
                      brand_name:brand_name,
                    )));
      },
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: color,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.60,
          height: MediaQuery.of(context).size.height * 0.50,
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      "${instock?'instock':'out of stock'}",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite),
                    onPressed: () {},
                  ),
                ],
              ),
              Flexible(
                child: Center(
                  child: Image.asset(
                    path,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                //alignment: Alignment(-1, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 27,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "\$$price",
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
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> list_of_product_card = [
  ProductCard(
      color: Color.fromARGB(150, 159, 221, 251),
      name: 'Addidas Drago M',
      brand_name:'Addidas',
      price: '160',
      instock: true,
      path:
          'assets/shoes/addidas/Drogo_M_Walking_Shoes_For_Men/shoes_black1.png'),
  ProductCard(
      color: Color.fromARGB(150, 113, 233, 212),
      name: 'Fluo_M',
      brand_name: 'Addidas',
      price: '160',
      instock: true,
      path:
          'assets/shoes/addidas/Fluo_M_Running_Shoe_For_Men/shoes_black2.png'),
];
