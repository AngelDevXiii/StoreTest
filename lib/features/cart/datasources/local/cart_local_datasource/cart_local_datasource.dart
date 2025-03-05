import 'package:store_app/config/db/store.dart';
import 'package:store_app/features/cart/datasources/local/cart_local_datasource/cart_item_entity.dart';
import 'package:store_app/features/cart/datasources/local/cart_local_datasource/metadata_entity.dart';
import 'package:store_app/features/cart/models/cart_item/cart_item_model.dart';

abstract class CartLocalDataSource {
  const CartLocalDataSource();

  Future<DateTime?> getCartLastUpdated();

  Future<List<CartItem>> getCachedCarts();

  Future<List<int>> cacheCarts(List<CartItem> carts);

  Future<int> clearCartCache();
}

class CartObjectBoxLocalDataSource extends CartLocalDataSource {
  final ObjectBoxStore storage;

  const CartObjectBoxLocalDataSource({required this.storage});

  @override
  Future<DateTime?> getCartLastUpdated() async {
    return storage.metadataBox.get(1)?.cartLastUpdated;
  }

  @override
  Future<List<CartItem>> getCachedCarts() async {
    final carts =
        storage.cartBox
            .getAll()
            .map(
              (cart) => CartItem(
                uid: cart.uid,
                id: cart.cartItemId,
                name: cart.name,
                price: cart.price,
                discount: cart.discount,
                imageUrl: cart.imageUrl,
                quantity: cart.quantity,
              ),
            )
            .toList();

    return carts;
  }

  @override
  Future<List<int>> cacheCarts(List<CartItem> carts) async {
    storage.cartBox.removeAll();

    final cachedCarts =
        carts
            .map(
              (cart) => CachedCartItem(
                uid: cart.uid,
                cartItemId: cart.id,
                quantity: cart.quantity,
                name: cart.name,
                price: cart.price,
                discount: cart.discount,
                imageUrl: cart.imageUrl,
              ),
            )
            .toList();

    final metadata = storage.metadataBox.get(1);
    metadata?.cartLastUpdated = DateTime.now();

    if (metadata != null) {
      storage.metadataBox.put(metadata);
    } else {
      storage.metadataBox.put(Metadata(cartLastUpdated: DateTime.now()));
    }

    return storage.cartBox.putMany(cachedCarts);
  }

  @override
  Future<int> clearCartCache() async => storage.cartBox.removeAll();
}
