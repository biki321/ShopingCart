part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();
}

class CartInitial extends CartState {
  @override
  List<Object> get props => [];
}

class CartDetailsState extends CartState {
  final CartDetails cartDetails;

  const CartDetailsState({this.cartDetails});

  @override
  List<Object> get props => [cartDetails];
}

class CartSuccessOrFailMsg extends CartState {
  //for routes
  final bool addOrRemoveRoute;
  final bool addToCartRoute;
  final bool deleteItemInCartRoute;

  //this two route shows what is err or msg about
  final bool isLoggedOut;
  final bool isNotAuthenticated;

  //

  final String msg;
  final String err;

  const CartSuccessOrFailMsg(
      {this.isLoggedOut,
      this.isNotAuthenticated,
      this.deleteItemInCartRoute,
      this.addOrRemoveRoute,
      this.addToCartRoute,
      this.msg,
      this.err});
  @override
  List<Object> get props => [
        msg,
        err,
        addOrRemoveRoute,
        addToCartRoute,
        deleteItemInCartRoute,
        isLoggedOut,
        isNotAuthenticated
      ];
}

class CartUnknownError extends CartState {
  final String error;

  const CartUnknownError({this.error});
  @override
  List<Object> get props => throw UnimplementedError();
}

class CartRelatedLoading extends CartState{
  final bool isUpdatingCart;

  const CartRelatedLoading({this.isUpdatingCart});
  @override  
  List<Object> get props => throw UnimplementedError();
  
}