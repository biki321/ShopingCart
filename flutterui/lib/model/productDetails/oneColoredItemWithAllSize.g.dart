// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oneColoredItemWithAllSize.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OneColoredItemWithAllSize _$OneColoredItemWithAllSizeFromJson(
    Map<String, dynamic> json) {
  return OneColoredItemWithAllSize(
    urlForImage: json['url_for_image'] as String,
    id: json['_id'] as String,
    productPrice: (json['product_price'] as num).toDouble(),
    sizeAndQuantity: SizeAndQuantity.fromJson(
        json['size_and_quantity'] as Map<String, dynamic>),
    nestedId: json['nested_id'] as String,
    namesOfColors: json['names_of_colors'] as String,
  );
}

Map<String, dynamic> _$OneColoredItemWithAllSizeToJson(
        OneColoredItemWithAllSize instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'product_price': instance.productPrice,
      'size_and_quantity': instance.sizeAndQuantity.toJson(),
      'nested_id': instance.nestedId,
      'names_of_colors': instance.namesOfColors,
      'url_for_image': instance.urlForImage,
    };

SizeAndQuantity _$SizeAndQuantityFromJson(Map<String, dynamic> json) {
  return SizeAndQuantity(
    size5: (json['5'] as num)?.toDouble(),
    size6: (json['6'] as num)?.toDouble(),
    size7: (json['7'] as num)?.toDouble(),
    size8: (json['8'] as num)?.toDouble(),
    size9: (json['9'] as num)?.toDouble(),
    size10: (json['10'] as num)?.toDouble(),
    size11: (json['11'] as num)?.toDouble(),
    size12: (json['12'] as num)?.toDouble(),
    size13: (json['13'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$SizeAndQuantityToJson(SizeAndQuantity instance) =>
    <String, dynamic>{
      '5': instance.size5,
      '6': instance.size6,
      '7': instance.size7,
      '8': instance.size8,
      '9': instance.size9,
      '10': instance.size10,
      '11': instance.size11,
      '12': instance.size12,
      '13': instance.size13,
    };
