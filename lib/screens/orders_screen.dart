import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/order_provider.dart';
import 'package:flutter_shop_app/widgets/main_drawer.dart';
import 'package:flutter_shop_app/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Your orders"),
        ),
        drawer: AppDrawer(),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return OrderItem(order: orderData.orders[index]);
          },
          itemCount: orderData.orders.length,
        ));
  }
}
