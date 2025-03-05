import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:store_app/features/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/features/auth/models/user/user_model.dart';
import 'package:store_app/features/cart/bloc/cart/cart_bloc.dart';
import 'package:store_app/widgets/images/cache_image_container/cache_image_container.dart';

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
    final authState = context.read<AuthBloc>().state;

    final user = authState is Authenticated ? authState.user : User.empty();

    return AppBar(
      title: Text(
        user.name ?? user.email ?? '',
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      centerTitle: true,
      titleTextStyle: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),

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

        if (user.photoUrl != null)
          CacheImageContainer(
            imageUrl: user.photoUrl ?? "",
            imageBuilder:
                (context, imageProvider) =>
                    CircleAvatar(backgroundImage: imageProvider, radius: 15),
          ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            context.read<AuthBloc>().add(AuthLogoutPressed());
          },
        ),
      ],
    );
  }

  Widget cartItem(BuildContext context) {
    final products = context.watch<CartBloc>().state.products;

    final itemsInCart = products
        .map((element) => element.quantity)
        .fold(0, (value, element) => value + element);

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
