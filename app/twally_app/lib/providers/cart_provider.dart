import 'package:flutter/material.dart';
import '../models/menu_item_model.dart';

/// Ein einzelner Artikel im Warenkorb
class CartItem {
  final MenuItemModel item;
  int quantity;

  CartItem({
    required this.item,
    this.quantity = 1,
  });

  double get total => item.price * quantity;

  Map<String, dynamic> toJson() => {
        'menu_item': item.toJson(),
        'quantity': quantity,
      };
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {}; // key = menuItemId

  /// Gibt eine unveränderliche Liste der Warenkorb-Artikel zurück
  List<CartItem> get cartItems => _items.values.toList(growable: false);

  /// Gesamtanzahl aller Artikel im Warenkorb
  int get itemCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  /// Zwischensumme (ohne Liefergebühr)
  double get subtotal =>
      _items.values.fold(0.0, (sum, item) => sum + item.total);

  /// Standard-Liefergebühr (wird später vom Restaurant überschrieben)
  double get deliveryFee => subtotal > 0 ? 3.0 : 0.0;

  /// Gesamtsumme (Zwischensumme + Liefergebühr)
  double get total => subtotal + deliveryFee;

  /// Fügt einen Artikel hinzu oder erhöht die Menge, falls bereits vorhanden
  void addItem(MenuItemModel item) {
    if (_items.containsKey(item.id)) {
      _items[item.id]!.quantity++;
    } else {
      _items[item.id] = CartItem(item: item);
    }
    notifyListeners();
  }

  /// Entfernt einen Artikel vollständig aus dem Warenkorb
  void removeItem(String menuItemId) {
    _items.remove(menuItemId);
    notifyListeners();
  }

  /// Aktualisiert die Menge eines Artikels.
  /// Entfernt den Artikel, wenn quantity <= 0.
  void updateQuantity(String menuItemId, int quantity) {
    if (!_items.containsKey(menuItemId)) return;

    if (quantity <= 0) {
      _items.remove(menuItemId);
    } else {
      _items[menuItemId]!.quantity = quantity;
    }
    notifyListeners();
  }

  /// Leert den gesamten Warenkorb
  void clear() {
    _items.clear();
    notifyListeners();
  }
}