import 'package:flutter/material.dart';
import '../models/service.dart';
import 'booking_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  final List<Service> services = const [
    Service(
      name: 'Corte de Cabello',
      price: 25000,
      duration: '45 min',
      imageUrl: 'https://raw.githubusercontent.com/PereZzZzZ580/hyh-shop/main/public/soloCorte.png',
    ),
    Service(
      name: 'Afeitado Clásico',
      price: 30000,
      duration: '60 min',
      imageUrl: 'https://raw.githubusercontent.com/PereZzZzZ580/hyh-shop/main/public/barba_corte.jpeg',
    ),
    Service(
      name: 'Arreglo de Barba',
      price: 15000,
      duration: '25 min',
      imageUrl: 'https://raw.githubusercontent.com/PereZzZzZ580/hyh-shop/main/public/barba_Sola.jpeg',
    ),
    Service(
      name: 'Corte y Barba',
      price: 35000,
      duration: '75 min',
      imageUrl: 'https://raw.githubusercontent.com/PereZzZzZ580/hyh-shop/main/public/corteYbarba.png',
    ),
    Service(
      name: 'Cejas',
      price: 5000,
      duration: '10 min',
      imageUrl: 'https://raw.githubusercontent.com/PereZzZzZ580/hyh-shop/main/public/cejas_holman.jpeg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nuestros Servicios',
              style: textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return _buildServiceCard(context, service);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, Service service) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Image.network(
              service.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.broken_image, size: 40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  '\$${service.price.toStringAsFixed(0)} - ${service.duration}',
                  style: textTheme.titleMedium?.copyWith(color: colorScheme.primary),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingScreen(service: service),
                        ),
                      );
                    },
                    child: const Text('Agendar'),
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