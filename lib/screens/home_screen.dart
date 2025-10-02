import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Placeholder product data
  final List<Product> products = const [
    Product(
      id: '1',
      name: 'Cera Moldeadora',
      description: 'Cera para peinar con acabado mate.',
      price: 35000,
      imageUrl: 'https://raw.githubusercontent.com/PereZzZzZ580/hyh-shop/main/public/barba_Sola.jpeg',
    ),
    Product(
      id: '2',
      name: 'Aceite para Barba',
      description: 'Aceite hidratante para barba con aroma a sándalo.',
      price: 45000,
      imageUrl: 'https://raw.githubusercontent.com/PereZzZzZ580/hyh-shop/main/public/barba_corte.jpeg',
    ),
    Product(
      id: '3',
      name: 'Shampoo Fortalecedor',
      description: 'Shampoo para cabello y barba.',
      price: 40000,
      imageUrl: 'https://raw.githubusercontent.com/PereZzZzZ580/hyh-shop/main/public/cejas_holman.jpeg',
    ),
    Product(
      id: '4',
      name: 'Tónico Capilar',
      description: 'Tónico para estimular el crecimiento del cabello.',
      price: 55000,
      imageUrl: 'https://raw.githubusercontent.com/PereZzZzZ580/hyh-shop/main/public/corteYbarba.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeroSection(context),
          ),
          SliverToBoxAdapter(
            child: _buildAboutBlock(context),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Text(
                'Nuestros Productos',
                style: textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7, // Adjust aspect ratio for better layout
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(product: products[index]);
              },
            ),
          ),
          SliverToBoxAdapter(
            child: _buildWhyChooseUsSection(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://raw.githubusercontent.com/PereZzZzZ580/hyh-shop/main/public/barba_corte.jpeg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Estilo y Cuidado Profesional',
                style: textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
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
        children: [
          Text('Sobre Nosotros', style: textTheme.headlineSmall),
          const SizedBox(height: 16),
          Text(
            'En HyH Shop, nos dedicamos a ofrecerte la mejor experiencia en cuidado personal masculino. Seleccionamos cuidadosamente cada producto para asegurar la máxima calidad y resultados excepcionales.',
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
        children: [
          Text('¿Por Qué Elegirnos?', style: textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 32),
          _buildFeatureItem(context, Icons.workspace_premium, 'Calidad Premium', 'Materiales seleccionados y montaje preciso.'),
          const SizedBox(height: 24),
          _buildFeatureItem(context, Icons.star, 'Ediciones Limitadas', 'Piezas con disponibilidad controlada.'),
          const SizedBox(height: 24),
          _buildFeatureItem(context, Icons.shield_outlined, 'Garantía Real', 'Soporte humano y cambios sin drama.'),
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
