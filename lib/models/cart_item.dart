import 'product.dart';

class CartItem {
  final Product product;
  final ProductVariant? variant;
  int quantity;

  CartItem({
    required this.product,
    this.variant,
    this.quantity = 1,
  });

  double get totalPrice {
    final unitPrice = variant?.price ?? product.price;
    return unitPrice * quantity;
  }
}
