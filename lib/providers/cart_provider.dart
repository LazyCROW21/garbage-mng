import 'package:flutter/material.dart';
import 'package:garbage_mng/models/waste_item_model.dart';

class Cart with ChangeNotifier {
  final Map<String, Map<String, dynamic>> _cart = {};

  Map<String, Map<String, dynamic>> get cart => _cart;

  void addToCart(WasteItemModel item) {
    _cart[item.id] = {};
    _cart[item.id]!['item'] = item;
    _cart[item.id]!['qty'] = 1;
    notifyListeners();
  }

  void removeFromCart(String id) {
    _cart.remove(id);
    notifyListeners();
  }

  void incrementQty(String id) {
    _cart[id]!['qty'] = _cart[id]!['qty']! + 1;
    notifyListeners();
  }

  void decrementQty(String id) {
    if (_cart[id]!['qty']! > 1) {
      _cart[id]!['qty'] = _cart[id]!['qty']! - 1;
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
