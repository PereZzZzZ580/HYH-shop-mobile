import 'package:flutter/material.dart';
import 'services_screen.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tus Próximas Citas',
              style: textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Agendar Nueva Cita'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ServicesScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Próximas',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildAppointmentCard(context, 'Corte de Cabello', 'Juan Pérez', 'Mañana, 10:00 AM'),
                  _buildAppointmentCard(context, 'Afeitado Clásico', 'Miguel Ortiz', '25 de Octubre, 2:30 PM'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, String service, String barber, String dateTime) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(Icons.calendar_today, color: colorScheme.primary),
        title: Text(service, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text('$barber\n$dateTime', style: textTheme.bodyMedium),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: Implement navigation to appointment details
        },
      ),
    );
  }
}