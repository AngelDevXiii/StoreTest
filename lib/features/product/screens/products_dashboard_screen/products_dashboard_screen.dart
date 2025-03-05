import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MainAppBar(backgroundColor: Colors.white, actions: [], title: ""),
      body: ProductList(screenWidth: screenWidth),
    );
  }
}
