import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cartDetails.g.dart';

@JsonSerializable(explicitToJson: true)
class CartDetails {
  @JsonKey(nullable: true, name: "total_price")
  final double totalPrice;

  @JsonKey(nullable: false, name: "_id")
  final String id;

  @JsonKey(nullable: false, name: "user_id")
  final String userId;

  @JsonKey(nullable: true)
  final List<ItemOnCart> products;

  int get noOfItemsInCart => products.length;

  const CartDetails(
      {@required this.products,
      @required this.totalPrice,
      @required this.id,
      @required this.userId});

  factory CartDetails.fromJson(Map<String, dynamic> json) =>
      _$CartDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$CartDetailsToJson(this);

  CartDetails copyWith({
    double totalPrice,
    String id,
    String userId,
    List<ItemOnCart> products,
  }) {
    return CartDetails(
        id: id ?? this.id,
        totalPrice: totalPrice ?? this.totalPrice,
        userId: userId ?? this.userId,
        products: products ?? this.products);
  }
}

@JsonSerializable()
class ItemOnCart {
  @JsonKey(nullable: false, name: "_id")
  final String id;

  @JsonKey(nullable: false, name: "product_id")
  final String productId;

  @JsonKey(nullable: false, name: "nested_id")
  final String nestedId;

  @JsonKey(nullable: false, name: "brand")
  final String brand;

  @JsonKey(nullable: true, name: "product_name")
  final String productName;

  @JsonKey(nullable: false, name: "product_image_url")
  final String productImageUrl;

  @JsonKey(nullable: false, name: "size")
  final int size;

  @JsonKey(nullable: false, name: "price")
  final double price;

  @JsonKey(nullable: false, name: "quantity")
  final int quantity;

  @JsonKey(nullable: false, name: "modified_on")
  final DateTime modifiedOn;
  @JsonKey(nullable: false, name: "isPurchased")
  final bool isPurchased;

  const ItemOnCart(
      {this.isPurchased,
      this.productName,
      @required this.productImageUrl,
      @required this.id,
      @required this.productId,
      @required this.nestedId,
      @required this.brand,
      @required this.size,
      @required this.price,
      @required this.quantity,
      @required this.modifiedOn});

  factory ItemOnCart.fromJson(Map<String, dynamic> json) =>
      _$ItemOnCartFromJson(json);

  Map<String, dynamic> toJson() => _$ItemOnCartToJson(this);

  ItemOnCart copyWith({
    String id,
    String productId,
    String nestedId,
    String brand,
    String productName,
    String productImageUrl,
    int size,
    int quantity,
    DateTime modifiedOn,
    double price,
    bool isPurchased,
  }) {
    return ItemOnCart(
        brand: brand ?? this.brand,
        productName: productName ?? this.productName,
        id: id ?? this.id,
        modifiedOn: modifiedOn ?? DateTime.now(),
        nestedId: nestedId ?? this.nestedId,
        price: price ?? this.price,
        productId: productId ?? this.productId,
        productImageUrl: productImageUrl ?? this.productImageUrl,
        quantity: quantity ?? this.quantity,
        size: size ?? this.size,
        isPurchased: isPurchased ?? this.isPurchased);
  }
}
