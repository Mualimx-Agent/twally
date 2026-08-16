import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../models/restaurant_model.dart';
import '../../models/menu_item_model.dart';
import '../../models/review_model.dart';

// Sample menu items
final _sampleMenuItems = <String, List<MenuItemModel>>{
  'مقبلات': List.generate(3, (i) => MenuItemModel(
    id: 'a$i',
    restaurantId: 'demo',
    nameAr: '${['شوربة عدس', 'سلطة خضراء', 'حمص'][i]}',
    descriptionAr: '${['شوربة عدس بالكمون', 'سلطة خضراء طازجة', 'حمص بالطحينة'][i]}',
    price: 5.0 + (i * 2.0),
    category: 'appetizer',
    isPopular: i == 0,
  )),
  'الوجبة الرئيسية': List.generate(4, (i) => MenuItemModel(
    id: 'b$i',
    restaurantId: 'demo',
    nameAr: '${['كبسة دجاج', 'مندي لحم', 'باستا ألفريدو', 'شاورما'][i]}',
    descriptionAr: '${['كبسة دجاج مع أرز بسمتي', 'مندي لحم ضاني', 'باستا ألفريدو بالدجاج', 'شاورما دجاج مع ثوم'][i]}',
    price: 12.0 + (i * 4.0),
    category: 'main',
    isPopular: i < 2,
  )),
  'مشروبات': List.generate(2, (i) => MenuItemModel(
    id: 'c$i',
    restaurantId: 'demo',
    nameAr: '${['عصير مانجو', 'مياه غازية'][i]}',
    descriptionAr: '${['عصير مانجو طبيعي', 'مياه غازية مثلجة'][i]}',
    price: 3.0 + (i * 2.0),
    category: 'drink',
  )),
  'حلويات': List.generate(2, (i) => MenuItemModel(
    id: 'd$i',
    restaurantId: 'demo',
    nameAr: '${['كنافة بالقشطة', 'أم علي'][i]}',
    descriptionAr: '${['كنافة نابلسية بالقشطة', 'أم علي بالمكسرات'][i]}',
    price: 8.0 + (i * 3.0),
    category: 'dessert',
  )),
};

final _sampleReviews = List.generate(5, (i) => ReviewModel(
  id: 'rev$i',
  orderId: 'ord$i',
  userId: 'user$i',
  restaurantId: 'demo',
  rating: 4 + (i % 2),
  comment: [
    'ممتاز جداً، الأكل طيب والتوصيل سريع',
    'مطعم رائع، أنصح به الجميع',
    'جيد ولكن التأخير كان مزعج قليلاً',
    'الأكل لذيذ والتعبئة ممتازة',
    'أفضل مطعم في الخرطوم بلا منازع',
  ][i],
));

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final RestaurantModel restaurant;

  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  ConsumerState<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends ConsumerState<RestaurantDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedMenuCategory = '';
  int _cartCount = 0;
  double _cartTotal = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedMenuCategory = _sampleMenuItems.keys.first;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addToCart(MenuItemModel item) {
    setState(() {
      _cartCount++;
      _cartTotal += item.price;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.nameAr}: ${AppStrings.addedToCart}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.restaurant;
    final menuCategories = _sampleMenuItems.keys.toList();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // AppBar with cover image
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              backgroundColor: AppColors.background,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Cover image placeholder
                    Container(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      child: Center(
                        child: Icon(
                          Icons.restaurant,
                          size: 80,
                          color: AppColors.primary.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.black.withValues(alpha: 0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    // Info overlay
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Logo
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              Icons.restaurant,
                              color: AppColors.primary.withValues(alpha: 0.6),
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.nameAr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star, size: 16, color: AppColors.warning),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${r.rating.toStringAsFixed(1)}',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '(${r.reviewCount})',
                                      style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(Icons.access_time, size: 14, color: Colors.white.withValues(alpha: 0.8)),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${r.deliveryTimeMin}-${r.deliveryTimeMax} ${AppStrings.mins}',
                                      style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            // Tab bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                tabController: _tabController,
                onTap: (index) => setState(() {}),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Menu Tab
            _buildMenuTab(menuCategories),
            // Reviews Tab
            _buildReviewsTab(),
            // Info Tab
            _buildInfoTab(r),
          ],
        ),
      ),
      // Floating cart button
      floatingActionButton: _cartCount > 0
          ? FloatingActionButton.extended(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم الإنتقال إلى سلة المشتريات')),
                );
              },
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.shopping_cart),
              label: Text(
                '$_cartCount | ${_cartTotal.toStringAsFixed(0)} ${AppConstants.defaultCurrencySymbol}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            )
          : null,
    );
  }

  // Menu Tab
  Widget _buildMenuTab(List<String> menuCategories) {
    return Column(
      children: [
        // Category chips
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: menuCategories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = menuCategories[index];
              final isSelected = _selectedMenuCategory == cat;
              return GestureDetector(
                onTap: () => setState(() => _selectedMenuCategory = cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(height: 1),
        // Menu items
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...(_sampleMenuItems[_selectedMenuCategory] ?? []).map((item) => _MenuItemCard(
                item: item,
                onAdd: () => _addToCart(item),
              )),
            ],
          ),
        ),
      ],
    );
  }

  // Reviews Tab
  Widget _buildReviewsTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _sampleReviews.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final review = _sampleReviews[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                    child: Icon(Icons.person, size: 20, color: AppColors.primary.withValues(alpha: 0.6)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'مستخدم ${review.userId.replaceAll('user', '')}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary),
                    ),
                  ),
                  Row(
                    children: List.generate(5, (i) => Icon(
                      i < review.rating ? Icons.star : Icons.star_border,
                      size: 16,
                      color: AppColors.warning,
                    )),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                review.comment,
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 6),
              Text(
                'منذ ${index + 1} ${['أيام', 'أسابيع', 'أشهر'][index.clamp(0, 2)]}',
                style: const TextStyle(fontSize: 11, color: AppColors.textHint),
              ),
            ],
          ),
        );
      },
    );
  }

  // Info Tab
  Widget _buildInfoTab(RestaurantModel r) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Opening hours
        _InfoSection(
          icon: Icons.access_time,
          title: 'أوقات العمل',
          children: [
            _InfoRow(label: 'السبت - الخميس', value: '9:00 ص - 11:00 م'),
            _InfoRow(label: 'الجمعة', value: '1:00 م - 11:00 م'),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'مفتوح الآن',
                    style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Address
        _InfoSection(
          icon: Icons.location_on_outlined,
          title: 'العنوان',
          children: [
            Text(
              '${r.address}، ${r.district}، ${r.city}',
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Contact
        _InfoSection(
          icon: Icons.phone_outlined,
          title: 'معلومات الاتصال',
          children: [
            const SizedBox(height: 4),
            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  const Icon(Icons.phone, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    r.phone,
                    style: const TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            if (r.whatsapp != null) ...[
              const SizedBox(height: 8),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    const Icon(Icons.chat, size: 16, color: Color(0xFF25D366)),
                    const SizedBox(width: 8),
                    Text(
                      r.whatsapp!,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF25D366), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        // Delivery info
        _InfoSection(
          icon: Icons.delivery_dining,
          title: 'معلومات التوصيل',
          children: [
            _InfoRow(label: AppStrings.deliveryFee, value: '${r.deliveryFee.toStringAsFixed(0)} ${AppConstants.defaultCurrencySymbol}'),
            _InfoRow(label: AppStrings.minOrder, value: '${r.minOrder.toStringAsFixed(0)} ${AppConstants.defaultCurrencySymbol}'),
            _InfoRow(label: 'وقت التوصيل', value: '${r.deliveryTimeMin}-${r.deliveryTimeMax} ${AppStrings.mins}'),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

// Tab Bar Delegate
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final void Function(int index)? onTap;

  _TabBarDelegate({required this.tabController, this.onTap});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background,
      child: TabBar(
        controller: tabController,
        indicatorColor: AppColors.primary,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textHint,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
        onTap: onTap,
        tabs: const [
          Tab(text: AppStrings.menu),
          Tab(text: AppStrings.reviews),
          Tab(text: AppStrings.info),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

// Menu Item Card
class _MenuItemCard extends StatelessWidget {
  final MenuItemModel item;
  final VoidCallback onAdd;

  const _MenuItemCard({required this.item, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.fastfood, size: 28, color: AppColors.primary.withValues(alpha: 0.4)),
          ),
          const SizedBox(width: 12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.nameAr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (item.isPopular)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'مميز',
                          style: TextStyle(fontSize: 10, color: AppColors.warning, fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.descriptionAr,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.textHint, height: 1.3),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${item.price.toStringAsFixed(0)} ${AppConstants.defaultCurrencySymbol}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onAdd,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Info Section Widget
class _InfoSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const _InfoSection({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

// Info Row Widget
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}