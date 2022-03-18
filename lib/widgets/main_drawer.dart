import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          AppBar(
            title: const Text("Hello Friend!"),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.store, color: Theme.of(context).primaryColor),
            title: const Text("Shop"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart, color: Theme.of(context).primaryColor),
            title: const Text("Orders"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/orders");
            },
          ),
        ],
      ),
    );
  }
}
