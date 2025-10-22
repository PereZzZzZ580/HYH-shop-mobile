import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService.fetchProducts(perPage: 30);
  }

  Future<void> _reloadProducts() async {
    try {
      final products = await ProductService.fetchProducts(perPage: 30);
      if (!mounted) return;
      setState(() {
        _productsFuture = Future.value(products);
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _productsFuture = Future.error(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          final products = snapshot.data ?? const <Product>[];
          final hasError = snapshot.hasError;

          return RefreshIndicator(
            onRefresh: _reloadProducts,
            displacement: 72,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 100,
                        height: 100,
                        errorBuilder: (context, error, stack) => Icon(
                          Icons.store,
                          size: 80,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: _buildHeroSection(context)),
                SliverToBoxAdapter(child: _buildAboutBlock(context)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          'Nuestros Productos',
                          style: textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Catalogo sincronizado con hyh-shop.com',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                if (isLoading)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  )
                else if (hasError)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      child: Column(
                        children: [
                          const Icon(Icons.warning_amber_rounded, size: 48, color: Colors.amber),
                          const SizedBox(height: 12),
                          Text(
                            'No pudimos conectar con el catalogo.',
                            style: textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Revisa tu conexion o desliza hacia abajo para reintentar.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else if (products.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      child: Column(
                        children: [
                          const Icon(Icons.inventory_2_outlined, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            'No hay productos disponibles en este momento.',
                            style: textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) => ProductCard(product: products[index]),
                    ),
                  ),
                SliverToBoxAdapter(child: _buildWhyChooseUsSection(context)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      constraints: const BoxConstraints(minHeight: 320),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/hero_banner.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                margin: const EdgeInsets.only(bottom: 16),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stack) => const Icon(
                    Icons.store,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                'Estilo y cuidado profesional',
                style: textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Productos de alta calidad para el hombre moderno.',
                style: textTheme.titleLarge?.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutBlock(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Sobre nosotros', style: textTheme.headlineSmall),
          const SizedBox(height: 16),
          Text(
            'En HyH Shop seleccionamos cada producto para asegurar la mejor experiencia en barberia y cuidado personal masculino.',
            style: textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWhyChooseUsSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Por que elegirnos?', style: textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 32),
          _buildFeatureItem(context, Icons.workspace_premium, 'Calidad premium', 'Materiales seleccionados y montaje preciso.'),
          const SizedBox(height: 24),
          _buildFeatureItem(context, Icons.star, 'Ediciones limitadas', 'Piezas con disponibilidad controlada.'),
          const SizedBox(height: 24),
          _buildFeatureItem(context, Icons.shield_outlined, 'Garantía real', 'Soporte humano y cambios sin drama.'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String title, String description) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: colorScheme.primary, size: 40),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(description, style: textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
