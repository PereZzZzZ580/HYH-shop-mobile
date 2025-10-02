import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/service.dart';

class BookingScreen extends StatefulWidget {
  final Service service;

  const BookingScreen({super.key, required this.service});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _addressController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yMMMMd', 'es_ES').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  void _launchWhatsApp() async {
    final address = _addressController.text;
    final date = _dateController.text;
    final time = _timeController.text;
    final notes = _notesController.text;

    final text = 'Hola, deseo agendar ${widget.service.name}'
        '${date.isNotEmpty ? ' el $date' : ''}'
        '${time.isNotEmpty ? ' a las $time' : ''}'
        '${address.isNotEmpty ? ' en $address' : ''}.'
        '${notes.isNotEmpty ? ' Notas: $notes' : ''}';

    // Try different URL formats for WhatsApp
    final url = 'https://wa.me/573138907119?text=${Uri.encodeComponent(text)}';
    final alternativeUrl = 'whatsapp://send?phone=573138907119&text=${Uri.encodeComponent(text)}';

    // First try the web version
    if (await canLaunchUrl(Uri.parse(url))) {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } 
    // If that fails, try the app version
    else if (await canLaunchUrl(Uri.parse(alternativeUrl))) {
      launchUrl(Uri.parse(alternativeUrl), mode: LaunchMode.externalApplication);
    } 
    // If both fail, show error
    else {
      // Check if WhatsApp is installed
      final whatsappInstalled = await canLaunchUrl(Uri.parse('whatsapp://'));
      if (!whatsappInstalled) {
        // WhatsApp is not installed - schedule dialog after build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showWhatsAppNotInstalledDialog(context);
        });
      } else {
        // WhatsApp is installed but still can't open
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudo abrir WhatsApp. Intente manualmente.'),
            ),
          );
        });
      }
    }
  }

  void showWhatsAppNotInstalledDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('WhatsApp no instalado'),
        content: const Text('Parece que WhatsApp no está instalado en tu dispositivo. ¿Deseas descargarlo?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () async {
              final appStoreUrl = Platform.isIOS 
                ? 'itms-apps://itunes.apple.com/app/id310633997' 
                : 'market://details?id=com.whatsapp';
              
              final url = Platform.isIOS 
                ? 'https://apps.apple.com/app/whatsapp-messenger/id310633997' 
                : 'https://play.google.com/store/apps/details?id=com.whatsapp';
              
              if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
                launchUrl(Uri.parse(appStoreUrl), mode: LaunchMode.externalApplication);
              } else {
                launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              }
              Navigator.of(context).pop();
            },
            child: const Text('IR A LA TIENDA'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar Cita'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Servicio: ${widget.service.name}',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Duración: ${widget.service.duration} - Precio: \$${widget.service.price.toStringAsFixed(0)}',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  hintText: '(Opcional)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Hora',
                  suffixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                onTap: () => _selectTime(context),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notas',
                  hintText: '(Opcional)',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _launchWhatsApp,
                icon: Icon(Icons.chat),
                label: const Text('Contactar por WhatsApp'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _launchWhatsApp();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Agendar Cita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
