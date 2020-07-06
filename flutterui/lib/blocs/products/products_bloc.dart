import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutterui/constants/NetworkRelated.dart';
import 'package:flutterui/model/products/productsModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterui/services/getListOfProducts.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  String brandName;
  @override
  ProductsState get initialState => ProductsUninitialized();

  @override
  Stream<Transition<ProductsEvent, ProductsState>> transformEvents(
    Stream<ProductsEvent> events,
    TransitionFunction<ProductsEvent, ProductsState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<ProductsState> mapEventToState(ProductsEvent event) async* {
    var currentState = state;

    //this state is emited when a new brand is selected
    if (event is Fetch && event.isNewBrand) {
      yield ProductsUninitialized();
      currentState = state;
    }
    if (event is Fetch && !_hasReachedMax(currentState)) {
      brandName = event.brandName;
      try {
        if (currentState is ProductsUninitialized) {
          final products = await fetchproducts(
              event.brandName, 0, limitOfNoOfProductsPerApiCall);
          yield ProductsLoaded(
            products: products,
            hasReachedMax: false,
          );
          return ;
        }
        if (currentState is ProductsLoaded) {
          final products = await fetchproducts(event.brandName,
              currentState.products.length, limitOfNoOfProductsPerApiCall); 
          yield products.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : ProductsLoaded(
                  products: currentState.products + products,
                  hasReachedMax: false,
                );
        }
      } catch (_) {
        yield ProductsError();
      }
    }
  }

  bool _hasReachedMax(ProductsState state) =>
      state is ProductsLoaded && state.hasReachedMax;
}
