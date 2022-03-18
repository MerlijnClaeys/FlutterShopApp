import 'package:flutter/material.dart';
import 'package:flutter_shop_app/screens/orders_screen.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/products_provider.dart';
import '../screens/product_detail_screen.dart';
import '../screens/products_overview_screen.dart';
import '../screens/shopping_cart_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductsProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider())
      ],
      child: MaterialApp(
        title: "Salespoint",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.orange,
          fontFamily: "Lato",
        ),
        home: const ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => const ProductDetailScreen(),
          ShoppingCartScreen.routeName: (context) => const ShoppingCartScreen(),
          OrdersScreen.routeName: (context) => const OrdersScreen(),
        },
      ),
    );
  }
}
