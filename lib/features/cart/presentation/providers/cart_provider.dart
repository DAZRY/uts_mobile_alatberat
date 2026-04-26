import 'package:flutter/material.dart';
import 'package:uts_mobile_alatberat/features/catalog/domain/product_model.dart';

class CartItem {
  final int productId;
  final String name;
  final double price;
  int qty;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    this.qty = 1,
  });
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, e) => sum + e.qty);
  double get totalPrice => _items.fold(0, (sum, e) => sum + (e.price * e.qty));

  void addItem(ProductModel product) {
    final idx = _items.indexWhere((e) => e.productId == product.id);
    if (idx >= 0) {
      _items[idx].qty++;
    } else {
      _items.add(CartItem(
        productId: product.id,
        name:      product.name,
        price:     product.price,
      ));
    }
    notifyListeners();
  }

  void removeItem(int productId) {
    _items.removeWhere((e) => e.productId == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}