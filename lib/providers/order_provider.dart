import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/order.dart';
import 'package:http/http.dart' as http;

import '../models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  final String authToken;
  final String userId;
  List<Order> _orders = [];

  OrderProvider(this.authToken, this.userId, this._orders);

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://shop-app-2fd5f-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          "amount": total,
          "dateTime": timestamp.toIso8601String(),
          "products": cartProducts
              .map((ci) => {
                    "id": ci.id,
                    "title": ci.title,
                    "quantity": ci.quantity,
                    "price": ci.price,
                  })
              .toList()
        }));
    _orders.insert(
        0,
        Order(
          id: json.decode(response.body)["name"],
          amount: total,
          cartItems: cartProducts,
          dateTime: timestamp,
        ));
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://shop-app-2fd5f-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    List<Order> loadedOrders = [];
    final extractedData = json.decode(response.body);
    if (extractedData == null) return;
    (extractedData as Map<String, dynamic>).forEach((orderId, orderData) {
      loadedOrders.add(Order(
          id: orderId,
          amount: orderData["amount"],
          cartItems: (orderData["products"] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item["id"],
                  title: item["title"],
                  quantity: item["quantity"],
                  price: item["price"],
                ),
              )
              .toList(),
          dateTime: DateTime.parse(orderData["dateTime"])));
    });
    _orders = loadedOrders;
    notifyListeners();
  }
}
