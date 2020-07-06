import 'package:json_annotation/json_annotation.dart';

part 'productDetails.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductDetails {
  @JsonKey(nullable: false, name: "_id")
  final String id;

  @JsonKey(nullable: true, name: "product_name")
  final String productName;

  @JsonKey(nullable: false, name: "product_brand")
  final String productBrand;

  @JsonKey(nullable: false, name: "product_price")
  final double productPrice;

  @JsonKey(nullable: true, name: "product_des")
  final String productDes;

  @JsonKey(nullable: false, name: "different_colored_product")
  final List<ParticularColoredProduct> differentColoredProduct;

  ProductDetails(
      {this.id,
      this.productName,
      this.productBrand,
      this.productPrice,
      this.productDes,
      this.differentColoredProduct});

  factory ProductDetails.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDetailsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ParticularColoredProduct {
  @JsonKey(nullable: false, name: "size_and_quantity")
  final SizeAndQuantity sizeAndQuantity;

  @JsonKey(nullable: false, name: "_id")
  final String nestedid;

  @JsonKey(nullable: true, name: "names_of_colors")
  final String namesOfColors;

  @JsonKey(nullable: false, name: "url_for_image")
  final String urlForImage;

  ParticularColoredProduct(
      {this.sizeAndQuantity, this.nestedid, this.namesOfColors, this.urlForImage});

  factory ParticularColoredProduct.fromJson(Map<String, dynamic> json) =>
      _$ParticularColoredProductFromJson(json);
  Map<String, dynamic> toJson() => _$ParticularColoredProductToJson(this);
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

  //check whether the a colored shoes is avail or not
  // (if at least one size is avail then shoe is avail too)
  bool get isNotAvail => [
        size5,
        size6,
        size7,
        size8,
        size9,
        size10,
        size11,
        size12,
        size13
      ].every((element) => element <= 0.0);

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
