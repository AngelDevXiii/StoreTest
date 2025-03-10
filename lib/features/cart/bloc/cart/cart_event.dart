part of 'cart_bloc.dart';

@immutable
sealed class CartEvent extends Equatable {}

final class GetCart extends CartEvent {
  final String userId;

  GetCart({required this.userId});

  @override
  List<Object?> get props => [userId];
}

final class AddToCart extends CartEvent {
  final String userId;
  final CartItem product;

  AddToCart({required this.userId, required this.product});

  @override
  List<Object?> get props => [userId, product];
}

final class SaveCart extends CartEvent {
  final String userId;
  final List<CartItem> products;

  SaveCart({required this.userId, required this.products});

  @override
  List<Object?> get props => [userId, products];
}

final class RemoveFromCart extends CartEvent {
  final String userId;
  final String productId;

  RemoveFromCart({required this.userId, required this.productId});

  @override
  List<Object?> get props => [userId, productId];
}

final class ClearCart extends CartEvent {
  final String userId;

  ClearCart({required this.userId});

  @override
  List<Object?> get props => [userId];
}
