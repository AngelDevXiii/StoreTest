part of 'product_bloc.dart';

final class ProductState extends Equatable {
  const ProductState({
    this.products = const [],

    this.productsLoading = false,
    this.productsHasError = false,
    this.productsErrorMessage = '',
    this.productDetail,

    this.productDetailLoading = false,
    this.productDetailHasError = false,
    this.productDetailErrorMessage = '',
  });

  final List<Product> products;
  final bool productsLoading;
  final bool productsHasError;
  final String? productsErrorMessage;

  final Product? productDetail;
  final bool productDetailLoading;
  final bool productDetailHasError;
  final String? productDetailErrorMessage;

  @override
  List<Object?> get props => [products, productDetail];

  ProductState copyWith({
    List<Product>? products,
    Product? productDetail,
    bool? productsLoading,
    bool? productsHasError,
    String? productsErrorMessage,
    bool? productDetailLoading,
    bool? productDetailHasError,
    String? productDetailErrorMessage,
  }) {
    return ProductState(
      products: products ?? this.products,
      productDetail: productDetail ?? this.productDetail,
      productsLoading: productsLoading ?? this.productsLoading,
      productsHasError: productsHasError ?? this.productsHasError,
      productsErrorMessage: productsErrorMessage ?? this.productsErrorMessage,
      productDetailLoading: productDetailLoading ?? this.productDetailLoading,
      productDetailHasError:
          productDetailHasError ?? this.productDetailHasError,
      productDetailErrorMessage:
          productDetailErrorMessage ?? this.productDetailErrorMessage,
    );
  }
}
