import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../services/api_service.dart';
import 'package:dio/dio.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  int get ordersCount {
    return _orders.length;
  }

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  void addOrder(Order order) {
    _orders.insert(0, order); // Insert at the beginning to show latest orders first
    notifyListeners();
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex >= 0) {
      _orders[orderIndex] = Order(
        id: _orders[orderIndex].id,
        products: _orders[orderIndex].products,
        amount: _orders[orderIndex].amount,
        dateTime: _orders[orderIndex].dateTime,
        customerName: _orders[orderIndex].customerName,
        customerEmail: _orders[orderIndex].customerEmail,
        customerPhone: _orders[orderIndex].customerPhone,
        customerAddress: _orders[orderIndex].customerAddress,
        status: newStatus,
      );
      notifyListeners();
    }
  }

  List<Order> getOrdersByStatus(String status) {
    return _orders.where((order) => order.status == status).toList();
  }

  List<Order> getCompletedOrders() {
    return _orders.where((order) => order.status == 'completed').toList();
  }

  List<Order> getPendingOrders() {
    return _orders.where((order) => order.status == 'pending').toList();
  }
  
  // Load orders from backend
  Future<void> loadOrdersFromBackend(String userId) async {
    try {
      final response = await ApiService.getUserOrders(userId);
      if (response.statusCode == 200) {
        final List<dynamic> ordersData = response.data;
        _orders.clear();
        for (final orderData in ordersData) {
          _orders.add(Order.fromJson(orderData));
        }
        notifyListeners();
      }
    } on DioException catch (e) {
      throw Exception('Error fetching orders from backend: ${e.message}');
    }
  }
  
  // Save order to backend
  Future<void> saveOrderToBackend(Order order) async {
    try {
      final orderData = order.toJson();
      final response = await ApiService.createOrder(orderData);
      if (response.statusCode == 201) {
        // Add to local list if successful
        _orders.insert(0, order);
        notifyListeners();
      }
    } on DioException catch (e) {
      throw Exception('Error saving order to backend: ${e.message}');
    }
  }
  
  // Initialize or refresh orders from backend
  Future<void> initializeOrders(String userId) async {
    await loadOrdersFromBackend(userId);
  }
}