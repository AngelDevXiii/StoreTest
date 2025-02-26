import 'package:store_app/features/product/models/product/product_model.dart';
import 'package:store_app/features/product/services/product_service.dart';

class ProductRepository {
  ProductRepository([ProductService? service])
    : _service = service ?? ProductService();

  final ProductService _service;

  Future<List<Product>> getProducts() async {
    final productsData = await _service.getProducts();
    final products = productsData.map(Product.fromJson).toList();

    return products;
  }

  Future<Product?> getProduct(String productId) async {
    final productData = await _service.getProduct(productId);

    if (productData != null) {
      return Product.fromJson(productData);
    }

    return null;
  }
}
