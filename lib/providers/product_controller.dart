import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final productProvider = ChangeNotifierProvider.family(
    (ref, Product product) => ProductController(product));

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});
}

class ProductController with ChangeNotifier {
  final Product product;

  ProductController(this.product);

  void _setFavValue(bool newVal) {
    product.isFavorite = newVal;
    notifyListeners();
  }

  Future<void> toogleFavoriteStatus(String token, String userId) async {
    final oldStatus = product.isFavorite;
    product.isFavorite = !product.isFavorite;
    notifyListeners();

    final url =
        'https://shop-app-8c3fe.firebaseio.com/userFavorites/$userId/${product.id}.json?auth=$token';
    try {
      final response =
          await http.put(url, body: json.encode(product.isFavorite));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
