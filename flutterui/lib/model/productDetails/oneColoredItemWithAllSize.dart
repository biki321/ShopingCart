import 'package:json_annotation/json_annotation.dart';

part 'oneColoredItemWithAllSize.g.dart';

@JsonSerializable(explicitToJson: true)
class OneColoredItemWithAllSize {
  @JsonKey(nullable: false, name: "_id")
  final String id;

  @JsonKey(nullable: false, name: "product_price")
  final double productPrice;

  @JsonKey(nullable: false, name: "size_and_quantity")
  final SizeAndQuantity sizeAndQuantity;

  @JsonKey(nullable: false, name: "nested_id")
  final String nestedId;

  @JsonKey(nullable: false, name: "names_of_colors")
  final String namesOfColors;

  @JsonKey(nullable: false, name: "url_for_image")
  final String urlForImage;

  const OneColoredItemWithAllSize(
      {this.urlForImage,
      this.id,
      this.productPrice,
      this.sizeAndQuantity,
      this.nestedId,
      this.namesOfColors});

  factory OneColoredItemWithAllSize.fromJson(Map<String, dynamic> json) =>
      _$OneColoredItemWithAllSizeFromJson(json);
  Map<String, dynamic> toJson() => _$OneColoredItemWithAllSizeToJson(this);
}

@JsonSerializable()
class SizeAndQuantity {
  @JsonKey(nullable: true, name: "5")
  final double size5;

  @JsonKey(nullable: true, name: "6")
  final double size6;

  @JsonKey(nullable: true, name: "7")
  final double size7;

  @JsonKey(nullable: true, name: "8")
  final double size8;

  @JsonKey(nullable: true, name: "9")
  final double size9;

  @JsonKey(nullable: true, name: "10")
  final double size10;

  @JsonKey(nullable: true, name: "11")
  final double size11;

  @JsonKey(nullable: true, name: "12")
  final double size12;

  @JsonKey(nullable: true, name: "13")
  final double size13;

  //sizes those are not available
  List<int> listOfSizesNotAvailable() {
    List<int> list = [];
    if (size5 <= 0) list.add(5);
    if (size6 <= 0) list.add(6);
    if (size7 <= 0) list.add(7);
    if (size8 <= 0) list.add(8);
    if (size9 <= 0) list.add(9);
    if (size10 <= 0) list.add(10);
    if (size11 <= 0) list.add(11);
    if (size12 <= 0) list.add(12);
    if (size13 <= 0) list.add(13);
    print("list size:   $list");
    return list;
  }

  const SizeAndQuantity(
      {this.size5,
      this.size6,
      this.size7,
      this.size8,
      this.size9,
      this.size10,
      this.size11,
      this.size12,
      this.size13});

  factory SizeAndQuantity.fromJson(Map<String, dynamic> json) =>
      _$SizeAndQuantityFromJson(json);
  Map<String, dynamic> toJson() => _$SizeAndQuantityToJson(this);
}
