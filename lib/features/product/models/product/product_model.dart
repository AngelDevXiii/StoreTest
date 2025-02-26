import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class Product with _$Product {
  const Product._();

  const factory Product({
    required String uid,
    required String id,
    required String name,
    required double price,
    String? description,
    String? imageUrl,
    @Default(0) double discount,
    @Default(0) int quantity,
    @Default(0) double stars,
    @Default(0) int reviews,
    @Default(true) bool isAvailable,
  }) = _Product;

  factory Product.fromJson(Map<String, Object?> json) =>
      _$ProductFromJson(json);

  get discountPrice =>
      num.parse((price - (price * discount / 100)).toStringAsFixed(2));
}
