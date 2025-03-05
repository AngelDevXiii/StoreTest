import 'package:store_app/features/product/datasources/local/product_local_datasource/product_local_datasource.dart';
import 'package:store_app/features/product/datasources/remote/product_service/product_service.dart';
import 'package:store_app/features/product/models/product/product_model.dart';

class ProductRepository {
  ProductRepository({required this.service, required this.localDataSource});

  final ProductService service;
  final ProductLocalDataSource localDataSource;

  Future<List<Product>> getProducts() async {
    try {
      final productsData = await service.getProducts();
      final products = productsData.map(Product.fromJson).toList();

      if (products.isEmpty) return localDataSource.getCachedProducts();

      localDataSource.clearProductCache();
      localDataSource.cacheProducts(products);

      return localDataSource.getCachedProducts();
    } catch (error) {
      return localDataSource.getCachedProducts();
    }
  }
}
