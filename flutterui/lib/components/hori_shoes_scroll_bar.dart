import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterui/blocs/item/item_bloc.dart';
import 'package:flutterui/components/circularLoader.dart';

class ShoesScrollBar extends StatefulWidget {
  @override
  _ShoesScrollBarState createState() => _ShoesScrollBarState();
}

class _ShoesScrollBarState extends State<ShoesScrollBar> {
  ItemBloc _itemBloc;
  Widget card(
      String path, double opacity, String id, String nestedId, bool isActive) {
    return InkWell(
      onTap: () {
        //this will store the currently selected nestedid of colored shoe in ItemBloc
        _itemBloc.activeShoeNestedId = nestedId;

        //this event is triggered again to refresh the entire scroller
        _itemBloc.add(FetchItemDetails(
            id: id,
            nestedId: nestedId,
            isBeginningOfFetchItemDetailsEvent: false));
        //this will trigger a event which will help to give available sizes for this(nestedId) colored shoe
        _itemBloc
            .add(FetchOneColoredItemWithAllSize(id: id, nestedid: nestedId));
      },
      focusColor: Colors.grey,
      child: Opacity(
        opacity: opacity,
        child: Card(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: isActive ? Colors.grey : null,
            //   border: Border.all(
            //       color: isActive ? Colors.blueAccent : Colors.white,
            //       width: isActive ? 3.0 : 0.0),
             ),
            child: Image.asset(
              path,
              fit: BoxFit.contain,             
              width: 70,
            ),
          ),
        ),
      ),
    );
  }

  Widget get sizedBox => SizedBox(
        width: 10,
      );

  //here indexsOfShoes contains the shoes which are available
  List<Widget> listOfCard(
      indexsOfShoes, activeNestedId, bool isBeginningOfFetchItemDetailsEvent) {
    List<Widget> list = [];
    bool active = false;
    int i = 0;
    for (i = 0;
        i < _itemBloc.productDetails.differentColoredProduct.length;
        i++) {
      if (indexsOfShoes.contains(i)) {
        if (_itemBloc.activeShoeNestedId == '' && i == 0) {
          active = true;
        }
        if (activeNestedId != '' &&
            _itemBloc.productDetails.differentColoredProduct[i].nestedid ==
                activeNestedId) active = true;

        list.add(card(
            _itemBloc.productDetails.differentColoredProduct[i].urlForImage,
            1.0,
            _itemBloc.productDetails.id,
            _itemBloc.productDetails.differentColoredProduct[i].nestedid,
            active));
      } else {
        if (activeNestedId == '' && i == 0) active = true;
        if (activeNestedId != '' &&
            _itemBloc.productDetails.differentColoredProduct[i].nestedid ==
                activeNestedId) active = true;

        list.add(card(
            _itemBloc.productDetails.differentColoredProduct[i].urlForImage,
            0.3,
            _itemBloc.productDetails.id,
            _itemBloc.productDetails.differentColoredProduct[i].nestedid,
            active));
      }

      if (isBeginningOfFetchItemDetailsEvent && i == 0) {
        _itemBloc.activeShoeNestedId =
            _itemBloc.productDetails.differentColoredProduct[i].nestedid;
        _itemBloc.add(FetchOneColoredItemWithAllSize(
            id: _itemBloc.productDetails.id,
            nestedid:
                _itemBloc.productDetails.differentColoredProduct[i].nestedid));
      }
      active = false;
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    _itemBloc = BlocProvider.of<ItemBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocBuilder<ItemBloc, ItemState>(
        condition: (previousState, state) {
          if ((state is Visible && state.indexsOfShoes != null) ||
              (state is ItemRelatedLoading && state.isLoadingShoesScrollBar))
            return true;
          return false;
        },
        builder: (BuildContext context, ItemState state) {
          if (state is Visible) {
            return Container(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: listOfCard(state.indexsOfShoes, state.nestedid,
                    state.isBeginningOfFetchItemDetailsEvent),
              ),
            );
          }
          return CircularLoader();
        },
      ),
    );
  }
}
