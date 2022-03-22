import 'package:flutter/material.dart';
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
        title: const Text("you cart"),
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
                  const Spacer(),
                  const SizedBox(width: 16),
                  Chip(
                    label: Text("\$${cart.totalAmount}"),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
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

class OrderButton extends StatefulWidget {
  const OrderButton({Key? key, required this.cart}) : super(key: key);

  final CartProvider cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<OrderProvider>(context, listen: false)
                  .addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);
              widget.cart.clearCart();
              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : Text(
              "Order now",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
    );
  }
}
