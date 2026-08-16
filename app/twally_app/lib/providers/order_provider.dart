import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  OrderModel? _currentOrder;

  List<OrderModel> get orders => _orders;
  OrderModel? get currentOrder => _currentOrder;

  /// Simuliert das Aufgeben einer Bestellung
  Future<void> placeOrder(OrderModel order) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _currentOrder = order;
    _orders.insert(0, order);
    _isLoading = false;
    notifyListeners();
  }

  /// Simuliert das Stornieren einer Bestellung
  Future<void> cancelOrder(String orderId, {String? reason}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(
        orderStatus: 'cancelled',
        cancellationReason: reason,
      );
      if (_currentOrder?.id == orderId) {
        _currentOrder = _orders[index];
      }
      notifyListeners();
    }
  }

  /// Aktualisiert den Status einer Bestellung
  void updateOrderStatus(String orderId, String status) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(
        orderStatus: status,
        updatedAt: DateTime.now(),
      );
      if (_currentOrder?.id == orderId) {
        _currentOrder = _orders[index];
      }
      notifyListeners();
    }
  }

  // ====================================================================
  //  INTERNER STATE
  // ====================================================================

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Initialisiert Demo-Bestellungen
  void initDemoOrders() {
    if (_orders.isNotEmpty) return;

    final now = DateTime.now();

    _orders = [
      OrderModel(
        id: 'ord_hist_1',
        orderNumber: 'TW-${now.year}${_pad(now.month)}${_pad(now.day)}-0001',
        userId: 'user_1',
        restaurantId: 'r1',
        items: [
          OrderItem(
            menuItemId: 'm1_1',
            nameAr: 'فول مدمس',
            quantity: 2,
            price: 3.5,
            subtotal: 7.0,
          ),
          OrderItem(
            menuItemId: 'm1_2',
            nameAr: 'فلافل',
            quantity: 1,
            price: 2.0,
            subtotal: 2.0,
          ),
        ],
        subtotal: 9.0,
        deliveryFee: 2.5,
        serviceFee: 1.0,
        total: 12.5,
        paymentMethod: 'cod',
        paymentStatus: 'paid',
        orderStatus: 'completed',
        deliveryAddress: OrderAddress(
          street: 'شارع 15',
          district: 'الرياض',
          city: 'Khartoum',
          lat: 15.6009,
          lng: 32.5327,
          notes: 'بجانب المسجد',
        ),
        customerPhone: '0912345678',
        customerName: 'أحمد محمد',
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 3)),
        estimatedDeliveryTime: now.subtract(const Duration(days: 3)).add(const Duration(minutes: 30)),
        actualDeliveryTime: now.subtract(const Duration(days: 3)).add(const Duration(minutes: 28)),
      ),
      OrderModel(
        id: 'ord_hist_2',
        orderNumber: 'TW-${now.year}${_pad(now.month)}${_pad(now.day)}-0002',
        userId: 'user_1',
        restaurantId: 'r5',
        items: [
          OrderItem(
            menuItemId: 'm5_1',
            nameAr: 'كباب',
            quantity: 1,
            price: 18.0,
            subtotal: 18.0,
          ),
          OrderItem(
            menuItemId: 'm5_3',
            nameAr: 'كفتة',
            quantity: 1,
            price: 14.0,
            subtotal: 14.0,
          ),
        ],
        subtotal: 32.0,
        deliveryFee: 4.0,
        serviceFee: 2.0,
        total: 38.0,
        paymentMethod: 'mobile_money',
        paymentStatus: 'paid',
        orderStatus: 'completed',
        deliveryAddress: OrderAddress(
          street: 'شارع المطار',
          district: 'الخرطوم 2',
          city: 'Khartoum',
          lat: 15.5898,
          lng: 32.5530,
        ),
        customerPhone: '0912345678',
        customerName: 'أحمد محمد',
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 7)),
        estimatedDeliveryTime: now.subtract(const Duration(days: 7)).add(const Duration(minutes: 45)),
        actualDeliveryTime: now.subtract(const Duration(days: 7)).add(const Duration(minutes: 40)),
      ),
      OrderModel(
        id: 'ord_hist_3',
        orderNumber: 'TW-${now.year}${_pad(now.month)}${_pad(now.day)}-0003',
        userId: 'user_1',
        restaurantId: 'r10',
        items: [
          OrderItem(
            menuItemId: 'm10_1',
            nameAr: 'مندي لحم',
            quantity: 1,
            price: 16.0,
            subtotal: 16.0,
          ),
        ],
        subtotal: 16.0,
        deliveryFee: 3.5,
        serviceFee: 1.0,
        total: 20.5,
        paymentMethod: 'cod',
        paymentStatus: 'pending',
        orderStatus: 'cancelled',
        deliveryAddress: OrderAddress(
          street: 'شارع النيل',
          district: 'برّي',
          city: 'Khartoum',
          lat: 15.6100,
          lng: 32.5400,
        ),
        customerPhone: '0912345678',
        customerName: 'أحمد محمد',
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 10)),
        cancellationReason: 'تأخر التوصيل',
      ),
    ];
  }

  String _pad(int n) => n.toString().padLeft(2, '0');
}