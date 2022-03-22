import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/http_exception.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  final url = Uri.parse(
      'https://shop-app-2fd5f-default-rtdb.europe-west1.firebasedatabase.app/products.json');
  List<Product> _items = [];

  var favoritesOnly = false;

  List<Product> get items {
    return [..._items]; //copy of _items
  }

  Future<void> fetchAndSetProducts() async {
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      final List<Product> loadedProducts = [];
      (extractedData as Map<String, dynamic>).forEach(
        (prodId, prodData) {
          loadedProducts.add(
            Product(
              id: prodId,
              title: prodData["title"],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData["imageUrl"],
            ),
          );
        },
      );
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite
          },
        ),
      );
      var id = json.decode(response.body)['name'];
      final newProduct = Product(
          id: id,
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print('err: ${error.toString()}');
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product editedProduct) async {
    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      final url = Uri.parse(
          "https://shop-app-2fd5f-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json");

      await http.patch(url,
          body: json.encode({
            "title": editedProduct.title,
            "description": editedProduct.description,
            "price": editedProduct.price,
            "imageUrl": editedProduct.imageUrl,
          }));
      _items[productIndex] = editedProduct;
    } else {
      //handle error
    }
    notifyListeners();
  }

  Future<void> removeProduct(String id) async {
    final url = Uri.parse(
        "https://shop-app-2fd5f-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json");
    final existingProductIndex = _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete product.");
    }
    existingProduct = null;
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }
}
