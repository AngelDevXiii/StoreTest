import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:store_app/features/cart/bloc/cart/cart_bloc.dart';
import 'package:store_app/features/product/bloc/product_bloc.dart';
import 'package:store_app/features/product/widgets/product_card/product_card.dart';

class ProductList extends StatelessWidget {
  const ProductList({required this.screenWidth, super.key});

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductBloc>().state.products;

    final isLoading = context.watch<ProductBloc>().state.productsLoading;
    final hasError = context.watch<ProductBloc>().state.productsHasError;
    final errorMessage =
        context.watch<ProductBloc>().state.productsErrorMessage;

    final cartItems = context.watch<CartBloc>().state.products;
    final isCartLoading = context.watch<CartBloc>().state.loading;

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return Center(child: Text(errorMessage ?? ''));
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final cartItem = cartItems.firstWhereOrNull(
          (element) => element.id == product.id,
        );

        return Container(
          key: ValueKey('${product.id}detail'),
          margin: EdgeInsets.symmetric(vertical: 5),
          child: GestureDetector(
            onTap: () {
              context.goNamed('details', pathParameters: {"id": product.uid});
            },
            child: ProductCard(
              width: screenWidth / 2,
              product: product,
              cartItem: cartItem,
              isCartLoading: isCartLoading,
            ),
          ),
        );
      },
    );
  }
}
