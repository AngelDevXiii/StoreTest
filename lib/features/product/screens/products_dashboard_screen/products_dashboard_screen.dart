import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/features/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/features/cart/bloc/cart/cart_bloc.dart';
import 'package:store_app/features/product/bloc/product_bloc.dart';
import 'package:store_app/features/product/widgets/product_list/product_list.dart';
import 'package:store_app/widgets/layout/main_app_bar/main_app_bar.dart';

class ProductsDashboardScreen extends StatefulWidget {
  const ProductsDashboardScreen({super.key});

  @override
  State<ProductsDashboardScreen> createState() =>
      _ProductsDashboardScreenState();
}

class _ProductsDashboardScreenState extends State<ProductsDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(GetProducts());
    final userId = (context.read<AuthBloc>().state as Authenticated).user.id;
    context.read<CartBloc>().add(GetCart(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MainAppBar(backgroundColor: Colors.white, actions: [], title: ""),
      body: ProductList(screenWidth: screenWidth),
    );
  }
}
