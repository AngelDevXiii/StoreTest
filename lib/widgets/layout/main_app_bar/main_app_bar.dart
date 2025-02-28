import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:store_app/features/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/features/cart/bloc/cart/cart_bloc.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize = const Size.fromHeight(56.0);

  final String title;
  final Color backgroundColor;
  final List<Widget> actions;

  const MainAppBar({
    required this.title,
    required this.backgroundColor,
    required this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state as Authenticated;
    return AppBar(
      title: Text(
        authState.user.name ?? authState.user.email ?? '',
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      centerTitle: true,
      titleTextStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: Colors.amber[50],
        fontWeight: FontWeight.bold,
      ),

      backgroundColor: Colors.brown,

      actions: [
        BlocListener<CartBloc, CartState>(
          listenWhen:
              (previous, current) =>
                  previous.loading != current.loading && current.hasError,
          listener: (context, state) {
            if (state.hasError) {
              context.read<AuthBloc>().add(AuthLogoutPressed());
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage ?? 'Authentication Failure',
                    ),
                  ),
                );
            }
          },
          child: cartItem(context),
        ),

        if (authState.user.photoUrl != null)
          CircleAvatar(
            backgroundImage: NetworkImage(authState.user.photoUrl!),
            radius: 15,
          ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            context.read<AuthBloc>().add(AuthLogoutPressed());
          },
        ),
      ],

      elevation: 0,
    );
  }

  Widget cartItem(BuildContext context) {
    final products = context.watch<CartBloc>().state.products;

    if (products.isEmpty) {
      return SizedBox();
    }

    final itemsInCart = products
        .map((element) => element.quantity)
        .reduce((value, element) => value + element);

    return Stack(
      children: [
        IconButton(
          icon: const Icon(FontAwesomeIcons.cartShopping),

          onPressed: () {
            context.goNamed("cart");
          },
        ),
        Positioned(
          right: 5,
          top: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            child: Text(
              '$itemsInCart',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
