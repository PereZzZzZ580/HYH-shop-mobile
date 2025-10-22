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
    final targetVariantId = product.primaryVariant?.id;
    return _items.any((cartItem) {
      final itemVariantId = cartItem.variant?.id;
      if (targetVariantId != null && itemVariantId != null) {
        return itemVariantId == targetVariantId;
      }
      return cartItem.product.id == product.id;
    });
  }

  CartItem? getCartItem(Product product) {
    try {
      final targetVariantId = product.primaryVariant?.id;
      return _items.firstWhere((cartItem) {
        final itemVariantId = cartItem.variant?.id;
        if (targetVariantId != null && itemVariantId != null) {
          return itemVariantId == targetVariantId;
        }
        return cartItem.product.id == product.id;
      });
    } catch (e) {
      return null;
    }
  }

  void addItem(Product product, {int quantity = 1}) {
    final variant = product.primaryVariant;
    final targetId = variant?.id ?? product.id;
    final existingCartItemIndex = _items.indexWhere((cartItem) {
      final itemId = cartItem.variant?.id ?? cartItem.product.id;
      return itemId == targetId;
    });

    if (existingCartItemIndex >= 0) {
      _items[existingCartItemIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        product: product,
        variant: variant,
        quantity: quantity,
      ));
    }
    notifyListeners();
  }

  void removeItem(String productKey) {
    _items.removeWhere(
      (cartItem) => (cartItem.variant?.id ?? cartItem.product.id) == productKey,
    );
    notifyListeners();
  }

  void updateQuantity(String productKey, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productKey);
    } else {
      final existingCartItemIndex = _items.indexWhere(
        (cartItem) => (cartItem.variant?.id ?? cartItem.product.id) == productKey,
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
  
  // Load cart from backend for logged in user
  Future<void> loadCartFromBackend() async {
    // This would load the user's cart from the backend
    // Implementation depends on authentication and backend API
  }
  
  // Save cart to backend for logged in user
  Future<void> saveCartToBackend() async {
    // This would sync the user's cart to the backend
    // Implementation depends on authentication and backend API
  }
}
