import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterui/blocs/item/item_bloc.dart';

class SizeScrollBar extends StatefulWidget {
  @override
  _SizeScrollBarState createState() => _SizeScrollBarState();
}

class _SizeScrollBarState extends State<SizeScrollBar> {
  ItemBloc _itemBloc;
  Widget card(
      double size, double opacity, bool isActive, String id, String nestedId) {
    return InkWell(
      onTap: () {
        _itemBloc.activeShoeSize = size;

        _itemBloc
            .add(FetchOneColoredItemWithAllSize(id: id, nestedid: nestedId));
      },
      focusColor: Colors.grey,
      child: Opacity(
        opacity: opacity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0.0,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                // border: Border.all(
                //   color: isActive ? Colors.blueAccent : Colors.white,
                // ),
                color: isActive
                    ? Colors.black
                    : Color.fromARGB(255, 239, 243, 253)),
            width: 50,
            child: Center(
              child: Text(
                "${size.toInt().toString()}",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: isActive ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get sizedBox => SizedBox(
        width: 8.0,
      );

  List<Widget> listOfCard(currentState) {
    var notAvailableSizes = currentState
        .oneColoredItemWithAllSize.sizeAndQuantity
        .listOfSizesNotAvailable();
    String id = currentState.oneColoredItemWithAllSize.id;
    String nestedId = currentState.oneColoredItemWithAllSize.nestedId;
    List<Widget> list = [];
    bool active = false;

    for (int i = 5; i < 14; i++) {
      //set active true if i is equal to size selected
      if (i.toDouble() == _itemBloc.activeShoeSize) active = true;
      //if size is not selected that is in the starting of the app, then set active to true
      if (i == 5 && _itemBloc.activeShoeSize == 0.0) {
        active = true;
      }

      if (notAvailableSizes.contains(i)) {
        list.add(card(i.toDouble(), 0.3, active, id, nestedId));
      } else {
        list.add(card(i.toDouble(), 1.0, active, id, nestedId));
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
      child: Container(
        height: 50,
        child: BlocBuilder<ItemBloc, ItemState>(
          condition: (previousState, state) {
            if (state is OneColoredItem) {
              if (state.oneColoredItemWithAllSize != null)
                return true;
              else
                return false;
            } else
              return false;
          },
          builder: (BuildContext context, ItemState state) {
            if (state is OneColoredItem &&
                state.oneColoredItemWithAllSize != null) {
              return ListView(
                padding: EdgeInsets.only(left: 10.0),
                scrollDirection: Axis.horizontal,
                children: listOfCard(state),
              );
            } else {
              //return CircularLoader();
              return Container(
                width: 0.0,
                height: 0.0,
              );
            }
          },
        ),
      ),
    );
  }
}
