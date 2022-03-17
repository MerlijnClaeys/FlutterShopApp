import 'package:flutter/material.dart';
import 'package:flutter_shop_app/widgets/products_grid.dart';

class ProductOverviewScreen extends StatelessWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SalesPoint"),
      ),
      body: const ProductsGrid(),
    );
  }
}
