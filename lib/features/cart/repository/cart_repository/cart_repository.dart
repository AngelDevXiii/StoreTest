import 'package:store_app/features/cart/models/cart_item/cart_item_model.dart';
import 'package:store_app/features/cart/services/cart_service.dart';

class CartRepository {
  CartRepository([CartService? service]) : _service = service ?? CartService();

  final CartService _service;

  Stream<List<CartItem>> streamCartProducts(String userId) =>
      _service.streamCartProducts(userId);

  Future<List<CartItem>> getCart(String userId) async {
    final cartData = await _service.getCart(userId);

    return cartData.map(CartItem.fromJson).toList();
  }

  Future<void> addOrUpdateCartProduct(String userId, CartItem product) async {
    return _service.addProductToCart(userId, product.toJson());
  }

  Future<void> deleteProductFromCart(String userId, String productId) async {
    return _service.deleteProductFromCart(userId, productId);
  }

  Future<void> clearCart(String userId) async {
    return _service.clearCart(userId);
  }
}
