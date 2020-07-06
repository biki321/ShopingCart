import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterui/blocs/item/item_bloc.dart';
import 'package:flutterui/components/circularLoader.dart';

class SliverAppBarForProductDetailsPage extends StatefulWidget {
  final Color color;
  final String productName;
  final String path;
  final bool inStock;
  final String productBrand;

  const SliverAppBarForProductDetailsPage(
      {Key key,
      @required this.color,
      this.productName,
      @required this.path,
      @required this.productBrand,
      this.inStock})
      : super(key: key);
  @override
  _SliverAppBarForProductDetailsPageState createState() =>
      _SliverAppBarForProductDetailsPageState();
}

class _SliverAppBarForProductDetailsPageState
    extends State<SliverAppBarForProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      iconTheme: new IconThemeData(color: Colors.black), //DRAWER ICON COLOR
      floating: false,
      // leading: IconButton(
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
      //   icon: Icon(
      //     Icons.arrow_back,
      //     color: Colors.black,
      //   ),
      // ),
      backgroundColor: widget.color,
      elevation: 0.0,
      expandedHeight: MediaQuery.of(context).size.height * 0.58,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            BlocBuilder<ItemBloc, ItemState>(
              condition: (previousState, state) {
                if (state is OneColoredItem &&
                    state.oneColoredItemWithAllSize != null)
                  return true;
                else
                  return false;
              },
              builder: (BuildContext context, ItemState state) {
                if (state is OneColoredItem &&
                    state.oneColoredItemWithAllSize != null) {
                  return Image.asset(
                    state.oneColoredItemWithAllSize.urlForImage,
                    fit: BoxFit.contain,
                  );
                } else
                  return CircularLoader();
              },
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
                      "${widget.inStock ? 'instock' : 'out of stock'}",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${widget.productBrand}",
                      style: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.productName}',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 27,
                        fontWeight: FontWeight.w400,
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
