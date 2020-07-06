import 'package:json_annotation/json_annotation.dart';

part 'oneColoredItemWithOneSize.g.dart';

@JsonSerializable(explicitToJson: true)
class OneColoredItemWithOneSize{

  @JsonKey(nullable: false, name: "_id")
  final String id;

  @JsonKey(nullable: false, name: "product_price")
  final double productPrice;

  @JsonKey(nullable: false, name: "size_and_quantity")
  final Map<String, int> sizeAndQuantity;

    @JsonKey(nullable: false, name: "nested_id")
  final String nestedId;

    @JsonKey(nullable: false, name: "names_of_colors")
  final String namesOfColors;

  const OneColoredItemWithOneSize({this.id, this.productPrice, this.sizeAndQuantity, this.nestedId, this.namesOfColors});

  factory OneColoredItemWithOneSize.fromJson(Map<String, dynamic> json) => _$OneColoredItemWithOneSizeFromJson(json);
  Map<String, dynamic> toJson() => _$OneColoredItemWithOneSizeToJson(this);
}


