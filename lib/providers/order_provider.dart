import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/order.dart';

import '../models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        amount: total,
        cartItems: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
