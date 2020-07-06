import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutterui/model/cart/cartDetails.dart';
import 'package:flutterui/services/cartServices.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  bool isCartRefreshedBeforePayment = false;
  CartDetails cartDetails;
  @override
  CartState get initialState => CartInitial();

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is FetchCartDetails) {
      yield* mapFetchCartDetails(event);
    } else if (event is AddToCart) {
      yield* mapAddToCart(event);
    } else if (event is AddOrRemoveItemInCart) {
      yield* mapAddOrRemoveItemInCart(event);
    } else if (event is DeleteItemInCart) {
      yield* mapDeleteItemInCart(event);
    } else if (event is PaymentResult) {
      yield* mapPaymentResult(event);
    }
  }

  Stream<CartState> mapFetchCartDetails(FetchCartDetails event) async* {
    try {
      var response = await fetchCartDetails();
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        cartDetails = CartDetails.fromJson(res);
        yield CartDetailsState(cartDetails: cartDetails);
        return;
      } else {
        yield* checkAuth(response);
      }
    } catch (error) {
      yield CartUnknownError();
      return;
    }
  }

  Stream<CartState> mapAddToCart(AddToCart event) async* {
    try {
      yield CartRelatedLoading(isUpdatingCart: true);

      var response = await addToCart(
          event.productId, event.nestedId, event.size, event.quantity);
      if (response.statusCode == 200) {
        yield* emitCartSuccessOrFailMsg(
          addToCartRoute: true,
          msg: jsonDecode(response.body)["msg"],
        );
        return;
      } else if (response.statusCode == 404) {
        print(
            "response: == ${jsonDecode(response.body)["err"]},  ${jsonDecode(response.body)["msg"]}");
        yield CartRelatedLoading();
        yield* emitCartSuccessOrFailMsg(
            addToCartRoute: true, err: jsonDecode(response.body)["err"]);
        return;
      } else {
        yield* checkAuth(response);
      }
    } catch (error) {
      print("error at Add to Cart");
      yield CartUnknownError();
      return;
    }
  }

  Stream<CartState> mapAddOrRemoveItemInCart(
      AddOrRemoveItemInCart event) async* {
    try {
      yield CartRelatedLoading(isUpdatingCart: true);

      var response = await addOrRemoveItemInCart(
        event.productId,
        event.nestedId,
        event.size,
        event.quantity,
        event.idOfCartItem,
      );

      if (response.statusCode == 200) {
        yield* emitCartSuccessOrFailMsg(
          addOrRemoveRoute: true,
          msg: jsonDecode(response.body)["msg"],
        );
        return;
        // //if there is only one item in cart then after inc or dec of no of item
        // //in cart no need to fetch the entire cart again and update the ui
        // //just updated the required info of that item and update the UI.
        // //here data may contain the updated price of item and updated quantity in cart,
        // //if only one item is in cart but if there are many than data will be empty.
        // var data = jsonDecode(response.body)["data"];
        // if (data != {}) {
        //   var cart = cartDetails.copyWith(
        //     totalPrice: data["quantity"] * data["productPrice"],
        //     products: <ItemOnCart>[
        //       cartDetails.products[0].copyWith(
        //         quantity: data["quantity"],
        //         price: data["productPrice"],
        //         modifiedOn: DateTime.now(),
        //       )
        //     ],
        //   );
        //   cartDetails = cart;
        //   yield CartDetailsState(cartDetails: cartDetails);
        //   return;
        // } else {
        //   //if there are more than one item in cart then update the
        //   //CartDetailsState by fetching entire cartDetails again
        //   yield* mapFetchCartDetails(FetchCartDetails());
        // }
        // return;
      } else if (response.statusCode == 404) {
        yield* emitCartSuccessOrFailMsg(
          addOrRemoveRoute: true,
          err: jsonDecode(response.body)["err"],
        );
        return;
      } else {
        yield* checkAuth(response);
      }
    } catch (error) {
      print("error at AddOrRemoveItem,");
      yield CartUnknownError();
      return;
    }
  }

  Stream<CartState> mapDeleteItemInCart(DeleteItemInCart event) async* {
    try {
      yield CartRelatedLoading(isUpdatingCart: true);

      var response = await deleteItemInCart(event.idOfCartItem);
      if (response.statusCode == 200) {
        yield* emitCartSuccessOrFailMsg(
          deleteItemInCartRoute: true,
          msg: jsonDecode(response.body)["msg"],
        );
        return;
        // //if there is only one item in cart then after deleting that just update
        // //the CartDetailsState in the app without fetching cartDetails again
        // if (event.noOfItemsInCart == 1) {
        //   yield CartDetailsState(
        //       cartDetails: cartDetails.copyWith(
        //     totalPrice: 0.0,
        //     products: <ItemOnCart>[],
        //   ));
        //   return;
        // } else {
        //   //if many items are there then fetch the cartDetails again and update CartdetailsState
        //   yield* mapFetchCartDetails(FetchCartDetails());
        // }
      } else if (response.statusCode == 404) {
        yield* emitCartSuccessOrFailMsg(
          deleteItemInCartRoute: true,
          err: jsonDecode(response.body)["err"],
        );
        return;
      } else {
        yield* checkAuth(response);
      }
    } catch (error) {
      print("error at DeleteAtCart");
      yield CartUnknownError();
      return;
    }
  }

  Stream<CartState> mapPaymentResult(PaymentResult event) async* {
    if (event.res != null) {
      var statusCode = event.res.statusCode;
      var body = jsonDecode(event.res.body);
      if (statusCode == 200) {    
        yield* emitCartSuccessOrFailMsg(msg: body["msg"]);
        cartDetails = CartDetails.fromJson(body["cartData"]);
        //this is the updated cart with items marked as Purchased
        yield CartDetailsState(cartDetails: cartDetails);
        return;
      } else {        
        yield* emitCartSuccessOrFailMsg(err: body["err"]);
        return;
      }
    } else {     
      yield* emitCartSuccessOrFailMsg(err: event.error);
      return;
    }
  }

  //it will check whether the request made to server is authenticated or
  //not and emit state accordingly
  Stream<CartState> checkAuth(response) async* {
    try {
      if (response.statusCode == 401) {
        print("you are logged out");
        yield* emitCartSuccessOrFailMsg(
            isLoggedOut: true, err: jsonDecode(response.body)["err"]);
        return;
      } else if (response.statusCode == 403) {
        print("Not Authorized");
        yield* emitCartSuccessOrFailMsg(
            isNotAuthenticated: true, err: jsonDecode(response.body)["err"]);
        return;
      }
    } catch (error) {
      print("error at checkAuth");
      yield CartUnknownError();
      return;
    }
  }

  Stream<CartState> emitCartSuccessOrFailMsg({
    bool addOrRemoveRoute = false,
    bool addToCartRoute = false,
    bool deleteItemInCartRoute = false,
    bool isLoggedOut = false,
    bool isNotAuthenticated = false,
    String msg = '',
    String err = '',
  }) async* {
    yield CartSuccessOrFailMsg(
      addOrRemoveRoute: addOrRemoveRoute,
      addToCartRoute: addToCartRoute,
      deleteItemInCartRoute: deleteItemInCartRoute,
      isLoggedOut: isLoggedOut,
      isNotAuthenticated: isNotAuthenticated,
      msg: msg,
      err: err,
    );
  }
}
