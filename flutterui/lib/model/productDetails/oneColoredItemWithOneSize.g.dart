// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oneColoredItemWithOneSize.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OneColoredItemWithOneSize _$OneColoredItemWithOneSizeFromJson(
    Map<String, dynamic> json) {
  return OneColoredItemWithOneSize(
    id: json['_id'] as String,
    productPrice: (json['product_price'] as num).toDouble(),
    sizeAndQuantity: Map<String, int>.from(json['size_and_quantity'] as Map),
    nestedId: json['nested_id'] as String,
    namesOfColors: json['names_of_colors'] as String,
  );
}

Map<String, dynamic> _$OneColoredItemWithOneSizeToJson(
        OneColoredItemWithOneSize instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'product_price': instance.productPrice,
      'size_and_quantity': instance.sizeAndQuantity,
      'nested_id': instance.nestedId,
      'names_of_colors': instance.namesOfColors,
    };
