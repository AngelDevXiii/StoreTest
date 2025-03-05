import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:store_app/features/cart/datasources/local/cart_local_datasource/cart_local_datasource.dart';
import 'package:store_app/features/cart/datasources/remote/cart_service/cart_service.dart';
import 'package:store_app/features/cart/models/cart_item/cart_item_model.dart';

class CartRepository {
  CartRepository({required this.service, required this.localDataSource});

  final CartService service;
  final CartLocalDataSource localDataSource;

  Future<List<CartItem>> getCart(String userId) async {
    try {
      final cartsData = await service.getCart(userId);
      final cartLastUpdated = await localDataSource.getCartLastUpdated();

      if (cartsData.updatedAt != null) {
        final cart = cartsData.cart.map(CartItem.fromJson).toList();

        if (cartLastUpdated == null ||
            cartsData.updatedAt!.isAfter(cartLastUpdated)) {
          localDataSource.clearCartCache();
          localDataSource.cacheCarts(cart);
        } else {
          final cachedCarts = await localDataSource.getCachedCarts();
          final cachedCartsData =
              cachedCarts.map((element) => element.toJson()).toList();
          service.saveCart(userId, cachedCartsData);
        }
      }
      return localDataSource.getCachedCarts();
    } catch (error) {
      return localDataSource.getCachedCarts();
    }
  }

  Future<List<CartItem>> saveCart(
    String userId,
    List<CartItem> products,
  ) async {
    await localDataSource.cacheCarts(products);

    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      await service.saveCart(
        userId,
        products.map((product) => product.toJson()).toList(),
      );
    }

    return localDataSource.getCachedCarts();
  }

  Future<void> clearCart(String userId) async {
    await localDataSource.clearCartCache();
    await service.clearCart(userId);
  }
}
