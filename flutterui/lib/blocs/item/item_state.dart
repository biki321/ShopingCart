part of 'item_bloc.dart';

abstract class ItemState extends Equatable {
  const ItemState();
}

class ItemInitial extends ItemState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class ItemError extends ItemState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class ItemDetailsLoaded extends ItemState {
  final ProductDetails productDetails;
  const ItemDetailsLoaded({this.productDetails});

  ItemDetailsLoaded copyWith({ProductDetails productDetails}) {
    return ItemDetailsLoaded(
        productDetails: productDetails ?? this.productDetails);
  }

  @override
  List<Object> get props => [productDetails];

  @override
  String toString() => 'ItemDetailsLoaded { products: $productDetails}';
}

class OneColoredItem extends ItemState {
  final OneColoredItemWithOneSize oneColoredItemWithOneSize;
  final OneColoredItemWithAllSize oneColoredItemWithAllSize;
  const OneColoredItem(
      {this.oneColoredItemWithAllSize, this.oneColoredItemWithOneSize});

  OneColoredItem copyWith(
      {OneColoredItemWithOneSize oneColoredItemWithOneSize,
      OneColoredItemWithAllSize oneColoredItemWithAllSize}) {
    return OneColoredItem(
        oneColoredItemWithOneSize:
            oneColoredItemWithOneSize ?? this.oneColoredItemWithOneSize,
        oneColoredItemWithAllSize:
            oneColoredItemWithAllSize ?? this.oneColoredItemWithAllSize);
  }

  @override
  List<Object> get props =>
      [oneColoredItemWithOneSize, oneColoredItemWithAllSize];

  @override
  String toString() =>
      """OneColoredItem { oneColoredItemWithOneSize: $oneColoredItemWithOneSize, 
        oneColoredItemWithAllSize: $oneColoredItemWithAllSize}""";
}

//this state is for the different colored shoes to show and which to not show  depending on availability
class Visible extends ItemState {
  final List<int> indexsOfShoes;
  final String nestedid;
  final bool isBeginningOfFetchItemDetailsEvent;

  const Visible(
      {this.isBeginningOfFetchItemDetailsEvent,
      this.nestedid,
      @required this.indexsOfShoes});

  Visible copyWith({List<int> indexsOfShoes, List<int> sizes}) {
    return Visible(
      indexsOfShoes: indexsOfShoes ?? this.indexsOfShoes,
      nestedid: nestedid ?? this.nestedid,
      isBeginningOfFetchItemDetailsEvent: isBeginningOfFetchItemDetailsEvent ??
          this.isBeginningOfFetchItemDetailsEvent,
    );
  }

  @override
  List<Object> get props =>
      [indexsOfShoes, nestedid, isBeginningOfFetchItemDetailsEvent];
}

class Focus extends ItemState {
  final int indexOfShoe;
  final int size;

  const Focus({this.indexOfShoe, this.size});

  @override
  List<Object> get props => [indexOfShoe, size];
}

class ItemRelatedLoading extends ItemState {
  final bool isLoadingShoesScrollBar;
  final bool isLoadingSizesScrollBar;

  const ItemRelatedLoading({
    this.isLoadingShoesScrollBar,
    this.isLoadingSizesScrollBar,
  });
  @override
  List<Object> get props => [
        isLoadingShoesScrollBar,
        isLoadingSizesScrollBar,
      ];
}
