import 'package:flutter_shop_app/models/cart_item.dart';

class Order {
  final String id;
  final double amount;
  final List<CartItem> cartItems;
  final DateTime dateTime;

  Order(
      {required this.id,
      required,
      required this.amount,
      required this.cartItems,
      required this.dateTime});
}
