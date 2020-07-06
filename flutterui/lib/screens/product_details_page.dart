import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterui/blocs/cart/cart_bloc.dart';
import 'package:flutterui/blocs/item/item_bloc.dart';
import 'package:flutterui/components/bottom_bar_product_details_page.dart';
import 'package:flutterui/components/circularLoader.dart';
import 'package:flutterui/components/hori_shoes_scroll_bar.dart';
import 'package:flutterui/components/hori_shoes_size_scroll.dart';
import 'package:flutterui/components/sliverappbar_for_product_details_page.dart';
import 'package:flutterui/components/cardCircularLoader.dart';
import 'package:flutterui/components/snackBar.dart';
import 'package:flutterui/screens/drawer.dart';

class ProductDetails extends StatefulWidget {
  //this id is productId
  final String id;
  final Color color;
  final String path;
  final String nestedId;
  final bool inStock;
  final String productName;
  final String productBrand;

  const ProductDetails({
    Key key,
    @required this.color,
    @required this.path,
    @required this.inStock,
    @required this.nestedId,
    @required this.id,
    this.productName,
    @required this.productBrand,
  }) : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  ItemBloc _itemBloc;
  //CartBloc _cartBloc;

  @override
  void initState() {
    super.initState();
    _itemBloc = BlocProvider.of<ItemBloc>(context);
    _itemBloc.add(FetchItemDetails(
        id: widget.id,
        nestedId: null,
        isBeginningOfFetchItemDetailsEvent: true));
//    _cartBloc = BlocProvider.of<CartBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<CartBloc, CartState>(
        condition: (previousState, state) {
          if (state is CartSuccessOrFailMsg && state.addToCartRoute)
            return true;
          return false;
        },
        listener: (context, state) {
          if (state is CartSuccessOrFailMsg) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar(state.msg, state.msg));
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBarForProductDetailsPage(
                  color: widget.color,
                  productName: widget.productName,
                  path: widget.path,
                  productBrand: widget.productBrand,
                  inStock: widget.inStock,
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                    child: BlocBuilder<ItemBloc, ItemState>(
                      condition: (previousState, state) {
                        if (state is ItemDetailsLoaded) {
                          return true;
                        } else
                          return false;
                      },
                      builder: (BuildContext context, ItemState state) {
                        if (state is ItemDetailsLoaded) {
                          return Row(
                            children: <Widget>[
                              Spacer(),
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
                                    text:
                                        '${state.productDetails.productPrice}',
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
                          );
                        } else
                          return CircularLoader();
                      },
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Color',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
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
                        fontSize: 16,
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

            //this will set a modal when addToCart is clicked
            //so that user user can not give any input till its done
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is CartRelatedLoading && state.isUpdatingCart) {
                  return ModalBarrier(
                    dismissible: false,
                  );
                } else
                  return Container(
                    width: 0.0,
                    height: 0.0,
                  );
              },
            ),
            BlocBuilder<CartBloc, CartState>(builder: (context, state) {
              if (state is CartRelatedLoading && state.isUpdatingCart) {
                return Align(
                  alignment: Alignment.center,
                  child: cardCircularLoader(),
                );
              } else
                return Container(
                  width: 0.0,
                  height: 0.0,
                );
            }),
          ],
        ),
      ),
      drawer: DrawerScreen(),
    );
  }
}
