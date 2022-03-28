import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/auth_provider.dart';
import 'package:flutter_shop_app/screens/auth_screen.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:flutter_shop_app/screens/orders_screen.dart';
import 'package:flutter_shop_app/screens/splash_screen.dart';
import 'package:flutter_shop_app/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/products_provider.dart';
import '../screens/product_detail_screen.dart';
import '../screens/products_overview_screen.dart';
import '../screens/shopping_cart_screen.dart';
//https://shop-app-2fd5f-default-rtdb.europe-west1.firebasedatabase.app/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          update: (ctx, auth, previousProducts) => ProductsProvider(auth.token ?? "",
              auth.userId ?? "", previousProducts == null ? [] : previousProducts.items),
          create: (_) => ProductsProvider("", "", []),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          update: (ctx, auth, previousOrders) => OrderProvider(auth.token ?? "", auth.userId ?? "",
              previousOrders == null ? [] : previousOrders.orders),
          create: (_) => OrderProvider("", "", []),
        ),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) {
          return MaterialApp(
            title: "Salespoint",
            theme: ThemeData(
              primarySwatch: Colors.blue,
              accentColor: Colors.orange,
              fontFamily: "Lato",
            ),
            home: auth.isAuth
                ? const ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState == ConnectionState.waiting
                            ? const SplashScreen()
                            : const AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (context) => const ProductDetailScreen(),
              ShoppingCartScreen.routeName: (context) => const ShoppingCartScreen(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              UserProductsScreen.routeName: (context) => const UserProductsScreen(),
              EditProductScreen.routeName: (context) => const EditProductScreen(),
            },
          );
        },
      ),
    );
  }
}
