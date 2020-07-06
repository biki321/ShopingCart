import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterui/blocs/products/products_bloc.dart';

Widget sizedBox() => SizedBox(width: 10);

List<Widget> brandsLogosList(String activeBrandName) {
  return [
    BrandLogoButton(
      url: 'assets/logo/adidas_logo.png',
      padding: 0.0,
      brandName: "Addidas",
      isActive: "Addidas" == activeBrandName ? true : false,
      //isActive: true,
    ),
    sizedBox(),
    BrandLogoButton(
      url: 'assets/logo/nike_logo.png',
      padding: 5.0,
      brandName: "Nike",
      isActive: "Nike" == activeBrandName ? true : false,
      //isActive: false,
    ),
    sizedBox(),
    BrandLogoButton(
      url: 'assets/logo/reebok_logo.png',
      padding: 10.0,
      brandName: "Reebok",
      isActive: "Reebok" == activeBrandName ? true : false,
      //isActive: false,
    ),
    // sizedBox(),
    // BrandLogoButton(
    //   url: 'assets/logo/fila_logo.png',
    //   padding: 0.0,
    //   brandName: "Fila",
    //   isActive: "Fila" == activeBrandName ? true : false,
    //   //isActive: false,
    // ),
    sizedBox(),
    BrandLogoButton(
      url: 'assets/logo/puma_logo.png',
      padding: 10.0,
      brandName: "Puma",
      isActive: "Puma" == activeBrandName ? true : false,
      //isActive: false,
    ),
    sizedBox(),
  ];
}

class BrandLogoButton extends StatefulWidget {
  final String brandName;
  final String url;
  final double padding;
  final bool isActive;

  const BrandLogoButton(
      {Key key, this.url, this.padding, this.brandName, this.isActive})
      : super(key: key);
  @override
  _BrandLogoButtonState createState() => _BrandLogoButtonState();
}

class _BrandLogoButtonState extends State<BrandLogoButton> {
  ProductsBloc _productsBloc;

  @override
  void initState() {
    super.initState();
    _productsBloc = BlocProvider.of<ProductsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => _productsBloc
          .add(Fetch(brandName: widget.brandName, isNewBrand: true)),
      child: Card(
        //this shape is set so that card take the shape of
        //child container()
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: widget.isActive ? 5.0 : 0.0,
        child: Container(
          decoration: BoxDecoration(
            color: widget.isActive ? Color.fromARGB(255, 245, 81, 21) : null,
            borderRadius: BorderRadius.circular(15.0),
          ),
          //color: Colors.red,
          width: 80,
          //height: 50,
          child: Padding(
            padding: EdgeInsets.all(widget.padding),
            child: Image.asset(
              widget.url,
              color: widget.isActive ? Colors.white : null,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
