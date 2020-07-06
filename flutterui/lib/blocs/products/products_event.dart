part of 'products_bloc.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();
}

//this event will trigger to fetch products for a particular sneaker brand(eq. Addidas)
class Fetch extends ProductsEvent {
  final String brandName;
  final bool isNewBrand;

  const Fetch({this.isNewBrand, @required this.brandName });
  @override
  List<Object> get props => [brandName, isNewBrand];
}
