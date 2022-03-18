import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/cart_item.dart';
import 'package:flutter_shop_app/providers/order_provider.dart';
import 'package:flutter_shop_app/widgets/shopping_cart_item.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class ShoppingCartScreen extends StatelessWidget {
  static const routeName = "/cart";

  const ShoppingCartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("you cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  const SizedBox(width: 16),
                  Chip(
                    label: Text("\$${cart.totalAmount}"),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<OrderProvider>(context, listen: false)
                          .addOrder(cart.items.values.toList(), cart.totalAmount);
                      cart.clearCart();
                    },
                    child: Text(
                      "Order now",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, cartItem) {
              return ShoppingCartItem(
                  id: cart.items.values.toList()[cartItem].id,
                  title: cart.items.values.toList()[cartItem].title,
                  productId: cart.items.keys.toList()[cartItem],
                  price: cart.items.values.toList()[cartItem].price,
                  quantity: cart.items.values.toList()[cartItem].quantity);
            },
            itemCount: cart.items.length,
          ))
        ],
      ),
    );
  }
}
