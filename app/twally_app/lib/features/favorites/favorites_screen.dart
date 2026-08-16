import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../models/restaurant_model.dart';

// Sample favorite restaurants
final _sampleFavorites = List.generate(5, (i) => RestaurantModel(
  id: 'fav_$i',
  nameAr: 'مطعم ${['الشيف', 'الزيتون', 'الريف', 'المذاق', 'الخيمة'][i]}',
  phone: '0912345678',
  address: 'الخرطوم',
  district: '${['الرياض', 'العمارات', 'السوق', 'أمدرمان', 'بحري'][i]}',
  rating: (4.0 + (i * 0.2)).clamp(0, 5.0),
  reviewCount: 100 + i * 30,
  deliveryFee: 3.0 + (i * 0.5),
  deliveryTimeMin: 25 + i * 5,
  deliveryTimeMax: 40 + i * 5,
  isFeatured: true,
  category: ['sudanese', 'middle_eastern', 'fast_food', 'pizza', 'asian'][i],
));

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  List<RestaurantModel> _favorites = List.from(_sampleFavorites);

  void _removeFavorite(RestaurantModel restaurant) {
    setState(() {
      _favorites.removeWhere((r) => r.id == restaurant.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إزالة "${restaurant.nameAr}" من المفضلة'),
        action: SnackBarAction(
          label: 'تراجع',
          textColor: AppColors.primaryLight,
          onPressed: () {
            setState(() {
              _favorites.add(restaurant);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(AppStrings.myFavorites),
        ),
        body: _favorites.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border,
                        size: 72, color: AppColors.primary.withValues(alpha: 0.4)),
                    const SizedBox(height: 20),
                    const Text(
                      'لا توجد مطاعم مفضلة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'أضف مطاعمك المفضلة هنا',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textHint,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/home'),
                      icon: const Icon(Icons.search, color: Colors.white),
                      label: const Text(
                        'تصفح المطاعم',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _favorites.length,
                itemBuilder: (context, index) {
                  final r = _favorites[index];
                  return _FavoriteRestaurantCard(
                    restaurant: r,
                    onRemove: () => _removeFavorite(r),
                    onTap: () => context.push('/restaurant_detail', extra: r),
                  );
                },
              ),
      ),
    );
  }
}

class _FavoriteRestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _FavoriteRestaurantCard({
    required this.restaurant,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 90,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius:
                    const BorderRadius.horizontal(right: Radius.circular(12)),
              ),
              child: Center(
                child: Icon(Icons.restaurant,
                    size: 36, color: AppColors.primary.withValues(alpha: 0.5)),
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    restaurant.nameAr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          size: 14, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Text(
                        restaurant.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${restaurant.reviewCount})',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.access_time,
                          size: 12, color: AppColors.textHint),
                      const SizedBox(width: 2),
                      Text(
                        '${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} ${AppStrings.mins}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 12, color: AppColors.textHint),
                      const SizedBox(width: 2),
                      Text(
                        '${restaurant.district}، ${restaurant.city}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            // Remove favorite button
            GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.favorite,
                  color: AppColors.error,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}