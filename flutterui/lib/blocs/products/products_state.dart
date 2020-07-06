part of 'products_bloc.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();
}

class ProductsUninitialized extends ProductsState {
  @override
  List<Object> get props => [];
}

class ProductsLoaded extends ProductsState {
  final bool hasReachedMax;
  final List<Product> products;

  const ProductsLoaded({this.hasReachedMax, this.products});

  ProductsLoaded copyWith({
    bool hasReachedMax,
    List<Product> products,
  }) {
    return ProductsLoaded(
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      products: products ?? this.products,
    );
  }

  @override
  List<Object> get props => [hasReachedMax, products];

  @override
  String toString() => 'ProductsLoaded { products: ${products.length}, hasReachedMax: $hasReachedMax }' ;
}

class ProductsError extends ProductsState {
  @override
  List<Object> get props => [];
}
