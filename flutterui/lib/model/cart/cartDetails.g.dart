// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cartDetails.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartDetails _$CartDetailsFromJson(Map<String, dynamic> json) {
  return CartDetails(
    products: (json['products'] as List)
        ?.map((e) =>
            e == null ? null : ItemOnCart.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    totalPrice: (json['total_price'] as num)?.toDouble(),
    id: json['_id'] as String,
    userId: json['user_id'] as String,
  );
}

Map<String, dynamic> _$CartDetailsToJson(CartDetails instance) =>
    <String, dynamic>{
      'total_price': instance.totalPrice,
      '_id': instance.id,
      'user_id': instance.userId,
      'products': instance.products?.map((e) => e?.toJson())?.toList(),
    };

ItemOnCart _$ItemOnCartFromJson(Map<String, dynamic> json) {
  return ItemOnCart(
    productName: json['product_name'] as String,
    productImageUrl: json['product_image_url'] as String,
    id: json['_id'] as String,
    productId: json['product_id'] as String,
    nestedId: json['nested_id'] as String,
    brand: json['brand'] as String,
    size: json['size'] as int,
    price: (json['price'] as num).toDouble(),
    quantity: json['quantity'] as int,
    modifiedOn: DateTime.parse(json['modified_on'] as String),
    isPurchased: json['isPurchased'] as bool,
  );
}

Map<String, dynamic> _$ItemOnCartToJson(ItemOnCart instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'product_id': instance.productId,
      'nested_id': instance.nestedId,
      'brand': instance.brand,
      'product_name': instance.productName,
      'product_image_url': instance.productImageUrl,
      'size': instance.size,
      'price': instance.price,
      'quantity': instance.quantity,
      'modified_on': instance.modifiedOn.toIso8601String(),
      "isPurchased": instance.isPurchased,
    };
