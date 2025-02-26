import 'package:flutter/material.dart';
import 'package:store_app/features/cart/widget/cart_list/cart_list.dart';
import 'package:store_app/widgets/layout/main_app_bar/main_app_bar.dart';

class CartsScreen extends StatefulWidget {
  const CartsScreen({super.key});

  @override
  State<CartsScreen> createState() => _CartsScreenState();
}

class _CartsScreenState extends State<CartsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MainAppBar(backgroundColor: Colors.white, actions: [], title: ""),
      body: CartList(screenWidth: screenWidth),
    );
  }
}
