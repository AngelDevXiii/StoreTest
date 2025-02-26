import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/features/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/features/cart/bloc/cart/cart_bloc.dart';
import 'package:store_app/features/cart/models/cart_item/cart_item_model.dart';
import 'package:store_app/features/product/bloc/product_bloc.dart';
import 'package:store_app/features/product/widgets/star_rating/star_rating.dart';
import 'package:store_app/widgets/layout/main_app_bar/main_app_bar.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String? productId;
  const ProductDetailsScreen({super.key, this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final String productId;

  @override
  void initState() {
    super.initState();

    productId = widget.productId ?? '';

    context.read<ProductBloc>().add(GetProductDetail(productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(backgroundColor: Colors.white, actions: [], title: ""),
      body: productBody(context),
    );
  }

  Widget productBody(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; //
    final product = context.watch<ProductBloc>().state.productDetail;
    final cartItems = context.watch<CartBloc>().state.products;
    final isCartLoading = context.watch<CartBloc>().state.loading;
    final cartItem = cartItems.firstWhereOrNull(
      (element) => element.id == product?.id,
    );

    final isLoading = context.watch<ProductBloc>().state.productDetailLoading;
    final hasError = context.watch<ProductBloc>().state.productDetailHasError;
    final errorMessage =
        context.watch<ProductBloc>().state.productDetailErrorMessage;

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (hasError || product == null) {
      return Center(child: Text(errorMessage ?? 'Unkown error ocurred'));
    }

    return ListView(
      children: [
        Container(
          width: screenWidth,
          height: 400,
          color: Color.fromRGBO(242, 242, 242, 1),
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: product.imageUrl ?? '',
            fit: BoxFit.scaleDown,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${product.discountPrice} DOP',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (product.discount > 0) SizedBox(height: 4),
              if (product.discount > 0)
                Text(
                  '${product.price} DOP',
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              SizedBox(height: 8),
              Text(
                product.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                softWrap: true,
              ),
              SizedBox(height: 8),
              Text(
                product.description ?? '',
                style: TextStyle(fontSize: 14),
                softWrap: true,
              ),
              SizedBox(height: 8),
              Row(
                spacing: 2,
                children: [
                  Text('${product.stars}'),
                  Text('(${product.reviews})'),
                ],
              ),
              SizedBox(height: 4),
              Row(spacing: 2, children: [StarRating(rating: product.stars)]),
              SizedBox(height: 16),

              SizedBox(height: 8),
              if (cartItem != null)
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Red background for error
                      foregroundColor: Colors.white, // White text color
                    ),
                    onPressed: () {
                      final authState =
                          context.read<AuthBloc>().state as Authenticated;

                      context.read<CartBloc>().add(
                        RemoveFromCart(
                          userId: authState.user.id,
                          productId: product.uid,
                        ),
                      );
                    },
                    child: Text("Remove from cart"),
                  ),
                ),
              if (cartItem == null)
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed:
                        isCartLoading
                            ? null
                            : () {
                              final authState =
                                  context.read<AuthBloc>().state
                                      as Authenticated;

                              context.read<CartBloc>().add(
                                AddToCart(
                                  userId: authState.user.id,
                                  product: CartItem.fromProduct(
                                    product,
                                  ).copyWith(
                                    quantity: (cartItem?.quantity ?? 0) + 1,
                                  ),
                                ),
                              );
                            },
                    child: const Text("Add to cart"),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
