import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  final Map<String, int> _cart = {};

  Map<String, int> get cart => _cart;

  void addToCart(String id) {
    _cart[id] = 1;
    notifyListeners();
  }

  void removeFromCart(String id) {
    _cart.remove(id);
    notifyListeners();
  }

  void incrementQty(String id) {
    _cart[id] = _cart[id]! + 1;
    notifyListeners();
  }

  void decrementQty(String id) {
    if (_cart[id]! > 1) {
      _cart[id] = _cart[id]! - 1;
    }
    notifyListeners();
  }
}
