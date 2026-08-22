import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';
import '../models/menu_item_model.dart';

class RestaurantProvider extends ChangeNotifier {
  List<RestaurantModel> _restaurants = [];
  List<MenuItemModel> _menuItems = [];
  bool _isLoading = false;
  bool _initialized = false;

  List<RestaurantModel> get restaurants => _restaurants;
  List<MenuItemModel> get menuItems => _menuItems;
  bool get isLoading => _isLoading;

  /// Gefiltert: nur Restaurants mit isFeatured == true
  List<RestaurantModel> get featuredRestaurants =>
      _restaurants.where((r) => r.isFeatured).toList();

  /// Menü-Einträge, gruppiert nach Restaurant-ID
  Map<String, List<MenuItemModel>> get menuByRestaurant {
    final map = <String, List<MenuItemModel>>{};
    for (final item in _menuItems) {
      map.putIfAbsent(item.restaurantId, () => []);
      map[item.restaurantId]!.add(item);
    }
    return map;
  }

  /// Initialisiert Demo-Daten (nur einmal)
  Future<void> loadRestaurants() async {
    if (_initialized) return;

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    _initDemoData();
    _initialized = true;
    _isLoading = false;
    notifyListeners();
  }

  /// Gibt ein Restaurant anhand seiner ID zurück
  RestaurantModel? getRestaurantById(String id) {
    try {
      return _restaurants.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Gibt die Menü-Einträge eines bestimmten Restaurants zurück
  List<MenuItemModel> getMenuItems(String restaurantId) {
    return _menuItems.where((m) => m.restaurantId == restaurantId).toList();
  }

  /// Durchsucht Restaurants nach Name oder Beschreibung
  List<RestaurantModel> searchRestaurants(String query) {
    if (query.isEmpty) return _restaurants;
    final q = query.toLowerCase();
    return _restaurants.where((r) {
      return r.nameAr.toLowerCase().contains(q) ||
          r.nameEn.toLowerCase().contains(q) ||
          r.descriptionAr.toLowerCase().contains(q) ||
          r.district.toLowerCase().contains(q);
    }).toList();
  }

  /// Durchsucht Menü-Einträge nach Name oder Beschreibung
  List<MenuItemModel> searchMenuItems(String query) {
    if (query.isEmpty) return _menuItems;
    final q = query.toLowerCase();
    return _menuItems.where((m) {
      return m.nameAr.toLowerCase().contains(q) ||
          m.nameEn.toLowerCase().contains(q) ||
          m.descriptionAr.toLowerCase().contains(q);
    }).toList();
  }

  // ====================================================================
  //  DEMO-DATEN – 10 sudanesische Restaurants mit 33 authentischen Gerichten
  // ====================================================================

  void _initDemoData() {
    // ---------- RESTAURANTS ----------
    _restaurants = [
      RestaurantModel(
        id: 'r1',
        nameAr: 'مطعم أبو عوف',
        nameEn: 'Abu Auf Restaurant',
        descriptionAr: 'أشهر مطعم سوداني في الخرطوم، متخصص في الفول والفلافل والعصيدة',
        category: 'sudanese',
        phone: '0912345001',
        whatsapp: '24912345001',
        address: 'شارع النيل، الخرطوم',
        district: 'الرياض',
        rating: 4.8,
        reviewCount: 342,
        deliveryFee: 2.5,
        minOrder: 5.0,
        deliveryTimeMin: 20,
        deliveryTimeMax: 35,
        isFeatured: true,
        acceptsCod: true,
        acceptsMobileMoney: true,
      ),
      RestaurantModel(
        id: 'r2',
        nameAr: 'مطبخ الكوثر',
        nameEn: 'Al Kawthar Kitchen',
        descriptionAr: 'مطبخ سوداني أصيل يقدم أشهى المأكولات التقليدية',
        category: 'sudanese',
        phone: '0912345002',
        whatsapp: '24912345002',
        address: 'شارع العرضة، أم درمان',
        district: 'أم درمان',
        rating: 4.6,
        reviewCount: 215,
        deliveryFee: 3.0,
        minOrder: 8.0,
        deliveryTimeMin: 25,
        deliveryTimeMax: 45,
        isFeatured: true,
        acceptsCod: true,
        acceptsMobileMoney: true,
      ),
      RestaurantModel(
        id: 'r3',
        nameAr: 'بيتزا الزعيم',
        nameEn: "Al Za'eem Pizza",
        descriptionAr: 'بيتزا على الطريقة الإيطالية والسودانية، أشهى البيتزا في الخرطوم',
        category: 'pizza',
        phone: '0912345003',
        address: 'شارع المطار، الخرطوم',
        district: 'الخرطوم 2',
        rating: 4.5,
        reviewCount: 187,
        deliveryFee: 3.5,
        minOrder: 12.0,
        deliveryTimeMin: 20,
        deliveryTimeMax: 30,
        isFeatured: true,
        acceptsCod: true,
        acceptsMobileMoney: true,
      ),
      RestaurantModel(
        id: 'r4',
        nameAr: 'فول وفلافل النيل',
        nameEn: 'Nile Ful & Falafel',
        descriptionAr: 'أفخم فول وفلافل في السودان، فول مدمس بالزبدة والكمون',
        category: 'sudanese',
        phone: '0912345004',
        address: 'شارع النيل، الخرطوم',
        district: 'الرياض',
        rating: 4.7,
        reviewCount: 298,
        deliveryFee: 2.0,
        minOrder: 3.0,
        deliveryTimeMin: 15,
        deliveryTimeMax: 25,
        isFeatured: true,
        acceptsCod: true,
        acceptsMobileMoney: true,
      ),
      RestaurantModel(
        id: 'r5',
        nameAr: 'مشاوي الخرطوم',
        nameEn: 'Khartoum Grill',
        descriptionAr: 'أفضل المشاوي في الخرطوم – كباب، شيش طاووق، كفتة و لحم غنم',
        category: 'middle_eastern',
        phone: '0912345005',
        whatsapp: '24912345005',
        address: 'شارع السيد عبد الرحمن، الخرطوم',
        district: 'السجانة',
        rating: 4.9,
        reviewCount: 421,
        deliveryFee: 4.0,
        minOrder: 15.0,
        deliveryTimeMin: 30,
        deliveryTimeMax: 50,
        isFeatured: true,
        acceptsCod: true,
        acceptsMobileMoney: true,
      ),
      RestaurantModel(
        id: 'r6',
        nameAr: 'مطعم السودان',
        nameEn: 'Sudan Restaurant',
        descriptionAr: 'مطعم سوداني تقليدي يقدم الكبسة، العصيدة، والملاح بجميع أنواعه',
        category: 'sudanese',
        phone: '0912345006',
        address: 'شارع الوادي، بحري',
        district: 'بحري',
        rating: 4.4,
        reviewCount: 156,
        deliveryFee: 3.0,
        minOrder: 8.0,
        deliveryTimeMin: 25,
        deliveryTimeMax: 40,
        isFeatured: false,
        acceptsCod: true,
        acceptsMobileMoney: true,
      ),
      RestaurantModel(
        id: 'r7',
        nameAr: 'برجر كينق السودان',
        nameEn: 'Burger King Sudan',
        descriptionAr: 'برجر لحم و دجاج بجودة عالية، مع البطاطس المقلية والصلصات',
        category: 'fast_food',
        phone: '0912345007',
        address: 'أفريقيا شارع، الخرطوم',
        district: 'المعمورة',
        rating: 4.3,
        reviewCount: 134,
        deliveryFee: 3.5,
        minOrder: 10.0,
        deliveryTimeMin: 20,
        deliveryTimeMax: 35,
        isFeatured: false,
        acceptsCod: true,
        acceptsMobileMoney: true,
      ),
      RestaurantModel(
        id: 'r8',
        nameAr: 'حلويات رمضان',
        nameEn: "Ramadan Sweets",
        descriptionAr: 'أشهى الحلويات والكنافة والقطايف، متخصص في الحلويات الشرقية',
        category: 'dessert',
        phone: '0912345008',
        address: 'شارع السوق، أم درمان',
        district: 'السوق الشعبي',
        rating: 4.6,
        reviewCount: 203,
        deliveryFee: 2.5,
        minOrder: 5.0,
        deliveryTimeMin: 15,
        deliveryTimeMax: 25,
        isFeatured: false,
        acceptsCod: true,
        acceptsMobileMoney: true,
      ),
      RestaurantModel(
        id: 'r9',
        nameAr: 'مقهى النيل',
        nameEn: 'Nile Cafe',
        descriptionAr: 'قهوة سودانية أصيلة، شاي كرك، ومشروبات منعشة مع إطلالة رائعة على النيل',
        category: 'cafe',
        phone: '0912345009',
        address: 'كورنيش النيل، الخرطوم',
        district: 'المنشية',
        rating: 4.2,
        reviewCount: 98,
        deliveryFee: 2.0,
        minOrder: 3.0,
        deliveryTimeMin: 10,
        deliveryTimeMax: 20,
        isFeatured: false,
        acceptsCod: true,
        acceptsMobileMoney: true,
      ),
      RestaurantModel(
        id: 'r10',
        nameAr: 'مطعم الشرق',
        nameEn: 'Al Sharq Restaurant',
        descriptionAr: 'مأكولات شرق أوسطية وعربية – مندي، كبسة، محشي، ورق عنب',
        category: 'middle_eastern',
        phone: '0912345010',
        whatsapp: '24912345010',
        address: 'شارع الجمهورية، الخرطوم',
        district: 'برّي',
        rating: 4.7,
        reviewCount: 276,
        deliveryFee: 3.5,
        minOrder: 12.0,
        deliveryTimeMin: 25,
        deliveryTimeMax: 45,
        isFeatured: true,
        acceptsCod: true,
        acceptsMobileMoney: true,
      ),
    ];

    // ---------- MENU ITEMS (33 Gerichte) ----------
    _menuItems = [
      // --- مطعم أبو عوف (r1) ---
      MenuItemModel(
        id: 'm1_1',
        restaurantId: 'r1',
        nameAr: 'فول مدمس',
        nameEn: 'Ful Medames',
        descriptionAr: 'فول مدمس بالزبدة والكمون، يقدم مع الخبز',
        category: 'main',
        price: 3.5,
        isPopular: true,
        preparationTimeMin: 10,
      ),
      MenuItemModel(
        id: 'm1_2',
        restaurantId: 'r1',
        nameAr: 'فلافل',
        nameEn: 'Falafel',
        descriptionAr: 'فلافل مقلية طازجة مع الطحينة',
        category: 'appetizer',
        price: 2.0,
        isPopular: true,
        preparationTimeMin: 10,
      ),
      MenuItemModel(
        id: 'm1_3',
        restaurantId: 'r1',
        nameAr: 'بطاطس مقلية',
        nameEn: 'French Fries',
        descriptionAr: 'بطاطس مقلية ذهبية مع كاتشاب',
        category: 'side',
        price: 1.5,
        preparationTimeMin: 8,
      ),
      MenuItemModel(
        id: 'm1_4',
        restaurantId: 'r1',
        nameAr: 'طعمية',
        nameEn: "Ta'meya",
        descriptionAr: 'طعمية مصرية بالفلافل والطحينة',
        category: 'appetizer',
        price: 2.5,
        preparationTimeMin: 12,
      ),

      // --- مطبخ الكوثر (r2) ---
      MenuItemModel(
        id: 'm2_1',
        restaurantId: 'r2',
        nameAr: 'عصيدة',
        nameEn: 'Asida',
        descriptionAr: 'عصيدة سودانية تقليدية مع الملاح',
        category: 'main',
        price: 6.0,
        isPopular: true,
        preparationTimeMin: 20,
      ),
      MenuItemModel(
        id: 'm2_2',
        restaurantId: 'r2',
        nameAr: 'ملاح',
        nameEn: 'Mullah',
        descriptionAr: 'ملاح سوداني بالبامية واللحم',
        category: 'main',
        price: 7.0,
        isPopular: true,
        preparationTimeMin: 25,
      ),
      MenuItemModel(
        id: 'm2_3',
        restaurantId: 'r2',
        nameAr: 'شوربة عدس',
        nameEn: 'Lentil Soup',
        descriptionAr: 'شوربة عدس بالكمون والليمون',
        category: 'appetizer',
        price: 3.0,
        preparationTimeMin: 15,
      ),
      MenuItemModel(
        id: 'm2_4',
        restaurantId: 'r2',
        nameAr: 'كسرة',
        nameEn: 'Kisra',
        descriptionAr: 'كسرة سودانية مع اللبن والملاح',
        category: 'side',
        price: 4.0,
        preparationTimeMin: 15,
      ),

      // --- بيتزا الزعيم (r3) ---
      MenuItemModel(
        id: 'm3_1',
        restaurantId: 'r3',
        nameAr: 'بيتزا مارجريتا',
        nameEn: 'Margherita Pizza',
        descriptionAr: 'بيتزا بجبنة الموزاريلا والطماطم',
        category: 'main',
        price: 12.0,
        isPopular: true,
        preparationTimeMin: 20,
      ),
      MenuItemModel(
        id: 'm3_2',
        restaurantId: 'r3',
        nameAr: 'بيتزا سودانية',
        nameEn: 'Sudanese Pizza',
        descriptionAr: 'بيتزا باللحم المفروم والبهارات السودانية',
        category: 'main',
        price: 14.0,
        isPopular: true,
        preparationTimeMin: 25,
      ),
      MenuItemModel(
        id: 'm3_3',
        restaurantId: 'r3',
        nameAr: 'بيتزا دجاج',
        nameEn: 'Chicken Pizza',
        descriptionAr: 'بيتزا بقطع الدجاج والفلفل',
        category: 'main',
        price: 13.0,
        preparationTimeMin: 22,
      ),

      // --- فول وفلافل النيل (r4) ---
      MenuItemModel(
        id: 'm4_1',
        restaurantId: 'r4',
        nameAr: 'فول مدمس بالزبدة',
        nameEn: 'Ful with Butter',
        descriptionAr: 'فول مدمس بالزبدة السودانية البلدية',
        category: 'main',
        price: 4.0,
        isPopular: true,
        preparationTimeMin: 10,
      ),
      MenuItemModel(
        id: 'm4_2',
        restaurantId: 'r4',
        nameAr: 'فلافل مشكل',
        nameEn: 'Mixed Falafel',
        descriptionAr: 'فلافل متنوعة مع الحمص والطحينة',
        category: 'appetizer',
        price: 3.0,
        isPopular: true,
        preparationTimeMin: 12,
      ),
      MenuItemModel(
        id: 'm4_3',
        restaurantId: 'r4',
        nameAr: 'عصير تمر هندي',
        nameEn: 'Tamarind Juice',
        descriptionAr: 'عصير تمر هندي طبيعي منعش',
        category: 'drink',
        price: 2.0,
        preparationTimeMin: 5,
      ),

      // --- مشاوي الخرطوم (r5) ---
      MenuItemModel(
        id: 'm5_1',
        restaurantId: 'r5',
        nameAr: 'كباب',
        nameEn: 'Kebab',
        descriptionAr: 'كباب لحم غنم على الفحم',
        category: 'main',
        price: 18.0,
        isPopular: true,
        preparationTimeMin: 30,
      ),
      MenuItemModel(
        id: 'm5_2',
        restaurantId: 'r5',
        nameAr: 'شيش طاووق',
        nameEn: 'Shish Tawook',
        descriptionAr: 'شيش طاووق دجاج متبل على الفحم',
        category: 'main',
        price: 15.0,
        isPopular: true,
        preparationTimeMin: 25,
      ),
      MenuItemModel(
        id: 'm5_3',
        restaurantId: 'r5',
        nameAr: 'كفتة',
        nameEn: 'Kofta',
        descriptionAr: 'كفتة لحم مفروم مع البقدونس والبهارات',
        category: 'main',
        price: 14.0,
        preparationTimeMin: 25,
      ),
      MenuItemModel(
        id: 'm5_4',
        restaurantId: 'r5',
        nameAr: 'مقانق',
        nameEn: 'Makanek',
        descriptionAr: 'مقانق لحم ببهارات خاصة',
        category: 'appetizer',
        price: 10.0,
        preparationTimeMin: 20,
      ),

      // --- مطعم السودان (r6) ---
      MenuItemModel(
        id: 'm6_1',
        restaurantId: 'r6',
        nameAr: 'كبسة',
        nameEn: 'Kabsa',
        descriptionAr: 'كبسة لحم أو دجاج مع الأرز البسمتي',
        category: 'main',
        price: 12.0,
        isPopular: true,
        preparationTimeMin: 35,
      ),
      MenuItemModel(
        id: 'm6_2',
        restaurantId: 'r6',
        nameAr: 'فتة',
        nameEn: 'Fatta',
        descriptionAr: 'فتة باللحم واللبن والخبز المحمص',
        category: 'main',
        price: 10.0,
        preparationTimeMin: 20,
      ),
      MenuItemModel(
        id: 'm6_3',
        restaurantId: 'r6',
        nameAr: 'بامية',
        nameEn: 'Bamia',
        descriptionAr: 'بامية باللحم والصلصة الحمراء',
        category: 'main',
        price: 8.0,
        preparationTimeMin: 25,
      ),

      // --- برجر كينق السودان (r7) ---
      MenuItemModel(
        id: 'm7_1',
        restaurantId: 'r7',
        nameAr: 'برجر لحم',
        nameEn: 'Beef Burger',
        descriptionAr: 'برجر لحم بقري مع الجبن والخس والطماطم',
        category: 'main',
        price: 8.0,
        isPopular: true,
        preparationTimeMin: 15,
      ),
      MenuItemModel(
        id: 'm7_2',
        restaurantId: 'r7',
        nameAr: 'برجر دجاج',
        nameEn: 'Chicken Burger',
        descriptionAr: 'برجر صدر دجاج مقرمش مع المايونيز',
        category: 'main',
        price: 7.0,
        preparationTimeMin: 15,
      ),
      MenuItemModel(
        id: 'm7_3',
        restaurantId: 'r7',
        nameAr: 'بطاطس مقلية كبيرة',
        nameEn: 'Large Fries',
        descriptionAr: 'بطاطس مقلية كبيرة مع كاتشاب ومايونيز',
        category: 'side',
        price: 3.0,
        preparationTimeMin: 8,
      ),

      // --- حلويات رمضان (r8) ---
      MenuItemModel(
        id: 'm8_1',
        restaurantId: 'r8',
        nameAr: 'كنافة',
        nameEn: 'Kunafa',
        descriptionAr: 'كنافة ناعمة بالجبنة والقطر',
        category: 'dessert',
        price: 6.0,
        isPopular: true,
        preparationTimeMin: 15,
      ),
      MenuItemModel(
        id: 'm8_2',
        restaurantId: 'r8',
        nameAr: 'بسبوسة',
        nameEn: 'Basbousa',
        descriptionAr: 'بسبوسة بالسميد وجوز الهند',
        category: 'dessert',
        price: 4.0,
        preparationTimeMin: 12,
      ),
      MenuItemModel(
        id: 'm8_3',
        restaurantId: 'r8',
        nameAr: 'أم علي',
        nameEn: 'Om Ali',
        descriptionAr: 'أم علي بالعجينة والمكسرات والحليب',
        category: 'dessert',
        price: 5.0,
        preparationTimeMin: 15,
      ),

      // --- مقهى النيل (r9) ---
      MenuItemModel(
        id: 'm9_1',
        restaurantId: 'r9',
        nameAr: 'قهوة سودانية',
        nameEn: 'Sudanese Coffee',
        descriptionAr: 'قهوة سودانية أصيلة مع البهارات',
        category: 'drink',
        price: 2.5,
        isPopular: true,
        preparationTimeMin: 10,
      ),
      MenuItemModel(
        id: 'm9_2',
        restaurantId: 'r9',
        nameAr: 'شاي كرك',
        nameEn: 'Karak Tea',
        descriptionAr: 'شاي كرك بالحليب والهيل',
        category: 'drink',
        price: 2.0,
        isPopular: true,
        preparationTimeMin: 8,
      ),
      MenuItemModel(
        id: 'm9_3',
        restaurantId: 'r9',
        nameAr: 'عصير مانجو',
        nameEn: 'Mango Juice',
        descriptionAr: 'عصير مانجو طازج طبيعي',
        category: 'drink',
        price: 3.0,
        preparationTimeMin: 5,
      ),

      // --- مطعم الشرق (r10) ---
      MenuItemModel(
        id: 'm10_1',
        restaurantId: 'r10',
        nameAr: 'مندي لحم',
        nameEn: 'Mandi Lamb',
        descriptionAr: 'مندي لحم غنم مع أرز بسمتي والبهارات',
        category: 'main',
        price: 16.0,
        isPopular: true,
        preparationTimeMin: 40,
      ),
      MenuItemModel(
        id: 'm10_2',
        restaurantId: 'r10',
        nameAr: 'محشي ورق عنب',
        nameEn: 'Stuffed Vine Leaves',
        descriptionAr: 'ورق عنب محشي بالأرز واللحم المفروم',
        category: 'main',
        price: 10.0,
        isPopular: true,
        preparationTimeMin: 35,
      ),
      MenuItemModel(
        id: 'm10_3',
        restaurantId: 'r10',
        nameAr: 'شوربة عدس بالخضار',
        nameEn: 'Veg Lentil Soup',
        descriptionAr: 'شوربة عدس بالجزر والبطاطس والكمون',
        category: 'appetizer',
        price: 3.5,
        preparationTimeMin: 20,
      ),
      MenuItemModel(
        id: 'm10_4',
        restaurantId: 'r10',
        nameAr: 'لحم مفروم بالصلصة',
        nameEn: 'Minced Meat with Sauce',
        descriptionAr: 'لحم مفروم مع صلصة الطماطم والخضار',
        category: 'main',
        price: 11.0,
        preparationTimeMin: 25,
      ),
    ];
  }
}