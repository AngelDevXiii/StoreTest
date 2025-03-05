import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/features/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/features/cart/bloc/cart/cart_bloc.dart';
import 'package:store_app/features/cart/models/cart_item/cart_item_model.dart';
import 'package:store_app/features/product/models/product/product_model.dart';
import 'package:store_app/features/product/widgets/star_rating/star_rating.dart';
import 'package:store_app/widgets/images/cache_image_container/cache_image_container.dart';

class ProductCard extends StatelessWidget {
  ProductCard({
    required this.width,
    required this.product,
    required this.cartItem,
    required this.isCartLoading,
    super.key,
  }) : uid = product.uid,
       id = product.id,
       name = product.name,
       price = product.price,
       description = product.description ?? '',
       imageUrl = product.imageUrl ?? '',
       discount = product.discount,
       quantity = product.quantity,
       stars = product.stars,
       reviews = product.reviews,
       isAvailable = product.isAvailable;

  final double width;
  final Product product;
  final CartItem? cartItem;

  final String uid;
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final double discount;
  final int quantity;
  final double stars;
  final int reviews;
  final bool isAvailable;
  final bool isCartLoading;

  @override
  Widget build(BuildContext context) {
    final widgetHeight = 350.0;
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
            child: CacheImageContainer(imageUrl: imageUrl),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 10, top: 10),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(name, maxLines: 2, overflow: TextOverflow.ellipsis),
                  Text(
                    description,

                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${product.discountPrice} DOP',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  if (product.discount > 0)
                    Text(
                      '${product.price} DOP',
                      style: TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Row(
                    spacing: 2,
                    children: [Text('$stars'), Text('($reviews)')],
                  ),
                  Row(spacing: 2, children: [StarRating(rating: stars)]),

                  Spacer(),
                  Row(
                    spacing: 8,
                    children: [
                      if (cartItem != null)
                        Text("${cartItem?.quantity} in cart"),
                      if (cartItem != null)
                        TextButton(
                          onPressed: () {
                            final authState = context.read<AuthBloc>().state;
                            if (authState is Authenticated) {
                              context.read<CartBloc>().add(
                                RemoveFromCart(
                                  userId: authState.user.id,
                                  productId: product.uid,
                                ),
                              );
                            }
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "Remove",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                    ],
                  ),
                  cardButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed:
            isCartLoading
                ? () {}
                : () {
                  final authState = context.read<AuthBloc>().state;
                  if (authState is Authenticated) {
                    context.read<CartBloc>().add(
                      AddToCart(
                        userId: authState.user.id,
                        product: CartItem.fromProduct(
                          product,
                        ).copyWith(quantity: (cartItem?.quantity ?? 0) + 1),
                      ),
                    );
                  }
                },
        child: const Text("Add to cart"),
      ),
    );
  }
}
