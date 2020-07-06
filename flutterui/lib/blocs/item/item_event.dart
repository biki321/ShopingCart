part of 'item_bloc.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();
}

class FetchItemDetails extends ItemEvent {
  //id of the product
  final String id;
  final String nestedId;
  final bool isBeginningOfFetchItemDetailsEvent;

  const FetchItemDetails({this.isBeginningOfFetchItemDetailsEvent, this.nestedId, this.id});

  @override
  List<Object> get props => throw UnimplementedError();
}

class FetchOneColoredItemWithOneSize extends ItemEvent {
  final String id;
  final String nestedid;
  final double size;

  const FetchOneColoredItemWithOneSize({this.id, this.nestedid, this.size});

  @override
  List<Object> get props => throw UnimplementedError();
}

class FetchOneColoredItemWithAllSize extends ItemEvent {
  final String id;
  final String nestedid;

  const FetchOneColoredItemWithAllSize({this.id, this.nestedid});

  @override
  List<Object> get props => throw UnimplementedError();
}
