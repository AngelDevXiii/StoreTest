import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_app/features/product/models/product/product_model.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

@freezed
class CartItem with _$CartItem {
  const CartItem._();

  const factory CartItem({
    required String uid,
    required String id,
    required String name,
    required double price,
    String? imageUrl,
    @Default(0) double discount,
    @Default(0) int quantity,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, Object?> json) =>
      _$CartItemFromJson(json);

  factory CartItem.fromProduct(Product product) => CartItem(
    uid: product.uid,
    id: product.id,
    name: product.name,
    price: product.price,
    discount: product.discount,
    imageUrl: product.imageUrl,
  );

  double get discountPrice =>
      double.parse((price - (price * discount / 100)).toStringAsFixed(2));

  double get totalPrice => (discountPrice * quantity);
}
