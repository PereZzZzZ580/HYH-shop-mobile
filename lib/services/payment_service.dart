import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'wompi_service.dart';

class PaymentService {
  // Updated payment methods including contra entrega, WhatsApp, and Wompi
  static const List<String> paymentMethods = [
    'Contra Entrega',
    'WhatsApp',
    'Wompi',
    'Efectivo',
    'Tarjeta de Débito',
    'Tarjeta de Crédito',
    'Transferencia Bancaria',
    'PayPal',
  ];

  // Process payment based on method
  static Future<bool> processPayment({
    required double amount,
    required String paymentMethod,
    required String customerId,
    required String customerEmail,
    required String customerName,
    String? customerPhone,
    String? customerAddress,
    String? cardNumber,
    String? cardHolder,
    String? expiryDate,
    String? cvv,
  }) async {
    switch (paymentMethod) {
      case 'Wompi':
        String? paymentUrl = await WompiService.createPayment(
          amount: amount,
          customerId: customerId,
          customerEmail: customerEmail,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          currency: 'COP', // Colombian Peso
        );
        
        if (paymentUrl != null) {
          // Launch the Wompi payment page
          await _launchURL(paymentUrl);
          // Return true to indicate that the payment process has started
          // The actual payment verification would happen in a separate process
          return true;
        }
        return false;
        
      case 'WhatsApp':
        // For WhatsApp, we can send a message with order details
        String message = "Hola, quiero confirmar mi pedido en HyH Shop Barbería.%0A"
            "Cliente: ${customerName}%0A"
            "Email: ${customerEmail}%0A"
            "Teléfono: ${customerPhone ?? ''}%0A"
            "Dirección: ${customerAddress ?? ''}%0A"
            "Total: %24${amount.toStringAsFixed(0)}%0A"
            "Por favor, indíquenme cómo completar el pago.";
        String whatsAppUrl = "https://wa.me/?text=$message";
        await _launchURL(whatsAppUrl);
        return true;
        
      case 'Contra Entrega':
        // For contra entrega, the order is confirmed but payment happens on delivery
        return true;
        
      case 'Tarjeta de Débito':
      case 'Tarjeta de Crédito':
        // For demo purposes, simulate card payment processing
        await Future.delayed(const Duration(seconds: 2));
        return true;
        
      default:
        // For other payment methods, simulate processing
        await Future.delayed(const Duration(seconds: 2));
        return true;
    }
  }

  static Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Validate card information (for demo purposes)
  static bool validateCreditCard({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  }) {
    // Basic validation - in real app, use proper validation
    if (cardNumber.length < 13 || cardNumber.length > 19) return false;
    if (cvv.length != 3 && cvv.length != 4) return false;
    
    // Check if expiry date is in the future
    try {
      final parts = expiryDate.split('/');
      if (parts.length != 2) return false;
      
      final month = int.tryParse(parts[0]);
      final year = int.tryParse(parts[1]);
      
      if (month == null || year == null) return false;
      if (month < 1 || month > 12) return false;
      
      final currentDate = DateTime.now();
      final currentYear = currentDate.year % 100;
      final currentMonth = currentDate.month;
      
      if (year < currentYear) return false;
      if (year == currentYear && month < currentMonth) return false;
      
      return true;
    } catch (e) {
      return false;
    }
  }
}