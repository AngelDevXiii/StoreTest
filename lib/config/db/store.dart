import 'package:store_app/features/auth/datasources/local/user_local_datasource/user_entity.dart';
import 'package:store_app/features/cart/datasources/local/cart_local_datasource/cart_item_entity.dart';
import 'package:store_app/features/cart/datasources/local/cart_local_datasource/metadata_entity.dart';
import 'package:store_app/features/product/datasources/local/product_local_datasource/product_entity.dart';
import 'package:store_app/objectbox.g.dart';

class ObjectBoxStore {
  late final Store store;
  late final Box<CachedUser> userBox;
  late final Box<CachedProduct> productBox;
  late final Box<CachedCartItem> cartBox;
  late final Box<Metadata> metadataBox;

  ObjectBoxStore._create(this.store) {
    userBox = store.box<CachedUser>();
    productBox = store.box<CachedProduct>();
    cartBox = store.box<CachedCartItem>();
    metadataBox = store.box<Metadata>();
  }

  static Future<ObjectBoxStore> create() async {
    final store = await openStore();
    return ObjectBoxStore._create(store);
  }
}
