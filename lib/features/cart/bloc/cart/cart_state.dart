part of 'cart_bloc.dart';

final class CartState extends Equatable {
  const CartState({
    this.products = const [],
    this.loading = false,
    this.hasError = false,
    this.errorMessage = '',
  });

  factory CartState.initial() {
    return CartState(
      products: [],
      loading: false,
      hasError: false,
      errorMessage: '',
    );
  }

  final List<CartItem> products;

  final bool loading;
  final bool hasError;
  final String? errorMessage;

  CartState copyWith({
    List<CartItem>? products,
    bool? loading,
    bool? hasError,
    String? errorMessage,
  }) {
    return CartState(
      products: products ?? this.products,

      loading: loading ?? this.loading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [products, loading, hasError, errorMessage];
}
