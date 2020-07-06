import 'package:flutter/material.dart';
import 'package:flutterui/model/products/productsModel.dart';
import 'package:flutterui/screens/product_details_page.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetails(
                      id: product.id,
                      color: Color.fromARGB(150, 159, 221, 251),
                      path: product.differentColoredProduct[0].urlForImage,
                      productBrand: product.productBrand,
                      productName: product.productName,
                      nestedId: product.differentColoredProduct[0].id,
                      inStock: true,
                    )));
      },
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        //color: Color.fromARGB(255, 207, 240, 255),
        color: Color.fromARGB(255, 178, 250, 238),
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
                      'instock',
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
                    product.differentColoredProduct[0].urlForImage,
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
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        '${product.productName ?? null}',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 27,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    RichText(
                      maxLines: 1,
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: '\$',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        TextSpan(
                          text: '${product.productPrice}',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 24,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ]),
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
