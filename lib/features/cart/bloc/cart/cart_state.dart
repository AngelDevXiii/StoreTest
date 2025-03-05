part of 'cart_bloc.dart';

final class CartState extends Equatable {
  const CartState({
    this.products = const [],
    this.savedProducts = const [],
    this.loading = false,
    this.hasError = false,
    this.errorMessage = '',
  });

  factory CartState.initial() {
    return CartState(
      products: [],
      savedProducts: [],
      loading: false,
      hasError: false,
      errorMessage: '',
    );
  }

  final List<CartItem> products;
  final List<CartItem> savedProducts;
  final bool loading;
  final bool hasError;
  final String? errorMessage;

  CartState copyWith({
    List<CartItem>? products,
    List<CartItem>? savedProducts,
    bool? loading,
    bool? hasError,
    String? errorMessage,
  }) {
    return CartState(
      products: products ?? this.products,
      savedProducts: savedProducts ?? this.savedProducts,
      loading: loading ?? this.loading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    products,
    loading,
    savedProducts,
    hasError,
    errorMessage,
  ];
}
