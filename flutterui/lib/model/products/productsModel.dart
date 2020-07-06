import 'package:json_annotation/json_annotation.dart';

part 'productsModel.g.dart';

@JsonSerializable(explicitToJson: true)
class Product {
  @JsonKey(nullable: false, name: "_id")
  final String id;

  @JsonKey(name: "product_name")
  final String productName;

  @JsonKey(nullable: false, name: "product_brand")
  final String productBrand;

  @JsonKey(nullable: false, name: "product_price")
  final double productPrice;

  @JsonKey(nullable: false, name: "different_colored_product")
  final List<Url> differentColoredProduct;

  Product(
      {this.id,
      this.productName,
      this.productBrand,
      this.productPrice,
      this.differentColoredProduct});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@JsonSerializable()
class Url {
  @JsonKey(nullable: false, name: "url_for_image")
  final String urlForImage;

  @JsonKey(nullable: false, name: "_id")
  final String id;

  Url({this.urlForImage, this.id});

  factory Url.fromJson(Map<String, dynamic> json) => _$UrlFromJson(json);

  Map<String, dynamic> toJson() => _$UrlToJson(this);
}
