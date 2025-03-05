import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/features/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/features/cart/bloc/cart/cart_bloc.dart';
import 'package:store_app/features/cart/widget/cart_card/cart_card.dart';

class CartList extends StatelessWidget {
  const CartList({required this.screenWidth, super.key});

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartBloc>().state.products;
    final savedProducts = context.watch<CartBloc>().state.savedProducts;
    final isLoading = context.watch<CartBloc>().state.loading;
    final hasError = context.watch<CartBloc>().state.hasError;
    final errorMessage = context.watch<CartBloc>().state.errorMessage;

    final totalNum =
        cart.isEmpty
            ? "0"
            : cart
                .map((element) => element.totalPrice)
                .reduce((value, element) => value + element)
                .toStringAsFixed(2);

    if (hasError) {
      return Center(child: Text(errorMessage ?? ''));
    }

    if (cart.isEmpty) {}

    return Column(
      children: [
        SizedBox(height: 20),
        if (!listEquals(savedProducts, cart))
          Center(
            child: ElevatedButton(
              onPressed: () {
                final authState = context.read<AuthBloc>().state;

                if (authState is Authenticated) {
                  context.read<CartBloc>().add(
                    SaveCart(userId: authState.user.id, products: cart),
                  );
                }
              },
              child: Text("Save cart"),
            ),
          ),
        if (cart.isNotEmpty) Center(child: Text(errorMessage ?? '')),
        if (cart.isNotEmpty)
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Total:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (cart.isNotEmpty)
                        Text(
                          '\$$totalNum DOP',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final cartItem = cart[index];

                      return Container(
                        key: ValueKey('${cartItem.uid}cartDetail'),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: CartCard(
                          width: screenWidth / 2,
                          cartItem: cartItem,
                          isCartLoading: isLoading,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
