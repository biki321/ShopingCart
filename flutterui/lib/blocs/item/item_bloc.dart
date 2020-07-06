import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutterui/model/productDetails/oneColoredItemWithAllSize.dart';
import 'package:flutterui/model/productDetails/oneColoredItemWithOneSize.dart';
import 'package:flutterui/model/productDetails/productDetails.dart';
import 'package:flutterui/services/getDetailsOfProduct.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ProductDetails productDetails;

  //this will store which shoe size is choosen(or clicked on);
  double activeShoeSize = 5.0;
  //this will store which colored shoe is selected(or clicked on )
  String activeShoeNestedId = '';
  //seleted quantity to buy or add to cart which default to 1
  int seletedQuantity = 1;

  @override
  ItemState get initialState => ItemInitial();

  //   @override
  // Stream<Transition<ItemEvent, ItemState>> transformEvents(
  //   Stream<ItemEvent> events,
  //   TransitionFunction<ItemEvent, ItemState> transitionFn,
  // ) {
  //   return super.transformEvents(
  //     events.debounceTime(const Duration(milliseconds: 500)),
  //     transitionFn,
  //   );
  // }

  //this will return the indexes of the different colored items if they are in stock
  List<int> returnAvailableItems() {
    List<int> indexes = [];
    for (int i = 0; i < productDetails.differentColoredProduct.length; i++) {
      //check if the different colored item is in stock
      if (!productDetails
          .differentColoredProduct[i].sizeAndQuantity.isNotAvail) {
        indexes.add(i);
      }
    }
    return indexes;
  }

  @override
  Stream<ItemState> mapEventToState(
    ItemEvent event,
  ) async* {
    if (event is FetchItemDetails) {     
      productDetails = await fetchProductDetails(event.id);       

      yield ItemDetailsLoaded(productDetails: productDetails);

      var indexes = returnAvailableItems();     
      yield Visible(
          indexsOfShoes: indexes,
          nestedid: event.nestedId,
          isBeginningOfFetchItemDetailsEvent:
              event.isBeginningOfFetchItemDetailsEvent);
    }
    if (event is FetchOneColoredItemWithAllSize) {     
      final oneColoredItemWithAllSize =
          await fetchOneColoredItemWithAllSize(event.id, event.nestedid);
      yield OneColoredItem(
          oneColoredItemWithAllSize: oneColoredItemWithAllSize,
          oneColoredItemWithOneSize: null);
    }
    if (event is FetchOneColoredItemWithOneSize) {
      final oneColoredItemWithOneSize = await fetchOneColoredItemWithOneSize(
          event.id, event.nestedid, event.size);
      yield OneColoredItem(
          oneColoredItemWithAllSize: null,
          oneColoredItemWithOneSize: oneColoredItemWithOneSize);
    }
  }
}
