import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../models/review_model.dart';
import '../../models/order_model.dart';

// Sample completed orders for review
final _sampleOrdersToReview = List.generate(3, (i) => OrderModel(
  id: 'ord_${i + 1}',
  orderNumber: 'TW-20250815-${1000 + i}',
  userId: 'user_1',
  restaurantId: 'r$i',
  items: [
    OrderItem(
      menuItemId: 'm${i}_1',
      nameAr: 'وجبة ${['شاورما', 'مندي', 'برجر'][i]}',
      quantity: 1,
      price: 15.0,
      subtotal: 15.0,
    ),
  ],
  subtotal: 15.0,
  deliveryFee: 3.0,
  serviceFee: 1.0,
  total: 19.0,
  paymentMethod: 'cod',
  paymentStatus: 'paid',
  orderStatus: 'completed',
  deliveryAddress: OrderAddress(
    street: 'شارع 15',
    district: 'الرياض',
    city: 'الخرطوم',
    lat: 15.5007,
    lng: 32.5599,
  ),
  customerPhone: '+249912345678',
  customerName: 'أحمد محمد',
  createdAt: DateTime.now().subtract(Duration(days: i + 1)),
));

class ReviewsScreen extends ConsumerStatefulWidget {
  const ReviewsScreen({super.key});

  @override
  ConsumerState<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends ConsumerState<ReviewsScreen> {
  List<OrderModel> _ordersToReview = List.from(_sampleOrdersToReview);
  final List<ReviewModel> _submittedReviews = [];

  // Current review being written
  String? _reviewingOrderId;
  int _rating = 5;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _startReview(String orderId) {
    setState(() {
      _reviewingOrderId = orderId;
      _rating = 5;
      _commentController.clear();
    });
  }

  void _cancelReview() {
    setState(() {
      _reviewingOrderId = null;
      _commentController.clear();
    });
  }

  void _submitReview() {
    if (_reviewingOrderId == null) return;

    final order = _ordersToReview.firstWhere(
      (o) => o.id == _reviewingOrderId,
      orElse: () => _ordersToReview.first,
    );

    final review = ReviewModel(
      id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
      orderId: _reviewingOrderId!,
      userId: 'user_1',
      restaurantId: order.restaurantId,
      rating: _rating,
      comment: _commentController.text.trim(),
    );

    setState(() {
      _submittedReviews.add(review);
      _ordersToReview.removeWhere((o) => o.id == _reviewingOrderId);
      _reviewingOrderId = null;
      _commentController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إرسال التقييم بنجاح ✓'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isReviewing = _reviewingOrderId != null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(isReviewing ? AppStrings.rateOrder : AppStrings.reviews),
          leading: isReviewing
              ? IconButton(
                  icon: const Icon(Icons.close, size: 22),
                  onPressed: _cancelReview,
                )
              : IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: () => context.pop(),
                ),
        ),
        body: isReviewing ? _buildReviewForm() : _buildOrdersList(),
      ),
    );
  }

  Widget _buildOrdersList() {
    if (_ordersToReview.isEmpty && _submittedReviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rate_review_outlined,
                size: 72, color: AppColors.textHint.withValues(alpha: 0.4)),
            const SizedBox(height: 20),
            const Text(
              'لا توجد تقييمات بعد',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'بعد إتمام طلبك، يمكنك تقييم المطعم',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Pending reviews
        if (_ordersToReview.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'طلبات تحتاج تقييم',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          ..._ordersToReview.map((order) => _OrderReviewCard(
                order: order,
                onRate: () => _startReview(order.id),
              )),
        ],

        // Submitted reviews
        if (_submittedReviews.isNotEmpty) ...[
          if (_ordersToReview.isNotEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(color: AppColors.divider),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'تقييماتي السابقة',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          ..._submittedReviews.map((review) => _SubmittedReviewCard(
                review: review,
              )),
        ],
      ],
    );
  }

  Widget _buildReviewForm() {
    final order = _ordersToReview.firstWhere(
      (o) => o.id == _reviewingOrderId,
      orElse: () => _ordersToReview.first,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Restaurant icon
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: const Icon(Icons.restaurant,
                size: 36, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            order.items.isNotEmpty ? order.items.first.nameAr : '',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            '#${order.orderNumber}',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 32),

          // Star rating
          const Text(
            AppStrings.rateOrder,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              return GestureDetector(
                onTap: () => setState(() => _rating = starIndex),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    starIndex <= _rating
                        ? Icons.star
                        : Icons.star_border,
                    size: 44,
                    color: starIndex <= _rating
                        ? AppColors.warning
                        : AppColors.textHint,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            _getRatingLabel(_rating),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),

          // Comment field
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppStrings.writeReview,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _commentController,
            textDirection: TextDirection.rtl,
            maxLines: 4,
            maxLength: 500,
            decoration: const InputDecoration(
              hintText: 'اكتب تعليقك عن الطلب...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _submitReview,
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              label: const Text(
                AppStrings.submitReview,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'سيء جداً';
      case 2:
        return 'سيء';
      case 3:
        return 'متوسط';
      case 4:
        return 'جيد';
      case 5:
        return 'ممتاز';
      default:
        return '';
    }
  }
}

class _OrderReviewCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onRate;

  const _OrderReviewCard({
    required this.order,
    required this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.receipt_long,
                  color: AppColors.secondary, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.items.isNotEmpty ? order.items.first.nameAr : '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '#${order.orderNumber}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${order.total.toStringAsFixed(0)} ج.س',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onRate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('قيم'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmittedReviewCard extends StatelessWidget {
  final ReviewModel review;

  const _SubmittedReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      i < review.rating ? Icons.star : Icons.star_border,
                      size: 18,
                      color: i < review.rating
                          ? AppColors.warning
                          : AppColors.textHint,
                    );
                  }),
                ),
                const Spacer(),
                Text(
                  _formatDate(review.createdAt),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
            if (review.comment.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                review.comment,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}