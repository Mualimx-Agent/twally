import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_constants.dart';
import '../../theme/app_colors.dart';
import '../../models/order_model.dart';

/// Status labels in Arabic
String _statusLabelAr(String status) {
  switch (status) {
    case 'pending':
      return 'قيد الانتظار';
    case 'confirmed':
      return 'تم التأكيد';
    case 'preparing':
      return 'جاري التحضير';
    case 'ready':
      return 'الطلب جاهز';
    case 'delivering':
      return 'في الطريق';
    case 'completed':
      return 'تم التوصيل';
    case 'cancelled':
      return 'ملغي';
    default:
      return status;
  }
}

/// Status color
Color _statusColor(String status) {
  switch (status) {
    case 'pending':
      return AppColors.statusPending;
    case 'confirmed':
      return AppColors.statusConfirmed;
    case 'preparing':
      return AppColors.statusPreparing;
    case 'ready':
    case 'delivering':
      return AppColors.statusDelivering;
    case 'completed':
      return AppColors.statusCompleted;
    case 'cancelled':
      return AppColors.statusCancelled;
    default:
      return AppColors.textHint;
  }
}

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  bool _isLoading = false;

  /// Sample orders for UI demonstration
  final List<OrderModel> _orders = [
    OrderModel(
      id: 'o1',
      orderNumber: 'TW-20260815-0001',
      userId: 'u1',
      restaurantId: 'r1',
      items: [],
      subtotal: 12.0,
      deliveryFee: 3.0,
      total: 15.0,
      paymentMethod: 'cod',
      orderStatus: 'delivering',
      deliveryAddress: OrderAddress(street: 'شارع النيل', district: 'الرياض', city: 'الخرطوم'),
      customerPhone: '0912345678',
      customerName: 'أحمد',
      createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
    ),
    OrderModel(
      id: 'o2',
      orderNumber: 'TW-20260814-0003',
      userId: 'u1',
      restaurantId: 'r2',
      items: [],
      subtotal: 18.0,
      deliveryFee: 3.0,
      total: 21.0,
      paymentMethod: 'mobile_money',
      orderStatus: 'completed',
      deliveryAddress: OrderAddress(street: 'شارع الجمهورية', district: 'العمارات', city: 'الخرطوم'),
      customerPhone: '0912345678',
      customerName: 'أحمد',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      estimatedDeliveryTime: DateTime.now().subtract(const Duration(days: 1)).add(const Duration(minutes: 35)),
      actualDeliveryTime: DateTime.now().subtract(const Duration(days: 1)).add(const Duration(minutes: 40)),
    ),
    OrderModel(
      id: 'o3',
      orderNumber: 'TW-20260813-0007',
      userId: 'u1',
      restaurantId: 'r3',
      items: [],
      subtotal: 8.5,
      deliveryFee: 3.0,
      total: 11.5,
      paymentMethod: 'cod',
      orderStatus: 'cancelled',
      deliveryAddress: OrderAddress(street: 'شارع المطار', district: 'أمدرمان', city: 'أمدرمان'),
      customerPhone: '0912345678',
      customerName: 'أحمد',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      cancellationReason: 'تأخير في التوصيل',
    ),
    OrderModel(
      id: 'o4',
      orderNumber: 'TW-20260812-0002',
      userId: 'u1',
      restaurantId: 'r1',
      items: [],
      subtotal: 25.0,
      deliveryFee: 3.0,
      total: 28.0,
      paymentMethod: 'cod',
      orderStatus: 'completed',
      deliveryAddress: OrderAddress(street: 'شارع النيل', district: 'الرياض', city: 'الخرطوم'),
      customerPhone: '0912345678',
      customerName: 'أحمد',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      estimatedDeliveryTime: DateTime.now().subtract(const Duration(days: 3)).add(const Duration(minutes: 30)),
      actualDeliveryTime: DateTime.now().subtract(const Duration(days: 3)).add(const Duration(minutes: 33)),
    ),
    OrderModel(
      id: 'o5',
      orderNumber: 'TW-20260811-0008',
      userId: 'u1',
      restaurantId: 'r4',
      items: [],
      subtotal: 14.0,
      deliveryFee: 3.0,
      total: 17.0,
      paymentMethod: 'cod',
      orderStatus: 'confirmed',
      deliveryAddress: OrderAddress(street: 'شارع الوادي', district: 'بحري', city: 'بحري'),
      customerPhone: '0912345678',
      customerName: 'أحمد',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  Future<void> _refresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  String _formatDate(DateTime date) {
    final months = [
      '', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  String _restaurantName(String restaurantId) {
    const names = {
      'r1': 'مطعم الشيف',
      'r2': 'مطعم الزيتون',
      'r3': 'مطعم الريف',
      'r4': 'مطعم المذاق',
    };
    return names[restaurantId] ?? 'مطعم';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.orders)),
        body: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _refresh,
          child: _orders.isEmpty ? _buildEmptyState() : _buildList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: AppColors.textHint.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد طلبات سابقة',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    final sortedOrders = List<OrderModel>.from(_orders)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: sortedOrders.length,
      itemBuilder: (context, index) => _buildOrderCard(sortedOrders[index]),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final statusColor = _statusColor(order.orderStatus);
    final name = _restaurantName(order.restaurantId);

    return InkWell(
      onTap: () {
        if (order.orderStatus == 'cancelled' || order.orderStatus == 'completed') {
          context.go('/order_tracking', extra: {
            'orderNumber': order.orderNumber,
            'orderStatus': order.orderStatus,
          });
        } else {
          context.go('/order_tracking', extra: {
            'orderNumber': order.orderNumber,
            'orderStatus': order.orderStatus,
          });
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Order number + status badge
            Row(
              children: [
                Text(
                  '#${order.orderNumber}',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabelAr(order.orderStatus),
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Restaurant name
            Row(
              children: [
                Icon(Icons.restaurant, size: 16, color: AppColors.textHint),
                const SizedBox(width: 6),
                Text(
                  name,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Date & total
            Row(
              children: [
                Icon(Icons.date_range, size: 14, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text(
                  _formatDate(order.createdAt),
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${order.total.toStringAsFixed(1)} ${AppConstants.defaultCurrencySymbol}',
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            // Cancellation reason
            if (order.cancellationReason != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.info_outline, size: 14, color: AppColors.error),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      order.cancellationReason!,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: AppColors.error,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}