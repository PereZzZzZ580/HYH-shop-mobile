import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((cartItem) {
      total += cartItem.totalPrice;
    });
    return total;
  }

  bool isInCart(Product product) {
    return _items.any((cartItem) => cartItem.product.id == product.id);
  }

  CartItem? getCartItem(Product product) {
    try {
      return _items.firstWhere(
        (cartItem) => cartItem.product.id == product.id,
      );
    } catch (e) {
      return null;
    }
  }

  void addItem(Product product, {int quantity = 1}) {
    final existingCartItemIndex = _items.indexWhere(
      (cartItem) => cartItem.product.id == product.id,
    );

    if (existingCartItemIndex >= 0) {
      _items[existingCartItemIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        product: product,
        quantity: quantity,
      ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((cartItem) => cartItem.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
    } else {
      final existingCartItemIndex = _items.indexWhere(
        (cartItem) => cartItem.product.id == productId,
      );
      if (existingCartItemIndex >= 0) {
        _items[existingCartItemIndex].quantity = newQuantity;
        notifyListeners();
      }
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}