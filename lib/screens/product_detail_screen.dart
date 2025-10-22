import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;
    final primaryVariant = product.primaryVariant;
    final bool isInCart = cart.isInCart(product);
    final bool isOutOfStock = primaryVariant == null || primaryVariant.stock <= 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.name,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: ClipRRect(
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
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: colorScheme.surface,
                          child: const Icon(Icons.broken_image, size: 60),
                        ),
                      )
                    : Container(
                        color: colorScheme.surface,
                        child: Icon(
                          Icons.storefront,
                          size: 60,
                          color: colorScheme.primary,
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.robotoSlab(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (product.compareAtPrice != null && product.compareAtPrice! > product.price)
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            '\$${product.compareAtPrice!.toStringAsFixed(0)}',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: colorScheme.onSurface.withOpacity(0.6),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (primaryVariant != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        primaryVariant.stock > 0 ? 'Stock: ${primaryVariant.stock}' : 'Sin stock disponible',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: primaryVariant.stock > 0 ? colorScheme.onSurface : colorScheme.error,
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Disponibilidad: consultar con el asesor',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ),
                  if (product.brand != null && product.brand!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Marca: ${product.brand}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    'Descripción',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description.isNotEmpty
                        ? product.description
                        : 'Próximamente añadiremos más información para este producto.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (primaryVariant != null && primaryVariant.attributes.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Características',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...primaryVariant.attributes.entries.map(
                            (entry) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      '${entry.key}:',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      entry.value?.toString() ?? '',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: colorScheme.onSurface.withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(isInCart ? Icons.shopping_cart_checkout : Icons.add_shopping_cart),
                      label: Text(isInCart ? 'En carrito' : 'Agregar al carrito'),
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
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
