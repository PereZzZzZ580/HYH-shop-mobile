import 'package:flutter/material.dart';

class BarbersScreen extends StatelessWidget {
  const BarbersScreen({super.key});

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
              'Nuestro Barbero',
              style: textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: _buildBarberCard(context, 'Holman Steven', 'Barbero Profesional', Icons.person),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarberCard(BuildContext context, String name, String specialty, IconData icon) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: colorScheme.primary,
              child: Icon(icon, size: 60, color: colorScheme.onPrimary),
            ),
            const SizedBox(height: 24),
            Text(
              name,
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              specialty,
              style: textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
