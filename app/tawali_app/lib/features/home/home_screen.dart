import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../models/restaurant_model.dart';

// Sample data for UI demonstration
final _featuredRestaurants = List.generate(5, (i) => RestaurantModel(
  id: 'r$i',
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

final _allRestaurants = List.generate(10, (i) => RestaurantModel(
  id: 'a$i',
  nameAr: 'مطعم ${['نجم', 'سدرة', 'بساتين', 'كنافة', 'مندي', 'شاورما', 'فطائر', 'سمك', 'دجاج', 'مشاوي'][i]}',
  phone: '0912345678',
  address: 'الخرطوم',
  district: '${['الرياض', 'العمارات', 'السوق', 'أمدرمان', 'بحري', 'الخرطوم', 'الثورة', 'الكلاكلة', 'بربري', 'الحاج يوسف'][i]}',
  rating: (3.5 + (i * 0.15)).clamp(0, 5.0),
  reviewCount: 50 + i * 20,
  deliveryFee: 2.0 + (i * 0.3),
  deliveryTimeMin: 20 + i * 3,
  deliveryTimeMax: 35 + i * 5,
  isFeatured: false,
  category: ['sudanese', 'middle_eastern', 'fast_food', 'pizza', 'asian', 'dessert', 'cafe', 'other', 'sudanese', 'fast_food'][i],
));

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isLoading = false;
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _loadData,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // App Bar
            SliverAppBar(
              pinned: false,
              floating: true,
              backgroundColor: AppColors.background,
              elevation: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt, color: AppColors.primary, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        AppStrings.appNameAr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${AppStrings.deliverTo}: الخرطوم',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textHint),
                    ],
                  ),
                ),
              ),
            ),
            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Navigator.of(context).pushNamed('/search'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: AppColors.textHint, size: 22),
                        const SizedBox(width: 12),
                        Text(
                          AppStrings.searchRestaurants,
                          style: const TextStyle(
                            color: AppColors.textHint,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Categories
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        AppStrings.categories,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: AppConstants.categories.length + 1,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return _CategoryChip(
                              label: 'الكل',
                              icon: Icons.all_inclusive,
                              isSelected: _selectedCategory.isEmpty,
                              onTap: () => setState(() => _selectedCategory = ''),
                            );
                          }
                          final entry = AppConstants.categories.entries.elementAt(index - 1);
                          final iconMap = <String, IconData>{
                            'sudanese': Icons.restaurant,
                            'middle_eastern': Icons.room_service,
                            'fast_food': Icons.fastfood,
                            'pizza': Icons.local_pizza,
                            'asian': Icons.ramen_dining,
                            'dessert': Icons.cake,
                            'cafe': Icons.coffee,
                            'other': Icons.more_horiz,
                          };
                          return _CategoryChip(
                            label: entry.value,
                            icon: iconMap[entry.key] ?? Icons.restaurant,
                            isSelected: _selectedCategory == entry.key,
                            onTap: () => setState(() => _selectedCategory = entry.key),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Featured restaurants
            if (!_isLoading) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Text(
                    AppStrings.featured,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _featuredRestaurants.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final r = _featuredRestaurants[index];
                      return _FeaturedCard(restaurant: r);
                    },
                  ),
                ),
              ),
            ],
            // All restaurants
            if (!_isLoading) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Row(
                    children: [
                      Text(
                        AppStrings.allRestaurants,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${_allRestaurants.length} مطعم',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final r = _allRestaurants[index];
                    return _RestaurantListItem(restaurant: r);
                  },
                  childCount: _allRestaurants.length,
                ),
              ),
            ],
            // Loading shimmer
            if (_isLoading) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Column(
                      children: List.generate(6, (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      )),
                    ),
                  ),
                ),
              ),
            ],
            // Bottom padding for nav bar
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: AppStrings.orders,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}

// Category Chip
class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Featured restaurant card
class _FeaturedCard extends StatelessWidget {
  final RestaurantModel restaurant;

  const _FeaturedCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/restaurant_detail', arguments: restaurant),
      child: Container(
        width: 220,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover placeholder
            Container(
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(
                child: Icon(Icons.restaurant, size: 40, color: AppColors.primary.withValues(alpha: 0.5)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.nameAr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Text(
                        restaurant.rating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${restaurant.reviewCount})',
                        style: const TextStyle(fontSize: 11, color: AppColors.textHint),
                      ),
                      const Spacer(),
                      Icon(Icons.access_time, size: 12, color: AppColors.textHint),
                      const SizedBox(width: 2),
                      Text(
                        '${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} ${AppStrings.mins}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Restaurant list item
class _RestaurantListItem extends StatelessWidget {
  final RestaurantModel restaurant;

  const _RestaurantListItem({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/restaurant_detail', arguments: restaurant),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.restaurant, size: 30, color: AppColors.secondary.withValues(alpha: 0.5)),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.nameAr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: AppColors.warning),
                      const SizedBox(width: 3),
                      Text(
                        restaurant.rating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${restaurant.reviewCount})',
                        style: const TextStyle(fontSize: 11, color: AppColors.textHint),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.access_time, size: 12, color: AppColors.textHint),
                      const SizedBox(width: 2),
                      Text(
                        '${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMax} ${AppStrings.mins}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 12, color: AppColors.textHint),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          '${restaurant.district}، ${restaurant.city}',
                          style: const TextStyle(fontSize: 11, color: AppColors.textHint),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${AppStrings.deliveryFee}: ${restaurant.deliveryFee.toStringAsFixed(0)} ${AppConstants.defaultCurrencySymbol}',
                        style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}