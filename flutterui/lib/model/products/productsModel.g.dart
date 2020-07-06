// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productsModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    id: json['_id'] as String,
    productName: json['product_name'] as String,
    productBrand: json['product_brand'] as String,
    productPrice: (json['product_price'] as num).toDouble(),
    differentColoredProduct: (json['different_colored_product'] as List)
        .map((e) => Url.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      '_id': instance.id,
      'product_name': instance.productName,
      'product_brand': instance.productBrand,
      'product_price': instance.productPrice,
      'different_colored_product':
          instance.differentColoredProduct.map((e) => e.toJson()).toList(),
    };

Url _$UrlFromJson(Map<String, dynamic> json) {
  return Url(
    urlForImage: json['url_for_image'] as String,
    id: json['_id'] as String,
  );
}

Map<String, dynamic> _$UrlToJson(Url instance) => <String, dynamic>{
      'url_for_image': instance.urlForImage,
      '_id': instance.id,
    };
