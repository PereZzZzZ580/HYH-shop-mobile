import 'package:intl/intl.dart';
import 'cart_item.dart';
import 'product.dart';

class Order {
  final String id;
  final List<CartItem> products;
  final double amount;
  final DateTime dateTime;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String customerAddress;
  final String status; // pending, completed, cancelled
  final String? userId;            // Campo adicional que puede estar en tu esquema Prisma
  final String? paymentMethod;     // Campo adicional que puede estar en tu esquema Prisma
  final String? transactionId;     // Campo adicional que puede estar en tu esquema Prisma
  final DateTime? deliveredAt;     // Campo adicional que puede estar en tu esquema Prisma
  final String? notes;             // Campo adicional que puede estar en tu esquema Prisma

  Order({
    required this.id,
    required this.products,
    required this.amount,
    required this.dateTime,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.customerAddress,
    this.status = 'pending',
    this.userId,
    this.paymentMethod,
    this.transactionId,
    this.deliveredAt,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'products': products.map((product) => {
        'product': product.product.toJson(),
        'quantity': product.quantity,
      }).toList(),
      'amount': amount,
      'dateTime': dateTime.toIso8601String(),
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'status': status,
      if (userId != null) 'userId': userId,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      if (transactionId != null) 'transactionId': transactionId,
      if (deliveredAt != null) 'deliveredAt': deliveredAt!.toIso8601String(),
      if (notes != null) 'notes': notes,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      products: (json['products'] as List).map((item) {
        return CartItem(
          product: Product.fromJson(item['product']),
          quantity: item['quantity'],
        );
      }).toList(),
      amount: (json['amount'] is int) ? (json['amount'] as int).toDouble() : json['amount'].toDouble(),
      dateTime: DateTime.parse(json['dateTime']),
      customerName: json['customerName'],
      customerEmail: json['customerEmail'],
      customerPhone: json['customerPhone'],
      customerAddress: json['customerAddress'],
      status: json['status'] ?? 'pending',
      userId: json['userId'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      transactionId: json['transactionId'] as String?,
      deliveredAt: json['deliveredAt'] != null ? DateTime.parse(json['deliveredAt']) : null,
      notes: json['notes'] as String?,
    );
  }
}