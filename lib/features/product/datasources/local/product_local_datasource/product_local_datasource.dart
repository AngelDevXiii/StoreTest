import 'package:store_app/config/db/store.dart';
import 'package:store_app/features/product/datasources/local/product_local_datasource/product_entity.dart';
import 'package:store_app/features/product/models/product/product_model.dart';

abstract class ProductLocalDataSource {
  const ProductLocalDataSource();

  Future<List<Product>> getCachedProducts();

  Future<List<int>> cacheProducts(List<Product> products);

  Future<int> clearProductCache();
}

class ProductObjectBoxLocalDataSource extends ProductLocalDataSource {
  final ObjectBoxStore storage;

  const ProductObjectBoxLocalDataSource({required this.storage});

  @override
  Future<List<Product>> getCachedProducts() {
    final products =
        storage.productBox
            .getAll()
            .map(
              (product) => Product(
                uid: product.uid,
                id: product.productId,
                name: product.name,
                price: product.price,
                description: product.description,
                discount: product.discount,
                imageUrl: product.imageUrl,
                isAvailable: product.isAvailable,
                reviews: product.reviews,
                stars: product.stars,
              ),
            )
            .toList();

    return Future.value(products);
  }

  @override
  Future<List<int>> cacheProducts(List<Product> products) async {
    storage.productBox.removeAll();

    final cachedProducts =
        products
            .map(
              (product) => CachedProduct(
                uid: product.uid,
                productId: product.id,
                name: product.name,
                price: product.price,
                description: product.description,
                discount: product.discount,
                imageUrl: product.imageUrl,
                isAvailable: product.isAvailable,
                reviews: product.reviews,
                stars: product.stars,
              ),
            )
            .toList();

    return storage.productBox.putMany(cachedProducts);
  }

  @override
  Future<int> clearProductCache() =>
      Future.value(storage.productBox.removeAll());
}
