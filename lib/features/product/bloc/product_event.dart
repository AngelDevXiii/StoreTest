part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {
  const ProductEvent();
}

final class GetProducts extends ProductEvent {
  const GetProducts();
}

final class GetProductDetail extends ProductEvent {
  const GetProductDetail(this.productId);

  final String productId;
}
