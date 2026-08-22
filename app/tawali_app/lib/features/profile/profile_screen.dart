import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../models/user_model.dart';

// Sample user for UI demonstration
final _sampleUser = UserModel(
  id: 'user_1',
  phone: '+249912345678',
  name: 'أحمد محمد',
  email: 'ahmed@example.com',
  addresses: [
    UserAddress(
      id: 'addr_1',
      label: 'المنزل',
      street: 'شارع 15',
      district: 'الرياض',
      isDefault: true,
      lat: 15.5007,
      lng: 32.5599,
    ),
    UserAddress(
      id: 'addr_2',
      label: 'العمل',
      street: 'شارع الجامعة',
      district: 'العمارات',
      isDefault: false,
      lat: 15.5507,
      lng: 32.5899,
    ),
  ],
  favorites: ['r1', 'r2'],
  languagePreference: 'ar',
);

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _user = _sampleUser;

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            AppStrings.logout,
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: const Text(
            AppStrings.logoutConfirm,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text(AppStrings.logout),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && mounted) {
      // Perform logout logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تسجيل الخروج بنجاح')),
      );
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(AppStrings.myProfile),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
              onPressed: () => context.push('/profile/edit'),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // User Avatar
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: Text(
                  _user.name.isNotEmpty ? _user.name[0] : '?',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Name
              Text(
                _user.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              // Phone
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.phone_outlined,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text(
                    _user.phone,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Email
              if (_user.email != null && _user.email!.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.email_outlined,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      _user.email!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 30),
              // Menu items
              _ProfileMenuItem(
                icon: Icons.location_on_outlined,
                title: AppStrings.myAddresses,
                onTap: () => context.push('/profile/addresses'),
              ),
              _ProfileMenuItem(
                icon: Icons.favorite_outline,
                title: AppStrings.myFavorites,
                onTap: () => context.push('/favorites'),
              ),
              _ProfileMenuItem(
                icon: Icons.receipt_long_outlined,
                title: AppStrings.orderHistory,
                onTap: () => context.push('/orders/history'),
              ),
              _ProfileMenuItem(
                icon: Icons.discount_outlined,
                title: AppStrings.myPromoCodes,
                onTap: () => context.push('/promos'),
              ),
              _ProfileMenuItem(
                icon: Icons.reviews_outlined,
                title: AppStrings.reviews,
                onTap: () => context.push('/reviews'),
              ),
              _ProfileMenuItem(
                icon: Icons.settings_outlined,
                title: AppStrings.settings,
                onTap: () => context.push('/settings'),
              ),
              const SizedBox(height: 24),
              // Logout button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _confirmLogout,
                    icon: const Icon(Icons.logout, color: AppColors.error),
                    label: Text(
                      AppStrings.logout,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // App version
              Text(
                '${AppStrings.version} ${AppConstants.appVersion}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textHint,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Icon(icon, color: AppColors.primary, size: 24),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_left,
            color: AppColors.textHint,
            size: 22,
          ),
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}