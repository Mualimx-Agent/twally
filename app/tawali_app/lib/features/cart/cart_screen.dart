import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_constants.dart';
import '../../theme/app_colors.dart';
import '../../models/menu_item_model.dart';

/// Internal cart item model used by the cart screen.
class CartItemDisplay {
  final MenuItemModel menuItem;
  final int quantity;
  final double price;

  CartItemDisplay({
    required this.menuItem,
    required this.quantity,
    required this.price,
  });

  double get subtotal => price * quantity;
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  /// Sample cart items for UI demonstration
  final List<CartItemDisplay> _items = [
    CartItemDisplay(
      menuItem: MenuItemModel(
        id: 'm1',
        restaurantId: 'r1',
        nameAr: 'شاورما دجاج',
        price: 5.0,
        imageUrl: null,
        category: 'main',
      ),
      quantity: 2,
      price: 5.0,
    ),
    CartItemDisplay(
      menuItem: MenuItemModel(
        id: 'm2',
        restaurantId: 'r1',
        nameAr: 'بطاطس مقلي',
        price: 2.5,
        imageUrl: null,
        category: 'side',
      ),
      quantity: 1,
      price: 2.5,
    ),
    CartItemDisplay(
      menuItem: MenuItemModel(
        id: 'm3',
        restaurantId: 'r1',
        nameAr: 'مشروب غازي',
        price: 1.5,
        imageUrl: null,
        category: 'drink',
      ),
      quantity: 2,
      price: 1.5,
    ),
  ];

  double get _subtotal => _items.fold(0, (sum, item) => sum + item.subtotal);
  double get _deliveryFee => AppConstants.defaultDeliveryFee;
  double get _total => _subtotal + _deliveryFee;

  void _incrementQuantity(int index) {
    setState(() {
      final item = _items[index];
      _items[index] = CartItemDisplay(
        menuItem: item.menuItem,
        quantity: item.quantity + 1,
        price: item.price,
      );
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      final item = _items[index];
      if (item.quantity > 1) {
        _items[index] = CartItemDisplay(
          menuItem: item.menuItem,
          quantity: item.quantity - 1,
          price: item.price,
        );
      } else {
        _items.removeAt(index);
      }
    });
  }

  void _removeItem(int index) {
    setState(() => _items.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حذف العنصر')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.cart)),
        body: _items.isEmpty ? _buildEmptyState() : _buildCartContent(),
        bottomNavigationBar: _items.isEmpty ? null : _buildBottomBar(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: AppColors.textHint.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            AppStrings.cartEmpty,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أضف وجباتك المفضلة من المطاعم',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _items.length,
            itemBuilder: (context, index) => _buildCartItemCard(index),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItemCard(int index) {
    final item = _items[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Item image placeholder
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.fastfood,
              size: 28,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(width: 12),
          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.menuItem.nameAr,
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.price.toStringAsFixed(1)} ${AppConstants.defaultCurrencySymbol}',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 6),
                // Quantity controls
                Row(
                  children: [
                    _buildQuantityButton(
                      icon: Icons.add,
                      onTap: () => _incrementQuantity(index),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${item.quantity}',
                      style: GoogleFonts.cairo(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildQuantityButton(
                      icon: Icons.remove,
                      onTap: () => _decrementQuantity(index),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Price and delete
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                onPressed: () => _removeItem(index),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 20,
              ),
              const SizedBox(height: 8),
              Text(
                '${item.subtotal.toStringAsFixed(1)} ${AppConstants.defaultCurrencySymbol}',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Summary
            _buildSummaryRow(AppStrings.subtotal, _subtotal),
            const SizedBox(height: 6),
            _buildSummaryRow(AppStrings.deliveryFee, _deliveryFee),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(),
            ),
            _buildSummaryRow(AppStrings.total, _total, isTotal: true),
            const SizedBox(height: 16),
            // Checkout button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to checkout via go_router
                  GoRouter.of(context).push('/checkout');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  AppStrings.checkout,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isTotal = false}) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        Text(
          '${value.toStringAsFixed(1)} ${AppConstants.defaultCurrencySymbol}',
          style: GoogleFonts.cairo(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}