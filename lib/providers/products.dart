import 'dart:io';

import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouritesItem {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product product) async {
    final uri = Uri.https(
        "shopappflutter-ad186-default-rtdb.firebaseio.com", "/products.json");
    final response = await http.post(uri,
        body: convert.jsonEncode({
          "title": product.title,
          "description": product.description,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "isFavourite": product.isFavourite
        }));

    final newProduct = Product(
      id: convert.jsonDecode(response.body)["name"],
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    );

    _items.add(newProduct);
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    final idx = _items.indexWhere((element) => element.id == id);
    if (idx >= 0) {
      _items[idx] = newProduct;
      notifyListeners();
    }
  }

  Future<void> fetchAndSyncProducts() async {
    final uri = Uri.https(
        "shopappflutter-ad186-default-rtdb.firebaseio.com", "/products.json");
    try {
      final response = await http.get(uri);
      print(convert.jsonDecode(response.body));
      var products = convert.jsonDecode(response.body) as Map<String, dynamic>;
      var loadedProducts = <Product>[];
      products.forEach((key, value) {
        loadedProducts.add(Product(
            id: key,
            title: value["title"],
            description: value["description"],
            price: value["price"],
            imageUrl: value["imageUrl"]));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  void removeProduct(String id) {
    _items.removeWhere((element) => element.id == id);
  }
}
