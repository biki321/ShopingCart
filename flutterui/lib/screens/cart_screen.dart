import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterui/blocs/cart/cart_bloc.dart';
import 'package:flutterui/blocs/item/item_bloc.dart';
import 'package:flutterui/components/circularLoader.dart';
import 'package:flutterui/components/cardCircularLoader.dart';
import 'package:flutterui/components/snackBar.dart';
import 'package:flutterui/model/cart/cartDetails.dart';
import 'package:flutterui/screens/drawer.dart';
import 'package:flutterui/screens/login_page.dart';
import 'package:flutterui/screens/product_details_page.dart';
import 'package:flutterui/services/authentication.dart';
import 'package:flutterui/services/payment.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CartBloc _cartBloc;
  ItemBloc _itemBloc;
  Razorpay _razorpay = Razorpay();

  Widget appBar(BuildContext context) {
    return SliverAppBar(
      iconTheme: new IconThemeData(color: Colors.black), //DRAWER ICON COLOR
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

  Widget itemCount(ItemOnCart itemOnCart) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          iconSize: 20.0,
          icon: Icon(Icons.add),
          onPressed: () {
            _cartBloc.add(AddOrRemoveItemInCart(
                nestedId: itemOnCart.nestedId,
                idOfCartItem: itemOnCart.id,
                //noOfItemsInCart: _cartBloc.cartDetails.noOfItemsInCart,
                productId: itemOnCart.productId,
                quantity: 1,
                size: itemOnCart.size));
            _cartBloc.add(FetchCartDetails());
          },
        ),
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            border:
                Border.all(color: Color.fromARGB(255, 242, 97, 61), width: 2.0),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              "${itemOnCart.quantity}",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
        ),
        IconButton(
          icon: itemOnCart.quantity == 1 ? Container() : Icon(Icons.remove),
          iconSize: 20.0,
          onPressed: itemOnCart.quantity == 1
              ? null
              : () {
                  _cartBloc.add(AddOrRemoveItemInCart(
                      nestedId: itemOnCart.nestedId,
                      idOfCartItem: itemOnCart.id,
                      //noOfItemsInCart: _cartBloc.cartDetails.noOfItemsInCart,
                      productId: itemOnCart.productId,
                      quantity: -1,
                      size: itemOnCart.size));
                  _cartBloc.add(FetchCartDetails());
                },
        ),
      ],
    );
  }

  Widget deleteButton(String idOfCartItem, int noOfItemsInCart) {
    return FlatButton(
        onPressed: () {
          _cartBloc.add(DeleteItemInCart(idOfCartItem: idOfCartItem));
          //FetchCartDetails is again triggerd to update the cart details again
          _cartBloc.add(FetchCartDetails());
        },
        child: Container(
          height: 25,
          width: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(5), right: Radius.circular(5)),
            color: Colors.deepOrange,
          ),
          child: Center(
            child: Text(
              'delete',
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
        ));
  }

  Widget purchased() {
    return Container(
      height: 25,
      width: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(
            left: Radius.circular(5), right: Radius.circular(5)),
        color: Color.fromARGB(255, 243, 243, 243),
      ),
      child: Center(
        child: Text(
          'Purchased',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget infoAboutItem(ItemOnCart itemOnCart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text(
          "${itemOnCart.brand}",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 15,
            //fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        Text(
          "${itemOnCart.productName ?? ""}",
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: Color.fromARGB(255, 140, 140, 140),
          ),
        ),
        RichText(
          maxLines: 1,
          text: TextSpan(children: <TextSpan>[
            TextSpan(
              text: 'Size:',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                color: Colors.deepOrange[200],
                fontWeight: FontWeight.w300,
              ),
            ),
            TextSpan(
              text: '${itemOnCart.size}',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 15,
                color: Colors.deepOrange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ]),
        ),
        itemOnCart.isPurchased
            ? purchased()
            : Container(width: 0.0, height: 0.0),
      ],
    );
  }

  Widget item(ItemOnCart itemOnCart) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: 70,
                height: 100,
                decoration: BoxDecoration(
                  //color: Colors.grey,
                  color: Color.fromARGB(255, 253, 162, 1),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              Image.asset(
                itemOnCart.productImageUrl,
                width: 90,
                height: 70,
                fit: BoxFit.contain,
              ),
            ],
          ),
          Spacer(),
          Container(height: 100, child: infoAboutItem(itemOnCart)),
          Spacer(),
          itemCount(itemOnCart),
          //SizedBox(width: 20),
          Container(
            height: 90,
            child: Column(
              children: <Widget>[
                RichText(
                  maxLines: 1,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                      text: '\$',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextSpan(
                      text: '${itemOnCart.price}',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 17,
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ]),
                ),
                deleteButton(
                    itemOnCart.id, _cartBloc.cartDetails.noOfItemsInCart),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      print("paymentId: ${response.paymentId}");
      print("orderId: ${response.orderId}");
      print("signature: ${response.signature}");

      //this will send signature for verification
      var res = await pay(response);
      _cartBloc.add(PaymentResult(res: res, error: ""));
    } catch (err) {
      throw err;
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("code: ${response.code}");
    print("message: ${response.message}");
    _cartBloc.add(PaymentResult(res: null, error: response.message));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  void _purchase() async {
    try {
      //it first check if the cart has  been refreshed once
      //before payment
      if (!_cartBloc.isCartRefreshedBeforePayment) {
        _cartBloc.isCartRefreshedBeforePayment = true;
        _cartBloc.add(FetchCartDetails());
        return;
      }

      //this will sent a order req to server
      var res = await order();
      var options = {
        'key': 'rzp_test_VOK1C71v7bZLqc',
        'amount': res["amount"],
        'order_id': res["id"],
      };
      //this will open the checkout form
      _razorpay.open(options);
    } catch (err) {
      throw err;
    }
  }

  @override
  void initState() {
    super.initState();
    _cartBloc = BlocProvider.of<CartBloc>(context);
    _cartBloc.add(FetchCartDetails());
    _itemBloc = BlocProvider.of<ItemBloc>(context);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //this bloc listener will listen to error or success msg
      //and navigate when required
      body: BlocListener<CartBloc, CartState>(
        condition: (previousState, state) {
          if (state is CartSuccessOrFailMsg) return true;
          return false;
        },
        listener: (context, state) {
          if (state is CartSuccessOrFailMsg) {
            if (state.isLoggedOut || state.isNotAuthenticated) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar('', state.err));
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LogInPage()));
            } else {
              //if it is not about authentication related
              //then the msg or err will must be about other route related
              //so other boolean fields or not checked here

              //if msg is not null then show msg or it is null then definately there is error,
              //so show err
              Scaffold.of(context).showSnackBar(snackBar(state.msg, state.err));
            }
          }
        },
        child: Stack(
          children: <Widget>[
            CustomScrollView(
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

                BlocBuilder<CartBloc, CartState>(
                  condition: (previousState, state) {
                    if (state is CartDetailsState) return true;
                    return false;
                  },
                  builder: (BuildContext context, CartState state) {
                    if (state is CartDetailsState) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return item(state.cartDetails.products[index]);
                          },
                          childCount: state.cartDetails.products.length,
                        ),
                        //itemExtent: 130,
                      );
                    } else
                      return SliverToBoxAdapter(
                        child: CircularLoader(),
                      );
                  },
                ),

                SliverPadding(
                  padding: EdgeInsets.all(10.0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 30),
                        TotalPrice(
                            //totalPrice: '560',
                            ),
                        SizedBox(height: 3),
                        // Discount(
                        //   discount: '120',
                        // ),
                        // SizedBox(height: 25),
                        FlatButton(
                            onPressed: _purchase,
                            child: Container(
                              height: 45,
                              width: MediaQuery.of(context).size.width * 0.75,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(20),
                                    right: Radius.circular(20)),
                                color: Color.fromARGB(255, 253, 162, 1),
                              ),
                              child: Center(
                                child: Text(
                                  'Next',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w200,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
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
                    alignment: Alignment.center, child: cardCircularLoader());
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

  @override
  // ignore: must_call_super
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }
}

class TotalPrice extends StatelessWidget {
  final String totalPrice;
  const TotalPrice({this.totalPrice});
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
        BlocBuilder<CartBloc, CartState>(condition: (previousState, state) {
          if (state is CartDetailsState) return true;
          return false;
        }, builder: (BuildContext context, CartState state) {
          if (state is CartDetailsState) {
            return RichText(
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
                  text: '${state.cartDetails.totalPrice}',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ]),
            );
          } else
            return Container(width: 0.0, height: 0.0);
        }),
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
        onPressed: () async {
          var jwt = await readJwt();
        },
        child: Container(
          height: 45,
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(20), right: Radius.circular(20)),
              color: Color.fromARGB(255, 253, 162, 1)),
          child: Center(
            child: Text(
              'Next',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 18,
              ),
            ),
          ),
        ));
  }
}
