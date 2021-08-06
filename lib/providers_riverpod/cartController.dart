import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartProvider = ChangeNotifierProvider((ref) => CartController());

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;

  CartItem({this.id, this.title, this.quantity, this.price, this.imageUrl});
}

class CartController with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items == null ? 0 : _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title, String imageUrl) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existing) => CartItem(
            id: existing.id,
            title: existing.title,
            price: existing.price,
            quantity: existing.quantity + 1,
            imageUrl: existing.imageUrl),
      );
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1,
              imageUrl: imageUrl));
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((key, value) => productId == key);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id].quantity > 1) {
      _items.update(
        id,
        (existing) => CartItem(
            id: existing.id,
            title: existing.title,
            price: existing.price,
            quantity: existing.quantity - 1,
            imageUrl: existing.imageUrl),
      );
    } else {
      _items.remove(id);
    }

    notifyListeners();
  }
}
