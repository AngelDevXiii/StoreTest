import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_app/features/cart/models/cart_item/cart_item_model.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
class Profile with _$Profile {
  const Profile._();

  const factory Profile({
    required String id,

    required String userId,

    required List<CartItem> cartItems,
  }) = _Profile;

  factory Profile.fromJson(Map<String, Object?> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'cartItems': cartItems.map((item) => {item.toJson()}).toList(),
    };
  }
}
