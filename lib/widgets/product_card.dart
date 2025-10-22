import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';
import '../screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cart = Provider.of<CartProvider>(context);
    final primaryVariant = product.primaryVariant;
    final bool isInCart = cart.isInCart(product);
    final bool isOutOfStock = primaryVariant == null || primaryVariant.stock <= 0;
    final double? compareAtPrice = product.compareAtPrice;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      color: colorScheme.surface.withOpacity(0.7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(product: product),
                  ),
                );
              },
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  child: product.imageUrl.isNotEmpty
                      ? Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: colorScheme.surface,
                            child: const Icon(
                              Icons.broken_image,
                              size: 40,
                            ),
                          ),
                        )
                      : Container(
                          color: colorScheme.surface,
                          child: Icon(
                            Icons.storefront,
                            size: 40,
                            color: colorScheme.primary,
                          ),
                        ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(0)}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (compareAtPrice != null && compareAtPrice > product.price)
                  Text(
                    '\$${compareAtPrice.toStringAsFixed(0)}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: colorScheme.onSurface.withOpacity(0.6),
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                if (isOutOfStock)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Sin stock',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: Icon(
                    isInCart ? Icons.shopping_cart_checkout : Icons.add_shopping_cart,
                    size: 16,
                  ),
                  label: Text(
                    isInCart
                        ? 'En carrito'
                        : isOutOfStock
                            ? 'Sin stock'
                            : 'Agregar',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: isOutOfStock
                      ? null
                      : () {
                          if (isInCart) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} ya esta en el carrito'),
                                action: SnackBarAction(
                                  label: 'VER CARRITO',
                                  onPressed: () {
                                    Navigator.pushNamed(context, CartScreen.routeName);
                                  },
                                ),
                              ),
                            );
                          } else {
                            cart.addItem(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} agregado al carrito'),
                                action: SnackBarAction(
                                  label: 'VER CARRITO',
                                  onPressed: () {
                                    Navigator.pushNamed(context, CartScreen.routeName);
                                  },
                                ),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isInCart
                        ? colorScheme.primary
                        : colorScheme.primary.withOpacity(isOutOfStock ? 0.1 : 0.2),
                    foregroundColor: isInCart || isOutOfStock ? Colors.black : colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: colorScheme.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
