import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/features/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/features/cart/bloc/cart/cart_bloc.dart';
import 'package:store_app/features/cart/models/cart_item/cart_item_model.dart';
import 'package:store_app/features/product/widgets/number_stepper/number_stepper.dart';
import 'package:transparent_image/transparent_image.dart';

class CartCard extends StatelessWidget {
  CartCard({
    required this.width,
    required this.cartItem,
    required this.isCartLoading,
    super.key,
  }) : uid = cartItem.uid,
       id = cartItem.id,
       name = cartItem.name,
       price = cartItem.price,
       imageUrl = cartItem.imageUrl ?? '',
       discount = cartItem.discount,
       quantity = cartItem.quantity;

  final double width;
  final CartItem cartItem;

  final String uid;
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final double discount;
  final int quantity;
  final bool isCartLoading;

  @override
  Widget build(BuildContext context) {
    final widgetHeight = 220.0;
    final mainColor = Color.fromRGBO(242, 242, 242, 1);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: mainColor),
          top: BorderSide(color: mainColor),
        ),
      ),
      height: widgetHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Container(
            width: width,
            height: widgetHeight,
            color: mainColor,
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: imageUrl,
              fit: BoxFit.scaleDown,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 10, top: 10),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          final authState =
                              context.read<AuthBloc>().state as Authenticated;

                          context.read<CartBloc>().add(
                            RemoveFromCart(
                              userId: authState.user.id,
                              productId: cartItem.uid,
                            ),
                          );
                        },
                        color: Colors.red,
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),

                  Text(
                    '${cartItem.discountPrice} DOP',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  if (cartItem.discount > 0)
                    Text(
                      '${cartItem.price} DOP',
                      style: TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  SizedBox(height: 8),
                  NumberStepper(
                    quantity: quantity,
                    onPressed: (pQuantity) {
                      final authState =
                          context.read<AuthBloc>().state as Authenticated;

                      context.read<CartBloc>().add(
                        AddToCart(
                          userId: authState.user.id,
                          product: cartItem.copyWith(quantity: pQuantity),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
