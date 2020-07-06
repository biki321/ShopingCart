part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

//this event is to get the entire cart details
class FetchCartDetails extends CartEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

//this event is to add the item in the cart directly by pressing addToCart button
class AddToCart extends CartEvent {
  final String productId;
  final String nestedId;
  final int size;
  final int quantity;

  const AddToCart(
      {@required this.productId,
      @required this.nestedId,
      @required this.size,
      @required this.quantity});

  @override
  List<Object> get props => [productId, nestedId, size, quantity];
}

//this event is for increasing or decreasing no of item in the cart
class AddOrRemoveItemInCart extends CartEvent {
  final String productId;
  final String nestedId;
  final int size;
  final int quantity;
  final String idOfCartItem;
  //final int noOfItemsInCart;

  const AddOrRemoveItemInCart({
    @required this.productId,
    @required this.nestedId,
    @required this.size,
    @required this.quantity,
    @required this.idOfCartItem,
    //@required this.noOfItemsInCart
  });
  @override
  List<Object> get props => [productId, nestedId, size, quantity, idOfCartItem];
}

class DeleteItemInCart extends CartEvent {
  final String idOfCartItem;
  //final int noOfItemsInCart;

  const DeleteItemInCart({this.idOfCartItem});
  @override
  List<Object> get props => [idOfCartItem];
}

class UpdateTheOnlyItemInCart extends CartEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class PaymentResult extends CartEvent {
  //this is the response object returned by pay()
  // it contains success msg or a error for payment verification
  final res;
  //if a payment directly failed just after razorpay checkout
  //then this error will contain that error msg( PaymentFailureResponse from razorpay )
  final String error;
  const PaymentResult({this.error, this.res});

  @override
  List<Object> get props => throw UnimplementedError();
}
