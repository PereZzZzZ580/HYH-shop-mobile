import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../services/payment_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Customer information
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  // Payment information
  String _selectedPaymentMethod = 'Contra Entrega';
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer Information Section
                Text(
                  'Información del Cliente',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre Completo',
                    hintText: 'Ingresa tu nombre completo',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    hintText: 'tu@email.com',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu correo electrónico';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Por favor ingresa un correo electrónico válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Teléfono',
                    hintText: '+57 300 123 4567',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu número de teléfono';
                    }
                    if (value.length < 7) {
                      return 'Por favor ingresa un número de teléfono válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Dirección de Entrega',
                    hintText: 'Calle, número, ciudad, código postal...',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu dirección de entrega';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Payment Method Section
                Text(
                  'Método de Pago',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Payment method selector
                        DropdownButtonFormField<String>(
                          value: _selectedPaymentMethod,
                          decoration: const InputDecoration(
                            labelText: 'Selecciona un método de pago',
                          ),
                          items: PaymentService.paymentMethods.map((method) {
                            return DropdownMenuItem(
                              value: method,
                              child: Text(method),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedPaymentMethod = newValue;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        // Payment method specific fields
                        if (_selectedPaymentMethod.contains('Tarjeta'))
                          // Credit card fields
                          Column(
                            children: [
                              TextFormField(
                                controller: _cardNumberController,
                                decoration: const InputDecoration(
                                  labelText: 'Número de Tarjeta',
                                  hintText: '1234 5678 9012 3456',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (_selectedPaymentMethod.contains('Tarjeta')) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa el número de tarjeta';
                                    }
                                    if (value.replaceAll(RegExp(r'\s+'), '').length < 13) {
                                      return 'Número de tarjeta inválido';
                                    }
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _cardHolderController,
                                decoration: const InputDecoration(
                                  labelText: 'Titular de la Tarjeta',
                                  hintText: 'Nombre como aparece en la tarjeta',
                                ),
                                validator: (value) {
                                  if (_selectedPaymentMethod.contains('Tarjeta')) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa el nombre del titular';
                                    }
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _expiryDateController,
                                      decoration: const InputDecoration(
                                        labelText: 'Vencimiento',
                                        hintText: 'MM/AA',
                                      ),
                                      validator: (value) {
                                        if (_selectedPaymentMethod.contains('Tarjeta')) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor ingresa la fecha de vencimiento';
                                          }
                                          if (!RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$').hasMatch(value)) {
                                            return 'Fecha inválida (MM/AA)';
                                          }
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _cvvController,
                                      decoration: const InputDecoration(
                                        labelText: 'CVV',
                                        hintText: '123',
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (_selectedPaymentMethod.contains('Tarjeta')) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor ingresa el CVV';
                                          }
                                          if (value.length < 3 || value.length > 4) {
                                            return 'CVV inválido';
                                          }
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        else if (_selectedPaymentMethod == 'Wompi')
                          // Wompi payment instructions
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.surface.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Instrucciones de pago con Wompi:',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '1. Se te redirigirá a la pasarela de pagos de Wompi\n2. Sigue las instrucciones para completar tu pago\n3. Regresa a la aplicación para confirmar tu pedido',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: colorScheme.onSurface.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else if (_selectedPaymentMethod == 'WhatsApp')
                          // WhatsApp payment instructions
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.surface.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Instrucciones de pago por WhatsApp:',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '1. Envíanos un mensaje por WhatsApp con tu número de pedido\n2. Confirma los detalles de tu compra\n3. Te enviaremos las instrucciones para completar el pago',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: colorScheme.onSurface.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else if (_selectedPaymentMethod == 'Contra Entrega')
                          // Contra entrega information
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.surface.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pago contra entrega:',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '1. Recibirás tu pedido en la dirección indicada\n2. Paga directamente al momento de recibir tu compra\n3. El monto total será el que aparece en el resumen del pedido',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: colorScheme.onSurface.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(), // Empty container for other payment methods
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Order Summary Section
                Text(
                  'Resumen del Pedido',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cart.items.length,
                          itemBuilder: (context, index) {
                            final item = cart.items[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.name,
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                        Text(
                                          '${item.quantity} x \$${item.product.price.toStringAsFixed(0)}',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: colorScheme.onSurface.withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '\$${item.totalPrice.toStringAsFixed(0)}',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total:',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              '\$${cart.totalAmount.toStringAsFixed(0)}',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Checkout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Process payment first, then place order
                        _processPaymentAndPlaceOrder(
                          cart,
                          orderProvider,
                          _nameController.text,
                          _emailController.text,
                          _phoneController.text,
                          _addressController.text,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Proceder al Pago'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _processPaymentAndPlaceOrder(
    CartProvider cart,
    OrderProvider orderProvider,
    String name,
    String email,
    String phone,
    String address,
  ) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 20),
                  Text(
                    'Procesando pago...',
                    style: GoogleFonts.inter(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      );

      // Process the payment
      bool paymentSuccess = await PaymentService.processPayment(
        amount: cart.totalAmount,
        paymentMethod: _selectedPaymentMethod,
        customerId: DateTime.now().millisecondsSinceEpoch.toString(), // Using timestamp as customer ID for demo
        customerEmail: _emailController.text,
        customerName: _nameController.text,
        customerPhone: _phoneController.text,
        customerAddress: _addressController.text,
        cardNumber: _selectedPaymentMethod.contains('Tarjeta') ? _cardNumberController.text : null,
        cardHolder: _selectedPaymentMethod.contains('Tarjeta') ? _cardHolderController.text : null,
        expiryDate: _selectedPaymentMethod.contains('Tarjeta') ? _expiryDateController.text : null,
        cvv: _selectedPaymentMethod.contains('Tarjeta') ? _cvvController.text : null,
      );

      // Close the loading dialog
      if (mounted) {
        Navigator.of(context).pop(); // Dismiss the loading dialog
      }

      // For contra entrega, WhatsApp, and Wompi, we consider the order as pending until payment is completed
      String orderStatus = 'pending';
      if (_selectedPaymentMethod.contains('Tarjeta') || _selectedPaymentMethod == 'Efectivo' || _selectedPaymentMethod == 'Transferencia Bancaria' || _selectedPaymentMethod == 'PayPal') {
        orderStatus = paymentSuccess ? 'completed' : 'cancelled';
      } else {
        // For Contra Entrega, WhatsApp, and Wompi, the status remains pending until payment completion
        orderStatus = 'pending';
      }

      if (paymentSuccess || 
          _selectedPaymentMethod == 'Contra Entrega' || 
          _selectedPaymentMethod == 'WhatsApp' || 
          _selectedPaymentMethod == 'Wompi') {
        // Create a unique order ID
        final orderId = DateTime.now().millisecondsSinceEpoch.toString();
        
        // Create a new order
        final order = Order(
          id: orderId,
          products: [...cart.items], // Copy the cart items
          amount: cart.totalAmount,
          dateTime: DateTime.now(),
          customerName: name,
          customerEmail: email,
          customerPhone: phone,
          customerAddress: address,
          status: orderStatus, // Set appropriate status based on payment method
        );

        // Try to save the order to backend
        try {
          await orderProvider.saveOrderToBackend(order);
        } catch (e) {
          print('Error saving order to backend: $e');
          // Even if backend save fails, still add to local provider
          orderProvider.addOrder(order);
        }

        // Clear the cart after successful order placement
        cart.clear();

        // Show success message
        if (mounted) {
          String successMessage = '¡Pedido realizado con éxito!';
          if (_selectedPaymentMethod == 'Contra Entrega') {
            successMessage = '¡Pedido realizado con éxito! Recibirás tu pedido en la dirección indicada y podrás pagar contra entrega.';
          } else if (_selectedPaymentMethod == 'WhatsApp') {
            successMessage = '¡Pedido realizado con éxito! Te contactaremos por WhatsApp para completar el proceso de pago.';
          } else if (_selectedPaymentMethod == 'Wompi') {
            successMessage = '¡Pedido realizado con éxito! Serás redirigido a la pasarela de pago de Wompi para completar tu compra.';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(successMessage),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate back to home screen
          Navigator.pop(context); // Go back from checkout screen
          Navigator.pop(context); // Go back to home screen
        }
      } else {
        // Show payment failed message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error en el pago, por favor intenta de nuevo'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Close the loading dialog if it's still open
      if (mounted) {
        Navigator.of(context).pop(); // Dismiss the loading dialog
      }
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al procesar el pedido: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}